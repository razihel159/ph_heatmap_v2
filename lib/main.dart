import 'package:flutter/material.dart';
import 'screens/map_screen.dart'; // Siguraduhing 'screens' ang folder name

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PH Heatmap Project',
      theme: ThemeData(
        useMaterial3: true, 
        colorSchemeSeed: Colors.blue
      ),
      home: const MapScreen(),
    );
  }
}