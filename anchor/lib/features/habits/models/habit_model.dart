import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String title;
  final int streak;
  final Color statusColor; // The small line at the top (Red/Green/Yellow)

  Habit({
    required this.id,
    required this.title,
    required this.streak,
    required this.statusColor,
  });
}