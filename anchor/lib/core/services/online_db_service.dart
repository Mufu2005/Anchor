import 'package:anchor/core/services/encryption_service.dart';
import 'package:anchor/core/services/session_manager.dart';
import 'package:anchor/features/journal/models/journal_model.dart';
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
      final response = await _client.from('profiles').select();

      return (response as List)
          .map((e) => user_model.User.fromJson(e))
          .toList();
    } catch (e) {
      print("Error fetching habits: $e");
      return [];
    }
  }

  Future<List<user_model.User>> getUserByHashEmail(String email) async {
    final hashEmail = EncryptionService().generateBlindIndex(email);
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('email_hash', hashEmail)
          .order('timeStamp', ascending: false);

      return (response as List)
          .map((e) => user_model.User.fromJson(e))
          .toList();
    } catch (e) {
      print("Error fetching User: $e");
      return [];
    }
  }

  Future<String> createProfile({
    required String email,
    required String name,
    required String nickname,
    required String password,
    required String encryption_key,
    required String hash_email,
  }) async {
    final response = await _client
        .from('profiles')
        .insert({
          // 'user_id': ... REMOVE THIS LINE ENTIRELY
          // OR set it to null if you prefer:
          'email': email,
          'name': name,
          'nickname': nickname,
          'password': password,
          'encryption_key': encryption_key,
          'email_hash': hash_email,
        })
        .select('id')
        .single();

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

  // ------------------------Journals---------------------------//

  Future<List<JournalEntry>> getEntries() async {
    try {
      final response = await _client
          .from('journals')
          .select()
          .eq('userId', SessionManager().userId)
          .order('timeStamp', ascending: false);

      return (response as List).map((e) => JournalEntry.fromJson(e)).toList();
    } catch (e) {
      print("Error fetching entries: $e");
      return [];
    }
  }

  Future<void> createNewEntry({
    required String title,
    required String content,
    required String category,
  }) async {
    // We removed the user check because we are in "Dev Mode"

    final response = await _client.from('journals').insert({
      'id': "v",
      'userId': SessionManager().userId,
      'title': title,
      'entry': content,
      'category': category,
    });
    print("Entry Created: $response");
  }

  Future<Map<String, dynamic>?> getSharedEntry(String id,String entryId) async {
    final response = await _client
        .from('shared_entries')
        .select()
        .eq('id', id)
        .eq('entry_id', entryId)
        .maybeSingle();
    print("Shared Entry: $response");
    return response;
  }

  Future<String> createSharedEntry({
    required String key,
    required String id,
    required String title,
    required String content,
  }) async {
    // We removed the user check because we are in "Dev Mode"
    final String enctitle = EncryptionService().encryptWithSharedKey(title, key);
    final String enccontent = EncryptionService().encryptWithSharedKey(content, key);

    final response = await _client.from('shared_entries').insert({
      'entry_id': id,
      'title': enctitle,
      'entry': enccontent,
    })
    .select('id')
    .single();

    print("Shared Entry Created: $response");
    return response['id'] as String;
  }

  Future<void> deleteEntry(String EntryId) async {
    await _client.from('journals').delete().eq('id', EntryId);
  }
}
