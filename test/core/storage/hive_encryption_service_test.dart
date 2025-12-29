import 'package:finance_tracker/core/storage/hive_encryption_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'dart:typed_data';

import 'hive_encryption_service_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
void main() {
  late HiveEncryptionService service;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    service = HiveEncryptionService(mockSecureStorage);
  });

  group('HiveEncryptionService', () {
    test('should generate and store encryption key on first call', () async {
      // Arrange
      when(mockSecureStorage.read(key: anyNamed('key'))).thenAnswer((_) async => null);
      when(mockSecureStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async => {});

      // Act
      final key = await service.getEncryptionKey();

      // Assert
      expect(key, isNotNull);
      expect(key.length, equals(32)); // 256 bits = 32 bytes
      verify(mockSecureStorage.read(key: 'hive_encryption_key')).called(1);
      verify(mockSecureStorage.write(
        key: 'hive_encryption_key',
        value: anyNamed('value'),
      )).called(1);
    });

    test('should retrieve existing encryption key', () async {
      // Arrange
      final mockKey = List<int>.generate(32, (i) => i);
      final mockKeyString = 'AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8='; // Base64 encoded 32 bytes

      when(mockSecureStorage.read(key: anyNamed('key')))
          .thenAnswer((_) async => mockKeyString);

      // Act
      final key = await service.getEncryptionKey();

      // Assert
      expect(key, isNotNull);
      expect(key.length, equals(32));
      verify(mockSecureStorage.read(key: 'hive_encryption_key')).called(1);
      verifyNever(mockSecureStorage.write(key: anyNamed('key'), value: anyNamed('value')));
    });

    test('should return Uint8List when requested', () async {
      // Arrange
      final mockKeyString = 'AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8=';
      when(mockSecureStorage.read(key: anyNamed('key')))
          .thenAnswer((_) async => mockKeyString);

      // Act
      final keyBytes = await service.getEncryptionKeyAsBytes();

      // Assert
      expect(keyBytes, isA<Uint8List>());
      expect(keyBytes.length, equals(32));
    });

    test('should validate encryption key correctly', () async {
      // Arrange
      final mockKeyString = 'AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8='; // Valid 32-byte key
      when(mockSecureStorage.read(key: anyNamed('key')))
          .thenAnswer((_) async => mockKeyString);

      // Act
      final isValid = await service.hasValidEncryptionKey();

      // Assert
      expect(isValid, isTrue);
    });

    test('should return false for invalid encryption key', () async {
      // Arrange
      when(mockSecureStorage.read(key: anyNamed('key')))
          .thenAnswer((_) async => 'invalid_key'); // Invalid base64

      // Act
      final isValid = await service.hasValidEncryptionKey();

      // Assert
      expect(isValid, isFalse);
    });

    test('should delete encryption key successfully', () async {
      // Arrange
      when(mockSecureStorage.delete(key: anyNamed('key')))
          .thenAnswer((_) async => {});

      // Act
      await service.deleteEncryptionKey();

      // Assert
      verify(mockSecureStorage.delete(key: 'hive_encryption_key')).called(1);
    });

    test('should throw exception when key retrieval fails', () async {
      // Arrange
      when(mockSecureStorage.read(key: anyNamed('key')))
          .thenThrow(Exception('Storage error'));

      // Act & Assert
      expect(
        () => service.getEncryptionKey(),
        throwsA(isA<HiveEncryptionException>()),
      );
    });
  });
}
