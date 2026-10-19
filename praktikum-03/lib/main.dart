
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

  // Digit terakhir NIM: 5
  static const double d = 5;

  static const double cardPadding = 16 + d;
  static const double cardRadius = 8 + d;
  static const double buttonHeight = 40 + d;
  static const double buttonRadius = 4 + d;
  static const double avatarSize = 40 + (2 * d);
  static const double nameNimSpacing = 8 + d;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Profile Card'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cardRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(cardPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: avatarSize / 2,
                    child: const Icon(Icons.person),
                  ),

                  const SizedBox(height: 16),

                  const Text('Rafi Maulana Saputra'),

                  SizedBox(height: nameNimSpacing),

                  const Text('NIM: 20240801195'),

                  const SizedBox(height: 8),

                  const Text('Program Studi: Teknik Informatika'),

                  const SizedBox(height: 16),

                  const Text(
                    'Saya adalah mahasiswa Teknik Informatika '
                        'yang tertarik mempelajari pengembangan web, '
                        'backend development, dan teknologi AI. '
                        'Saya terus mengembangkan keterampilan '
                        'pemrograman melalui praktikum dan proyek.',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  AppButton(
                    label: 'Kunjungi GitHub Saya',
                    icon: Icons.open_in_new,
                    url: 'https://github.com/MAULS08',
                    height: buttonHeight,
                    borderRadius: buttonRadius,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}