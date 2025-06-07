import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'login_screen.dart';
import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, // warna hijau cerah
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: AppColors.white,
              highlightColor: AppColors.secondary.withOpacity(0.3),
              child: const Icon(Icons.child_care,
                  size: 100, color: AppColors.white),
            ),
            const SizedBox(height: 20),
            Shimmer.fromColors(
              baseColor: AppColors.white,
              highlightColor: AppColors.secondary.withOpacity(0.3),
              child: const Text(
                'AYO Edukasi',
                style: AppTextStyles.heading,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Belajar itu menyenangkan!',
              style: AppTextStyles.body,
            ),
          ],
        ),
      ),
    );
  }
}
