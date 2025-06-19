// lib/views/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_tb_sportscope_prakpm/views/main_screen.dart'; // DIUBAH: Mengimpor MainScreen

// Definisi Warna Palet Aplikasi Anda
const Color appColorPrimary = Color(0xFF072BF2);
const Color appColorTextBlack = Color(0xFF0D0D0D);
const Color appColorTextSlightlyLighterBlack = Color(0xFF333333);
const Color appColorInactiveGrey = Color(0xFFBDBDBD);
const Color appColorIconBackground = Color(0xFFE0E0FF);

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (!mounted) return;

    // --- PERUBAHAN UTAMA DI SINI ---
    // Arahkan ke MainScreen. MainScreen akan menampilkan mode Viewer/Tamu secara otomatis.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  Widget _buildAnimatedIconContainer(IconData iconData, {double iconSize = 60.0, double containerSize = 120.0}) {
    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        color: appColorIconBackground,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: appColorPrimary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        iconData,
        size: iconSize,
        color: appColorPrimary,
      ),
    )
    .animate()
    .fadeIn(duration: 600.ms, delay: 200.ms)
    .scale(duration: 500.ms, curve: Curves.elasticOut, delay: 300.ms);
  }

  PageViewModel _buildPageViewModel({
    required String title,
    required String body,
    required Widget image,
    required PageDecoration decoration,
  }) {
    return PageViewModel(
      titleWidget: Text(
        title,
        textAlign: TextAlign.center,
        style: decoration.titleTextStyle,
      ).animate().fadeIn(delay: 500.ms, duration: 600.ms).slideY(begin: 0.2, duration: 500.ms, curve: Curves.easeOut),
      bodyWidget: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          body,
          textAlign: TextAlign.center,
          style: decoration.bodyTextStyle,
        ).animate().fadeIn(delay: 700.ms, duration: 600.ms).slideY(begin: 0.2, duration: 500.ms, curve: Curves.easeOut),
      ),
      image: Padding(
        padding: decoration.imagePadding ?? const EdgeInsets.all(0),
        child: image,
      ),
      decoration: decoration.copyWith(
        contentMargin: EdgeInsets.zero,
        bodyFlex: 2,
        imageFlex: 3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String? appFontFamily = 'Poppins';

    final pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        fontFamily: appFontFamily,
        color: appColorTextBlack,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        fontFamily: appFontFamily,
        color: appColorTextSlightlyLighterBlack,
        height: 1.4,
      ),
      bodyAlignment: Alignment.center,
      bodyPadding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
      imagePadding: const EdgeInsets.only(bottom: 24.0, top: 40.0),
      pageColor: Colors.white,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        _buildPageViewModel(
          title: "Akses Berita Terkini",
          body: "Dapatkan berita terbaru, terhangat, dan terpercaya dari berbagai sumber.",
          image: _buildAnimatedIconContainer(Icons.newspaper_outlined),
          decoration: pageDecoration,
        ),
        _buildPageViewModel(
          title: "Jangan Ketinggalan Momen",
          body: "Fitur notifikasi untuk berita penting yang tidak boleh Anda lewatkan.",
          image: _buildAnimatedIconContainer(Icons.notifications_active_outlined),
          decoration: pageDecoration,
        ),
        _buildPageViewModel(
          title: "Tulis & Kelola Artikel",
          body: "Masuk untuk menjadi kontributor, tulis beritamu sendiri, dan kelola semuanya dengan mudah.",
          image: _buildAnimatedIconContainer(Icons.drive_file_rename_outline),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: Text(
        'Lewati',
        style: TextStyle(
            fontWeight: FontWeight.w600,
            color: appColorTextBlack.withOpacity(0.7),
            fontFamily: appFontFamily),
      ),
      next: const Icon(Icons.arrow_forward, color: appColorPrimary, size: 26),
      done: Text(
        'Mulai',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: appColorPrimary,
            fontFamily: appFontFamily),
      ),
      curve: Curves.easeInOutCubic,
      controlsMargin: const EdgeInsets.all(16.0),
      controlsPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      dotsDecorator: DotsDecorator(
        size: const Size(8.0, 8.0),
        activeSize: const Size(22.0, 10.0),
        color: appColorInactiveGrey.withOpacity(0.5),
        activeColor: appColorPrimary,
        activeShape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      isProgress: true,
    );
  }
}