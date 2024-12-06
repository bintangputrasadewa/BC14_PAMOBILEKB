import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/introduction_screen.dart';
import 'pages/sign_in_page.dart';
import 'pages/sign_up_page.dart';
import 'pages/home_page.dart';
import 'pages/form_page.dart';
import 'pages/profile_page.dart';
import './controller/controller.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PredictionProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Map<String, String> userDatabase = {};

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutri AI',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const IntroductionScreen(),
        '/signIn': (context) => SignInPage(userDatabase: userDatabase),
        '/signUp': (context) => SignUpPage(userDatabase: userDatabase),
        '/home': (context) => const HomePage(),
        '/form': (context) => const FormPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
