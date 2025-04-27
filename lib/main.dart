import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kitkat_social_app/app.dart';
import 'package:kitkat_social_app/config/firebase_options.dart';

void main() async {
  // Firebase Set up
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Run App
  runApp(MyApp());
}
