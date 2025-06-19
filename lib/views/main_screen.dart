// lib/views/main_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:project_tb_sportscope_prakpm/views/home_screen.dart';
import 'package:project_tb_sportscope_prakpm/views/myarticle_screen.dart';
import 'package:project_tb_sportscope_prakpm/views/profile_screen.dart';
import 'package:project_tb_sportscope_prakpm/views/login_screen.dart';

const Color appColorPrimary = Color(0xFF072BF2);
const Color appColorTextBlack = Color(0xFF0D0D0D);
const String? appFontFamily = 'Poppins';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isLoggedIn = false;
  bool _isLoading = true; // State untuk loading saat cek token

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Fungsi untuk mengecek token saat aplikasi dibuka
  Future<void> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    setState(() {
      _isLoggedIn = (token != null && token.isNotEmpty);
      _isLoading = false; // Selesai loading
    });
  }

  // Fungsi untuk menangani logout dari ProfileScreen
  Future<void> _handleLogout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Hapus token
    setState(() {
      _isLoggedIn = false;
      _selectedIndex = 0; // Kembali ke tab Beranda
    });
  }

  // Fungsi untuk menangani navigasi ke login, lalu refresh state
  void _navigateToLogin() async {
    // Tunggu hasil dari halaman login
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
    // Setelah kembali dari login, cek ulang statusnya
    _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan loading indicator saat sedang mengecek token
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: appColorPrimary),
        ),
      );
    }
    
    // Siapkan halaman dan item navigasi berdasarkan status login
    final List<Widget> pages = _isLoggedIn
        ? [ // Tampilan untuk Creator (sudah login)
            const HomeScreen(),
            const ArtikelSayaScreen(),
            ProfileScreen(
              isLoggedIn: _isLoggedIn,
              onLogout: _handleLogout, // Kirim fungsi logout
              onLogin: _navigateToLogin,
            ),
          ]
        : [ // Tampilan untuk Viewer (belum login)
            const HomeScreen(),
            ProfileScreen(
              isLoggedIn: _isLoggedIn,
              onLogout: _handleLogout,
              onLogin: _navigateToLogin, // Kirim fungsi login
            ),
          ];

    final List<BottomNavigationBarItem> navBarItems = _isLoggedIn
        ? [ // Menu untuk Creator
            const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Beranda'),
            const BottomNavigationBarItem(icon: Icon(Icons.article_outlined), activeIcon: Icon(Icons.article), label: 'Artikel Saya'),
            const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
          ]
        : [ // Menu untuk Viewer
            const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Beranda'),
            const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
          ];

    return Scaffold(
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: navBarItems,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: appColorPrimary,
        unselectedItemColor: appColorTextBlack.withOpacity(0.6),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontFamily: appFontFamily),
        unselectedLabelStyle: const TextStyle(fontFamily: appFontFamily),
      ),
    );
  }
}