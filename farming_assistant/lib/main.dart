import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Farming Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: const Color(0xFFA7D77C),
          secondary: const Color(0xFFFFE57E),
          tertiary: const Color(0xFFC29E76),
          primaryContainer: const Color(0xFFF2F2F2),
          secondaryContainer: const Color(0xFFFFD2B1),
          tertiaryContainer: const Color(0xFF88D0E2),
          surface: const Color(0xFFFFF9E6), // background color
          // onSurface: const Color(0xFF4B4B4B), // text color
          onSurface: Colors.black,
          onSurfaceVariant: const Color(0xFF6A6A6A),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0xFFFFF9E6),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
