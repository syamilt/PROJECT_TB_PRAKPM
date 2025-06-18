// lib/models/article_model.dart

class Article {
  final String id;
  final String title;
  final String slug;
  final String? featuredImageUrl; // Nama field di API: featured_image_url
  final String content;
  final String category;
  final String authorName; // Nama field di API: author_name
  final DateTime publishedAt; // Nama field di API: published_at

  Article({
    required this.id,
    required this.title,
    required this.slug,
    this.featuredImageUrl,
    required this.content,
    required this.category,
    required this.authorName,
    required this.publishedAt,
  });

  // Factory constructor untuk membuat instance Article dari JSON
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Tanpa Judul',
      slug: json['slug'] ?? '',
      // PERBAIKAN NAMA FIELD
      featuredImageUrl: json['featured_image_url'], // Menggunakan snake_case
      content: json['content'] ?? '',
      // PERBAIKAN: category adalah string langsung, bukan objek
      category: json['category'] ?? 'Uncategorized',
      // PERBAIKAN NAMA FIELD
      authorName: json['author_name'] ?? 'Unknown Author', // Menggunakan snake_case
      // PERBAIKAN NAMA FIELD
      publishedAt: json['published_at'] != null ? DateTime.parse(json['published_at']) : DateTime.now(),
    );
  }
}