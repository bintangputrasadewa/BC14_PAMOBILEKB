import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool isPassword;

  const CustomTextField({super.key, required this.labelText, this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(labelText: labelText),
      obscureText: isPassword,
    );
  }
}
