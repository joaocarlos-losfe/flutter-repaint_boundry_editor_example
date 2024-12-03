import 'package:basic_editor/pages/editor/editor_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Map<String, dynamic> testData = {
    "user": "João Carlos",
    "titles": ["Distância Total", "Tempo", "Ritmo"],
    "data": ["30 km", "02:30:15 min", "07:12 min/km"],
    "datetime": "3 de dezembro de 2024"
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EditorPage(
        data: testData,
      ),
    );
  }
}
