import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/habits/models/habit_model.dart';

class OnlineDbService {
  final SupabaseClient _client = Supabase.instance.client;

  // Singleton
  static final OnlineDbService _instance = OnlineDbService._internal();
  factory OnlineDbService() => _instance;
  OnlineDbService._internal();

  // --- 1. GET ALL HABITS ---
  Future<List<Habit>> getHabits() async {
    try {
      final response = await _client
          .from('habits')
          .select()
          .order('created_at', ascending: false);

      return (response as List).map((e) => Habit.fromJson(e)).toList();
    } catch (e) {
      print("Error fetching habits: $e");
      return [];
    }
  }

  // --- 2. CREATE HABIT (Updated for new fields) ---
  Future<void> createHabit({
  required String title,
  required bool isStrict,
  required int deadline,
}) async {
  // We removed the user check because we are in "Dev Mode"
  
  await _client.from('habits').insert({
    // 'user_id': ... REMOVE THIS LINE ENTIRELY
    // OR set it to null if you prefer:
    'id': "AN-HAB-00111",
    'user_id': "AN-U-00111",   
    'title': title,
    'streak': 0,
    'is_strict': isStrict,
    'deadline': deadline,
    'last_completed': null,
  });
}

  // --- 3. DELETE HABIT ---
  Future<void> deleteHabit(String habitId) async {
    await _client.from('habits').delete().eq('id', habitId);
  }

  // --- 4. INCREMENT STREAK ---
  Future<void> incrementStreak(String habitId, int currentStreak) async {
    await _client.from('habits').update({
      'streak': currentStreak + 1,
      'last_completed': DateTime.now().toIso8601String(),
    }).eq('id', habitId);
  }
}