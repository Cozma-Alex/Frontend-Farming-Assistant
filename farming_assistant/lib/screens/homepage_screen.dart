/// A screen that displays the home page with multiple sections including a welcome message,
/// weather and time information, and various progress indicators.
///
/// The [HomePageScreen] widget is a stateful widget that manages the navigation between different
/// screens using a [PageView] and a bottom navigation bar.
///
/// The [HomeContent] widget is a stateless widget that displays the main content of the home page,
/// including a welcome message, weather and time information, and various progress indicators.
///
/// Example usage:
///
/// ```dart
/// HomePageScreen()
/// ```
import 'package:farming_assistant/screens/tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:farming_assistant/widgets/bottom_bar_widget.dart';
import '../widgets/weather_time_widget.dart';
import '../widgets/homepage_slider.dart';

const double containerHeight = 200.0;

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _currentIndex = 2;
  final PageController _pageController = PageController(initialPage: 2);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavBarTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      const Center(child: Text('Stats Screen')),
      const Center(child: Text('Map Screen')),
      const HomeContent(),
      const TasksScreen(),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTapped,
      ),
    );
  }
}

/// A widget that displays the main content of the home page, including a welcome message,
/// weather and time information, and various progress indicators.
///
/// The [HomeContent] widget is a stateless widget that takes no parameters.
///
/// Example usage:
///
/// ```dart
/// HomeContent()
/// ```
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.85;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: containerHeight,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: containerHeight,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  Container(
                    width: double.infinity,
                    height: containerHeight,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/images/home_background_top(2).png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome Back!',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Ready for a productive day?',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 125,
                decoration: BoxDecoration(
                  color: const Color(0xFF5F603E),
                  border: Border.all(
                    color: Colors.black54,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: WeatherTimeWidget(
                    textColor: Colors.white,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  color: const Color(0xFFCEB08A),
                  child: const BoxWithSlider(
                    isCenteredTitle: true,
                    title: 'Overall Mood',
                    progress: 50.0,
                  ),
                ),
                Container(
                  color: const Color(0xFFCEB08A),
                  child: const BoxWithSlider(
                    isCenteredTitle: false,
                    title: 'Daily tasks progress',
                    subtitle: '65% completed',
                    progress: 65.0,
                  ),
                ),
                Container(
                  color: const Color(0xFFCEB08A),
                  child: const BoxWithSlider(
                    isCenteredTitle: false,
                    title: 'Next estimated Harvest',
                    subtitle: 'In 17 days',
                    progress: 40.0,
                  ),
                ),
                Container(
                  color: const Color(0xFFCEB08A),
                  child: const BoxWithSlider(
                    isCenteredTitle: false,
                    title: 'Supplies Remaining',
                    subtitle: 'Corn is low',
                    progress: 15.0,
                  ),
                ),
                Container(
                  color: const Color(0xFFCEB08A),
                  child: const BoxWithSlider(
                    isCenteredTitle: false,
                    title: 'Animals\' Health',
                    subtitle: 'Cows are sick',
                    progress: 60.0,
                  ),
                ),
                Container(
                  color: const Color(0xFFCEB08A),
                  child: const BoxWithSlider(
                    isCenteredTitle: false,
                    title: 'Profit vs. Expenses for the Current Month',
                    subtitle: '15% profit',
                    progress: 85.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}