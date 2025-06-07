import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shimmer/shimmer.dart';
import '../models/user.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? username;
  String? profileImage;
  String? gender;
  int? age;
  String? description;

  final _descController = TextEditingController();
  final _ageController = TextEditingController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _initLocalNotifications();
  }

  void _loadUserProfile() async {
    final box = await Hive.openBox<User>('users');
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

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showSuccessNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'profile_update_channel',
      'Profile Update',
      channelDescription: 'Notifikasi update profil',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Berhasil',
      'Profil berhasil diupdate!',
      platformChannelSpecifics,
    );
  }

  Future<void> _saveProfile() async {
    final box = await Hive.openBox<User>('users');
    final user = box.values.isNotEmpty ? box.values.first : null;
    if (user != null) {
      user.gender = gender;
      user.age = int.tryParse(_ageController.text);
      user.description = _descController.text;
      user.profileImage = profileImage;
      await user.save();
      if (mounted) {
        await _showSuccessNotification();
        Navigator.pop(context, true); // Kembali ke profil
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        profileImage = pickedFile.path;
      });
    }
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
        title: const Text('Edit Profil'),
        centerTitle: true,
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
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Ganti Foto Profil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.purple),
                  const SizedBox(width: 8),
                  const Text('Jenis Kelamin:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'Laki-laki',
                        groupValue: gender,
                        onChanged: (val) => setState(() => gender = val),
                      ),
                      const Icon(Icons.male, color: Colors.blue),
                      const SizedBox(width: 4),
                      const Text(''),
                      const SizedBox(width: 12),
                      Radio<String>(
                        value: 'Perempuan',
                        groupValue: gender,
                        onChanged: (val) => setState(() => gender = val),
                      ),
                      const Icon(Icons.female, color: Colors.pink),
                      const SizedBox(width: 4),
                      const Text(''),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Icon(Icons.cake, color: Colors.orange),
                  const SizedBox(width: 8),
                  const Text('Usia:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(hintText: 'Masukkan usia'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
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
              TextField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Tulis sesuatu tentang dirimu (opsional)',
                  fillColor: Color(0xFFF1F8E9),
                  filled: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _saveProfile,
                icon: const Icon(Icons.save),
                label: const Text('Simpan Profil'),
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
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
