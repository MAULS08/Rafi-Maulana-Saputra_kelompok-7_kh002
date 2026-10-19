import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'widgets/app_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Profile Card',
      theme: AppTheme.lightTheme,
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Profile Card'), // Text tanpa style
        backgroundColor: const Color(0xFF00695C),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(21.0), // Padding card luar
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.0), // Rounded card
              ),
              child: Padding(
                padding: const EdgeInsets.all(21.0), // Padding card dalam
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 25.0, // Ukuran avatar (diameter = 50px)
                      child: Icon(Icons.person),
                    ),
                    const SizedBox(height: 16.0),
                    const Text('Rafi Maulana Saputra'),
                    const SizedBox(height: 13.0), // Jarak nama dan NIM (13px)
                    const Text('NIM: 20240801195'),
                    const SizedBox(height: 8.0),
                    const Text('Program Studi: Teknik Informatika'),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Saya adalah mahasiswa Teknik Informatika yang tertarik mempelajari pengembangan web, backend development, dan teknologi AI. Saya terus mengembangkan keterampilan pemrograman melalui praktikum dan proyek.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24.0),
                    const AppButton(
                      label: 'Kunjungi GitHub Saya',
                      icon: Icons.open_in_new,
                      url: 'https://github.com/MAULS08',
                      height: 45.0, // Tinggi tombol (45px)
                      borderRadius: 9.0, // Rounded tombol (9px)
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
