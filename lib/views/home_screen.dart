// lib/views/home_screen.dart (VERSI FINAL DENGAN PERBAIKAN LAYOUT)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_tb_sportscope_prakpm/models/article_model.dart';
import 'package:project_tb_sportscope_prakpm/services/api_service.dart';
import 'package:project_tb_sportscope_prakpm/services/bookmark_service.dart';
import 'package:project_tb_sportscope_prakpm/views/all_categories_screen.dart';
import 'package:project_tb_sportscope_prakpm/views/bookmark_screen.dart';
import 'package:project_tb_sportscope_prakpm/views/category_news_screen.dart';
import 'package:project_tb_sportscope_prakpm/views/news_detail_screen.dart';
import 'package:project_tb_sportscope_prakpm/views/search_delegate.dart';

// Konstanta
const Color appColorPrimary = Color(0xFF072BF2);
const Color appColorTextBlack = Color(0xFF0D0D0D);
const String? appFontFamily = 'Poppins';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Article>> _newsFuture;
  final ApiService _apiService = ApiService();
  final BookmarkService _bookmarkService = BookmarkService();
  Set<String> _bookmarkedSlugs = {};

  final List<String> _popularTopics = const ['Sports', 'Technology', 'Business', 'Health', 'Entertainment'];
  
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _newsFuture = _fetchData();
    });
  }

  Future<List<Article>> _fetchData() async {
    final articlesFuture = _apiService.getPublicNews();
    final bookmarksFuture = _bookmarkService.getBookmarkedSlugs();
    final results = await Future.wait([articlesFuture, bookmarksFuture]);
    final articles = results[0] as List<Article>;
    final bookmarkedSlugs = results[1] as List<String>;
    if (mounted) {
      setState(() { _bookmarkedSlugs = bookmarkedSlugs.toSet(); });
    }
    return articles;
  }
  
  Future<void> _toggleBookmark(String slug) async {
    final isCurrentlyBookmarked = _bookmarkedSlugs.contains(slug);
    if (isCurrentlyBookmarked) {
      await _bookmarkService.removeBookmark(slug);
    } else {
      await _bookmarkService.addBookmark(slug);
    }
    setState(() {
      if (isCurrentlyBookmarked) {
        _bookmarkedSlugs.remove(slug);
      } else {
        _bookmarkedSlugs.add(slug);
      }
    });
  }

  String _formatTimeAgo(DateTime date) {
    final duration = DateTime.now().difference(date);
    if (duration.inDays > 7) {
      return DateFormat('d MMM yy', 'id_ID').format(date);
    } else if (duration.inDays > 0) {
      return '${duration.inDays} hari lalu';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} jam lalu';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} menit lalu';
    } else {
      return 'Baru Saja';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<List<Article>>(
          future: _newsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: appColorPrimary));
            }
            if (snapshot.hasError) {
              return Center(child: Padding(padding: const EdgeInsets.all(16.0), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Terjadi kesalahan: ${snapshot.error}', textAlign: TextAlign.center), const SizedBox(height: 20), ElevatedButton(onPressed: _loadInitialData, child: const Text('Coba Lagi'))])));
            }
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final articles = snapshot.data!;
              final headlineArticles = articles.length > 2 ? articles.take(2).toList() : articles;
              return RefreshIndicator(
                onRefresh: _loadInitialData,
                color: appColorPrimary,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, articles),
                      _buildSectionTitle('Berita Utama'),
                      _buildHeadlineCarousel(headlineArticles),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Kategori Berita'),
                      _buildPopularTopics(context, _popularTopics),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Berita Terbaru'),
                      _buildLatestNewsList(articles),
                    ],
                  ),
                ),
              );
            }
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('Tidak ada berita saat ini.'), const SizedBox(height: 20), ElevatedButton(onPressed: _loadInitialData, child: const Text('Muat Ulang'))]));
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, List<Article> allArticles) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Beranda', style: TextStyle(fontFamily: appFontFamily, color: appColorTextBlack, fontSize: 28, fontWeight: FontWeight.bold)),
        Row(children: [
          IconButton(onPressed: () { showSearch(context: context, delegate: CustomSearchDelegate(allArticles: allArticles)); }, icon: const Icon(Icons.search, color: appColorTextBlack, size: 28)),
          IconButton(onPressed: () async { await Navigator.push(context, MaterialPageRoute(builder: (context) => const BookmarkScreen())); _loadInitialData(); }, icon: const Icon(Icons.bookmarks_outlined, color: appColorTextBlack, size: 28)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_outlined, color: appColorTextBlack, size: 28)),
        ])
      ]),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
      child: Text(title, style: TextStyle(fontFamily: appFontFamily, fontSize: 18, fontWeight: FontWeight.bold, color: appColorTextBlack)),
    );
  }

  Widget _buildHeadlineCarousel(List<Article> articles) {
    return Container(
      height: 220,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return GestureDetector(
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(article: article)));
              _loadInitialData();
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 5,
              shadowColor: Colors.black.withOpacity(0.2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Stack(fit: StackFit.expand, children: [
                  if (article.featuredImageUrl != null && article.featuredImageUrl!.isNotEmpty)
                    Image.network(article.featuredImageUrl!, fit: BoxFit.cover, filterQuality: FilterQuality.medium,
                      loadingBuilder: (context, child, loadingProgress) => loadingProgress == null ? child : const Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                      errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[200], child: Icon(Icons.broken_image, color: Colors.grey[400])),
                    )
                  else
                    Container(color: Colors.grey[200], child: Icon(Icons.image_not_supported, color: Colors.grey[400])),
                  Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.black.withOpacity(0.8), Colors.transparent], begin: Alignment.bottomCenter, end: const Alignment(0, -0.2)))),
                  Positioned(bottom: 16, left: 16, right: 16, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.circular(6.0)), child: Text(article.category.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: appFontFamily))),
                    const SizedBox(height: 8),
                    Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: appFontFamily, shadows: [Shadow(blurRadius: 4.0, color: Colors.black54)])),
                  ]))
                ]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularTopics(BuildContext context, List<String> topics) {
    return Container(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: topics.length + 1,
        itemBuilder: (context, index) {
          if (index == topics.length) {
            return TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AllCategoriesScreen())),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [Text('Lihat Semua', style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(width: 4), Icon(Icons.arrow_forward, size: 16)]),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ActionChip(
              label: Text(topics[index]),
              labelStyle: const TextStyle(color: appColorTextBlack, fontFamily: appFontFamily, fontWeight: FontWeight.w600),
              backgroundColor: Colors.grey[200],
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fitur filter kategori sedang dalam perbaikan.'), duration: Duration(seconds: 2)));
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              side: BorderSide.none,
            ),
          );
        },
      ),
    );
  }

  // --- FUNGSI DENGAN PERBAIKAN FINAL ---
  Widget _buildLatestNewsList(List<Article> articles) {
    return ListView.builder( // Diubah ke ListView.builder agar lebih efisien
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        final bool isBookmarked = _bookmarkedSlugs.contains(article.slug);

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: InkWell(
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailScreen(article: article)));
              _loadInitialData(); // Muat ulang semua data untuk refresh status bookmark
            },
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              // TINGGI KARTU TIDAK LAGI DIPAKSA (DIHAPUS)
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.0), border: Border.all(color: Colors.grey[200]!)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(12.0), bottomLeft: Radius.circular(12.0)),
                    child: (article.featuredImageUrl != null && article.featuredImageUrl!.isNotEmpty)
                        ? Image.network(
                            article.featuredImageUrl!,
                            width: 120, // Sedikit diperlebar
                            height: 120, // Tinggi gambar menjadi patokan
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.medium,
                            loadingBuilder: (context, child, loadingProgress) => loadingProgress == null ? child : Container(width: 120, height: 120, child: const Center(child: CircularProgressIndicator(strokeWidth: 2.0))),
                            errorBuilder: (context, error, stackTrace) => Container(width: 120, height: 120, color: Colors.grey[200], child: Icon(Icons.broken_image, color: Colors.grey[400])),
                          )
                        : Container(width: 120, height: 120, color: Colors.grey[200], child: Icon(Icons.image_not_supported, color: Colors.grey[400])),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(article.category.toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: appColorPrimary, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: appFontFamily)),
                          const SizedBox(height: 6),
                          Text(
                            article.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: appColorTextBlack, fontSize: 14, height: 1.4, fontWeight: FontWeight.bold, fontFamily: appFontFamily),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${article.authorName} • ${_formatTimeAgo(article.publishedAt)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12, fontFamily: appFontFamily),
                                ),
                              ),
                              IconButton(
                                onPressed: () => _toggleBookmark(article.slug),
                                icon: Icon(
                                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                  color: isBookmarked ? appColorPrimary : Colors.grey,
                                  size: 22,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                splashRadius: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
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