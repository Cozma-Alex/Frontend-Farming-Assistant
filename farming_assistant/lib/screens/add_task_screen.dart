import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 60),
          child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.black54,
                  width: 1,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 3,
                    blurRadius: 3,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
              child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text("data"),
                      SizedBox(height: 400),
                      Text("data"),
                    ],
                  ))),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.surface,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {},
              icon: Image.asset("assets/navigation_icons/animals.png"),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset("assets/navigation_icons/crops.png"),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset("assets/navigation_icons/map.png"),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset("assets/navigation_icons/tools.png"),
            ),
            IconButton(
                onPressed: () {},
                icon: Image.asset("assets/navigation_icons/analytics.png")),
          ],
        ),
      ),
    );
  }
}
