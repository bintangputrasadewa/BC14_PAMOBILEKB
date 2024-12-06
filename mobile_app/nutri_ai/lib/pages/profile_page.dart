import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController =
      TextEditingController(text: 'Rheza');
  final TextEditingController _weightController =
      TextEditingController(text: '100Kg');
  final TextEditingController _heightController =
      TextEditingController(text: '168cm');

  String _gender = 'Pria';
  bool _isEditing = false;

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    if (_nameController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _heightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi semua data!')),
      );
      return;
    }
    setState(() {
      // Anda bisa menyimpan perubahan ke database atau state management jika diperlukan
    });
    _toggleEditMode(); // Menutup mode edit setelah perubahan disimpan
  }

  @override
  Widget build(BuildContext context) {
    // Menentukan warna untuk container "ORINE" berdasarkan tema
    final containerColor = Theme.of(context).brightness == Brightness.dark
        ? const Color.fromARGB(255, 213, 176, 106) // Warna dark mode
        : Colors.grey[300]; // Warna light mode

    // Menentukan warna teks "ORINE" berdasarkan tema
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white // Warna teks pada dark mode
        : Colors.black; // Warna teks pada light mode

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: _isEditing ? _saveChanges : _toggleEditMode,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Data Diri',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: containerColor, // Menggunakan warna yang sesuai tema
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'ORINE',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor, // Menggunakan warna teks yang sesuai tema
                ),
              ),
            ),
            const SizedBox(height: 20),
            buildProfileInfo('Nama', _nameController),
            buildGenderField(),
            buildProfileInfo('Berat', _weightController),
            buildProfileInfo('Tinggi Badan', _heightController),
          ],
        ),
      ),
    );
  }

  Widget buildProfileInfo(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          _isEditing
              ? SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.6, // Responsif, 60% dari lebar layar
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                    ),
                  ),
                )
              : Expanded(
                  child: Text(
                    controller.text,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
        ],
      ),
    );
  }

  Widget buildGenderField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Jenis Kelamin',
            style: TextStyle(fontSize: 16),
          ),
          _isEditing
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: DropdownButton<String>(
                    value: _gender,
                    onChanged: (String? newValue) {
                      setState(() {
                        _gender = newValue!;
                      });
                    },
                    isExpanded: true,
                    items: <String>['Pria', 'Perempuan']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                )
              : Expanded(
                  child: Text(
                    _gender,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
        ],
      ),
    );
  }
}
