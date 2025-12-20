import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/accounts/domain/entities/account.dart';
import 'package:finance_tracker/features/accounts/domain/repositories/account_repository.dart';
import 'package:finance_tracker/features/accounts/domain/usecases/update_account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_account_test.mocks.dart';

@GenerateMocks([AccountRepository])
void main() {
  late UpdateAccount useCase;
  late MockAccountRepository mockRepository;

  setUp(() {
    mockRepository = MockAccountRepository();
    useCase = UpdateAccount(repository: mockRepository);
  });

  group('UpdateAccount', () {
    const tAccountId = 'acc_1';
    final tUpdatedAccount = Account(
      id: tAccountId,
      userId: 'user_1',
      name: 'Updated Checking Account',
      type: AccountType.bank,
      balance: 1000.0,
      currency: 'USD',
      icon: 'account_balance',
      color: '#2196F3',
      isActive: true,
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 15),
    );

    test('should update account successfully', () async {
      // Arrange
      const tParams = UpdateAccountParams(
        accountId: tAccountId,
        name: 'Updated Checking Account',
      );

      when(mockRepository.updateAccount(
        accountId: anyNamed('accountId'),
        name: anyNamed('name'),
        type: anyNamed('type'),
        currency: anyNamed('currency'),
        icon: anyNamed('icon'),
        color: anyNamed('color'),
        isActive: anyNamed('isActive'),
        notes: anyNamed('notes'),
        creditLimit: anyNamed('creditLimit'),
        interestRate: anyNamed('interestRate'),
      )).thenAnswer((_) async => Right(tUpdatedAccount));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(result, Right(tUpdatedAccount));
      verify(mockRepository.updateAccount(
        accountId: tAccountId,
        name: 'Updated Checking Account',
        type: null,
        currency: null,
        icon: null,
        color: null,
        isActive: null,
        notes: null,
        creditLimit: null,
        interestRate: null,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should update multiple fields simultaneously', () async {
      // Arrange
      const tParams = UpdateAccountParams(
        accountId: tAccountId,
        name: 'Updated Checking Account',
        icon: 'account_balance_wallet',
        color: '#FF5722',
        isActive: false,
      );

      when(mockRepository.updateAccount(
        accountId: anyNamed('accountId'),
        name: anyNamed('name'),
        type: anyNamed('type'),
        currency: anyNamed('currency'),
        icon: anyNamed('icon'),
        color: anyNamed('color'),
        isActive: anyNamed('isActive'),
        notes: anyNamed('notes'),
        creditLimit: anyNamed('creditLimit'),
        interestRate: anyNamed('interestRate'),
      )).thenAnswer((_) async => Right(tUpdatedAccount));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(result, Right(tUpdatedAccount));
      verify(mockRepository.updateAccount(
        accountId: tAccountId,
        name: 'Updated Checking Account',
        type: null,
        currency: null,
        icon: 'account_balance_wallet',
        color: '#FF5722',
        isActive: false,
        notes: null,
        creditLimit: null,
        interestRate: null,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should update credit card account with credit limit', () async {
      // Arrange
      const tParams = UpdateAccountParams(
        accountId: tAccountId,
        creditLimit: 10000.0,
      );

      final creditCardAccount = Account(
        id: tAccountId,
        userId: 'user_1',
        name: 'Credit Card',
        type: AccountType.creditCard,
        balance: -500.0,
        currency: 'USD',
        icon: 'credit_card',
        color: '#FF5722',
        isActive: true,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 15),
        creditLimit: 10000.0,
      );

      when(mockRepository.updateAccount(
        accountId: anyNamed('accountId'),
        name: anyNamed('name'),
        type: anyNamed('type'),
        currency: anyNamed('currency'),
        icon: anyNamed('icon'),
        color: anyNamed('color'),
        isActive: anyNamed('isActive'),
        notes: anyNamed('notes'),
        creditLimit: anyNamed('creditLimit'),
        interestRate: anyNamed('interestRate'),
      )).thenAnswer((_) async => Right(creditCardAccount));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(result, Right(creditCardAccount));
      verify(mockRepository.updateAccount(
        accountId: tAccountId,
        name: null,
        type: null,
        currency: null,
        icon: null,
        color: null,
        isActive: null,
        notes: null,
        creditLimit: 10000.0,
        interestRate: null,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should deactivate account', () async {
      // Arrange
      const tParams = UpdateAccountParams(
        accountId: tAccountId,
        isActive: false,
      );

      final inactiveAccount = tUpdatedAccount.copyWith(isActive: false);

      when(mockRepository.updateAccount(
        accountId: anyNamed('accountId'),
        name: anyNamed('name'),
        type: anyNamed('type'),
        currency: anyNamed('currency'),
        icon: anyNamed('icon'),
        color: anyNamed('color'),
        isActive: anyNamed('isActive'),
        notes: anyNamed('notes'),
        creditLimit: anyNamed('creditLimit'),
        interestRate: anyNamed('interestRate'),
      )).thenAnswer((_) async => Right(inactiveAccount));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(result, Right(inactiveAccount));
      verify(mockRepository.updateAccount(
        accountId: tAccountId,
        name: null,
        type: null,
        currency: null,
        icon: null,
        color: null,
        isActive: false,
        notes: null,
        creditLimit: null,
        interestRate: null,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NotFoundFailure when account does not exist', () async {
      // Arrange
      const tParams = UpdateAccountParams(
        accountId: tAccountId,
        name: 'Updated Name',
      );

      when(mockRepository.updateAccount(
        accountId: anyNamed('accountId'),
        name: anyNamed('name'),
        type: anyNamed('type'),
        currency: anyNamed('currency'),
        icon: anyNamed('icon'),
        color: anyNamed('color'),
        isActive: anyNamed('isActive'),
        notes: anyNamed('notes'),
        creditLimit: anyNamed('creditLimit'),
        interestRate: anyNamed('interestRate'),
      )).thenAnswer((_) async => Left(NotFoundFailure('Account not found')));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(result, Left(NotFoundFailure('Account not found')));
      verify(mockRepository.updateAccount(
        accountId: tAccountId,
        name: 'Updated Name',
        type: null,
        currency: null,
        icon: null,
        color: null,
        isActive: null,
        notes: null,
        creditLimit: null,
        interestRate: null,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      const tParams = UpdateAccountParams(
        accountId: tAccountId,
        name: 'Updated Name',
      );

      when(mockRepository.updateAccount(
        accountId: anyNamed('accountId'),
        name: anyNamed('name'),
        type: anyNamed('type'),
        currency: anyNamed('currency'),
        icon: anyNamed('icon'),
        color: anyNamed('color'),
        isActive: anyNamed('isActive'),
        notes: anyNamed('notes'),
        creditLimit: anyNamed('creditLimit'),
        interestRate: anyNamed('interestRate'),
      )).thenAnswer((_) async => Left(ServerFailure('Failed to update account')));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(result, Left(ServerFailure('Failed to update account')));
      verify(mockRepository.updateAccount(
        accountId: tAccountId,
        name: 'Updated Name',
        type: null,
        currency: null,
        icon: null,
        color: null,
        isActive: null,
        notes: null,
        creditLimit: null,
        interestRate: null,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when validation fails', () async {
      // Arrange
      const tParams = UpdateAccountParams(
        accountId: tAccountId,
        name: '',
      );

      when(mockRepository.updateAccount(
        accountId: anyNamed('accountId'),
        name: anyNamed('name'),
        type: anyNamed('type'),
        currency: anyNamed('currency'),
        icon: anyNamed('icon'),
        color: anyNamed('color'),
        isActive: anyNamed('isActive'),
        notes: anyNamed('notes'),
        creditLimit: anyNamed('creditLimit'),
        interestRate: anyNamed('interestRate'),
      )).thenAnswer((_) async => Left(ValidationFailure('Account name cannot be empty')));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(result, Left(ValidationFailure('Account name cannot be empty')));
      verify(mockRepository.updateAccount(
        accountId: tAccountId,
        name: '',
        type: null,
        currency: null,
        icon: null,
        color: null,
        isActive: null,
        notes: null,
        creditLimit: null,
        interestRate: null,
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
