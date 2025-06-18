import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Impor semua halaman tujuan
import 'package:project_tb_sportscope_prakpm/views/onboarding_screen.dart';
import 'package:project_tb_sportscope_prakpm/views/login_screen.dart';
import 'package:project_tb_sportscope_prakpm/views/main_screen.dart'; // Pastikan file ini sudah dibuat

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkStatusAndNavigate(); // Memanggil fungsi pengecekan
  }

  // Fungsi untuk memeriksa status dan melakukan navigasi
  Future<void> _checkStatusAndNavigate() async {
    // Memberi jeda agar animasi splash screen sempat terlihat penuh
    await Future.delayed(const Duration(milliseconds: 4500));

    // Jika widget sudah di-dispose (misal, pengguna menutup aplikasi), jangan lanjutkan.
    if (!mounted) return;

    // 1. Akses SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // 2. Cek apakah onboarding sudah selesai
    final bool onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

    // 3. Jika onboarding belum selesai, arahkan ke OnboardingScreen
    if (!onboardingCompleted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const OnboardingScreen(),
        ),
      );
      return; // Hentikan fungsi di sini
    }

    // 4. Jika onboarding sudah selesai, cek apakah ada token login
    final String? token = prefs.getString('auth_token'); // Kita akan gunakan key 'auth_token' nanti saat login

    // 5. Tentukan halaman berikutnya berdasarkan keberadaan token
    Widget nextPage;
    if (token != null && token.isNotEmpty) {
      // Jika ada token, anggap sudah login -> arahkan ke MainScreen
      nextPage = const MainScreen();
    } else {
      // Jika tidak ada token -> arahkan ke LoginScreen
      nextPage = const LoginScreen();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => nextPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Bagian UI tidak berubah sama sekali
    final String appFontFamily = 'Poppins';
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
              filterQuality: FilterQuality.high,
            )
            .animate()
            .fadeIn(duration: 1500.ms)
            .scale(delay: 300.ms, duration: 1200.ms, curve: Curves.elasticOut),

            const SizedBox(height: 8.0),

            Text(
              "InfoZine",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: appFontFamily,
                color: const Color(0xFF0D0D0D),
              ),
            )
            .animate()
            .fadeIn(delay: 1000.ms, duration: 1000.ms)
            .slideY(begin: 0.5, end: 0, duration: 800.ms, curve: Curves.easeOutCubic),
          ],
        ),
      ),
    );
  }
}