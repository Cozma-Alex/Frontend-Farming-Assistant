import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../APIs/location_related_apis.dart';
import '../models/animal.dart';
import '../models/location.dart';
import '../APIs/animal_related_apis.dart';
import '../models/user.dart';
import '../utils/providers/logged_user_provider.dart';
import 'animal_create_screen.dart';
import 'animal_detail_screen.dart';

/// A screen that displays a filterable list of animals belonging to the logged-in user.
///
/// Features:
/// - Location-based filtering using filter chips
/// - Animal list with basic information
/// - Direct navigation to animal details
/// - Quick access to animal creation
///
/// The screen manages its own state including:
/// - Selected location filter
/// - Animals list data
/// - Location list data
///
/// Uses Provider pattern for user authentication state and
/// handles loading/error states for data fetching.
class AnimalsScreen extends StatefulWidget {
  const AnimalsScreen({
    super.key,
  });

  @override
  State<AnimalsScreen> createState() => _AnimalsScreenState();
}

class _AnimalsScreenState extends State<AnimalsScreen> {
  late Future<List<Animal>> _animalsFuture;
  late Future<List<Location>> _locationsFuture;
  Location? _selectedLocation;
  late User _user;

  /// Initializes the screen state and loads user data.
  ///
  /// Checks for logged-in user via Provider and either:
  /// - Initializes data loading if user is authenticated
  /// - Sets error state if no user is logged in
  @override
  void initState() {
    super.initState();

    var loggedUser =
        Provider.of<LoggedUserProvider>(context, listen: false).user;

    if (loggedUser == null) {
      setState(() {
        _animalsFuture = Future.error('Not logged in');
      });
    } else {
      setState(() {
        _user = loggedUser;
      });
      _loadAnimals();
    }
  }

  /// Refreshes both animals and locations data.
  ///
  /// Fetches:
  /// - All animals for the current user
  /// - All locations for filtering
  /// Updates the state to trigger UI refresh.
  void _loadAnimals() {
    setState(() {
      _animalsFuture = getAllAnimalsOfUserAPI(_user);
      _locationsFuture = getAllLocationsOfUserAPI(_user);
    });
  }

  /// Filters the animals list by location.
  ///
  /// Takes a [location] to filter by and:
  /// - Toggles the filter if the location is already selected
  /// - Applies a new filter if a different location is selected
  /// - Updates the animals list accordingly
  ///
  /// The filter can be cleared by:
  /// - Selecting the same location again
  /// - Selecting the "All" filter chip
  void _filterByLocation(Location location) {
    setState(() {
      if (_selectedLocation?.id == location.id) {
        _selectedLocation = null;
        _loadAnimals();
      } else {
        _selectedLocation = location;
        _animalsFuture = getAnimalsByLocationAPI(location)
            .then((animalDTOs) => animalDTOs.map((dto) => dto.animal).toList());
      }
    });
  }

  /// Builds the screen layout with filterable animals list.
  ///
  /// Creates a structured display with:
  /// - Location filter chips in the app bar
  /// - Scrollable list of animal cards
  /// - Floating action button for adding new animals
  ///
  /// Handles:
  /// - Navigation to detail/create screens
  /// - List refresh after modifications
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCDC5AD),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF6FCDF),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
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
                                label: Text(
                                    location.name ?? 'Location ${location.id}'),
                                onSelected: (_) => _filterByLocation(location),
                                backgroundColor: Colors.white,
                                selectedColor: const Color(0xFFA7D77C),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                      color: Color(0xFFA7D77C)),
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
                    bottom: Radius.circular(30), top: Radius.circular(15)),
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
                                    width: 1.3,
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
                            animal.location.name ??
                                'Location ${animal.location.id}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onTap: () async {
                            final needsRefresh = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AnimalDetailsScreen(animal: animal),
                              ),
                            );
                            if (needsRefresh) {
                              _loadAnimals();
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
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
                onPressed: () async {
                  final Animal? savedAnimal = await Navigator.push<Animal>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddAnimalScreen(user: _user),
                    ),
                  );

                  if (savedAnimal != null) {
                    // If an animal was saved and returned
                    _loadAnimals();
                  }
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
