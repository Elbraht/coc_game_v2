import 'package:flutter/material.dart';
import 'package:coc_game_v2/ui/start_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StartScreen(), // Teraz to zadziała!
    );
  }
}
