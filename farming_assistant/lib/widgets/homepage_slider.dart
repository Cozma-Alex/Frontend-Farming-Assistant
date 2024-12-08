import 'package:flutter/material.dart';

class BoxWithSlider extends StatelessWidget {
  final bool isCenteredTitle;
  final String title;
  final String? subtitle; // Make subtitle nullable
  final double progress;

  const BoxWithSlider({
    super.key,
    required this.isCenteredTitle,
    required this.title,
    this.subtitle, // Optional parameter
    required this.progress,
  });

  Color _getSliderColor(double progress) {
    if (progress < 25) {
      return Colors.red;
    } else if (progress < 50) {
      return Colors.yellow;
    } else if (progress < 75) {
      return Colors.lightGreen;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        isCenteredTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: isCenteredTitle ? 20.0 : 16.0,
              fontWeight: isCenteredTitle ? FontWeight.bold : FontWeight.normal,
              //fontStyle: isCenteredTitle ? FontStyle.italic : FontStyle.normal,
            ),
            textAlign: isCenteredTitle ? TextAlign.center : TextAlign.left,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8.0),
            Text(
              subtitle!,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              ),
            ),
          ],
          //const SizedBox(height: 16.0),
          Slider(
            value: progress,
            min: 0,
            max: 100,
            onChanged: (value) {}, // Placeholder for slider action
            activeColor: _getSliderColor(progress),
            inactiveColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
