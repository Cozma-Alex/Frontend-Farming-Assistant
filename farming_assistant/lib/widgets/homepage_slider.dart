import 'package:flutter/material.dart';

/// A widget that displays a box with a title, an optional subtitle, and a slider.
///
/// The slider's color changes based on the progress value.
///
/// The [BoxWithSlider] widget is a stateless widget that takes the following parameters:
///
/// * [isCenteredTitle]: A boolean that determines if the title should be centered.
/// * [title]: A string that represents the title text.
/// * [subtitle]: An optional string that represents the subtitle text.
/// * [progress]: A double that represents the progress value for the slider.
///
/// Example usage:
///
/// ```dart
/// BoxWithSlider(
///   isCenteredTitle: true,
///   title: 'Progress',
///   subtitle: 'Subtitle text',
///   progress: 50.0,
/// )
/// ```
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

  /// Returns the color of the slider based on the progress value.
  ///
  /// * If progress is less than 25, the color is red.
  /// * If progress is between 25 and 50, the color is yellow.
  /// * If progress is between 50 and 75, the color is light green.
  /// * If progress is 75 or more, the color is green.
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