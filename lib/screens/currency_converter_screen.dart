import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shimmer/shimmer.dart';
import '../models/currency.dart';
import '../services/currency_service.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double _convertedAmount = 0.0;
  bool _isLoading = false;
  StreamSubscription? _accelerometerSubscription;
  double _lastX = 0, _lastY = 0, _lastZ = 0;
  final double _shakeThreshold = 15.0;
  final Random _random = Random();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Fungsi untuk melakukan konversi mata uang
  Future<void> _convert() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan jumlah yang valid')),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    // Membuat objek CurrencyConverter dengan parameter yang dipilih
    final converter = CurrencyConverter(
        fromCurrency: _fromCurrency, toCurrency: _toCurrency, amount: amount);

    try {
      // Panggil service untuk mengonversi mata uang
      final result = await CurrencyService.convertCurrency(converter);
      setState(() {
        // Set hasil konversi
        _convertedAmount = result.convertedAmount ?? 0.0;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Menangani error jika terjadi
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initLocalNotifications();
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      double deltaX = (event.x - _lastX).abs();
      double deltaY = (event.y - _lastY).abs();
      double deltaZ = (event.z - _lastZ).abs();
      if (deltaX > _shakeThreshold ||
          deltaY > _shakeThreshold ||
          deltaZ > _shakeThreshold) {
        _onShake();
      }
      _lastX = event.x;
      _lastY = event.y;
      _lastZ = event.z;
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

  Future<void> _showShakeNotification(int add, double newAmount) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'shake_channel',
      'Shake Notification',
      channelDescription: 'Notifikasi penambahan uang secara random',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      1,
      'Jumlah uang bertambah!',
      'Kamu mendapat tambahan $add, total sekarang: $newAmount',
      platformChannelSpecifics,
    );
  }

  void _onShake() {
    // Tambah jumlah uang secara random (misal 1-100)
    final current = double.tryParse(_amountController.text) ?? 0;
    final add = _random.nextInt(100) + 1;
    final newAmount = current + add;
    setState(() {
      _amountController.text = newAmount.toStringAsFixed(0);
    });
    _convert();
    _showShakeNotification(add, newAmount);
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF59D), Color(0xFF81D4FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Ayo Belajar Konversi Mata Uang!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Masukkan jumlah uang, pilih mata uang asal dan tujuan, lalu lihat hasilnya. Yuk, belajar nilai uang di dunia!',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Jumlah',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Dari',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          DropdownButton<String>(
                            value: _fromCurrency,
                            onChanged: (val) =>
                                setState(() => _fromCurrency = val!),
                            items: const [
                              DropdownMenuItem(
                                  value: 'USD', child: Text('USD')),
                              DropdownMenuItem(
                                  value: 'EUR', child: Text('EUR')),
                              DropdownMenuItem(
                                  value: 'IDR', child: Text('IDR')),
                            ],
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward,
                          size: 32, color: Colors.deepPurple),
                      Column(
                        children: [
                          const Text('Ke',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          DropdownButton<String>(
                            value: _toCurrency,
                            onChanged: (val) =>
                                setState(() => _toCurrency = val!),
                            items: const [
                              DropdownMenuItem(
                                  value: 'USD', child: Text('USD')),
                              DropdownMenuItem(
                                  value: 'EUR', child: Text('EUR')),
                              DropdownMenuItem(
                                  value: 'IDR', child: Text('IDR')),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton.icon(
                    onPressed: _convert,
                    icon: const Icon(Icons.calculate),
                    label: const Text('Konversi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 18),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _isLoading
                      ? const GlobalShimmerCard(height: 90)
                      : Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Hasil Konversi:',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$_convertedAmount $_toCurrency',
                                style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                  const SizedBox(height: 24),
                  const Text(
                    'Belajar nilai uang membantu kamu mengenal mata uang dunia! 💸',
                    style: TextStyle(fontSize: 14, color: Colors.deepPurple),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
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
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
      ),
    );
  }
}
