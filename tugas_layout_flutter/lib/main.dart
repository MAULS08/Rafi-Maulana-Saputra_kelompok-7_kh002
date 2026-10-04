import 'package:flutter/material.dart';

import 'profile_card.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tugas Layout Flutter',

      theme: ThemeData(
        // Digit terakhir NIM adalah 5 (ganjil)
        // sehingga menggunakan Colors.tealAccent[100]
        scaffoldBackgroundColor: Colors.tealAccent[100],
      ),

      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil Praktikan - Rafi Maulana Saputra',
        ),
        backgroundColor: Colors.teal,
      ),

      body: Center(
        child: ProfileCard(
          nama: "Rafi Maulana Saputra",
          nim: "20240801195",
          hobi: "Web Development & Jaringan",
          skorAktivitas: 145,
        ),
      ),
    );
  }
}