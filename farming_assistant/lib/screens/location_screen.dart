import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../APIs/animal_related_apis.dart';
import '../models/dtos/animalDTO.dart';
import '../models/enums/location_type.dart';
import '../models/location.dart';
import 'animal_detail_screen.dart';

class LocationScreen extends StatefulWidget {
  final Location location;

  const LocationScreen({
    super.key,
    required this.location,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late Future<List<AnimalDTO>> _animalsFuture;

  @override
  void initState() {
    super.initState();
    _animalsFuture = getAnimalsByLocationAPI(widget.location);
  }

  Widget _buildLocationIcon(LocationType type, bool isSelected) {
    IconData iconData;
    String label;

    switch (type) {
      case LocationType.field:
        iconData = Icons.grass;
        label = 'Field';
        break;
      case LocationType.barn:
        iconData = Icons.home;
        label = 'Barn';
        break;
      case LocationType.storage:
        iconData = Icons.warehouse;
        label = 'Storage';
        break;
      case LocationType.tools:
        iconData = Icons.build;
        label = 'Tools';
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? const Color(0xFF31511E) : Colors.grey.shade300,
          ),
          child: Icon(
            iconData,
            color: isSelected ? Colors.white : Colors.grey,
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF31511E) : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimalCard(AnimalDTO animalDto) {
    // Calculate hours till next feeding
    final nextFeeding = animalDto.foodProgrammes.isNotEmpty
        ? animalDto.foodProgrammes.first.startHour
        : null;

    String hoursTillFeeding = 'N/A';
    double progressValue = 0.0;

    if (nextFeeding != null) {
      final now = TimeOfDay.now();

      // Convert both times to minutes since midnight for easier comparison
      int nowMinutes = now.hour * 60 + now.minute;
      int feedingMinutes = nextFeeding.hour * 60 + nextFeeding.minute;

      // If feeding time is earlier today, assume it's for tomorrow
      if (feedingMinutes <= nowMinutes) {
        feedingMinutes += 24 * 60; // Add 24 hours
      }

      int minutesDifference = feedingMinutes - nowMinutes;
      double hours = minutesDifference / 60;
      hoursTillFeeding = '${hours.toStringAsFixed(1)}h';

      // Calculate progress (assuming 24h cycle)
      // Reverse the progress value so it decreases as we get closer to feeding time
      progressValue = minutesDifference / (24 * 60);
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnimalDetailsScreen(animal: animalDto.animal),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: animalDto.animal.imageData != null
                        ? MemoryImage(Uint8List.fromList(
                            animalDto.animal.imageData as List<int>))
                        : null,
                    child: animalDto.animal.imageData == null
                        ? Text(animalDto.animal.name[0].toUpperCase())
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          animalDto.animal.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Hours \'till feeding',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    hoursTillFeeding,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: Colors.grey[200],
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFF31511E)),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header image with back button
          Stack(
            children: [
              Container(
                height: 160,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/login_background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),

          // Location type icons
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: LocationType.values
                  .map((type) => _buildLocationIcon(
                        type,
                        type == widget.location.type,
                      ))
                  .toList(),
            ),
          ),

          // Animals list
          Expanded(
            child: FutureBuilder<List<AnimalDTO>>(
              future: _animalsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final animals = snapshot.data ?? [];

                if (animals.isEmpty) {
                  return const Center(
                    child: Text('No animals in this location'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: animals.length,
                  itemBuilder: (context, index) =>
                      _buildAnimalCard(animals[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
