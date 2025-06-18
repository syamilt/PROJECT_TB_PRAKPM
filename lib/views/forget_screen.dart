import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';


const Color appColorPrimary = Color(0xFF072BF2);
const Color appColorTextBlack = Color(0xFF0D0D0D);
const Color appColorTextSlightlyLighterBlack = Color(0xFF333333);

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';

  void _handleSendResetLink() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    print('Kirim link reset password ke: $_email');

    // Tampilkan SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Link untuk reset password telah dikirim ke $_email ')),
    );

 
    Future.delayed(const Duration(milliseconds: 1500), () { // Durasi SnackBar 
      if (mounted) { 
         Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String appFontFamily = 'Poppins'; 

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Lupa Password',
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
                Icon(
                  Icons.lock_open_outlined,
                  size: 80,
                  color: appColorPrimary,
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 300.ms)
                    .scale(
                        delay: 400.ms,
                        duration: 500.ms,
                        curve: Curves.elasticOut),
                const SizedBox(height: 24.0),
                Text(
                  'Reset Password Anda',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: appFontFamily,
                    color: appColorTextBlack,
                  ),
                ).animate().fadeIn(delay: 500.ms, duration: 600.ms),
                const SizedBox(height: 12.0),
                Text(
                  'Masukkan alamat email Anda yang terdaftar. Kami akan mengirimkan tautan untuk mereset password Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: appFontFamily,
                    color: appColorTextSlightlyLighterBlack,
                    height: 1.4,
                  ),
                ).animate().fadeIn(delay: 600.ms, duration: 600.ms),
                const SizedBox(height: 32.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email Terdaftar',
                    hintText: 'contoh@email.com',
                    prefixIcon:
                        const Icon(Icons.email_outlined, color: appColorPrimary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          const BorderSide(color: appColorPrimary, width: 2.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 12.0),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                      fontFamily: appFontFamily, color: appColorTextBlack),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Masukkan email yang valid';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value!,
                )
                    .animate()
                    .fadeIn(delay: 700.ms, duration: 600.ms)
                    .slideX(begin: -0.2),
                const SizedBox(height: 28.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColorPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    elevation: 5,
                  ),
                  onPressed: _handleSendResetLink,
                  child: Text(
                    'KIRIM LINK RESET',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: appFontFamily,
                      color: Colors.white,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 800.ms, duration: 600.ms)
                    .slideY(begin: 0.5, curve: Curves.easeOutBack),
                const SizedBox(height: 20.0),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Kembali ke Login',
                    style: TextStyle(
                      color: appColorPrimary,
                      fontFamily: appFontFamily,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ).animate().fadeIn(delay: 900.ms, duration: 600.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}