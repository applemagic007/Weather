import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // API key
  final _weatherService = WeatherServices("259a73c5c04cbde3995b1cc46ff410f9");
  Weather? _weather;
  String? _errorMessage; // To store error messages
  bool _isLoading = true; // Track loading state

  // Fetch weather data
  _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Reset error message on new fetch
      _weather = null; // Reset weather data
    });
    try {
      String cityName = await _weatherService.getCurrentCity();
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load weather data: ${e.toString()}";
        _isLoading = false;
      });
      print(e);
    }
  }

  // Get Lottie animation based on condition
  String _getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; // Default to sunny
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      case 'snow':
        return 'assets/snow.json';

       default:
        return 'assets/sunny.json'; // Default
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : (_errorMessage != null
                ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(_errorMessage!,
                       textAlign: TextAlign.center,
                       style: TextStyle(color: Colors.red, fontSize: 16),),
                )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _weather?.cityName ?? "Loading city...",
                        style: const TextStyle(fontSize: 20),
                      ),
                      Lottie.asset(
                        _getWeatherAnimation(_weather?.mainCondition),
                        width: 200,
                        height: 200,
                      ),
                      Text(
                        "${_weather?.temperature.round()} °C",
                        style: const TextStyle(fontSize: 30),
                      ),
                      Text(
                        _weather?.mainCondition ?? "",
                         style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  )),
      ),
    );
  }
}