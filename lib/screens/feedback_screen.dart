import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kesan & Pesan Creator'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.favorite, color: Colors.red, size: 60),
              SizedBox(height: 24),
              Text(
                'Kesan & Pesan untuk Dosen',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 18),
              Text(
                "Terima kasih kepada Dosen atas TUGAS HEBAT, ilmu, dan perintah yang diberikan selama perkuliahan.\n\nSemoga aplikasi ini dapat menjadi bukti hasil belajar dan dedikasi saya. Mohon maaf atas semua perlakuan saya yang disengaja maupun tidak disengaja dalam kelas ataupun luar kelas.\n\nSalam hormat,\n123220057 - Bagas D. Prasetya",
                style: TextStyle(fontSize: 17, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
