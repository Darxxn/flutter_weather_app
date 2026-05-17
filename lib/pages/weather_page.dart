import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_weather_app/models/weather_model.dart';
import 'package:flutter_weather_app/service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService(dotenv.env['API_KEY']!);
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    // get the weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/Sunny.png'; // default to sunny
    }

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/Cloud.png';
      case 'rain':
        return 'assets/Thunder_storm.png';
      case 'drizzle':
      case 'shower rain':
        return 'assets/Thunder_storm.png';
      case 'thunderstorm':
        return 'assets/Thunder_storm.png';
      case 'clear':
        return 'assets/Sunny.png';
      default:
        return 'assets/Sunny.png';
    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // location icon
            Image(
              image: AssetImage('assets/location_icon.png'),
              color: Colors.black,
              colorBlendMode: BlendMode.srcIn,
            ),

            const SizedBox(height: 15),

            // city name
            Text(
              _weather?.cityName ?? "loading city..",
              style: const TextStyle(fontSize: 24, letterSpacing: 2),
            ),

            const SizedBox(height: 80),

            // animation
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset(getWeatherAnimation(_weather?.mainCondition)),
            ),

            const SizedBox(height: 80),

            // temperature
            Text(
              '${_weather?.temperature.round()}°C',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
