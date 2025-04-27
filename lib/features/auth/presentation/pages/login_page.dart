/*

Login Page

Login with -> Email + password

-----------
Successfully Login -> Home Page

Doesn't have account -> Register Page (create new one)

*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitkat_social_app/features/auth/presentation/components/my_button.dart';
import 'package:kitkat_social_app/features/auth/presentation/components/my_text_field.dart';
import 'package:kitkat_social_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:kitkat_social_app/features/responsives/constrained_scaffold.dart';

class LoginPage extends StatefulWidget {
  void Function()? togglePages;
  LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text Controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // login button click
  void login() {
    //prepare email and password
    final String email = emailController.text;
    final String password = passwordController.text;

    // Auth Cubit
    final authCubit = context.read<AuthCubit>();

    // Ensure Email and password are not empty
    if (email.isNotEmpty & password.isNotEmpty) {
      authCubit.login(email, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password")),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    // Scaffold
    return ConstrainedScaffold(
      //Body
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_open_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 50),

                // Welcome Back msg
                Text(
                  "Welcome back you've been missed!!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),

                // email textField
                MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obsureText: false,
                ),
                const SizedBox(height: 20),

                // pw textField
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obsureText: true,
                ),

                const SizedBox(height: 20),

                // login button
                MyButton(onTap: login, text: "Login"),

                SizedBox(height: 20),

                // not a member? reg now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member? ",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.togglePages,
                      child: Text(
                        "Register Now",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
