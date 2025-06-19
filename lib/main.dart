// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Diperlukan untuk SystemUiOverlayStyle
import 'package:intl/date_symbol_data_local.dart'; // Impor untuk format tanggal
import 'package:project_tb_sportscope_prakpm/views/splash_screen.dart';

// Definisi warna utama aplikasi Anda
const Color appColorPrimary = Color(0xFF072BF2);
const Color appColorTextBlack = Color(0xFF0D0D0D);

void main() async {
  // Memastikan semua binding Flutter siap sebelum menjalankan kode async
  WidgetsFlutterBinding.ensureInitialized();

  // Menyiapkan data lokalisasi untuk format tanggal Bahasa Indonesia
  await initializeDateFormatting('id_ID', null);

  // Menjalankan aplikasi
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengatur agar status bar di atas (tempat jam, sinyal) memiliki ikon terang
    // karena AppBar kita seringkali berwarna gelap atau primer.
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent, // Membuat status bar transparan
      statusBarIconBrightness: Brightness.dark, // Ikon (jam, sinyal) menjadi gelap
    ));
    
    return MaterialApp(
      title: 'InfoZine', // Judul aplikasi Anda
      theme: ThemeData(
        // --- TEMA UTAMA APLIKASI ---
        fontFamily: 'Poppins', // Mengatur Poppins sebagai font default untuk seluruh aplikasi
        primaryColor: appColorPrimary,
        scaffoldBackgroundColor: Colors.white, // Latar belakang default untuk semua scaffold

        // Skema warna untuk konsistensi
        colorScheme: ColorScheme.fromSeed(
          seedColor: appColorPrimary,
          primary: appColorPrimary,
          onPrimary: Colors.white, // Warna teks di atas warna primer (misal, di tombol)
          background: Colors.white,
          onBackground: appColorTextBlack, // Warna teks umum
        ),

        // Tema untuk AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0.5,
          iconTheme: IconThemeData(color: appColorTextBlack), // Tombol back default menjadi hitam
          titleTextStyle: TextStyle(
            color: appColorTextBlack,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),

        // Tema untuk Tombol ElevatedButton
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: appColorPrimary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ),

        // Tema untuk Tombol TextButton
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: appColorPrimary,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            )
          ),
        ),
        
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // Halaman awal tetap SplashScreen
    );
  }
}