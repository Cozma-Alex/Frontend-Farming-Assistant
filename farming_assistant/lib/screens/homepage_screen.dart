import 'package:farming_assistant/screens/tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:farming_assistant/widgets/homepage_button.dart';

const double containerHeight = 200.0;

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Column(
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
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
          Expanded(
            child: Container(
              color: const Color(0xFFCEB08A),
              child: Stack(
                children: [
                  Positioned(
                    top: containerHeight - 190,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 312,
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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 120),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomIconButton(
                              title: 'To-Do List',
                              imagePath: 'assets/images/tasks_icon.png',
                              buttonText: 'To-Do text',
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => const TasksScreen()));
                              },
                            ),
                            CustomIconButton(
                              title: 'Crop Management',
                              imagePath: 'assets/images/crops_icon.png',
                              buttonText: 'Crop text',
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomIconButton(
                              title: 'Tool Management',
                              imagePath: 'assets/images/tools_icon.png',
                              buttonText: 'Tool text',
                              onPressed: () {},
                            ),
                            CustomIconButton(
                              title: 'Farm Map',
                              imagePath: 'assets/images/map_icon.png',
                              buttonText: 'Farm text',
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomIconButton(
                              title: 'Animal Management',
                              imagePath: 'assets/images/cow_icon.png',
                              buttonText: 'Animal text',
                              onPressed: () {},
                            ),
                            CustomIconButton(
                              title: 'Analytics',
                              imagePath: 'assets/images/analytics_icon.png',
                              buttonText: 'Analytics text',
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
