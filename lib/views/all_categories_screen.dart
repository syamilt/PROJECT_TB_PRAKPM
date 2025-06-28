// lib/views/all_categories_screen.dart

import 'package:flutter/material.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  // --- DAFTAR KATEGORI FINAL DARI ANDA ---
  final List<String> allCategories = const [
    'Politik',
    'Hukum & Kriminal',
    'Internasional',
    'Peristiwa',
    'Ekonomi',
    'Bisnis',
    'Teknologi',
    'Otomotif',
    'Gaya Hidup',
    'Kesehatan',
    'Pendidikan',
    'Kuliner',
    'Liburan',
    'Hiburan',
    'Kisah Inspiratif',
    'Sains',
    'Lingkungan',
    'Olahraga'
  ];

  // --- DAFTAR IKON YANG SUDAH DISESUAIKAN ---
  final List<IconData> categoryIcons = const [
    Icons.gavel,              // Politik
    Icons.local_police,       // Hukum & Kriminal
    Icons.public,             // Internasional
    Icons.newspaper,          // Peristiwa
    Icons.trending_up,        // Ekonomi
    Icons.business_center,    // Bisnis
    Icons.computer,           // Teknologi
    Icons.directions_car,     // Otomotif
    Icons.style,              // Gaya Hidup
    Icons.local_hospital,     // Kesehatan
    Icons.school,             // Pendidikan
    Icons.restaurant_menu,    // Kuliner
    Icons.flight_takeoff,     // Liburan
    Icons.movie_filter,       // Hiburan
    Icons.favorite,           // Kisah Inspiratif
    Icons.science,            // Sains
    Icons.eco,                // Lingkungan
    Icons.sports_soccer,      // Olahraga
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Kategori'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 2.8, // Sedikit diubah rasionya agar lebih pas
        ),
        itemCount: allCategories.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                // Untuk sementara dinonaktifkan sambil menunggu perbaikan server
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur filter untuk kategori ini sedang dalam perbaikan.'),
                    duration: Duration(seconds: 2),
                  ),
                );
                // Jika server sudah normal, gunakan kode di bawah ini:
                // Navigator.push(context, MaterialPageRoute(
                //   builder: (context) => CategoryNewsScreen(categoryName: allCategories[index]),
                // ));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(categoryIcons[index], color: Theme.of(context).primaryColor, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        allCategories[index],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins', fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}