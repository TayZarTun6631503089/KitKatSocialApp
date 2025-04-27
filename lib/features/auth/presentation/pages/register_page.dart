import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitkat_social_app/features/auth/presentation/components/my_button.dart';
import 'package:kitkat_social_app/features/auth/presentation/components/my_text_field.dart';
import 'package:kitkat_social_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:kitkat_social_app/features/responsives/constrained_scaffold.dart';

class RegisterPage extends StatefulWidget {
  void Function()? togglePages;
  RegisterPage({super.key, required this.togglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text Controller
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void register() {
    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

    // Auth Cubit
    final authCubit = context.read<AuthCubit>();

    if (name.isNotEmpty &
        email.isNotEmpty &
        password.isNotEmpty &
        confirmPassword.isNotEmpty) {
      if (password != confirmPassword) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Passwords must be the same")));
      } else {
        authCubit.register(name, email, password);
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill everything")));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

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
                  "Let's Create an Account For You!!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),

                // email textField
                MyTextField(
                  controller: nameController,
                  hintText: "Name",
                  obsureText: false,
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
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obsureText: true,
                ),

                const SizedBox(height: 20),

                // Register button
                MyButton(onTap: register, text: "Register"),

                SizedBox(height: 20),

                // not a member? reg now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already a member? ",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.togglePages,
                      child: Text(
                        "Login Now",
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
