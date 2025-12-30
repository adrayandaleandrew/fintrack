import 'package:hive_flutter/hive_flutter.dart';
import 'hive_encryption_service.dart';

/// Helper class for opening encrypted Hive boxes
///
/// Provides a consistent interface for opening all Hive boxes with encryption.
/// All boxes use AES-256 encryption with keys stored in secure storage.
///
/// Usage:
/// ```dart
/// final box = await EncryptedBoxHelper.openBox<String>('my_box');
/// ```
class EncryptedBoxHelper {
  final HiveEncryptionService _encryptionService;

  const EncryptedBoxHelper(this._encryptionService);

  /// Open an encrypted Hive box
  ///
  /// [boxName] - Name of the box to open
  ///
  /// Returns encrypted box with AES-256 encryption.
  /// The encryption key is retrieved from secure storage automatically.
  Future<Box<E>> openBox<E>(String boxName) async {
    try {
      // Check if box is already open
      if (Hive.isBoxOpen(boxName)) {
        return Hive.box<E>(boxName);
      }

      // Get encryption key
      final encryptionKey = await _encryptionService.getEncryptionKeyAsBytes();

      // Open encrypted box
      return await Hive.openBox<E>(
        boxName,
        encryptionCipher: HiveAesCipher(encryptionKey),
      );
    } catch (e) {
      throw HiveEncryptionException(
        'Failed to open encrypted box "$boxName": $e',
      );
    }
  }

  /// Close a box if it's open
  ///
  /// [boxName] - Name of the box to close
  Future<void> closeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }

  /// Delete a box (use with caution - deletes all data in box)
  ///
  /// [boxName] - Name of the box to delete
  Future<void> deleteBox(String boxName) async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        await Hive.box(boxName).close();
      }
      await Hive.deleteBoxFromDisk(boxName);
    } catch (e) {
      throw HiveEncryptionException('Failed to delete box "$boxName": $e');
    }
  }

  /// Delete all Hive boxes (factory reset)
  ///
  /// Use only when:
  /// - User logs out and wants to clear all data
  /// - User performs factory reset
  /// - Testing/development
  Future<void> deleteAllBoxes() async {
    try {
      // Close all open boxes first
      await Hive.close();

      // Delete all boxes from disk
      await Hive.deleteFromDisk();
    } catch (e) {
      throw HiveEncryptionException('Failed to delete all boxes: $e');
    }
  }
}
