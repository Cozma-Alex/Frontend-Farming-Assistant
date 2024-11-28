import 'package:farming_assistant/screens/tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:farming_assistant/widgets/bottom_bar_widget.dart';

import '../widgets/weather_time_widget.dart';

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
            /*Container(
              color: const Color(0xFFCEB08A),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 40),
                    child: Center(
                      child: Container(
                        width: containerWidth,
                        height: 83,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5F603E),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Mood\n Text',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            const VerticalDivider(
                              color: Colors.white,
                              thickness: 1,
                              width: 20,
                              indent: 15,
                              endIndent: 15,
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Nov 23, 2024\n22:35',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const VerticalDivider(
                              color: Colors.white,
                              thickness: 1,
                              width: 20,
                              indent: 15,
                              endIndent: 15,
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Weather\n Text',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),*/
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black54,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: const WeatherTimeWidget(
                  textColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
