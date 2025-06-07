import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../models/timezone.dart';

class TimeConverterScreen extends StatefulWidget {
  const TimeConverterScreen({super.key});

  @override
  State<TimeConverterScreen> createState() => _TimeConverterScreenState();
}

class _TimeConverterScreenState extends State<TimeConverterScreen> {
  TimeOfDay selectedTime = const TimeOfDay(hour: 12, minute: 0);
  String fromZone = 'WIB';
  String toZone = 'London';
  String? result;
  bool _isLoading = false;

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        result = null;
      });
    }
  }

  void _convertTime() {
    setState(() {
      _isLoading = true;
    });
    final fromOffset = timeOffsets[fromZone]!;
    final toOffset = timeOffsets[toZone]!;

    final now = DateTime.now();
    final inputTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    final utcTime = inputTime.subtract(Duration(hours: fromOffset));
    final convertedTime = utcTime.add(Duration(hours: toOffset));

    setState(() {
      result =
          '${convertedTime.hour.toString().padLeft(2, '0')}:${convertedTime.minute.toString().padLeft(2, '0')}';
      _isLoading = false;
    });
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
            colors: [Color(0xFFB2FF59), Color(0xFF81D4FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          'Ayo Belajar Konversi Waktu!',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Pilih waktu dan zona waktu, lalu lihat hasil konversinya. Ini membantu kamu tahu perbedaan waktu di dunia!',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _pickTime,
                          icon: const Icon(Icons.access_time),
                          label: Text(
                              'Pilih Waktu: ${selectedTime.format(context)}'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 18),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text('Dari',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                DropdownButton<String>(
                                  value: fromZone,
                                  onChanged: (val) => setState(() {
                                    fromZone = val!;
                                    result = null;
                                  }),
                                  items: timeOffsets.keys
                                      .map((zone) => DropdownMenuItem(
                                            value: zone,
                                            child: Text(zone),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                            const Icon(Icons.arrow_forward,
                                size: 32, color: Colors.deepPurple),
                            Column(
                              children: [
                                const Text('Ke',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                DropdownButton<String>(
                                  value: toZone,
                                  onChanged: (val) => setState(() {
                                    toZone = val!;
                                    result = null;
                                  }),
                                  items: timeOffsets.keys
                                      .map((zone) => DropdownMenuItem(
                                            value: zone,
                                            child: Text(zone),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        ElevatedButton(
                          onPressed: _convertTime,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('Konversi',
                              style: TextStyle(fontSize: 18)),
                        ),
                        const SizedBox(height: 28),
                        _isLoading
                            ? const GlobalShimmerCard(height: 80)
                            : result != null
                                ? Text(
                                    'Hasil Konversi: $result',
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  )
                                : const SizedBox.shrink(),
                        const SizedBox(height: 24),
                        const Text(
                          'Belajar zona waktu membantu kamu tahu jam di negara lain! 🌏',
                          style:
                              TextStyle(fontSize: 14, color: Colors.deepPurple),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
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
        width: double.infinity,
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
