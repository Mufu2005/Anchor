class SessionManager {
  // Singleton
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  // --- DATA HELD IN MEMORY ---
  String? _encryptionKey;
  String? _username;
  String? _nickname;
  String? _userId;

  // --- SETTERS ---
  void setSession({
    required String key, 
    required String username, 
    required String nickname,
    required String userId,
  }) {
    _encryptionKey = key;
    _username = username;
    _nickname = nickname;
    _userId = userId;
    print("✅ Session Started for: $_username");
  }

  // --- GETTERS (For Habits/Journal) ---
  String get key {
    if (_encryptionKey == null) throw Exception("Session Expired: Missing Encryption Key");
    return _encryptionKey!;
  }
  
  String get username => _username ?? "Unknown";
  String get nickname => _nickname ?? "User";
  String get userId => _userId ?? "";

  // --- CLEAR (Logout) ---
  void clear() {
    _encryptionKey = null;
    _username = null;
    _nickname = null;
    _userId = null;
  }
}