import 'package:flutter/material.dart';
import 'package:project_tb_sportscope_prakpm/models/article_model.dart';
import 'package:project_tb_sportscope_prakpm/views/news_detail_screen.dart';

// Konstanta warna dan font
const Color appColorPrimary = Color(0xFF072BF2);
const Color appColorTextBlack = Color(0xFF0D0D0D);
const String appFontFamily = 'Poppins';

class CustomSearchDelegate extends SearchDelegate<Article> {
  // Kita akan menerima daftar semua artikel dari HomeScreen
  final List<Article> allArticles;

  CustomSearchDelegate({required this.allArticles});

  // Mengatur style untuk search bar
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 1.0,
        iconTheme: IconThemeData(color: appColorTextBlack),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(fontFamily: appFontFamily, color: Colors.grey),
      ),
      textTheme: Theme.of(context).textTheme.copyWith(
        titleLarge: const TextStyle(
          color: appColorTextBlack,
          fontFamily: appFontFamily,
          fontSize: 18,
        ),
      ),
    );
  }
  
  // Membuat tombol 'clear' (ikon X) di sebelah kanan search bar
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Menghapus teks pencarian
          showSuggestions(context); // Tampilkan kembali saran
        },
      ),
    ];
  }

  // Membuat tombol 'back' (panah kembali) di sebelah kiri search bar
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, allArticles.first); // Menutup halaman pencarian
      },
    );
  }

  // Membangun daftar hasil setelah pengguna menekan 'enter' atau tombol search
  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  // Membangun daftar saran saat pengguna sedang mengetik
  @override
  Widget buildSuggestions(BuildContext context) {
    // Tampilkan hasil secara live saat mengetik
    return _buildSearchResults(context);
  }

  // Widget helper untuk membangun daftar hasil pencarian
  Widget _buildSearchResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Ketik sesuatu untuk mencari berita...'));
    }

    // Logika filter: mencari 'query' di dalam judul artikel
    final List<Article> searchResults = allArticles.where((article) {
      return article.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (searchResults.isEmpty) {
      return Center(child: Text('Tidak ada berita yang cocok dengan "$query"'));
    }

    // Menggunakan ListView yang sama seperti di HomeScreen untuk konsistensi
    return ListView.builder(
      itemCount: searchResults.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        final article = searchResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          elevation: 2,
          child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
            onTap: () {
              // Menutup halaman pencarian dan membuka detail berita
              close(context, article);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewsDetailScreen(article: article)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.category.toUpperCase(),
                          style: const TextStyle(color: appColorPrimary, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: appFontFamily),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          article.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: appColorTextBlack, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: appFontFamily),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (article.featuredImageUrl != null && article.featuredImageUrl!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        article.featuredImageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}