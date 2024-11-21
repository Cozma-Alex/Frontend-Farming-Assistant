import 'package:flutter/material.dart';

import 'weather_widget.dart';

/// Needs to be wrapped with a Container or something similar
/// Needs vertical limit because of a VerticalDivider
/// Example at the bottom of the file
class WeatherTimeWidget extends StatefulWidget {
  const WeatherTimeWidget({super.key});

  @override
  State<WeatherTimeWidget> createState() => _WeatherTimeWidgetState();
}

class _WeatherTimeWidgetState extends State<WeatherTimeWidget> {
  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    final monthName = _getMonthName(date.month);
    final day = date.day.toString();
    final year = date.year.toString();
    final time = '${TimeOfDay.now().hour}:${TimeOfDay.now().minute}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$monthName $day, $year',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            Text(
              time,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
        VerticalDivider(
          color: Theme.of(context).colorScheme.onSurface,
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
        const WeatherWidget(),
      ],
    );
  }
}

/*
Example of using WeatherTimeWidget:
Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black54,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: const WeatherTimeWidget(),
          ),
        ),
 */
