import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PredictionProvider with ChangeNotifier {
  // Data input untuk prediksi (berubah menjadi List<double>)
  List<double> inputData = [0.0, 0.0]; // Hanya dua fitur (calories dan meals)
  String? predictionMessage = "";

  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController mealsController = TextEditingController();

  // Fungsi untuk mengupdate input data berdasarkan index
  void updateInputData(int index, double value) {
    inputData[index] = value;
    notifyListeners();
  }

  // Fungsi untuk mengirim data ke API dan mendapatkan respons
  Future<void> predict() async {
    final url = Uri.parse(
        'https://nutriai.loca.lt/api/predict/'); // Ganti dengan URL API yang sesuai
    final body = jsonEncode({
      'calories': double.tryParse(
          caloriesController.text), // Pastikan mengirimkan dalam format double
      'meals': double.tryParse(
          mealsController.text), // Pastikan mengirimkan dalam format double
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        predictionMessage = data['message']; // Sesuaikan dengan respons API
      } else {
        predictionMessage = 'Gagal mendapatkan prediksi';
      }
      clearInputData();
      clearControllers();
    } catch (e) {
      predictionMessage = 'Terjadi kesalahan: $e';
    }
    notifyListeners();
  }

  // Fungsi untuk membersihkan data input
  void clearInputData() {
    inputData = [0.0, 0.0]; // Hanya reset dua fitur
    notifyListeners();
  }

  // Fungsi untuk mengosongkan semua controller input
  void clearControllers() {
    caloriesController.clear();
    mealsController.clear();
    clearInputData();
    notifyListeners();
  }

  @override
  void dispose() {
    // Dispose semua controller
    caloriesController.dispose();
    mealsController.dispose();
    super.dispose();
  }
}
