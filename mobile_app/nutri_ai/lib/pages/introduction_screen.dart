import 'package:flutter/material.dart';
import 'sign_in_page.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  @override
  void initState() {
    super.initState();
    // Delay 4 detik sebelum navigasi ke SignInPage
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) { // Memastikan context sudah terpasang
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignInPage(userDatabase: {}),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo-removebg.png',
          height: 200, // Menentukan tinggi logo
          errorBuilder: (context, error, stackTrace) {
            return const Text('Logo not found', style: TextStyle(fontSize: 18));
          },
        ),
      ),
    );
  }
}
