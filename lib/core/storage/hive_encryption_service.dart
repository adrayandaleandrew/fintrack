import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Service for managing Hive database encryption
///
/// Following bestpractices.md security principles:
/// - Encryption keys stored in secure storage (Keychain/Keystore)
/// - 256-bit AES encryption for all Hive boxes
/// - Key generation on first launch with secure random bytes
/// - No hardcoded keys or secrets
class HiveEncryptionService {
  final FlutterSecureStorage _secureStorage;

  static const String _encryptionKeyName = 'hive_encryption_key';

  const HiveEncryptionService(this._secureStorage);

  /// Get or generate encryption key for Hive
  ///
  /// Returns a 256-bit encryption key (32 bytes).
  /// If key doesn't exist, generates new secure random key and stores it.
  ///
  /// Following bestpractices.md: "Store encryption keys in platform keychain"
  Future<List<int>> getEncryptionKey() async {
    try {
      // Try to retrieve existing key
      final existingKey = await _secureStorage.read(key: _encryptionKeyName);

      if (existingKey != null) {
        // Decode base64 key
        return base64Decode(existingKey);
      }

      // Generate new 256-bit key if none exists
      final newKey = await _generateEncryptionKey();

      // Store in secure storage
      await _secureStorage.write(
        key: _encryptionKeyName,
        value: base64Encode(newKey),
      );

      return newKey;
    } catch (e) {
      throw HiveEncryptionException(
        'Failed to get or generate encryption key: $e',
      );
    }
  }

  /// Generate a secure 256-bit encryption key
  ///
  /// Uses Hive's built-in secure random generator.
  /// Returns 32 bytes (256 bits) for AES-256 encryption.
  Future<List<int>> _generateEncryptionKey() async {
    // Hive.generateSecureKey() generates a cryptographically secure 256-bit key
    return Hive.generateSecureKey();
  }

  /// Delete encryption key (use with caution - will make data unreadable)
  ///
  /// This should only be called when:
  /// - User logs out and wants to clear all data
  /// - User performs factory reset
  /// - Uninstalling the app
  Future<void> deleteEncryptionKey() async {
    try {
      await _secureStorage.delete(key: _encryptionKeyName);
    } catch (e) {
      throw HiveEncryptionException('Failed to delete encryption key: $e');
    }
  }

  /// Verify encryption key exists and is valid
  ///
  /// Returns true if key exists and is 256 bits (32 bytes)
  Future<bool> hasValidEncryptionKey() async {
    try {
      final keyString = await _secureStorage.read(key: _encryptionKeyName);

      if (keyString == null) {
        return false;
      }

      final key = base64Decode(keyString);
      return key.length == 32; // 256 bits = 32 bytes
    } catch (e) {
      return false;
    }
  }

  /// Get encryption key as Uint8List (required by Hive)
  ///
  /// Hive expects encryption key as Uint8List for openBox().
  Future<Uint8List> getEncryptionKeyAsBytes() async {
    final key = await getEncryptionKey();
    return Uint8List.fromList(key);
  }
}

/// Exception thrown when encryption operations fail
class HiveEncryptionException implements Exception {
  final String message;

  const HiveEncryptionException(this.message);

  @override
  String toString() => 'HiveEncryptionException: $message';
}
