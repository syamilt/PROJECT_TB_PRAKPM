// lib/views/artikel_saya_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_tb_sportscope_prakpm/models/article_model.dart';
import 'package:project_tb_sportscope_prakpm/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_tb_sportscope_prakpm/views/article_form_screen.dart'; // Path baru ke form

const Color appColorPrimary = Color(0xFF072BF2);
const String appFontFamily = 'Poppins';

class ArtikelSayaScreen extends StatefulWidget {
  const ArtikelSayaScreen({super.key});

  @override
  State<ArtikelSayaScreen> createState() => _ArtikelSayaScreenState();
}

class _ArtikelSayaScreenState extends State<ArtikelSayaScreen> {
  final ApiService _apiService = ApiService();
  Future<List<Article>>? _myArticlesFuture;

  @override
  void initState() {
    super.initState();
    _loadMyArticles();
  }

  Future<void> _loadMyArticles() async {
    setState(() {
      _myArticlesFuture = _fetchArticles();
    });
  }
  
  Future<List<Article>> _fetchArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('Token tidak ditemukan, silahkan login ulang.');
    }
    final articles = await _apiService.getMyArticles(token);
    articles.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return articles;
  }

  void _navigateToForm({Article? article}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ArticleFormScreen(article: article)),
    );
    if (result == true) {
      _loadMyArticles();
    }
  }

  // --- FUNGSI BARU UNTUK MENGHAPUS ARTIKEL ---
  Future<void> _handleDelete(String articleId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) throw Exception('Token tidak ditemukan');

      await _apiService.deleteArticle(token, articleId);
      
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Artikel berhasil dihapus'), backgroundColor: Colors.green),
        );
      }
      _loadMyArticles(); // Muat ulang daftar artikel
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus artikel: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showOptions(BuildContext context, Article article) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit Artikel'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToForm(article: article);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Hapus Artikel', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  // Tampilkan dialog konfirmasi sebelum menghapus
                  showDialog(
                    context: context,
                    builder: (BuildContext ctx) => AlertDialog(
                      title: const Text('Konfirmasi Hapus'),
                      content: Text('Apakah Anda yakin ingin menghapus artikel "${article.title}"?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _handleDelete(article.id);
                          },
                          child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Artikel Saya'), automaticallyImplyLeading: false),
      body: FutureBuilder<List<Article>>(
        future: _myArticlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: appColorPrimary));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final myArticles = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: myArticles.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildArticleCard(myArticles[index]),
            );
          }
          return _buildEmptyState();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        backgroundColor: appColorPrimary,
        tooltip: 'Tulis Artikel Baru',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
  
  Widget _buildArticleCard(Article article) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
        title: Text(article.title, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: appFontFamily)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(children: [
            Chip(
              label: Text(
                article.isPublished ? 'Diterbitkan' : 'Draft',
                style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: article.isPublished ? Colors.green[600] : Colors.orange[600],
              padding: const EdgeInsets.symmetric(horizontal: 8),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 8),
            Text(
              DateFormat('d MMM yy', 'id_ID').format(article.createdAt),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ]),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showOptions(context, article),
        ),
        onTap: () => _navigateToForm(article: article),
      ),
    );
  }

  Widget _buildEmptyState() {
    // LayoutBuilder digunakan untuk mendapatkan tinggi maksimal layar
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Agar bisa di-refresh
          child: ConstrainedBox(
            // Memaksa konten untuk setidaknya setinggi layar
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.note_add_outlined, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    const Text('Anda belum menulis artikel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: appFontFamily)),
                    const SizedBox(height: 8),
                    Text(
                      'Tekan tombol + di pojok kanan bawah untuk membuat artikel pertama Anda.',
                      textAlign: TextAlign.center, // <-- Menambahkan perataan tengah
                      style: TextStyle(color: Colors.grey[600], height: 1.5, fontFamily: appFontFamily), // Menambah tinggi baris
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}