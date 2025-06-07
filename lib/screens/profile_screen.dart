import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/user.dart';
import 'login_screen.dart'; // Pastikan untuk mengimpor LoginScreen
import 'edit_profile_screen.dart'; // Pastikan untuk mengimpor EditProfileScreen
import 'feedback_screen.dart'; // Pastikan untuk mengimpor FeedbackScreen
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username;
  String? profileImage;
  String? gender;
  int? age;
  String? description;
  String? _currentLocation;
  double? latitude;
  double? longitude;
  bool _isLoading = true;

  final _descController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Memuat data user dari Hive
  void _loadUserProfile() async {
    final box = await Hive.openBox<User>('users');
    // Ambil user pertama (atau sesuaikan dengan user yang sedang login)
    final user = box.values.isNotEmpty ? box.values.first : null;
    setState(() {
      username = user?.username;
      profileImage = user?.profileImage;
      gender = user?.gender;
      age = user?.age;
      description = user?.description;
      _descController.text = user?.description ?? '';
      _ageController.text = user?.age?.toString() ?? '';
      _isLoading = false;
    });
  }

  // Fungsi logout
  void _logout(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentLocation = 'Layanan lokasi tidak aktif.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentLocation = 'Izin lokasi ditolak.';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentLocation = 'Izin lokasi ditolak permanen.';
      });
      return;
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
      _currentLocation =
          'Lat: ${latitude?.toStringAsFixed(5)}, Long: ${longitude?.toStringAsFixed(5)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: GlobalShimmerCard(height: 220),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.feed_outlined, color: Colors.orangeAccent),
            tooltip: 'Kritik & Saran',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FeedbackScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.red),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.lightBlue[100],
                  backgroundImage: profileImage != null
                      ? FileImage(File(profileImage!))
                      : const AssetImage('assets/default_profile.png')
                          as ImageProvider,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                username != null ? username! : '-',
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              const SizedBox(height: 8),
              const Text(
                'Akun Edukasi Anak',
                style: TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person, color: Colors.purple),
                  const SizedBox(width: 8),
                  Text(
                    gender ?? '-',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cake, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(
                    age != null ? '$age tahun' : '-',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: const [
                    Icon(Icons.edit, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Deskripsi:', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFF1F8E9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade100),
                ),
                child: Text(
                  (description != null && description!.isNotEmpty)
                      ? description!
                      : '-',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const EditProfileScreen()),
                  );
                  if (updated == true) _loadUserProfile();
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Divider(thickness: 1, color: Colors.grey[300]),
              const SizedBox(height: 16),
              const Text(
                'Isi data profilmu agar teman-teman dan guru bisa lebih mengenalmu! 😊',
                style: TextStyle(fontSize: 15, color: Colors.deepPurple),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _getCurrentLocation,
                icon: const Icon(Icons.my_location, color: Colors.blue),
                label: const Text('Tampilkan Lokasi Saya'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              if (_currentLocation != null) ...[
                const SizedBox(height: 10),
                Text(
                  'Lokasi Saat Ini:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
                Text(
                  _currentLocation!,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
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
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
      ),
    );
  }
}
