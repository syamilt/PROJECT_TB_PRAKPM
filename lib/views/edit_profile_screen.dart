// lib/views/edit_profile_screen.dart

import 'package:flutter/material.dart';

// Konstanta
const Color appColorPrimary = Color(0xFF072BF2);
const String appFontFamily = 'Poppins';
const String profileAvatarPath = 'assets/images/profile_avatar.png';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _bioController;
  // Controller untuk tanggal lahir tetap ada untuk menampilkan teks
  late TextEditingController _birthDateController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: 'ITG');
    _lastNameController = TextEditingController(text: 'News');
    _bioController = TextEditingController(text: 'Akun resmi @ITG News. Selalu berikan informasi terkini, terhangat, dan terpercaya.');
    _birthDateController = TextEditingController(text: 'Belum diatur'); // Teks placeholder
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  void _handleSaveChanges() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Data disimpan: ${_firstNameController.text}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        actions: [
          TextButton(
            onPressed: _handleSaveChanges,
            child: const Text('Simpan', style: TextStyle(color: appColorPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                children: [
                  const CircleAvatar(radius: 60, backgroundImage: AssetImage(profileAvatarPath)),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: appColorPrimary,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        onPressed: () {}, // Dibiarkan kosong
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Nama Depan', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Nama depan tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Nama Belakang', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Nama belakang tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: 'Bio', border: OutlineInputBorder()),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // --- FIELD TANGGAL LAHIR (TIDAK AKTIF) ---
              TextFormField(
                controller: _birthDateController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Lahir',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today_outlined),
                ),
                readOnly: true, // Field hanya bisa dibaca
                // Properti onTap DIHAPUS, sehingga tidak terjadi apa-apa saat diklik
              ),
            ],
          ),
        ),
      ),
    );
  }
}