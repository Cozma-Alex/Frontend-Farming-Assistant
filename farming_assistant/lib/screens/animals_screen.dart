import 'package:flutter/material.dart';
import '../APIs/location-related-apis.dart';
import '../models/animal.dart';
import '../models/location.dart';
import '../APIs/animal-related-apis.dart';
import '../models/user.dart';

class AnimalsScreen extends StatefulWidget {
  final User user;

  const AnimalsScreen({
    super.key,
    required this.user,
  });

  @override
  State<AnimalsScreen> createState() => _AnimalsScreenState();
}

class _AnimalsScreenState extends State<AnimalsScreen> {
  late Future<List<Animal>> _animalsFuture;
  late Future<List<Location>> _locationsFuture;
  Location? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _loadAnimals();
    _loadLocations();
  }

  void _loadAnimals() {
    _animalsFuture = getAllAnimalsOfUserAPI(widget.user);
  }

  void _loadLocations() {
    _locationsFuture = getAllLocationsOfUserAPI(widget.user);
  }

  void _filterByLocation(Location location) {
    setState(() {
      if (_selectedLocation?.id == location.id) {
        _selectedLocation = null;
        _loadAnimals();
      } else {
        _selectedLocation = location;
        _animalsFuture = getAnimalsByLocationAPI(location)
            .then((dtos) => dtos.map((dto) => dto.animal).toList());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFFDFDFD),
      backgroundColor: const Color(0xFFCDC5AD),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: const BoxDecoration(
            // color: Color(0xFFEFFAC3),
            color: Color(0xFFF6FCDF),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.navigate_before),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: const Text('Animals'),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0, left: 16, right: 16),
                child: FutureBuilder<List<Location>>(
                  future: _locationsFuture,
                  builder: (context, snapshot) {
                    final locations = snapshot.data ?? [];
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChip(
                            selected: _selectedLocation == null,
                            label: const Text('All'),
                            onSelected: (_) {
                              setState(() {
                                _selectedLocation = null;
                                _loadAnimals();
                              });
                            },
                            backgroundColor: Colors.white,
                            selectedColor: const Color(0xFFA7D77C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(color: Color(0xFFA7D77C)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ...locations.map((location) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                selected: _selectedLocation?.id == location.id,
                                label: Text(location.name ?? 'Location ${location.id}'),
                                onSelected: (_) => _filterByLocation(location),
                                backgroundColor: Colors.white,
                                selectedColor: const Color(0xFFA7D77C),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(color: Color(0xFFA7D77C)),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Extended background for list that goes under the header
          Positioned(
            top: 0,
            left: -20,
            right: -20,
            bottom: 0,
            child: Container(
              margin: const EdgeInsets.only(
                top: 0,
                left: 16,
                right: 16,
                bottom: 80, // Space for add button
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFA7D77C),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                  top: Radius.circular(15)
                ),
              ),
              child: FutureBuilder<List<Animal>>(
                future: _animalsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final animals = snapshot.data ?? [];

                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 0),
                    itemCount: animals.length,
                    itemBuilder: (context, index) {
                      final animal = animals[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: index != animals.length - 1
                              ? const Border(
                            bottom: BorderSide(
                              color: Colors.white,
                              width: 1.3,  // Increased width
                            ),
                          )
                              : null,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            child: Text(
                              animal.name[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          title: Text(
                            animal.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            animal.location.name ?? 'Location ${animal.location.id}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // Add animal button at bottom
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF648B3F), Color(0xFFA7D77C)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Add animal logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Add animal',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}