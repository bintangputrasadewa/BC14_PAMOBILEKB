import 'package:flutter/material.dart';
import 'artikel_page.dart';
import 'form_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isDarkMode = false; // Menambahkan variabel untuk toggle dark mode

  // List of pages for navigation
  final List<Widget> _pages = [
    _HomeContent(), // Konten halaman home
    const FormPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Fungsi untuk toggle dark mode
  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode
          ? ThemeData.dark().copyWith(
              scaffoldBackgroundColor: const Color.fromRGBO(37, 37, 35, 1), // Dark mode background
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF252523), // Dark mode appBar
              ),
              iconTheme: const IconThemeData(
                color: Color(0xFFD5B06A), // Dark mode icon color
              ), 
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Color.fromARGB(255, 213, 176, 106)), // Dark mode text
                bodyMedium: TextStyle(color: Color(0xFFD5B06A)),
                bodySmall: TextStyle(color: Color(0xFFD5B06A)),
                headlineLarge: TextStyle(color: Color(0xFFD5B06A)),
                headlineMedium: TextStyle(color: Color(0xFFD5B06A)),
                headlineSmall: TextStyle(color: Color(0xFFD5B06A)),
                titleLarge: TextStyle(color: Color(0xFFD5B06A)),
                titleMedium: TextStyle(color: Color(0xFFD5B06A)),
                titleSmall: TextStyle(color: Color(0xFFD5B06A)),
                labelLarge: TextStyle(color: Color(0xFFD5B06A)),
                labelMedium: TextStyle(color: Color(0xFFD5B06A)),
                labelSmall: TextStyle(color: Color(0xFFD5B06A)),
              ),
            )
          : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            _selectedIndex == 0
                ? 'Home'
                : _selectedIndex == 1
                    ? 'Form'
                    : 'Profile',
          ),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: _toggleDarkMode, // Tombol untuk toggle dark mode
            ),
          ],
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.note_add),
              label: 'Form',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final List<Map<String, String>> healthyFoods = [
    {
      "title": "Healthy Food 1",
      "imagePath": "assets/images/healthy_food_0.jpg"
    },
    {
      "title": "Healthy Food 2",
      "imagePath": "assets/images/healthy_food_1.jpg"
    },
    {
      "title": "Healthy Food 3",
      "imagePath": "assets/images/healthy_food_2.jpg"
    },
  ];

  final List<Map<String, String>> unhealthyFoods = [
    {
      "title": "Unhealthy Food 1", 
      "imagePath": "assets/images/mts1.jpg"
    },
    {
      "title": "Unhealthy Food 2", 
      "imagePath": "assets/images/mts2.jpg"
    },
    {
      "title": "Unhealthy Food 3", 
      "imagePath": "assets/images/mts3.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Healthy Foods Section
          const Text(
            'Makanan Sehat',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: healthyFoods.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final item = healthyFoods[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArtikelPage(
                        title: item['title']!,
                        imagePath: item['imagePath']!,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    item['imagePath']!,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          const Text(
            'Makanan Tidak Sehat',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: unhealthyFoods.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final item = unhealthyFoods[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArtikelPage(
                        title: item['title']!,
                        imagePath: item['imagePath']!,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    item['imagePath']!,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
