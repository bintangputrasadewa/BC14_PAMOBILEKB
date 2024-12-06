import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/controller.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  double? _selectedMeals; // Mengubah menjadi tipe double
  final TextEditingController _caloriesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final predictionProvider = Provider.of<PredictionProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Nutri AI',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Buat Makananmu Sendiri!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Masukan Kalori dan Jumlah Makan!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _caloriesController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Masukkan kalori',
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Kalori',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: DropdownButton<double>(
                                isExpanded: true,
                                value: _selectedMeals,
                                underline: const SizedBox(),
                                items:
                                    <double>[1, 2, 3, 4, 5].map((double value) {
                                  return DropdownMenuItem<double>(
                                    value: value,
                                    child: Text(value.toString()),
                                  );
                                }).toList(),
                                onChanged: (double? newValue) {
                                  setState(() {
                                    _selectedMeals = newValue ??
                                        0.0; // Menggunakan nilai default 0.0 jika null
                                  });
                                },
                                hint: const Text('Pilih jumlah makan'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Makan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_caloriesController.text.isNotEmpty &&
                                _selectedMeals != null) {
                              final caloriesAsDouble =
                                  double.tryParse(_caloriesController.text) ?? 0.0;

                              predictionProvider.updateInputData(
                                  0, caloriesAsDouble);
                              predictionProvider.updateInputData(
                                  1, _selectedMeals!);
                              await predictionProvider.predict();

                              final snackBar = SnackBar(
                                content: Text(
                                  predictionProvider.predictionMessage ??
                                      'Prediksi gagal.',
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              final snackBar = const SnackBar(
                                content: Text(
                                    'Kalori dan jumlah makan harus diisi!'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text('Generate'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Text(
                    'Makan Pertama',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
