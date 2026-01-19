import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final Color priorityColor; // Red, Yellow, Green line
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.priorityColor,
    this.isCompleted = false,
  });
}