import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_tb_sportscope_prakpm/models/article_model.dart';
import 'package:project_tb_sportscope_prakpm/services/bookmark_service.dart'; // Impor bookmark service

// Konstanta warna dan font
const Color appColorPrimary = Color(0xFF072BF2);
const Color appColorTextBlack = Color(0xFF0D0D0D);
const String appFontFamily = 'Poppins';

class NewsDetailScreen extends StatefulWidget {
  final Article article;
  const NewsDetailScreen({super.key, required this.article});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final BookmarkService _bookmarkService = BookmarkService();
  bool _isBookmarked = false; // State untuk melacak status bookmark

  @override
  void initState() {
    super.initState();
    // Saat halaman pertama kali dibuka, cek apakah berita ini sudah di-bookmark
    _checkIfBookmarked();
  }

  // Fungsi untuk memeriksa status bookmark dari penyimpanan lokal
  Future<void> _checkIfBookmarked() async {
    bool bookmarked = await _bookmarkService.isBookmarked(widget.article.slug);
    // Update UI sesuai dengan status
    if (mounted) {
      setState(() {
        _isBookmarked = bookmarked;
      });
    }
  }
  
  // Fungsi yang dipanggil saat tombol bookmark ditekan
  Future<void> _toggleBookmark() async {
    if (_isBookmarked) {
      // Jika sudah di-bookmark, hapus
      await _bookmarkService.removeBookmark(widget.article.slug);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bookmark dihapus'), duration: Duration(seconds: 1)),
        );
      }
    } else {
      // Jika belum, tambahkan
      await _bookmarkService.addBookmark(widget.article.slug);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berita disimpan ke bookmark'), duration: Duration(seconds: 1)),
        );
      }
    }
    // Perbarui status ikon setelah aksi
    _checkIfBookmarked();
  }

  // Fungsi untuk format tanggal lengkap
  String _formatFullDate(DateTime date) {
    final DateFormat formatter = DateFormat('EEEE, d MMMM yyyy, HH:mm', 'id_ID');
    return '${formatter.format(date)} WIB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            stretch: true,
            backgroundColor: appColorPrimary,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
              title: Text(
                widget.article.category.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: appFontFamily,
                  shadows: [Shadow(blurRadius: 4.0, color: Colors.black87)],
                ),
              ),
              centerTitle: true,
              background: (widget.article.featuredImageUrl != null && widget.article.featuredImageUrl!.isNotEmpty)
                  ? Image.network(
                      widget.article.featuredImageUrl!,
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.4),
                      colorBlendMode: BlendMode.darken,
                    )
                  : Container(color: Colors.grey),
            ),
            actions: [
              //ICON BUTTON BOOKMARK 
              IconButton(
                // Ikon berubah berdasarkan state _isBookmarked
                icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                tooltip: 'Simpan Berita',
                onPressed: _toggleBookmark,
              ),
              IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Bagikan',
                onPressed: () { /* TODO: Logika Share */ },
              ),
            ],
          ),
          // Konten artikel di bawah AppBar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Berita
                  Text(
                    widget.article.title,
                    style: const TextStyle(
                      fontFamily: appFontFamily,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: appColorTextBlack,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Informasi Penulis dan Tanggal
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey[200],
                        child: const Icon(Icons.person, size: 22, color: Colors.grey),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.article.authorName,
                              style: const TextStyle(
                                fontFamily: appFontFamily,
                                fontWeight: FontWeight.w600,
                                color: appColorTextBlack,
                              ),
                            ),
                            Text(
                              _formatFullDate(widget.article.publishedAt),
                              style: TextStyle(
                                fontFamily: appFontFamily,
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  const Divider(thickness: 0.5),
                  const SizedBox(height: 12.0),

                  // Isi Konten Berita
                  Text(
                    widget.article.content.replaceAll(r'\n', '\n\n'), // Ganti '\n' menjadi paragraf baru
                    style: TextStyle(
                      fontFamily: appFontFamily,
                      fontSize: 16.0,
                      color: appColorTextBlack.withOpacity(0.85),
                      height: 1.7, // Jarak antar baris agar nyaman dibaca
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}