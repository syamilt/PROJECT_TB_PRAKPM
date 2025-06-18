// lib/services/bookmark_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  // Kunci unik untuk menyimpan daftar bookmark di SharedPreferences
  static const String _bookmarkKey = 'bookmarked_articles';

  // Mengambil daftar semua slug artikel yang di-bookmark
  Future<List<String>> getBookmarkedSlugs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Mengambil list of string, jika tidak ada, kembalikan list kosong
    return prefs.getStringList(_bookmarkKey) ?? [];
  }

  // Menambahkan artikel ke bookmark
  Future<void> addBookmark(String articleSlug) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = await getBookmarkedSlugs();
    // Tambahkan slug baru jika belum ada di dalam daftar
    if (!bookmarks.contains(articleSlug)) {
      bookmarks.add(articleSlug);
      await prefs.setStringList(_bookmarkKey, bookmarks);
    }
  }

  // Menghapus artikel dari bookmark
  Future<void> removeBookmark(String articleSlug) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = await getBookmarkedSlugs();
    // Hapus slug dari daftar
    bookmarks.remove(articleSlug);
    await prefs.setStringList(_bookmarkKey, bookmarks);
  }

  // Mengecek apakah sebuah artikel sudah di-bookmark
  Future<bool> isBookmarked(String articleSlug) async {
    List<String> bookmarks = await getBookmarkedSlugs();
    return bookmarks.contains(articleSlug);
  }
}