import 'package:farming_assistant/utils/providers/logged_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoggedUserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,  // Add this line
      debugShowCheckedModeBanner: false,
      title: 'Farming Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: const Color(0xFFA7D77C),
          secondary: const Color(0xFFFFE57E),
          tertiary: const Color(0xFFC29E76),
          primaryContainer: const Color(0xFFF2F2F2),
          secondaryContainer: const Color(0xFFCDC5AD),
          tertiaryContainer: const Color(0x55C5C5C5),
          surface: const Color(0xFFFFF9E6),
          onSurface: Colors.black,
          onSurfaceVariant: const Color(0xFF6A6A6A),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0xFFF2F2F2),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}