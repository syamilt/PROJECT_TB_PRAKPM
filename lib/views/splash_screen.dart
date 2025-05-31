import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_tb_sportscope_prakpm/views/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 4500), () { // Durasi total splash screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const OnboardingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? appFontFamily = 'Poppins';
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Logo Aplikasi dengan Animasi
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
              filterQuality: FilterQuality.high, // Opsional untuk gambar lebih halus
            )
            .animate()
            .fadeIn(duration: 1500.ms) // Efek fade in
            .scale(delay: 300.ms, duration: 1200.ms, curve: Curves.elasticOut), // Efek skala dengan delay

            
            const SizedBox(height: 1.0), 

            Text(
              "SportScope",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: appFontFamily,
                color: const Color(0xFF0D0D0D),
              ),
            )
            .animate()
            // animasi Muncul setelah logo mulai fadeIn dan scale
            .fadeIn(delay: 1000.ms, duration: 1000.ms)
            // animasi Bergerak naik dari bawah
            .slideY(begin: 0.5, end: 0, duration: 800.ms, curve: Curves.easeOutCubic),
          ],
        ),
      ),
    );
  }
}