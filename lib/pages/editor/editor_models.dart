import 'package:flutter/material.dart';

class EditorOptionModel {
  bool selected;
  String title;
  IconData icon;

  EditorOptionModel({
    required this.selected,
    required this.title,
    required this.icon,
  });
}

class EditorTemplateModel {
  Color color;
  double opacity;
  String? imagePath;
  dynamic data;

  EditorTemplateModel({
    required this.color,
    required this.opacity,
    required this.data,
    this.imagePath,
  });
}
