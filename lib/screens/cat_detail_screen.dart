import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../models/animal.dart';

class CatDetailScreen extends StatelessWidget {
  final Animal cat;
  const CatDetailScreen({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cat.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  cat.imageLink.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            cat.imageLink,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 100),
                          ),
                        )
                      : const Icon(Icons.pets, size: 100, color: Colors.grey),
                  const SizedBox(height: 18),
                  Text(
                    cat.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Asal: ${cat.origin}',
                      style:
                          const TextStyle(fontSize: 18, color: Colors.brown)),
                  Text('Panjang: ${cat.length}',
                      style:
                          const TextStyle(fontSize: 18, color: Colors.brown)),
                  Text('Berat: ${cat.minWeight} - ${cat.maxWeight} lbs',
                      style:
                          const TextStyle(fontSize: 18, color: Colors.brown)),
                  Text(
                      'Umur: ${cat.minLifeExpectancy} - ${cat.maxLifeExpectancy} tahun',
                      style:
                          const TextStyle(fontSize: 18, color: Colors.brown)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.lightBlue[50],
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Karakteristik Kucing',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      )),
                  const SizedBox(height: 12),
                  _buildRatingRow(
                      'Ramah untuk Keluarga', cat.familyFriendly, Colors.pink),
                  _buildRatingRow(
                      'Mudah Rontok Bulu', cat.shedding, Colors.orange),
                  _buildRatingRow(
                      'Kesehatan Umum', cat.generalHealth, Colors.green),
                  _buildRatingRow(
                      'Suka Bermain', cat.playfulness, Colors.purple),
                  _buildRatingRow(
                      'Ramah Anak-anak', cat.childrenFriendly, Colors.teal),
                  _buildRatingRow('Perawatan Bulu', cat.grooming, Colors.amber),
                  _buildRatingRow(
                      'Kecerdasan', cat.intelligence, Colors.indigo),
                  _buildRatingRow('Ramah dengan Hewan Lain',
                      cat.otherPetsFriendly, Colors.red),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Yuk, kenali kucing lebih dekat! Kucing adalah hewan peliharaan yang lucu, cerdas, dan penuh kasih sayang. Setiap ras punya keunikan sendiri. Jangan lupa sayangi dan rawat kucingmu ya!',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Tips Merawat Kucing:\n- Berikan makanan dan minuman yang sehat setiap hari.\n- Sering ajak bermain agar kucing aktif dan bahagia.\n- Sikat bulu kucing secara rutin agar tetap bersih.\n- Ajak ke dokter hewan untuk vaksin dan cek kesehatan.\n- Sayangi dan jangan pernah menyakiti kucing! 🐾',
                style: TextStyle(fontSize: 15, color: Colors.brown),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingRow(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.star, color: color, size: 22),
          const SizedBox(width: 8),
          Flexible(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                5,
                (i) => Icon(
                  i < value.round() ? Icons.star : Icons.star_border,
                  color: color,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GlobalShimmerCard extends StatelessWidget {
  final double height;

  const GlobalShimmerCard({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
