import 'package:flutter/material.dart';
import 'animal_screen.dart';
import 'currency_converter_screen.dart';
import 'time_converter_screen.dart';
import 'profile_screen.dart'; // Import ProfileScreen
import '../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    final List<Widget> pages = [
      const AnimalScreen(),
      const CurrencyConverterScreen(),
      const TimeConverterScreen(),
      const ProfileScreen(),
    ];

    return StatefulBuilder(
      builder: (context, setState) {
        // AppBar hanya untuk AnimalScreen dan ProfileScreen
        final bool showAppBar = selectedIndex == 0 || selectedIndex == 3;
        return Scaffold(
          extendBodyBehindAppBar: !showAppBar,
          appBar: showAppBar
              ? AppBar(
                  title: const Text('Edukasi Anak'),
                  centerTitle: true,
                )
              : null,
          body: pages[selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.pets),
                label: 'Kucing',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.attach_money),
                label: 'Mata Uang',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.access_time),
                label: 'Waktu',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Profil',
              ),
            ],
          ),
        );
      },
    );
  }
}
