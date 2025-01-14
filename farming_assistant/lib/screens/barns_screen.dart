import 'package:flutter/material.dart';

class BarnsScreen extends StatelessWidget {
  const BarnsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barns'),
      ),
      body: const Center(
        child: Text('Barns Management Coming Soon'),
      ),
    );
  }
}