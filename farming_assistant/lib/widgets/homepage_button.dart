import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String title;
  final String imagePath;
  final String buttonText;
  final VoidCallback onPressed;
  final Color buttonColor; // Button color with a default value

  const CustomIconButton({
    super.key,
    required this.title,
    required this.imagePath,
    required this.buttonText,
    required this.onPressed,
    this.buttonColor = const Color(0xFFFFF9E6), // Default button color
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 166,
      height: 115,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Column(
          children: [
            // Title
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              color: const Color(0xFFFFF9E6),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Button
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    Image.asset(
                      imagePath,
                      width: 36,
                      height: 36,
                    ),
                    const SizedBox(width: 10), 
                    
                    Expanded(
                      child: Text(
                        buttonText,
                        style: const TextStyle(fontSize: 16,
                          color: Colors.black
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
