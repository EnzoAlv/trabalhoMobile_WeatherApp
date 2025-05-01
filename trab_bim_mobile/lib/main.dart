import 'package:flutter/material.dart';
import 'package:trabbimmob/firebase_options.dart';
import 'package:trabbimmob/pages/login_page.dart';
import 'package:trabbimmob/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDu3aHw6w2D8EGkaGHNSlmSalbshK8KJEU",
          authDomain: "weatherapp-d28f5.firebaseapp.com",
          projectId: "weatherapp-d28f5",
          storageBucket: "weatherapp-d28f5.firebasestorage.app",
          messagingSenderId: "969834214693",
          appId: "1:969834214693:web:8f65220026d00df07296cc"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
