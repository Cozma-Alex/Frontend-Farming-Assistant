import 'package:farming_assistant/screens/animal_create_screen.dart';
import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../models/food_programme.dart';
import '../APIs/food-programme-apis.dart';

class AnimalDetailsScreen extends StatefulWidget {
  final Animal animal;

  const AnimalDetailsScreen({
    super.key,
    required this.animal,
  });

  @override
  State<AnimalDetailsScreen> createState() => _AnimalDetailsScreenState();
}

class _AnimalDetailsScreenState extends State<AnimalDetailsScreen> {
  late Future<List<FoodProgramme>> _foodProgrammesFuture;
  late Animal _animal;

  @override
  void initState() {
    super.initState();
    _animal = widget.animal;
    _foodProgrammesFuture = getFoodProgrammeForAnimalAPI(_animal);
  }

  void _updateAnimal(Animal updatedAnimal) {
    setState(() {
      _animal = updatedAnimal;
      _foodProgrammesFuture = getFoodProgrammeForAnimalAPI(updatedAnimal);
    });
  }

  Map<String, dynamic> _calculateHoursTillNextFeeding(
      List<FoodProgramme> programmes) {
    // Sort the programmes by startHour
    programmes.sort((a, b) {
      final aMinutes = a.startHour.hour * 60 + a.startHour.minute;
      final bMinutes = b.startHour.hour * 60 + b.startHour.minute;
      return aMinutes.compareTo(bMinutes);
    });

    final now = TimeOfDay.now();
    int nowMinutes = now.hour * 60 + now.minute;

    FoodProgramme? lastProgramme;
    FoodProgramme? nextProgramme;

    // Identify last and next feeding times
    for (final programme in programmes) {
      final feedingMinutes =
          programme.startHour.hour * 60 + programme.startHour.minute;

      if (feedingMinutes <= nowMinutes) {
        lastProgramme = programme;
      } else {
        nextProgramme ??= programme;
      }
    }

    // Wrap around for the next day if no future feeding time is found
    if (nextProgramme == null && programmes.isNotEmpty) {
      nextProgramme = programmes.first;
    }
    // Wrap around for the previous day if no past feeding time is found
    if (lastProgramme == null && programmes.isNotEmpty) {
      lastProgramme = programmes.last;
    }

    String hoursTillFeeding = 'N/A';
    double progressValue = 0.0;

    if (lastProgramme != null && nextProgramme != null) {
      final lastFeedingMinutes =
          lastProgramme.startHour.hour * 60 + lastProgramme.startHour.minute;
      final nextFeedingMinutes =
          nextProgramme.startHour.hour * 60 + nextProgramme.startHour.minute;

      // Calculate the total duration between last and next feeding
      final totalDuration = (nextFeedingMinutes > lastFeedingMinutes)
          ? (nextFeedingMinutes - lastFeedingMinutes)
          : ((nextFeedingMinutes + 24 * 60) - lastFeedingMinutes);

      // Calculate the elapsed time since the last feeding
      final elapsedDuration = (nowMinutes > lastFeedingMinutes)
          ? (nowMinutes - lastFeedingMinutes)
          : ((nowMinutes + 24 * 60) - lastFeedingMinutes);

      // Calculate progress and time until the next feeding
      progressValue = elapsedDuration / totalDuration;

      final minutesTillNextFeeding = totalDuration - elapsedDuration;
      final hours = minutesTillNextFeeding / 60;
      hoursTillFeeding = '${hours.toStringAsFixed(1)}h';
    }

    return {
      'hoursTillFeeding': hoursTillFeeding,
      'progressValue': progressValue,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCDC5AD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text('Animal'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
        child: Column(
          children: [
            // Animal info card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey[200],
                        child: Text(
                          _animal.name[0].toUpperCase(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _animal.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${DateTime.now().difference(_animal.age).inDays ~/ 365} years',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 125,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF789F3F), // Dark green
                              Color(0xFFACF36A), // Light green
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius:
                              BorderRadius.circular(25), // Rounded corners
                        ),
                        child: TextButton(
                          onPressed: () async {
                            final updatedAnimal = await Navigator.push<Animal>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddAnimalScreen(
                                  user: _animal.location.user,
                                  animal: _animal,
                                ),
                              ),
                            );

                            if (updatedAnimal != null) {
                              // Refresh the animal details
                              _updateAnimal(updatedAnimal);
                            }
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            foregroundColor: Colors.white,
                            // Text color
                            backgroundColor: Colors.transparent,
                            // Ensure no additional background
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text(
                            'Edit animal',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _animal.description,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Details sections container
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFA7D77C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: FutureBuilder<List<FoodProgramme>>(
                future: _foodProgrammesFuture,
                builder: (context, snapshot) {
                  final programmes = snapshot.data ?? [];

                  final result = _calculateHoursTillNextFeeding(programmes);
                  final hoursTillFeeding = result['hoursTillFeeding'];
                  final progressValue = result['progressValue'];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hours till feeding section
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Hours \'till feeding',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  hoursTillFeeding,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 18,
                              // Adjust height for a thicker progress bar
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                // Background color
                                borderRadius: BorderRadius.circular(
                                    10), // Rounded corners
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                // Clip child with rounded corners
                                child: LinearProgressIndicator(
                                  value: progressValue,
                                  // Use your calculated progress value
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Color(0xFF76F802)),
                                  // Green color for progress
                                  backgroundColor: Colors
                                      .transparent, // Match the container's color
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Divider(
                        color: Colors.white,
                        thickness: 1.5,
                        height: 1,
                      ),

                      // Food programme section
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Food programme',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: programmes.map((programme) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 24.0),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Text(programme.food.name[0]),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        programme.food.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${programme.startHour.hour}:${programme.startHour.minute.toString().padLeft(2, '0')}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      const Divider(color: Colors.white, height: 1),

                      // Health profile section
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Health profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _animal.healthProfile,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
