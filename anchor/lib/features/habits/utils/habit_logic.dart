import 'package:flutter/material.dart';

class HabitLogic {
  
  /// 1. GET BAR COLOR
  /// Returns the color based on status (Done, Warning, Failed, Neutral)
  static Color getBarColor({
    required bool isCompletedToday,
    required bool isStrict,
    DateTime? lastCompleted,
  }) {
    final now = DateTime.now();

    // A. NON-STRICT (Counter Mode) -> Always Neutral Blue/Grey
    if (!isStrict) {
      return const Color(0xFF607D8B); // Blue Grey
    }

    // B. COMPLETED TODAY -> Green
    if (isCompletedToday) {
      return const Color(0xFF00E676); // Neon Green
    }

    // C. PANIC MODE (After 6 PM and not done) -> Yellow
    if (now.hour >= 18) {
      return const Color(0xFFFFEA00); // Industrial Yellow
    }

    // D. FAILED (Yesterday was missed) -> Red
    // (We check if the last completion was before yesterday)
    if (lastCompleted != null) {
      final difference = now.difference(lastCompleted).inDays;
      if (difference > 1) {
        return const Color(0xFFFF1744); // Alert Red
      }
    }

    // E. NORMAL PENDING -> Grey
    return const Color(0xFF9E9E9E); 
  }

  /// 2. CALCULATE PROGRESS WIDTH (0.0 to 1.0)
  /// Shrinks the bar as the day goes by (Pressure!)
  static double getProgress(bool isStrict, bool isCompletedToday) {
    if (!isStrict || isCompletedToday) return 1.0; // Full bar if done or not strict

    final now = DateTime.now();
    final totalMinutes = 24 * 60;
    final currentMinutes = (now.hour * 60) + now.minute;
    
    // Returns percentage of day remaining (e.g., 0.5 at noon)
    return 1.0 - (currentMinutes / totalMinutes);
  }

  /// 3. CHECK IF DONE TODAY
  static bool checkIsCompletedToday(DateTime? lastCompleted) {
    if (lastCompleted == null) return false;
    final now = DateTime.now();
    return now.year == lastCompleted.year && 
           now.month == lastCompleted.month && 
           now.day == lastCompleted.day;
  }
}