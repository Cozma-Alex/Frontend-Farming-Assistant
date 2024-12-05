// lib/widgets/property_map_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/providers/farm_state_provider.dart';
import 'farm_drawing_canvas.dart';
import '../models/enums/drawing_mode.dart';

class PropertyMapView extends StatefulWidget {
  const PropertyMapView({super.key});

  @override
  State<PropertyMapView> createState() => _PropertyMapViewState();
}

class _PropertyMapViewState extends State<PropertyMapView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FarmStateProvider>(
      builder: (context, farmState, child) {
        return Container(
            color: const Color(0xFFCEB08A),
            child: Column(
              children: [
                AppBar(
                  title: const Text('Farm Map'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () => farmState.saveFarmData(),
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    children: [
                      // Toolbar
                      Container(
                        width: 60,
                        color: Theme
                            .of(context)
                            .colorScheme
                            .surface,
                        child: Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.pan_tool),
                              onPressed: () =>
                                  farmState.setMode(DrawingMode.view),
                              color: farmState.currentMode == DrawingMode.view
                                  ? Theme
                                  .of(context)
                                  .primaryColor
                                  : null,
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  farmState.setMode(DrawingMode.draw),
                              color: farmState.currentMode == DrawingMode.draw
                                  ? Theme
                                  .of(context)
                                  .primaryColor
                                  : null,
                            ),
                            IconButton(
                              icon: const Icon(Icons.crop_square),
                              onPressed: () =>
                                  farmState.setMode(DrawingMode.edit),
                              color: farmState.currentMode == DrawingMode.edit
                                  ? Theme
                                  .of(context)
                                  .primaryColor
                                  : null,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  farmState.setMode(DrawingMode.delete),
                              color: farmState.currentMode == DrawingMode.delete
                                  ? Theme
                                  .of(context)
                                  .primaryColor
                                  : null,
                            ),
                            // Add the new color picker button
                            IconButton(
                              icon: const Icon(Icons.color_lens),
                              onPressed: () {
                                // Show color picker dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Select Color'),
                                      content: Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          _buildColorButton(
                                              context, Colors.green, farmState),
                                          _buildColorButton(
                                              context, Colors.blue, farmState),
                                          _buildColorButton(
                                              context, Colors.brown, farmState),
                                          _buildColorButton(
                                              context, Colors.red, farmState),
                                          _buildColorButton(
                                              context, Colors.orange,
                                              farmState),
                                          _buildColorButton(
                                              context, Colors.purple,
                                              farmState),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                            ),
                          ],
                        ),
                      ),
                      const Expanded(
                        child: FarmDrawingCanvas(),
                      ),
                    ],
                  ),
                ),
              ],
            )
        );
      },
    );
  }
}

Widget _buildColorButton(BuildContext context, Color color,
    FarmStateProvider farmState) {
  return GestureDetector(
    onTap: () {
      farmState.setSelectedColor(color);
      Navigator.of(context).pop();
    },
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: farmState.selectedColor == color ? Colors.black : Colors.grey,
          width: 2,
        ),
      ),
    ),
  );
}
