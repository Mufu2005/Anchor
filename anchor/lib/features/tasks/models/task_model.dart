// import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String priority; // "High", "Medium", or "Low"
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.priority, // Store the text, not the color
    this.isCompleted = false,
  });
}