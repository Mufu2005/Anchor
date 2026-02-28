import 'package:anchor/core/services/session_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/habits/models/habit_model.dart';
import '../../features/auth/models/user_model.dart' as user_model;

class OnlineDbService {
  final SupabaseClient _client = Supabase.instance.client;

  // Singleton
  static final OnlineDbService _instance = OnlineDbService._internal();
  factory OnlineDbService() => _instance;
  OnlineDbService._internal();

  // ------------------------Profiles---------------------------//

  Future<List<user_model.User>> getUser() async {
    try {
      final response = await _client
          .from('profiles')
          .select();

      return (response as List).map((e) =>  user_model.User.fromJson(e)).toList();
    } catch (e) {
      print("Error fetching habits: $e");
      return [];
    }
  }

  Future<String> createProfile({
    required String email,
    required String name,
    required String nickname,
    required String password,
    required String encryption_key,
  }) async {

    final response = await _client.from('profiles').insert({
      // 'user_id': ... REMOVE THIS LINE ENTIRELY
      // OR set it to null if you prefer:
      'email': email,
      'name': name,
      'nickname': nickname,
      'password': password,
      'encryption_key': encryption_key,
    }).select('id').single();

    String newUserId = response['id'] as String;
    print("✅ New User Created: $newUserId");
    return newUserId;
  }

  Future<void> deleteUser(String userId) async {
    await _client.from('profiles').delete().eq('id', userId);
  }

  // ------------------------Profiles---------------------------//

  // ------------------------Habits---------------------------//

  // --- 1. GET ALL HABITS ---
  Future<List<Habit>> getHabits() async {
    try {
      final response = await _client
          .from('habits')
          .select()
          .eq('user_id', SessionManager().userId)
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
      'id': null,
      'user_id': SessionManager().userId,
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
    await _client
        .from('habits')
        .update({
          'streak': currentStreak + 1,
          'last_completed': DateTime.now().toIso8601String(),
        })
        .eq('id', habitId);
  }

  // ------------------------Habits---------------------------//

  
}
