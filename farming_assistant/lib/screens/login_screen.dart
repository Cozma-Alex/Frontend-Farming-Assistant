import 'dart:convert';

import 'package:farming_assistant/widgets/register_widget.dart';
import 'package:farming_assistant/screens/homepage_screen.dart'; // Add this line
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import  '../utils/config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _registerNameController = TextEditingController();
  final TextEditingController _registerFarmNameController = TextEditingController();

  void _openRegisterWidget() {
    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return RegisterWidget(
          emailController: _emailController,
          passwordController: _passwordController,
          nameController: _registerNameController,
          farmNameController: _registerFarmNameController,
        );
      },
    );
  }

  void _signIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePageScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double containerHeight = 200;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: containerHeight,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/login_background.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: containerHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage("assets/images/logo.png"),
                        width: 100,
                        height: 100,
                      ),
                      Text(
                        'Farming assistant',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Manage resources efficiently',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Keep track of your farm',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Log In',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller : _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email...',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller : _passwordController,
                    obscureText: true,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                      hintText: 'Password...',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      mouseCursor: SystemMouseCursors.click,
                      onTap: () {},
                      child: Text(
                        'Forgot password?',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.blue,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          thickness: 2,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('*'),
                      ),
                      Expanded(
                        child: Divider(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          thickness: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      width: 220,
                      child: ElevatedButton(
                        onPressed: _signIn, 
                      //TODO apply loginAPI call
                      //DO NOT DELETE THIS
                      //   onPressed: () {
                      //   String username = _emailController.text;
                      //   String password = _passwordController.text;
                      //   var userData = loginAPI(username, password);
                      //   userData.then((value) {
                      //     if (value.statusCode == 200) {
                      //       var jsonData = jsonDecode(value.body);
                      //       var user = User.fromJson(jsonData);
                      //     } else {
                      //       print('${value.statusCode} - error');
                      //     }
                      //   });
                      // },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Sign In',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                    ),
                  const SizedBox(height: 15),
                  Text(
                    'or',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 220,
                    child: ElevatedButton(
                      onPressed: _openRegisterWidget,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Create an account',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<http.Response> loginAPI(String email, String password) async {
  final uri = Uri.parse('${APIConfig.baseURI}/users/auth');

  try {
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password_hash': password,
      }),
    );

    return response;
  } catch (e) {
    throw Exception('Failed to login: $e');
  }
}
