// lib/views/main_screen.dart

import 'package:flutter/material.dart';

// Impor semua halaman yang akan ditampilkan di navigasi bawah
import 'package:project_tb_sportscope_prakpm/views/home_screen.dart';
import 'package:project_tb_sportscope_prakpm/views/myarticle_screen.dart';
import 'package:project_tb_sportscope_prakpm/views/profile_screen.dart';

// Impor warna palet aplikasi Anda
const Color appColorPrimary = Color(0xFF072BF2);
const Color appColorTextBlack = Color(0xFF0D0D0D);
const String appFontFamily = 'Poppins';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Variabel untuk melacak indeks/halaman yang sedang aktif
  int _selectedIndex = 0;

  // Daftar halaman/widget yang akan ditampilkan
  // Urutannya harus sesuai dengan urutan item di BottomNavigationBar
  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    ArtikelSayaScreen(),
    ProfileScreen(),
  ];

  // Fungsi yang akan dipanggil saat salah satu tab navigasi ditekan
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body akan menampilkan halaman dari list `_pages` sesuai dengan indeks yang aktif
      body: _pages.elementAt(_selectedIndex),
      
      // Definisikan BottomNavigationBar di sini
      bottomNavigationBar: BottomNavigationBar(
        // Daftar item/tombol navigasi
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // Ikon saat aktif
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: 'Artikel Saya',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        // Styling untuk BottomNavigationBar
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed, // Agar semua label terlihat dan ukurannya tetap
        selectedItemColor: appColorPrimary,
        unselectedItemColor: appColorTextBlack.withOpacity(0.6),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontFamily: appFontFamily),
        unselectedLabelStyle: const TextStyle(fontFamily: appFontFamily),
        elevation: 8.0,
      ),
    );
  }
}