import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_tb_sportscope_prakpm/views/forget_screen.dart';
import 'package:project_tb_sportscope_prakpm/views/register_screen.dart';
import 'package:project_tb_sportscope_prakpm/views/main_screen.dart';
import 'package:project_tb_sportscope_prakpm/services/api_service.dart';

// Konstanta
const Color appColorPrimary = Color(0xFF072BF2);
const Color appColorTextBlack = Color(0xFF0D0D0D);
const Color appColorTextSlightlyLighterBlack = Color(0xFF333333);
const String appLogoPath = 'assets/images/logoteks.png';
const String googleButtonImagePath = 'assets/images/google_button.png';
const String facebookButtonImagePath = 'assets/images/facebook_button.png';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiService _apiService = ApiService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _errorMessage;

  String _email = '';
  String _password = '';
  bool _isPasswordVisible = false;

  Future<void> _handleEmailPasswordLogin() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final String token = await _apiService.login(_email, _password);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);

      if (mounted) {
        // Kembali ke MainScreen dan kirim sinyal 'true' bahwa login sukses
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? appFontFamily = 'Poppins';

    return Scaffold(
      backgroundColor: Colors.white,
      // --- PENAMBAHAN APPBAR ---
      appBar: AppBar(
        // Kosongkan saja. Flutter akan otomatis menambahkan tombol kembali.
        // Styling-nya (warna latar, ikon) akan mengikuti appBarTheme di main.dart.
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset(appLogoPath, height: 180, filterQuality: FilterQuality.high)
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: -0.5, duration: 500.ms, curve: Curves.easeOut),
                  const SizedBox(height: 24.0),

                  Text(
                    'Selamat Datang!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: appFontFamily, color: appColorTextBlack),
                  ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
                  const SizedBox(height: 8.0),
                  Text(
                    'Masuk untuk melanjutkan ke InfoZine',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontFamily: appFontFamily, color: appColorTextSlightlyLighterBlack),
                  ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
                  const SizedBox(height: 32.0),

                  _buildEmailTextField(appFontFamily),
                  const SizedBox(height: 16.0),

                  _buildPasswordTextField(appFontFamily),
                  const SizedBox(height: 8.0),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgetScreen())),
                      child: Text('Lupa Password?', style: TextStyle(color: appColorPrimary, fontFamily: appFontFamily, fontWeight: FontWeight.w600)),
                    ),
                  ).animate().fadeIn(delay: 800.ms, duration: 600.ms),
                  const SizedBox(height: 16.0),
                  
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red[700], fontSize: 14, fontFamily: appFontFamily),
                      ).animate().shake(),
                    ),
                  
                  _isLoading
                      ? const Center(child: CircularProgressIndicator(color: appColorPrimary))
                      : _buildLoginButton(appFontFamily),
                  const SizedBox(height: 24.0),

                  _buildDivider(appFontFamily),
                  const SizedBox(height: 24.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(child: _buildSocialImageButton(imagePath: googleButtonImagePath, altText: 'Google')),
                      const SizedBox(width: 20.0),
                      Flexible(child: _buildSocialImageButton(imagePath: facebookButtonImagePath, altText: 'Facebook')),
                    ],
                  ).animate().fadeIn(delay: 1050.ms, duration: 600.ms),
                  const SizedBox(height: 32.0),

                  _buildSignUpLink(appFontFamily, context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailTextField(String? appFontFamily) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Email',
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
    ).animate().fadeIn(delay: 500.ms, duration: 600.ms).slideX(begin: -0.2);
  }

  Widget _buildPasswordTextField(String? appFontFamily) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Password',
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
        if (value == null || value.isEmpty || value.length < 6) {
          return 'Password minimal 6 karakter';
        }
        return null;
      },
      onSaved: (value) => _password = value!,
    ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideX(begin: 0.2);
  }

  Widget _buildLoginButton(String? appFontFamily) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: appColorPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        elevation: 5,
      ),
      onPressed: _isLoading ? null : _handleEmailPasswordLogin,
      child: Text(
        'MASUK',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: appFontFamily,
          color: Colors.white,
        ),
      ),
    ).animate().fadeIn(delay: 900.ms, duration: 600.ms).slideY(begin: 0.5, curve: Curves.easeOutBack);
  }

  Widget _buildDivider(String? appFontFamily) {
    return Row(
      children: <Widget>[
        const Expanded(child: Divider(thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            'Atau masuk dengan',
            style: TextStyle(color: appColorTextSlightlyLighterBlack, fontFamily: appFontFamily),
          ),
        ),
        const Expanded(child: Divider(thickness: 1)),
      ],
    ).animate().fadeIn(delay: 1000.ms, duration: 600.ms);
  }

  Widget _buildSocialImageButton({
    required String imagePath,
    required String altText,
  }) {
    return GestureDetector(
      onTap: () {
        print('Tombol Gambar $altText ditekan');
      },
      child: Container(
        height: 50,
        constraints: const BoxConstraints(
          minWidth: 50,
          maxWidth: 150,
        ),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              alignment: Alignment.center,
              height: 50,
              color: Colors.grey[200],
              child: Text('Gagal: $altText', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildSignUpLink(String? appFontFamily, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Belum punya akun? ',
          style: TextStyle(fontFamily: appFontFamily, color: appColorTextSlightlyLighterBlack),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterScreen()),
            );
          },
          child: Text(
            'Daftar Sekarang',
            style: TextStyle(
              color: appColorPrimary,
              fontWeight: FontWeight.w600,
              fontFamily: appFontFamily,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 1300.ms, duration: 600.ms);
  }
}