// lib/views/splash_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:project_tb_sportscope_prakpm/views/onboarding_screen.dart';
import 'package:project_tb_sportscope_prakpm/views/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingAndNavigate();
  }

  Future<void> _checkOnboardingAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 3500)); // Jeda untuk animasi

    if (!mounted) return;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

    if (!onboardingCompleted) {
      // Jika onboarding belum selesai, ke OnboardingScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    } else {
      // Jika onboarding sudah selesai, SELALU ke MainScreen.
      // MainScreen yang akan memutuskan apa yang ditampilkan selanjutnya.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Bagian UI tidak berubah
    final String? appFontFamily = 'Poppins';
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 270, height: 270, filterQuality: FilterQuality.high)
                .animate()
                .fadeIn(duration: 1500.ms)
                .scale(delay: 300.ms, duration: 1200.ms, curve: Curves.elasticOut),
            const SizedBox(height: 8.0),
            // Text(
            //   "InfoZine",
            //   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontFamily: appFontFamily, color: const Color(0xFF0D0D0D)),
            // ).animate().fadeIn(delay: 1000.ms, duration: 1000.ms).slideY(begin: 0.5, end: 0, duration: 800.ms, curve: Curves.easeOutCubic),
          ],
        ),
      ),
    );
  }
}