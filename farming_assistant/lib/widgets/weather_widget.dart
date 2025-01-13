import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

import 'package:farming_assistant/utils/location_utils.dart';

/// A widget for displaying the current weather based on the user's location.
/// The weather is fetched using the [WeatherFactory] from the [weather] package.
/// For this you'll need an API key from [OpenWeatherMap](https://openweathermap.org/).
/// This uses the [detectPosition] function from the [location_utils.dart] file.
/// The [WeatherFactory] handles the fetching of the weather data.
/// The widget then displays the name of the location, the current temperature
/// and based on a weather condition code, as well as the sunrise and
/// sunset time, displays an icon according to the current weather conditions.
/// The text color can be customized.
class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key, this.textColor = Colors.black});

  final Color textColor;

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
      return "assets/weather_icons/mist.png";
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
                ?.copyWith(color: widget.textColor),
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
                      color: widget.textColor,
                    ),
              ),
              Text(
                temperature,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: widget.textColor,
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
                ?.copyWith(color: widget.textColor),
          );
        }
      },
    );
  }
}
