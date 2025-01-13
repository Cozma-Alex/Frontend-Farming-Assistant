import 'package:farming_assistant/providers/logged_user_provider.dart';
import 'package:farming_assistant/widgets/register_widget.dart';
import 'package:farming_assistant/screens/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/user.dart';

/// A widget for the login screen.
/// A button press opens the [RegisterWidget] in a modal bottom sheet.
/// A successful login or registration saves the user in the [LoggedUserProvider]
/// and navigates to the [HomePageScreen].
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _registerNameController = TextEditingController();
  final TextEditingController _registerFarmNameController =
      TextEditingController();

  late AnimationController _animationController;

  void _openRegisterWidget() {
    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      context: context,
      transitionAnimationController: _animationController,
      builder: (BuildContext context) {
        return RegisterWidget(
          _emailController,
          _passwordController,
          _registerNameController,
          _registerFarmNameController,
        );
      },
    );
  }

  void _signIn() {
    User loggedUser = User(
      id: '0adff34b-9c96-434f-be4f-8bcbac042de6'
    );

    Provider.of<LoggedUserProvider>(context, listen: false).setUser(loggedUser);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePageScreen()),
    );
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      reverseDuration: const Duration(milliseconds: 450),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    _emailController.dispose();
    _passwordController.dispose();
    _registerNameController.dispose();
    _registerFarmNameController.dispose();

    super.dispose();
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
                    controller: _emailController,
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
                      fillColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _passwordController,
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
                      //   var userData = loginAPI(User(email : username, password : password));
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
