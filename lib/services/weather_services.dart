import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import "../models/weather_model.dart";

import 'package:http/http.dart' as http;
class WeatherServices {
  static const baseURL = "http://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherServices(this.apiKey);

  Future<Weather> getWeather(String cityName) async{
    final response = await http.get(Uri.parse('$baseURL?q=$cityName&appid=$apiKey&units=metric'));



    if (response.statusCode==200){
      return Weather.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async{
    //getting permission
    LocationPermission permission= await Geolocator.checkPermission();
    if(permission==LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }
    //fetching current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );
    //converting location into placemark

    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude); // Fixed here


    //city name from placemark
    String? city = placemark[0].locality;

    return city ?? "";


  }

}