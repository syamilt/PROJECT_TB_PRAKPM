import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_tb_sportscope_prakpm/models/article_model.dart';
import 'package:project_tb_sportscope_prakpm/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color appColorPrimary = Color(0xFF072BF2);
const String appFontFamily = 'Poppins';

// Enum untuk status publikasi
enum PublishingStatus { draft, published }

class ArticleFormScreen extends StatefulWidget {
  final Article? article;
  const ArticleFormScreen({super.key, this.article});

  @override
  State<ArticleFormScreen> createState() => _ArticleFormScreenState();
}

class _ArticleFormScreenState extends State<ArticleFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _summaryController;
  late TextEditingController _imageUrlController;
  
  String? _selectedCategory;
  final List<String> _categories = const [
    'Politik', 'Hukum & Kriminal', 'Internasional', 'Peristiwa', 'Ekonomi',
    'Bisnis', 'Teknologi', 'Otomotif', 'Gaya Hidup', 'Kesehatan',
    'Pendidikan', 'Kuliner', 'Liburan', 'Hiburan', 'Kisah Inspiratif',
    'Sains', 'Lingkungan', 'Olahraga'
  ];

  PublishingStatus _status = PublishingStatus.published;
  bool _isLoading = false;
  bool get _isEditMode => widget.article != null;

  final FocusNode _imageUrlFocusNode = FocusNode();
  String _imageUrlForPreview = '';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.article?.title ?? '');
    _contentController = TextEditingController(text: widget.article?.content ?? '');
    _summaryController = TextEditingController(text: widget.article?.summary ?? '');
    _imageUrlController = TextEditingController(text: widget.article?.featuredImageUrl ?? '');
    _status = (widget.article?.isPublished ?? true) ? PublishingStatus.published : PublishingStatus.draft;

    if (_isEditMode) {
      if (_categories.contains(widget.article!.category)) {
        _selectedCategory = widget.article!.category;
      }
      _imageUrlForPreview = widget.article?.featuredImageUrl ?? '';
    }

    _imageUrlFocusNode.addListener(() {
      if (!_imageUrlFocusNode.hasFocus && _imageUrlController.text.isNotEmpty) {
        setState(() {
          _imageUrlForPreview = _imageUrlController.text;
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _summaryController.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(() {});
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pasteFromClipboard() async {
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      setState(() {
        _imageUrlController.text = data.text!;
        _imageUrlForPreview = data.text!;
      });
    }
  }

  Future<void> _handleSaveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) throw Exception('Token tidak ditemukan');
      
      final articleData = Article(
        id: widget.article?.id ?? '', slug: widget.article?.slug ?? '',
        title: _titleController.text, content: _contentController.text,
        summary: _summaryController.text, category: _selectedCategory!,
        featuredImageUrl: _imageUrlController.text,
        isPublished: _status == PublishingStatus.published,
        tags: [], authorName: '', publishedAt: DateTime.now(),
        createdAt: widget.article?.createdAt ?? DateTime.now(),
      );

      if (_isEditMode) {
        await _apiService.updateArticle(token, widget.article!.id, articleData);
      } else {
        await _apiService.createArticle(token, articleData);
      }
      
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Artikel berhasil disimpan!'), backgroundColor: Colors.green));
        Navigator.of(context).pop(true);
      }
    } catch (e) {
       if(mounted) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan artikel: ${e.toString()}'), backgroundColor: Colors.red));
       }
    } finally {
       if(mounted) {
         setState(() => _isLoading = false);
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Artikel' : 'Tulis Artikel Baru'),
        actions: [
          if (_isLoading)
            const Padding(padding: EdgeInsets.all(16.0), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.0, color: appColorPrimary)))
          else
            TextButton(
              onPressed: _handleSaveChanges,
              child: const Text('Simpan', style: TextStyle(color: appColorPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _imageUrlController,
                focusNode: _imageUrlFocusNode,
                decoration: InputDecoration(
                  labelText: 'URL Gambar',
                  hintText: 'https://...',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(icon: const Icon(Icons.paste), tooltip: 'Tempel dari Clipboard', onPressed: _pasteFromClipboard),
                ),
                keyboardType: TextInputType.url,
              ),
              _buildImagePreview(),
              const SizedBox(height: 24),
              
              TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: 'Judul Berita', border: OutlineInputBorder()), validator: (value) => value!.isEmpty ? 'Judul tidak boleh kosong' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _contentController, decoration: const InputDecoration(labelText: 'Isi Konten Berita', border: OutlineInputBorder(), alignLabelWithHint: true), maxLines: 10, validator: (value) => (value == null || value.length < 10) ? 'Konten minimal 10 karakter' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _summaryController, decoration: const InputDecoration(labelText: 'Ringkasan (Summary)', border: OutlineInputBorder(), alignLabelWithHint: true), maxLines: 3),
              const SizedBox(height: 16),

              // --- WIDGET DIKEMBALIKAN KE DROPDOWN STANDAR ---
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                hint: const Text('Pilih Kategori'),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) => value == null ? 'Kategori harus dipilih' : null,
              ),
           

              const SizedBox(height: 24),
              const Text('Status Publikasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: appFontFamily)),
              const SizedBox(height: 8),
              SegmentedButton<PublishingStatus>(
                segments: const <ButtonSegment<PublishingStatus>>[
                  ButtonSegment<PublishingStatus>(value: PublishingStatus.draft, label: Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Text('Draft')), icon: Icon(Icons.edit_note)),
                  ButtonSegment<PublishingStatus>(value: PublishingStatus.published, label: Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Text('Diterbitkan')), icon: Icon(Icons.public)),
                ],
                selected: <PublishingStatus>{_status},
                onSelectionChanged: (Set<PublishingStatus> newSelection) {
                  setState(() {
                    _status = newSelection.first;
                  });
                },
                style: SegmentedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  selectedBackgroundColor: appColorPrimary,
                  selectedForegroundColor: Colors.white,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600, fontFamily: appFontFamily),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildImagePreview() {
    if (_imageUrlForPreview.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Preview Gambar:', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: appFontFamily)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.network(
              _imageUrlForPreview,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(height: 200, color: Colors.grey[200], child: const Center(child: CircularProgressIndicator()));
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 40),
                        SizedBox(height: 8),
                        Text('Gagal memuat gambar dari URL', textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

