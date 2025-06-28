// lib/views/category_news_screen.dart

import 'package:flutter/material.dart';
import 'package:project_tb_sportscope_prakpm/models/article_model.dart';
import 'package:project_tb_sportscope_prakpm/services/api_service.dart';
import 'package:project_tb_sportscope_prakpm/views/news_detail_screen.dart'; // Impor detail screen

class CategoryNewsScreen extends StatefulWidget {
  final String categoryName;
  const CategoryNewsScreen({super.key, required this.categoryName});

  @override
  State<CategoryNewsScreen> createState() => _CategoryNewsScreenState();
}

class _CategoryNewsScreenState extends State<CategoryNewsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Article>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = _apiService.getPublicNews(category: widget.categoryName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kategori: ${widget.categoryName}'),
      ),
      body: FutureBuilder<List<Article>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final articles = snapshot.data!;
            // Kita bisa gunakan lagi widget list dari HomeScreen, tapi untuk simpelnya kita buat di sini
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(article: article)));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(article.featuredImageUrl != null && article.featuredImageUrl!.isNotEmpty)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(article.featuredImageUrl!, height: 180, width: double.infinity, fit: BoxFit.cover),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(article.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 2, overflow: TextOverflow.ellipsis),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(article.authorName, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: Text('Tidak ada berita untuk kategori "${widget.categoryName}".'));
        },
      ),
    );
  }
}