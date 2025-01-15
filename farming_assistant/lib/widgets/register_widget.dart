// ignore_for_file: use_build_context_synchronously

import 'package:farming_assistant/models/user.dart';
import 'package:farming_assistant/utils/providers/logged_user_provider.dart';
import 'package:farming_assistant/screens/homepage_screen.dart';
import 'package:farming_assistant/screens/login_screen.dart';
import 'package:flutter/material.dart';

import 'package:farming_assistant/APIs/user_related_apis.dart';
import 'package:provider/provider.dart';

/// A widget for the registration screen.
/// Receives a [TextEditingController] for the email, password, name and farm
/// name from the [LoginScreen] to save the input even if you close the widget,
/// and email and password fields are mirrored in the [LoginScreen] and vice versa.
class RegisterWidget extends StatefulWidget {
  const RegisterWidget(this.emailController, this.passwordController,
      this.nameController, this.farmNameController, {super.key});

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final TextEditingController farmNameController;

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final TextEditingController passwordConfirmController =
      TextEditingController();

  void _trySignup() {
    if (widget.passwordController.text != passwordConfirmController.text) {
      showDialog(context: context, builder: (ctx) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Passwords do not match.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      });

      passwordConfirmController.clear();

      return;
    }

    String email = widget.emailController.text;
    String password = widget.passwordController.text;
    String name = widget.nameController.text;
    String farmName = widget.farmNameController.text;

    User user = User(
      email: email,
      password: password,
      name: name,
      farmName: farmName,
    );

    final navigator = Navigator.of(context);

    registerAPI(user).then((value) {
      if (context.mounted) {
        Provider.of<LoggedUserProvider>(context, listen: false).setUser(value);

        navigator.pushReplacement(MaterialPageRoute(builder: (ctx) {
          return const HomePageScreen();
        }));
      }
    }).catchError((error) {
      if (mounted) {
        showDialog(context: context, builder: (ctx) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Invalid sign up.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
      }
    });
  }

  @override
  void dispose() {
    passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55),
        child: Column(
          children: [
            Text(
              'Sign Up',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: widget.emailController,
              decoration: InputDecoration(
                hintText: 'Email...',
                hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
              controller: widget.nameController,
              decoration: InputDecoration(
                hintText: 'Name...',
                hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
              controller: widget.farmNameController,
              decoration: InputDecoration(
                hintText: 'Farm name...',
                hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
              controller: widget.passwordController,
              obscureText: true,
              obscuringCharacter: '*',
              decoration: InputDecoration(
                hintText: 'Password...',
                hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
              obscureText: true,
              obscuringCharacter: '*',
              controller: passwordConfirmController,
              decoration: InputDecoration(
                hintText: 'Confirm password...',
                hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.tertiaryContainer,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: _trySignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Join',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
