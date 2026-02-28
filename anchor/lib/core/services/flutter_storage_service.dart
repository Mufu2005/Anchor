  import 'package:flutter_secure_storage/flutter_secure_storage.dart';

  class FlutterStorageService {
      final FlutterSecureStorage storage = const FlutterSecureStorage();
      String? _key;
      String? _username;
      String? _nickname;
      String? _userId;
      bool? _isLoggedIn;

      // --- GETTERS ---
      String get key => _key ?? "";
      String get username => _username ?? "";
      String get nickname => _nickname ?? "";
      String get userId => _userId ?? "";
      bool get isLoggedIn => _isLoggedIn ?? false;

      void getSessionInfoFromUser(String key, String username, String nickname, String userId, bool isLoggedIn){
          _key = key;
          _username = username;
          _nickname = nickname;
          _userId = userId;
          _isLoggedIn = isLoggedIn;
      }

      Future<void> setUserInfoToStorage() async {
          await storage.write(key: 'key', value: _key);
          await storage.write(key: 'username', value: _username);
          await storage.write(key: 'nickname', value: _nickname);
          await storage.write(key: 'userId', value: _userId);
          await storage.write(key: 'isLoggedIn', value: _isLoggedIn.toString());
      }

      Future<void> getUserInfoFromStorage() async {
          _key = await storage.read(key: 'key');
          _username = await storage.read(key: 'username');
          _nickname = await storage.read(key: 'nickname');
          _userId = await storage.read(key: 'userId');
          _isLoggedIn = await storage.read(key: 'isLoggedIn') == 'true';
      }

      Future<void> clearUserInfoFromStorage() async {
          await storage.delete(key: 'key');
          await storage.delete(key: 'username');
          await storage.delete(key: 'nickname');
          await storage.delete(key: 'userId');
          await storage.delete(key: 'isLoggedIn');
      }
  }