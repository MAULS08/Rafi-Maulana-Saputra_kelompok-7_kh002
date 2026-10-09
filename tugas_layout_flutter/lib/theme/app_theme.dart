// import 'package:flutter/material.dart';
//
// class AppTheme {
//   AppTheme._();
//
//   static ThemeData get light => ThemeData(
//     colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
//     scaffoldBackgroundColor: Colors.deepOrange[100],
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Colors.deepPurple,
//       foregroundColor: Colors.yellow,
//       elevation: 0,
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.indigo,
//         foregroundColor: Colors.lightGreenAccent,
//       ),
//     ),
//   );
// }


import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
      ),
      scaffoldBackgroundColor: Colors.grey.shade100,
    );
  }
}