import 'package:flutter/material.dart';
import 'package:project_tb_sportscope_prakpm/models/article_model.dart';
import 'package:project_tb_sportscope_prakpm/services/api_service.dart';
import 'package:project_tb_sportscope_prakpm/services/bookmark_service.dart';
import 'package:project_tb_sportscope_prakpm/views/news_detail_screen.dart';

// Konstanta warna dan font
const Color appColorPrimary = Color(0xFF072BF2);
const Color appColorTextBlack = Color(0xFF0D0D0D);
const String appFontFamily = 'Poppins';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final BookmarkService _bookmarkService = BookmarkService();
  final ApiService _apiService = ApiService();
  late Future<List<Article>> _bookmarkedArticlesFuture;

  @override
  void initState() {
    super.initState();
    _loadBookmarkedArticles();
  }

  void _loadBookmarkedArticles() {
    setState(() {
      _bookmarkedArticlesFuture = _fetchBookmarkedArticles();
    });
  }

  Future<List<Article>> _fetchBookmarkedArticles() async {
    // 1. Dapatkan semua slug yang disimpan
    final List<String> slugs = await _bookmarkService.getBookmarkedSlugs();
    
    // 2. Ambil detail untuk setiap slug dari API
    final List<Future<Article>> articleFutures = slugs
        .map((slug) => _apiService.getNewsBySlug(slug))
        .toList();
    
    // 3. Tunggu semua permintaan API selesai
    final List<Article> articles = await Future.wait(articleFutures);
    return articles.reversed.toList(); // Tampilkan yang terbaru disimpan di atas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Berita Disimpan')),
      body: FutureBuilder<List<Article>>(
        future: _bookmarkedArticlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: appColorPrimary));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final articles = snapshot.data!;
            // Gunakan widget list yang sama seperti di HomeScreen 
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: appFontFamily)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(article.authorName, style: TextStyle(fontFamily: appFontFamily)),
                    ),
                    leading: (article.featuredImageUrl != null && article.featuredImageUrl!.isNotEmpty)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(article.featuredImageUrl!, width: 80, height: 80, fit: BoxFit.cover),
                        )
                      : Container(width: 80, height: 80, color: Colors.grey[200]),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewsDetailScreen(article: article)),
                      );
                      // Setelah kembali dari detail, muat ulang daftar bookmark
                      _loadBookmarkedArticles();
                    },
                  ),
                );
              },
            );
          }
          // Tampilan jika tidak ada bookmark
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_remove_outlined, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text('Anda belum menyimpan berita apapun.'),
              ],
            ),
          );
        },
      ),
    );
  }
}