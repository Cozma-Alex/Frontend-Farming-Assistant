import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../APIs/location_related_apis.dart';
import '../models/location.dart';
import '../utils/providers/logged_user_provider.dart';
import '../screens/location_details_screen.dart';

class LocationsSection extends StatefulWidget {
  final double height;
  const LocationsSection({super.key, required this.height});

  @override
  State<LocationsSection> createState() => _LocationsSectionState();
}

class _LocationsSectionState extends State<LocationsSection> {
  final PageController _pageController = PageController();
  bool _isLoading = false;
  final List<Location> _locations = [];
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = Provider.of<LoggedUserProvider>(context, listen: false).user;
      if (user != null) {
        final locations = await getAllLocationsOfUserAPI(user);
        setState(() {
          _locations.clear();
          _locations.addAll(locations);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading locations: $e')),
        );
      }
    }
  }

  void _handlePageChange(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _locations.isEmpty
                ? const Center(
              child: Text(
                'No locations available',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
                : PageView.builder(
              controller: _pageController,
              onPageChanged: _handlePageChange,
              itemCount: (_locations.length / 4).ceil(),
              itemBuilder: (context, pageIndex) {
                final startIndex = pageIndex * 4;
                final endIndex = (startIndex + 4).clamp(0, _locations.length);
                final pageLocations = _locations.sublist(startIndex, endIndex);

                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2,
                  ),
                  itemCount: pageLocations.length,
                  itemBuilder: (context, index) {
                    final location = pageLocations[index];
                    return MaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationDetailsScreen(location: location),
                          ),
                        );
                      },
                      color: const Color(0xFF31511E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            location.type.icon,
                            color: Colors.white,
                            size: 32,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            location.name ?? location.type.displayName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (_locations.isNotEmpty) Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate((_locations.length / 4).ceil(), (index) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentPageIndex
                        ? const Color(0xFF31511E)
                        : Colors.grey,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}