import 'dart:convert';
import 'package:crypto/crypto.dart'; // <--- For SHA-256
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  final _storage = const FlutterSecureStorage();
  encrypt.Key? _key;
  final encrypt.IV _iv = encrypt.IV.fromLength(16); // Standard IV

  // Check if a key is already set (User has logged in before)
  Future<bool> hasKey() async {
    String? storedHash = await _storage.read(key: 'user_key_hash');
    return storedHash != null;
  }

  // 1. SET KEY (User types their password)
  Future<void> setKey(String userPassword) async {
    // We turn the password into a 32-byte Key using SHA-256
    var bytes = utf8.encode(userPassword);
    var digest = sha256.convert(bytes);
    
    _key = encrypt.Key.fromBase16(digest.toString());
    
    // We store the key safely so they don't have to type it every time they open the app
    // (Optional: You could choose NOT to save this for max security)
    await _storage.write(key: 'user_key_hash', value: _key!.base16);
  }

  // 2. LOAD KEY (Auto-login)
  Future<void> loadSavedKey() async {
    String? storedHash = await _storage.read(key: 'user_key_hash');
    if (storedHash != null) {
      _key = encrypt.Key.fromBase16(storedHash);
    }
  }

  // 3. Encrypt
  String encryptData(String plainText) {
    if (_key == null) throw Exception("Key not set! User must enter password.");
    final encrypter = encrypt.Encrypter(encrypt.AES(_key!));
    // We use a fixed IV for simplicity in this architecture, 
    // but ideally, you store the IV with the data.
    return encrypter.encrypt(plainText, iv: _iv).base64;
  }

  // 4. Decrypt
  String decryptData(String encryptedBase64) {
    if (_key == null) throw Exception("Key not set! User must enter password.");
    final encrypter = encrypt.Encrypter(encrypt.AES(_key!));
    return encrypter.decrypt64(encryptedBase64, iv: _iv);
  }
  
  // 5. Logout / Clear Key
  Future<void> clearKey() async {
    _key = null;
    await _storage.delete(key: 'user_key_hash');
  }
}