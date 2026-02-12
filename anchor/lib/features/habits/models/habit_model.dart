import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String userId; // Standard naming is camelCase (userId, not user_id)
  final String title;
  final int streak;
  final DateTime? lastCompleted;
  final bool isStrict; // Changed Bool -> bool
  final int deadline;  // Changed Int -> int

  Habit({
    required this.id,
    required this.userId,
    required this.title,
    required this.streak,
    this.lastCompleted,
    required this.isStrict,
    required this.deadline,
  });

  // --- LOGIC: Calculate Status Color ---
  Color get statusColor {
    if (lastCompleted == null) return Colors.grey; // Never done

    final now = DateTime.now();
    
    // Check if done today
    final isToday = now.year == lastCompleted!.year &&
        now.month == lastCompleted!.month &&
        now.day == lastCompleted!.day;

    if (isToday) return Colors.greenAccent; // Done today

    // Calculate days passed (ignoring hours/minutes for accuracy)
    final dateNow = DateTime(now.year, now.month, now.day);
    final dateLast = DateTime(lastCompleted!.year, lastCompleted!.month, lastCompleted!.day);
    final difference = dateNow.difference(dateLast).inDays;

    if (difference == 1) return Colors.amberAccent; // Missed yesterday (Warning)
    if (difference > 1) return Colors.redAccent;    // Missed >1 day (Danger)

    return Colors.grey; // Fallback
  }

  // --- FACTORY: Convert DB JSON to Dart Object ---
  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'].toString(),
      userId: json['user_id']?.toString() ?? '', 
      title: json['title'] ?? 'Untitled',
      streak: json['streak'] ?? 0,
      
      // Parse Date
      lastCompleted: json['last_completed'] != null
          ? DateTime.tryParse(json['last_completed'].toString())
          : null,
      
      // Parse Booleans (Handle 1/0 from SQL or true/false from JSON)
      isStrict: json['is_strict'] == 1 || json['is_strict'] == true,
      
      // Parse Int
      deadline: json['deadline'] ?? 0,
    );
  }
}