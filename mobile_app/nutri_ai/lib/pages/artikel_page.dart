// artikel_page.dart
import 'package:flutter/material.dart';

class ArtikelPage extends StatelessWidget {
  final String title;
  final String imagePath;

  const ArtikelPage({
    super.key,
    required this.title,
    required this.imagePath,
  });

  String getDescription(String title) {
    switch (title) {
      case 'Healthy Food 1':
        return "Hidangan ini adalah perpaduan sempurna antara rasa dan nutrisi. Salmon panggang yang harum dan lembut menyatu dengan sempurna dengan nasi merah yang kaya serat. Setiap suapan akan memanjakan lidah dengan kelezatan daging salmon yang gurih, dipadukan dengan kesegaran sayuran dan manisnya buah-buahan. Warna-warni cerah dari sayuran dan buah-buahan membuat hidangan ini semakin menarik secara visual. Hidangan ini adalah pilihan yang sangat baik untuk mereka yang ingin menjaga kesehatan dan menikmati makanan yang lezat.";
      case 'Healthy Food 2':
        return "Hidangan ini adalah investasi terbaik untuk kesehatan Anda. Nasi merah yang kaya akan antioksidan, protein berkualitas tinggi dari udang, serta serat dari sayuran membantu menjaga sistem pencernaan tetap sehat dan meningkatkan energi. Rasakan manfaatnya dalam setiap suapan!";
      case 'Healthy Food 3':
        return "Sebuah pelukan dalam mangkuk! Sup hangat ini adalah teman setia di hari yang dingin. Bakso lembut yang mengapung di atas lautan kaldu bening, dikelilingi oleh pulau-pulau kecil sayuran berwarna-warni. Setiap suapan adalah petualangan kuliner yang menyenangkan.";
      case 'Unhealthy Food 1':
        return "Meskipun hidangan ini lezat dan mudah disiapkan, konsumsi berlebihan dapat berdampak negatif pada kesehatan. Kandungan natrium yang tinggi dapat meningkatkan tekanan darah, sementara penggunaan minyak goreng yang berlebihan dapat meningkatkan risiko penyakit jantung. Selain itu, penggunaan pengawet dan penyedap buatan dalam mie instan dan bahan tambahan lainnya juga perlu diperhatikan.";
      case 'Unhealthy Food 2':
        return "Meskipun lezat, konsumsi nasi goreng secara berlebihan dapat berdampak pada kesehatan. Kandungan lemak dan garam yang tinggi akibat penggunaan minyak goreng dan kecap asin dapat meningkatkan risiko penyakit jantung dan tekanan darah tinggi. Selain itu, penggunaan cabai dalam jumlah banyak dapat memicu masalah pencernaan pada sebagian orang";
      case 'Unhealthy Food 3':
        return "Ayam goreng KFC merupakan salah satu contoh makanan cepat saji yang populer namun tinggi lemak dan kalori. Meskipun lezat, konsumsi makanan ini sebaiknya dilakukan secara bijak dan diimbangi dengan pola makan yang sehat secara keseluruhan. Dengan memperhatikan aspek nutrisi dan memilih alternatif yang lebih sehat, kita dapat tetap menikmati makanan favorit tanpa mengorbankan kesehatan.";
      default:
        return "Default description for the article.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final String description = getDescription(title);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                description,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
