// lib/models/article_model.dart

class Article {
  final String id;
  final String title;
  final String slug;
  final String? summary; // Ditambahkan
  final String content;
  final String? featuredImageUrl;
  final String category;
  final List<String> tags; // Ditambahkan
  final bool isPublished; // Ditambahkan
  final String authorName;
  final DateTime publishedAt;
  final DateTime createdAt; // Ditambahkan

  Article({
    required this.id,
    required this.title,
    required this.slug,
    this.summary,
    required this.content,
    this.featuredImageUrl,
    required this.category,
    required this.tags,
    required this.isPublished,
    required this.authorName,
    required this.publishedAt,
    required this.createdAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Tanpa Judul',
      slug: json['slug'] ?? '',
      summary: json['summary'],
      content: json['content'] ?? '',
      featuredImageUrl: json['featured_image_url'],
      category: json['Category'] != null ? json['Category']['name'] ?? 'Uncategorized' : json['category'] ?? 'Uncategorized',
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      isPublished: json['isPublished'] ?? json['is_published'] ?? false,
      authorName: json['User'] != null ? json['User']['name'] ?? 'Unknown Author' : json['author_name'] ?? 'Unknown Author',
      publishedAt: json['published_at'] != null ? DateTime.parse(json['published_at']) : DateTime.now(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }

  // Fungsi untuk mengubah objek Article menjadi JSON (untuk POST & PUT)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'summary': summary,
      'content': content,
      'featuredImageUrl': featuredImageUrl,
      'category': category,
      'tags': tags,
      'isPublished': isPublished,
    };
  }
}