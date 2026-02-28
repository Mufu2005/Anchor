import 'package:anchor/core/services/flutter_storage_service.dart';

class SessionManager {
  // Singleton
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();
  //FlutterStorageService _storageService = FlutterStorageService();

  // --- DATA HELD IN MEMORY ---
  String? _encryptionKey;
  String? _username;
  String? _nickname;
  String? _userId;
  bool? _isLoggedIn;

  // --- SETTERS ---
  Future<void> setSession() async {
    final storage = FlutterStorageService();

    // 2. Tell THAT instance to pull data from the hard drive into its RAM
    await storage.getUserInfoFromStorage();

    // 3. Extract the variables from THAT same instance
    _encryptionKey = storage.key;
    _username = storage.username;
    _nickname = storage.nickname;
    _userId = storage.userId;
    _isLoggedIn = storage.isLoggedIn;
    
    if(_isLoggedIn == true){
      print("✅ Session Started for: $_username");  
    }
    else{
      print("No data found: $_username");
    }
  }

  // --- GETTERS (For Habits/Journal) ---
  String get key {
    if (_encryptionKey == null) throw Exception("Session Expired: Missing Encryption Key");
    return _encryptionKey!;
  }
  
  String get username => _username ?? "Unknown";
  String get nickname => _nickname ?? "User";
  String get userId => _userId ?? "";
  bool get isLoggedIn => _isLoggedIn ?? false;

  // --- CLEAR (Logout) ---
  void clear() {
    _encryptionKey = null;
    _username = null;
    _nickname = null;
    _userId = null;
    _isLoggedIn = false;
    print("✅ Session Ended");
  }
}