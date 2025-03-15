import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/service.dart';
import 'model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('00b468dac962ce703bf9c586cfc28a05');
  Weather? _weather;

  fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    print('City: $cityName'); // Debug log
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print('Error fetching weather: $e'); // Debug log
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  Color getBackgroundColor(String? mainCondition) {
    switch (mainCondition?.toLowerCase()) {
      case 'clouds':
        return Colors.purple.shade200;
      case 'rain':
        return Colors.blue.shade600;
      case 'thunderstorm':
        return Colors.deepPurple.shade800;
      case 'clear':
        return Colors.orange.shade600;
      default:
        return Colors.blue.shade500;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient Background
      backgroundColor: getBackgroundColor(_weather?.mainCondition),
      body: RefreshIndicator(
        onRefresh: () async {
          fetchWeather();
        },
        child: _weather == null
            ? const Center(child: CircularProgressIndicator()) // Show loader
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // City Name
              Text(
                _weather?.cityName ?? "Loading...",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 15),

              // Weather Animation
              Lottie.asset(
                getWeatherAnimation(_weather?.mainCondition),
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),

              const SizedBox(height: 15),

              // Glass Effect Weather Info Card
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2), // Glass effect
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Temperature
                    Text(
                      '${_weather?.temperature.round() ?? 0}°C',
                      style: const TextStyle(
                        fontSize: 65,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Weather Condition
                    Text(
                      _weather?.mainCondition ?? "",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
