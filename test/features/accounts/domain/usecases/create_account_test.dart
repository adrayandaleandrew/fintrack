import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/accounts/domain/entities/account.dart';
import 'package:finance_tracker/features/accounts/domain/repositories/account_repository.dart';
import 'package:finance_tracker/features/accounts/domain/usecases/create_account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'create_account_test.mocks.dart';

@GenerateMocks([AccountRepository])
void main() {
  late CreateAccount useCase;
  late MockAccountRepository mockRepository;

  setUp(() {
    mockRepository = MockAccountRepository();
    useCase = CreateAccount(repository: mockRepository);
  });

  group('CreateAccount', () {
    const tUserId = 'user_1';
    final tAccount = Account(
      id: 'acc_1',
      userId: tUserId,
      name: 'Checking Account',
      type: AccountType.bank,
      balance: 1000.0,
      currency: 'USD',
      icon: 'account_balance',
      color: '#2196F3',
      isActive: true,
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    );

    const tParams = CreateAccountParams(
      userId: tUserId,
      name: 'Checking Account',
      type: AccountType.bank,
      initialBalance: 1000.0,
      currency: 'USD',
      icon: 'account_balance',
      color: '#2196F3',
    );

    test('should create account successfully', () async {
      // Arrange
      when(mockRepository.createAccount(
        userId: anyNamed('userId'),
        name: anyNamed('name'),
        type: anyNamed('type'),
        initialBalance: anyNamed('initialBalance'),
        currency: anyNamed('currency'),
        icon: anyNamed('icon'),
        color: anyNamed('color'),
        notes: anyNamed('notes'),
        creditLimit: anyNamed('creditLimit'),
        interestRate: anyNamed('interestRate'),
      )).thenAnswer((_) async => Right(tAccount));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(result, Right(tAccount));
      verify(mockRepository.createAccount(
        userId: tUserId,
        name: 'Checking Account',
        type: AccountType.bank,
        initialBalance: 1000.0,
        currency: 'USD',
        icon: 'account_balance',
        color: '#2196F3',
        notes: null,
        creditLimit: null,
        interestRate: null,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should create credit card account with credit limit', () async {
      // Arrange
      final creditCardAccount = Account(
        id: 'acc_2',
        userId: tUserId,
        name: 'Credit Card',
        type: AccountType.creditCard,
        balance: -500.0,
        currency: 'USD',
        icon: 'credit_card',
        color: '#FF5722',
        isActive: true,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
        creditLimit: 5000.0,
      );

      const creditCardParams = CreateAccountParams(
        userId: tUserId,
        name: 'Credit Card',
        type: AccountType.creditCard,
        initialBalance: -500.0,
        currency: 'USD',
        icon: 'credit_card',
        color: '#FF5722',
        creditLimit: 5000.0,
      );

      when(mockRepository.createAccount(
        userId: anyNamed('userId'),
        name: anyNamed('name'),
        type: anyNamed('type'),
        initialBalance: anyNamed('initialBalance'),
        currency: anyNamed('currency'),
        icon: anyNamed('icon'),
        color: anyNamed('color'),
        notes: anyNamed('notes'),
        creditLimit: anyNamed('creditLimit'),
        interestRate: anyNamed('interestRate'),
      )).thenAnswer((_) async => Right(creditCardAccount));

      // Act
      final result = await useCase(creditCardParams);

      // Assert
      expect(result, Right(creditCardAccount));
      verify(mockRepository.createAccount(
        userId: tUserId,
        name: 'Credit Card',
        type: AccountType.creditCard,
        initialBalance: -500.0,
        currency: 'USD',
        icon: 'credit_card',
        color: '#FF5722',
        notes: null,
        creditLimit: 5000.0,
        interestRate: null,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should create savings account with interest rate', () async {
      // Arrange
      final savingsAccount = Account(
        id: 'acc_3',
        userId: tUserId,
        name: 'Savings',
        type: AccountType.bank,
        balance: 5000.0,
        currency: 'USD',
        icon: 'savings',
        color: '#4CAF50',
        isActive: true,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
        interestRate: 2.5,
      );

      const savingsParams = CreateAccountParams(
        userId: tUserId,
        name: 'Savings',
        type: AccountType.bank,
        initialBalance: 5000.0,
        currency: 'USD',
        icon: 'savings',
        color: '#4CAF50',
        interestRate: 2.5,
      );

      when(mockRepository.createAccount(
        userId: anyNamed('userId'),
        name: anyNamed('name'),
        type: anyNamed('type'),
        initialBalance: anyNamed('initialBalance'),
        currency: anyNamed('currency'),
        icon: anyNamed('icon'),
        color: anyNamed('color'),
        notes: anyNamed('notes'),
        creditLimit: anyNamed('creditLimit'),
        interestRate: anyNamed('interestRate'),
      )).thenAnswer((_) async => Right(savingsAccount));

      // Act
      final result = await useCase(savingsParams);

      // Assert
      expect(result, Right(savingsAccount));
      verify(mockRepository.createAccount(
        userId: tUserId,
        name: 'Savings',
        type: AccountType.bank,
        initialBalance: 5000.0,
        currency: 'USD',
        icon: 'savings',
        color: '#4CAF50',
        notes: null,
        creditLimit: null,
        interestRate: 2.5,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.createAccount(
        userId: anyNamed('userId'),
        name: anyNamed('name'),
        type: anyNamed('type'),
        initialBalance: anyNamed('initialBalance'),
        currency: anyNamed('currency'),
        icon: anyNamed('icon'),
        color: anyNamed('color'),
        notes: anyNamed('notes'),
        creditLimit: anyNamed('creditLimit'),
        interestRate: anyNamed('interestRate'),
      )).thenAnswer((_) async => Left(ServerFailure('Failed to create account')));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(result, Left(ServerFailure('Failed to create account')));
      verify(mockRepository.createAccount(
        userId: tUserId,
        name: 'Checking Account',
        type: AccountType.bank,
        initialBalance: 1000.0,
        currency: 'USD',
        icon: 'account_balance',
        color: '#2196F3',
        notes: null,
        creditLimit: null,
        interestRate: null,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when validation fails', () async {
      // Arrange
      when(mockRepository.createAccount(
        userId: anyNamed('userId'),
        name: anyNamed('name'),
        type: anyNamed('type'),
        initialBalance: anyNamed('initialBalance'),
        currency: anyNamed('currency'),
        icon: anyNamed('icon'),
        color: anyNamed('color'),
        notes: anyNamed('notes'),
        creditLimit: anyNamed('creditLimit'),
        interestRate: anyNamed('interestRate'),
      )).thenAnswer((_) async => Left(ValidationFailure('Account name is required')));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(result, Left(ValidationFailure('Account name is required')));
      verify(mockRepository.createAccount(
        userId: tUserId,
        name: 'Checking Account',
        type: AccountType.bank,
        initialBalance: 1000.0,
        currency: 'USD',
        icon: 'account_balance',
        color: '#2196F3',
        notes: null,
        creditLimit: null,
        interestRate: null,
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
