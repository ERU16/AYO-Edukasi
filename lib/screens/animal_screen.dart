import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../models/animal.dart';
import '../services/animal_api_service.dart';
import '../models/animal_query_list.dart';
import 'cat_detail_screen.dart';

class AnimalScreen extends StatefulWidget {
  const AnimalScreen({super.key});

  @override
  State<AnimalScreen> createState() => _AnimalScreenState();
}

class _AnimalScreenState extends State<AnimalScreen> {
  late Future<List<Animal>> animalFuture;
  List<Animal> _allAnimals = [];
  List<Animal> _filteredAnimals = [];
  String _searchQuery = '';
  String? _selectedOrigin;

  void _fetchTopCats() {
    setState(() {
      animalFuture = Future.wait(
        catQueryList.map((q) => ApiService.fetchCats(q)).toList(),
      ).then((lists) {
        final all = lists.expand((e) => e).toList();
        _allAnimals = all;
        _applyFilter();
        return all;
      });
    });
  }

  void _applyFilter() {
    setState(() {
      _filteredAnimals = _allAnimals.where((animal) {
        final matchesSearch =
            animal.name.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesOrigin = _selectedOrigin == null ||
            _selectedOrigin == 'Semua' ||
            animal.origin == _selectedOrigin;
        return matchesSearch && matchesOrigin;
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchTopCats();
  }

  void _refreshAnimal() {
    _fetchTopCats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengenalan Kucing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat Ulang',
            onPressed: _refreshAnimal,
          ),
        ],
      ),
      body: FutureBuilder<List<Animal>>(
        future: animalFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const GlobalShimmerList();
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Gagal memuat data: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data kucing.'));
          }

          // Ambil semua origin unik
          final origins = <String>{'Semua'};
          for (final animal in _allAnimals) {
            if (animal.origin.isNotEmpty) origins.add(animal.origin);
          }

          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Cari nama kucing...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (val) {
                          _searchQuery = val;
                          _applyFilter();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: _selectedOrigin ?? 'Semua',
                      items: origins
                          .map((o) => DropdownMenuItem(
                                value: o,
                                child: Text(o),
                              ))
                          .toList(),
                      onChanged: (val) {
                        _selectedOrigin = val;
                        _applyFilter();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _filteredAnimals.isEmpty
                    ? const Center(
                        child: Text(
                          'Kucing dengan nama tersebut tidak ditemukan.',
                          style:
                              TextStyle(fontSize: 16, color: Colors.redAccent),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredAnimals.length,
                        itemBuilder: (context, index) {
                          final animal = _filteredAnimals[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  animal.imageLink.isNotEmpty
                                      ? Image.network(animal.imageLink,
                                          height: 120,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(Icons.broken_image,
                                                      size: 80))
                                      : const Icon(Icons.pets,
                                          size: 80, color: Colors.grey),
                                  const SizedBox(height: 12),
                                  Text(animal.name,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Text('Asal: ${animal.origin}',
                                      style: const TextStyle(fontSize: 15)),
                                  Text('Panjang: ${animal.length}',
                                      style: const TextStyle(fontSize: 15)),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              CatDetailScreen(cat: animal),
                                        ),
                                      );
                                    },
                                    child: const Text('Lihat Lebih Detail'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class GlobalShimmerList extends StatelessWidget {
  const GlobalShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  color: Colors.grey,
                ),
                const SizedBox(height: 12),
                Container(
                  height: 20,
                  width: double.infinity,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 20,
                  width: 150,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
