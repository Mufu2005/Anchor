import 'dart:convert';
import 'package:crypto/crypto.dart'; 
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  // Singleton Pattern
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  final _storage = const FlutterSecureStorage();
  encrypt.Key? _key;

  // --- 1. SET KEY (Fixed: Returns Future & Saves to Storage) ---
  Future<void> setKey(String userKeyInput) async {
    // 1. Hash the input to get a 32-byte key
    var bytes = utf8.encode(userKeyInput);
    var digest = sha256.convert(bytes);
    
    // 2. Set the key in memory (for immediate use)
    _key = encrypt.Key.fromBase16(digest.toString());

    // 3. Persist the RAW input so we can regenerate the key next app launch
    // (Or you can save the hash, depending on your security model)
    await _storage.write(key: 'user_secret_key', value: userKeyInput);
  }

  // --- HELPER: LOAD KEY ON APP START ---
  // Call this in main.dart or Splash Screen to restore the key!
  Future<bool> loadKeyFromStorage() async {
    final savedKey = await _storage.read(key: 'user_secret_key');
    if (savedKey != null) {
      await setKey(savedKey);
      return true; // Key found and loaded
    }
    return false; // No key found (User needs to go to Setup)
  }

  // --- 2. ENCRYPT ---
  String encryptData(String plainText) {
    if (_key == null) throw Exception("Encryption Key not set!");
    
    final iv = encrypt.IV.fromLength(16); 
    final encrypter = encrypt.Encrypter(encrypt.AES(_key!));
    
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    
    // Return IV + Encrypted Data (separated by colon)
    return "${iv.base64}:${encrypted.base64}"; 
  }

  // --- 3. DECRYPT ---
  String decryptData(String encryptedString) {
    if (_key == null) throw Exception("Encryption Key not set!");
    
    try {
      final parts = encryptedString.split(':');
      if (parts.length != 2) return "Invalid Format";

      final iv = encrypt.IV.fromBase64(parts[0]);
      final encrypter = encrypt.Encrypter(encrypt.AES(_key!));
      
      return encrypter.decrypt64(parts[1], iv: iv);
    } catch (e) {
      return "Decryption Error"; // Return a safe string or rethrow
    }
  }
}