import 'package:flutter/material.dart';
import 'package:project_tb_sportscope_prakpm/views/splash_screen.dart'; // Impor splash screen



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SportScope',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Sesuaikan tema
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false, 
      home: const SplashScreen(), // halaman awal
    );
  }
}