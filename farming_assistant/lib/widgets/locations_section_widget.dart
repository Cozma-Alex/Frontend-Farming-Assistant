import 'package:flutter/material.dart';

import '../APIs/location_related_apis.dart';
import '../models/location.dart';
import '../screens/location_details_screen.dart';

class LocationsSection extends StatefulWidget {
  final double height;
  const LocationsSection({super.key, required this.height});

  @override
  State<LocationsSection> createState() => _LocationsSectionState();
}

class _LocationsSectionState extends State<LocationsSection> {
  final PageController _pageController = PageController();
  int _currentPage = 1;
  bool _isLoading = false;
  final List<Location> _locations = [];
  bool _hasMore = true;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadMore();
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newLocations = await getLocations(_currentPage);
      setState(() {
        _locations.addAll(newLocations);
        _currentPage++;
        _hasMore = newLocations.length == 4;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handlePageChange(int index) async {
    setState(() {
      _currentPageIndex = index;
    });

    // Load more if we're on the last page and there might be more
    if (index == ((_locations.length - 1) ~/ 4) && _hasMore) {
      await _loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total pages based on loaded locations
    int totalPages = (_locations.length / 4).ceil();

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
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _handlePageChange,
              itemCount: totalPages,
              itemBuilder: (context, pageIndex) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final locationIndex = pageIndex * 4 + index;
                      if (locationIndex >= _locations.length) {
                        return const SizedBox();
                      }

                      final location = _locations[locationIndex];
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
                            const Icon(
                              Icons.home,
                              color: Colors.white,
                              size: 32,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Location ${location.id}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          if (_locations.isNotEmpty) Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalPages, (index) {
                return Container(
                  width: 8,
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