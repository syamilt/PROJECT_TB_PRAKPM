import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';


const Color appColorPrimary = Color(0xFF072BF2);
const Color appColorTextBlack = Color(0xFF0D0D0D);
const Color appColorTextSlightlyLighterBlack = Color(0xFF333333);


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController(); // Untuk validasi konfirmasi password

  String _fullName = '';
  String _email = '';


  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

   
    print(
        'Daftar dengan Data:\nNama: $_fullName\nEmail: $_email\nPassword: ${_passwordController.text}');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pendaftaran Berhasil')),
    );
    Navigator.of(context).pop(); // atau pushReplacementNamed ke login

    
  }

  @override
  void dispose() {
    _passwordController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String appFontFamily = 'Poppins'; 

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Buat Akun Baru',
          style: TextStyle(
              fontFamily: appFontFamily,
              color: appColorTextBlack,
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: appColorTextBlack),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Icon
                Icon(
                  Icons.person_add_alt_1_outlined,
                  size: 70,
                  color: appColorPrimary,
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 300.ms)
                    .scale(
                        delay: 400.ms,
                        duration: 500.ms,
                        curve: Curves.elasticOut),
                const SizedBox(height: 20.0),

                // Judul
                Text(
                  'Gabung Bersama Kami!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: appFontFamily,
                    color: appColorTextBlack,
                  ),
                ).animate().fadeIn(delay: 500.ms, duration: 600.ms),
                const SizedBox(height: 8.0),
                Text(
                  'Isi data di bawah ini untuk membuat akun baru Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: appFontFamily,
                    color: appColorTextSlightlyLighterBlack,
                    height: 1.4,
                  ),
                ).animate().fadeIn(delay: 600.ms, duration: 600.ms),
                const SizedBox(height: 28.0),

                // Input Nama Lengkap
                _buildFullNameField(appFontFamily).animate().fadeIn(delay: 700.ms, duration: 600.ms).slideX(begin: -0.2),
                const SizedBox(height: 16.0),

                // Input Email
                _buildEmailField(appFontFamily).animate().fadeIn(delay: 800.ms, duration: 600.ms).slideX(begin: 0.2),
                const SizedBox(height: 16.0),

                // Input Password
                _buildPasswordField(appFontFamily).animate().fadeIn(delay: 900.ms, duration: 600.ms).slideX(begin: -0.2),
                const SizedBox(height: 16.0),

                // Input Konfirmasi Password
                _buildConfirmPasswordField(appFontFamily).animate().fadeIn(delay: 1000.ms, duration: 600.ms).slideX(begin: 0.2),
                const SizedBox(height: 28.0),

                // Tombol Daftar
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColorPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    elevation: 5,
                  ),
                  onPressed: _handleRegister,
                  child: Text(
                    'DAFTAR',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: appFontFamily,
                      color: Colors.white,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 1100.ms, duration: 600.ms)
                    .slideY(begin: 0.5, curve: Curves.easeOutBack),
                const SizedBox(height: 20.0),

                // --- Link Kembali ke Login ---
                _buildLoginLink(appFontFamily, context).animate().fadeIn(delay: 1200.ms, duration: 600.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullNameField(String? appFontFamily) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Nama Lengkap',
        hintText: 'Masukkan nama lengkap Anda',
        prefixIcon: const Icon(Icons.person_outline, color: appColorPrimary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: appColorPrimary, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      keyboardType: TextInputType.name,
      style: TextStyle(fontFamily: appFontFamily, color: appColorTextBlack),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nama lengkap tidak boleh kosong';
        }
        if (value.length < 3) {
          return 'Nama lengkap minimal 3 karakter';
        }
        return null;
      },
      onSaved: (value) => _fullName = value!,
    );
  }

  Widget _buildEmailField(String? appFontFamily) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'contoh@email.com',
        prefixIcon: const Icon(Icons.email_outlined, color: appColorPrimary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: appColorPrimary, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontFamily: appFontFamily, color: appColorTextBlack),
      validator: (value) {
        if (value == null || value.isEmpty || !value.contains('@')) {
          return 'Masukkan email yang valid';
        }
        return null;
      },
      onSaved: (value) => _email = value!,
    );
  }

  Widget _buildPasswordField(String? appFontFamily) {
    return TextFormField(
      controller: _passwordController, // Menggunakan controller
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Masukkan password Anda',
        prefixIcon: const Icon(Icons.lock_outline, color: appColorPrimary),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: appColorPrimary.withOpacity(0.7),
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: appColorPrimary, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      obscureText: !_isPasswordVisible,
      style: TextStyle(fontFamily: appFontFamily, color: appColorTextBlack),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password tidak boleh kosong';
        }
        if (value.length < 6) {
          return 'Password minimal 6 karakter';
        }
        // Validasi PW
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField(String? appFontFamily) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Konfirmasi Password',
        hintText: 'Ulangi password Anda',
        prefixIcon: const Icon(Icons.lock_outline, color: appColorPrimary),
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: appColorPrimary.withOpacity(0.7),
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: appColorPrimary, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      obscureText: !_isConfirmPasswordVisible,
      style: TextStyle(fontFamily: appFontFamily, color: appColorTextBlack),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Konfirmasi password tidak boleh kosong';
        }
        if (value != _passwordController.text) {
          return 'Password tidak cocok';
        }
        return null;
      },
    );
  }

  Widget _buildLoginLink(String? appFontFamily, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Sudah punya akun? ',
          style: TextStyle(fontFamily: appFontFamily, color: appColorTextSlightlyLighterBlack),
        ),
        GestureDetector(
          onTap: () {
            // Kembali ke halaman login
            Navigator.of(context).pop();

          },
          child: Text(
            'Masuk di sini',
            style: TextStyle(
              color: appColorPrimary,
              fontWeight: FontWeight.bold,
              fontFamily: appFontFamily,
            ),
          ),
        ),
      ],
    );
  }
}