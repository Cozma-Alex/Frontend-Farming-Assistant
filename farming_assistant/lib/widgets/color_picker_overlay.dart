import 'package:flutter/material.dart';

class ColorPickerOverlay extends StatelessWidget {
  final List<Color> colors;
  final Color selectedColor;
  final Function(Color) onColorSelected;
  final VoidCallback onDismiss;

  const ColorPickerOverlay({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Invisible dismiss layer
          Positioned.fill(
            child: GestureDetector(
              onTap: onDismiss,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // Color picker menu
          Positioned(
            left: 70, // Adjust based on your toolbar width
            top: 20,
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Select Color'),
                    ),
                    Container(
                      width: 200,
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: colors.map((color) {
                          return GestureDetector(
                            onTap: () => onColorSelected(color),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selectedColor == color
                                      ? Colors.black
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}