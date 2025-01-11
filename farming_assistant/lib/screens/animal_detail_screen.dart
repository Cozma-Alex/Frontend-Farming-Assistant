import 'dart:typed_data';
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

  @override
  void initState() {
    super.initState();
    _foodProgrammesFuture = getFoodProgrammeForAnimalAPI(widget.animal);
  }

  // String _calculateHoursTillNextFeeding(List<FoodProgramme> programmes) {
  //   final nextFeeding = programmes.isNotEmpty
  //       ? programmes.first.startHour
  //       : null;
  //
  //   String hoursTillFeeding = 'N/A';
  //   double progressValue = 0.0;
  //
  //   if (nextFeeding != null) {
  //     final now = TimeOfDay.now();
  //
  //     int nowMinutes = now.hour * 60 + now.minute;
  //     int feedingMinutes = nextFeeding.hour * 60 + nextFeeding.minute;
  //
  //     if (feedingMinutes <= nowMinutes) {
  //       feedingMinutes += 24 * 60;
  //     }
  //
  //     int minutesDifference = feedingMinutes - nowMinutes;
  //     double hours = minutesDifference / 60;
  //     hoursTillFeeding = '${hours.toStringAsFixed(1)}h';
  //
  //     progressValue = minutesDifference / (24 * 60);
  //   }
  //
  //   return hoursTillFeeding;
  // }

  // Map<String, dynamic> _calculateHoursTillNextFeeding(List<FoodProgramme> programmes) {
  //   // Sort the programmes by startHour
  //   programmes.sort((a, b) {
  //     final aMinutes = a.startHour.hour * 60 + a.startHour.minute;
  //     final bMinutes = b.startHour.hour * 60 + b.startHour.minute;
  //     return aMinutes.compareTo(bMinutes);
  //   });
  //
  //   final now = TimeOfDay.now();
  //   int nowMinutes = now.hour * 60 + now.minute;
  //
  //   String hoursTillFeeding = 'N/A';
  //   double progressValue = 0.0;
  //
  //   FoodProgramme? nextProgramme;
  //
  //   for (final programme in programmes) {
  //     final feedingMinutes = programme.startHour.hour * 60 + programme.startHour.minute;
  //
  //     if (feedingMinutes > nowMinutes) {
  //       nextProgramme = programme;
  //       break;
  //     }
  //   }
  //
  //   // If no future feeding time is found, wrap around to the first one tomorrow
  //   nextProgramme ??= programmes.isNotEmpty ? programmes.first : null;
  //
  //   if (nextProgramme != null) {
  //     final feedingMinutes = nextProgramme.startHour.hour * 60 + nextProgramme.startHour.minute;
  //
  //     // Calculate minutes till next feeding
  //     int minutesDifference = feedingMinutes > nowMinutes
  //         ? feedingMinutes - nowMinutes
  //         : (feedingMinutes + 24 * 60) - nowMinutes;
  //
  //     double hours = minutesDifference / 60;
  //     hoursTillFeeding = '${hours.toStringAsFixed(1)}h';
  //
  //     progressValue = minutesDifference / (24 * 60);
  //   }
  //
  //   return {
  //     'hoursTillFeeding': hoursTillFeeding,
  //     'progressValue': progressValue,
  //   };
  // }
  Map<String, dynamic> _calculateHoursTillNextFeeding(List<FoodProgramme> programmes) {
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
      final feedingMinutes = programme.startHour.hour * 60 + programme.startHour.minute;

      if (feedingMinutes <= nowMinutes) {
        lastProgramme = programme;
      } else if (nextProgramme == null) {
        nextProgramme = programme;
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
      final lastFeedingMinutes = lastProgramme.startHour.hour * 60 + lastProgramme.startHour.minute;
      final nextFeedingMinutes = nextProgramme.startHour.hour * 60 + nextProgramme.startHour.minute;

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
          onPressed: () => Navigator.pop(context),
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
                          widget.animal.name[0].toUpperCase(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.animal.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${DateTime.now().difference(widget.animal.age).inDays ~/ 365} years',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: const Text('Edit animal'),
                      //   style: TextButton.styleFrom(
                      //     foregroundColor: const Color(0xFFA7D77C),
                      //   ),
                      // ),
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
                          onPressed: () {
                            // Add your button functionality here
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
                    widget.animal.description,
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
                  // final hoursTillFeeding = _calculateHoursTillNextFeeding(programmes);
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
                            // LinearProgressIndicator(
                            //   value: 0.7,
                            //   backgroundColor: Colors.white.withOpacity(0.3),
                            //   valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            // ),
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
                              widget.animal.healthProfile,
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
