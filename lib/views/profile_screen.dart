// lib/views/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_tb_sportscope_prakpm/views/edit_profile_screen.dart';

// Konstanta
const Color appColorPrimary = Color(0xFF072BF2);
const Color appColorTextBlack = Color(0xFF0D0D0D);
const Color appColorTextSlightlyLighterBlack = Color(0xFF333333);
const String? appFontFamily = 'Poppins';
const String profileAvatarPath = 'assets/images/profile_avatar.png'; // Path untuk foto profil

class ProfileScreen extends StatelessWidget {
  final bool isLoggedIn;
  final VoidCallback onLogout;
  final VoidCallback onLogin;

  const ProfileScreen({
    super.key,
    required this.isLoggedIn,
    required this.onLogout,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // AppBar dihilangkan agar bisa membuat header custom di dalam body
      body: Center(
        // Padding utama dihilangkan dari sini dan diatur di dalam masing-masing view
        child: isLoggedIn ? _buildLoggedInView(context) : _buildGuestView(context),
      ),
    );
  }

  // Widget helper untuk membuat baris informasi yang rapi
  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: appColorPrimary.withOpacity(0.8)),
      title: Text(title, style: TextStyle(fontFamily: appFontFamily, color: Colors.grey[600], fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontFamily: appFontFamily, color: appColorTextBlack, fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }

  // Tampilan jika pengguna SUDAH LOGIN (Creator)
  Widget _buildLoggedInView(BuildContext context) {
    // TODO: Nanti kita panggil API untuk mendapatkan data asli pengguna
    const String userName = "ITG News";
    const String userEmail = "news@itg.ac.id";
    const String userBio = "Akun resmi @ITG News. Selalu berikan informasi terkini, terhangat, dan terpercaya.";
    final String joinDate = DateFormat('d MMMM yyyy', 'id_ID').format(DateTime.now().subtract(const Duration(days: 30)));
    const String birthDate = "Belum diatur";

    return ListView( // Menggunakan ListView agar bisa di-scroll
      padding: EdgeInsets.zero, // Menghilangkan padding default dari ListView
      children: [
        // --- Bagian Header dengan Foto Profil ---
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              // Memberi margin agar shadow dari Card di bawahnya terlihat
              margin: const EdgeInsets.only(bottom: 70), 
              height: 150,
              decoration: const BoxDecoration(
                color: appColorPrimary,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
            ),
            Positioned(
              top: 150 - 65, // Setengah dari ukuran avatar agar menonjol ke bawah
              child: CircleAvatar(
                radius: 65, // Radius untuk border putih
                backgroundColor: Colors.grey[100], // Warna sama dengan background scaffold
                child: CircleAvatar(
                  radius: 60, // Radius untuk gambar profil
                  backgroundColor: Colors.grey[200],
                  backgroundImage: const AssetImage(profileAvatarPath),
                ),
              ),
            ),
          ],
        ),

        // --- Informasi Nama dan Email ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Text(
                userName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: appFontFamily),
              ),
              const SizedBox(height: 4),
              Text(
                userEmail,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600], fontFamily: appFontFamily),
              ),
              const SizedBox(height: 16),
              Text(
                userBio,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: appFontFamily, fontSize: 14, color: appColorTextSlightlyLighterBlack, height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // --- Kartu Informasi Detail ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Card(
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: Column(
              children: [
                _buildInfoTile(Icons.person_outline, 'Nama Lengkap', userName),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildInfoTile(Icons.cake_outlined, 'Tanggal Lahir', birthDate),
                const Divider(height: 1, indent: 16, endIndent: 16),
                _buildInfoTile(Icons.calendar_today_outlined, 'Bergabung Sejak', joinDate),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // --- Tombol Edit Profil dan Logout ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                  );
                },
                icon: const Icon(Icons.edit_outlined, size: 20),
                label: const Text('EDIT PROFIL'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColorPrimary.withOpacity(0.15),
                  foregroundColor: appColorPrimary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Konfirmasi Logout'),
                        content: const Text('Apakah Anda yakin ingin keluar?'),
                        actions: [
                          TextButton(child: const Text('Batal'), onPressed: () => Navigator.of(context).pop()),
                          TextButton(
                            child: const Text('Logout', style: TextStyle(color: Colors.red)),
                            onPressed: () {
                              Navigator.of(context).pop();
                              onLogout();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('LOGOUT'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
         const SizedBox(height: 20),
      ],
    );
  }

  // Tampilan jika pengguna BELUM LOGIN (Viewer)
  Widget _buildGuestView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.login, size: 80, color: Colors.grey[400]),
        const SizedBox(height: 16),
        const Text(
          'Anda Belum Masuk',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: appFontFamily),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Masuk atau daftar untuk menjadi kontributor dan mengelola artikel Anda.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600], fontFamily: appFontFamily, height: 1.5),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: onLogin,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          ),
          child: const Text('MASUK ATAU DAFTAR'),
        ),
      ],
    );
  }
}