// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_tb_sportscope_prakpm/models/article_model.dart'; // Pastikan path model ini benar

class ApiService {
  // Alamat dasar dari server API Anda
  static const String _baseUrl = 'http://45.149.187.204:3000/api';

 // Di dalam file lib/services/api_service.dart

  Future<String> login(String email, String password) async {
    final Uri loginUrl = Uri.parse('$_baseUrl/auth/login');

    try {
      final response = await http.post(
        loginUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      print('Login Response Status: ${response.statusCode}');
      print('Login Response Body: ${response.body}');

      final Map<String, dynamic> responseData = json.decode(response.body);

      // Cek jika response sukses (200 atau 201)
      if (response.statusCode == 200 || response.statusCode == 201) {

        // --- PERBAIKAN UTAMA DI SINI ---
        // Mengambil token sesuai struktur JSON yang benar: body -> data -> token
        if (responseData.containsKey('body') &&
            responseData['body'] is Map &&
            responseData['body'].containsKey('data') &&
            responseData['body']['data'] is Map &&
            responseData['body']['data'].containsKey('token')) {
          
          final String token = responseData['body']['data']['token'];
          
          if (token.isNotEmpty) {
            return token; // BERHASIL! Kembalikan token.
          }
        }
        
        // Jika struktur tidak sesuai dengan yang diharapkan
        throw Exception('Format token dari server tidak dikenali.');

      } else {
        // Jika response gagal (4xx, 5xx), lempar pesan error dari server
        final errorMessage = responseData['message'] ?? 'Terjadi kesalahan saat login.';
        throw Exception(errorMessage);
      }
    } catch (e) {
      // Menangkap semua jenis error lain
      print('Error di fungsi login: $e');
      throw Exception('Gagal terhubung ke server. Periksa koneksi internet Anda.');
    }
  }


  // --- GANTI FUNGSI INI DENGAN VERSI BARU ---
  Future<List<Article>> getPublicNews({String? category}) async {
    // --- PERUBAHAN LOGIKA PEMBUATAN URL DI SINI ---

    // 1. Siapkan 'wadah' untuk parameter query
    final Map<String, String> queryParameters = {};

    // 2. Jika ada kategori yang dipilih (dan bukan 'Semua'), masukkan ke wadah
    if (category != null && category.toLowerCase() != 'semua') {
      queryParameters['category'] = category;
    }

    // 3. Buat URL dengan cara yang aman menggunakan Uri constructor.
    // Ini akan secara otomatis menangani encoding karakter khusus.
    final Uri newsUrl = Uri.http(
      '45.149.187.204:3000', // Authority (host dan port)
      '/api/news', // Path
      queryParameters.isEmpty ? null : queryParameters, // Query parameters
    );
    
    print('Fetching news from: $newsUrl'); // Print URL untuk debugging

    // --- SISA KODE DI BAWAH INI TETAP SAMA ---
    try {
      final response = await http.get(newsUrl);
      
      print('Get News Response Status: ${response.statusCode}');
      print('Get News Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData.containsKey('body') &&
            responseData['body'] is Map &&
            responseData['body'].containsKey('data') &&
            responseData['body']['data'] is List) {
              
          final List<dynamic> articlesJson = responseData['body']['data'];
          
          List<Article> articles = articlesJson
              .map((jsonItem) => Article.fromJson(jsonItem))
              .toList();
              
          return articles;
        } else {
          throw Exception("Format data berita dari server tidak dikenali.");
        }
      } else {
        throw Exception('Gagal memuat berita. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error di getPublicNews: $e');
      throw Exception('Gagal terhubung ke server berita.');
    }
  }

// --- FUNGSI BARU UNTUK MENGAMBIL SATU BERITA BERDASARKAN SLUG ---
  Future<Article> getNewsBySlug(String slug) async {
    final Uri newsUrl = Uri.parse('$_baseUrl/news/$slug');

    try {
      final response = await http.get(newsUrl);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('body') &&
            responseData['body'] is Map &&
            responseData['body'].containsKey('data') &&
            responseData['body']['data'] is Map) {
          // API mengembalikan satu objek, bukan list
          return Article.fromJson(responseData['body']['data']);
        } else {
          throw Exception("Format data detail berita tidak sesuai.");
        }
      } else {
        throw Exception('Gagal memuat detail berita. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error di getNewsBySlug: $e');
      throw Exception('Gagal terhubung ke server untuk detail berita.');
    }
  }

  // --- FUNGSI BARU UNTUK CRUD ---

  Future<List<Article>> getMyArticles(String token) async {
    final Uri url = Uri.parse('$_baseUrl/author/news');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['body']['success'] == true) {
          final List<dynamic> articlesJson = responseData['body']['data'];
          return articlesJson.map((json) => Article.fromJson(json)).toList();
        } else {
          throw Exception(responseData['body']['message']);
        }
      } else {
        throw Exception('Gagal memuat artikel saya.');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<void> createArticle(String token, Article article) async {
    final Uri url = Uri.parse('$_baseUrl/author/news');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(article.toJson()),
      );
      // --- PERBAIKAN DI SINI ---
      // Sekarang kita terima status 201 (Created) ATAU 200 (OK) sebagai tanda sukses
      if (response.statusCode != 201 && response.statusCode != 200) {
        print('Error Body: ${response.body}'); // Tambahan untuk debug
        throw Exception('Gagal membuat artikel baru. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<void> updateArticle(String token, String articleId, Article article) async {
    final Uri url = Uri.parse('$_baseUrl/author/news/$articleId');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(article.toJson()),
      );
      // Memastikan status 200 adalah sukses
      if (response.statusCode != 200) {
        print('Error Body: ${response.body}');
        throw Exception('Gagal memperbarui artikel. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<void> deleteArticle(String token, String articleId) async {
    final Uri url = Uri.parse('$_baseUrl/author/news/$articleId');
    try {
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      // Memastikan status 200 adalah sukses
      if (response.statusCode != 200) {
        print('Error Body: ${response.body}');
        throw Exception('Gagal menghapus artikel. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }
}