import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final void Function(int) onTap;
  final int currentIndex;

  const BottomNavBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _positionAnimation = Tween<double>(
      begin: widget.currentIndex.toDouble(),
      end: widget.currentIndex.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(BottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _positionAnimation = Tween<double>(
        begin: oldWidget.currentIndex.toDouble(),
        end: widget.currentIndex.toDouble(),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Stack(
        children: [
          BottomNavigationBar(
            currentIndex: widget.currentIndex,
            onTap: widget.onTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            items: [
              _buildNavItem(Icons.pets_outlined, "Animals"),
              _buildNavItem(Icons.map_outlined, "Map"),
              _buildNavItem(Icons.home_outlined, "Home"),
              _buildNavItem(Icons.task_outlined, "Tasks"),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 3,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Row(
                    children: [
                      SizedBox(width: _positionAnimation.value * (MediaQuery.of(context).size.width / 4) + (MediaQuery.of(context).size.width / 4 - 50) / 2),
                      Container(
                        width: 50,
                        height: 3,
                        color: const Color(0xFF31511E),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: Color(0xFF31511E),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 23,
          ),
        ),
      ),
      label: label,
    );
  }
}