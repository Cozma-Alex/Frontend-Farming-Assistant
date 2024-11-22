import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

import 'package:farming_assistant/utils/location_utils.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String _getWeatherIconPath(
      int weatherConditionCode, DateTime sunrise, DateTime sunset) {
    if (weatherConditionCode ~/ 100 == 2) {
      return "assets/weather_icons/thunderstorm.png";
    }
    if (weatherConditionCode ~/ 100 == 3 || weatherConditionCode ~/ 100 == 5) {
      return "assets/weather_icons/rain.png";
    }
    if (weatherConditionCode ~/ 100 == 6) {
      return "assets/weather_icons/snow.png";
    }
    if (weatherConditionCode ~/ 100 == 7) {
      return "assets/images/weather_icons/mist.png";
    }
    if (weatherConditionCode == 800) {
      if (TimeOfDay.now().hour >= sunrise.hour &&
          TimeOfDay.now().hour <= sunset.hour) {
        return "assets/weather_icons/sun.png";
      }
      return "assets/weather_icons/moon.png";
    }

    if (TimeOfDay.now().hour >= sunrise.hour &&
        TimeOfDay.now().hour <= sunset.hour) {
      return "assets/weather_icons/cloudy_sun.png";
    }
    return "assets/weather_icons/cloudy_moon.png";
  }

  WeatherFactory wf = WeatherFactory("", language: Language.ENGLISH);

  Future<Weather> _getWeather() async {
    Position position = await detectPosition();
    Weather weather = await wf.currentWeatherByLocation(
        position.latitude, position.longitude);

    // Weather weather = await wf.currentWeatherByLocation(46.77, 23.59);
    return weather;
  }

  late Future<Weather> weather;

  @override
  void initState() {
    weather = _getWeather();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Weather>(
      future: weather,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text(
            "Weather unavailable",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
          );
        } else if (snapshot.hasData) {
          final weather = snapshot.data!;
          final location = weather.areaName ?? "Location unknown";
          final temperature =
              "${weather.temperature?.celsius?.toStringAsFixed(1)}°C" ?? "N/A";

          final weatherIconPath = _getWeatherIconPath(
              weather.weatherConditionCode!, weather.sunrise!, weather.sunset!);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                weatherIconPath,
                width: 36,
                height: 36,
              ),
              const SizedBox(height: 10),
              Text(
                location,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              Text(
                temperature,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ],
          );
        } else {
          return Text(
            "No weather data",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
          );
        }
      },
    );
  }
}
