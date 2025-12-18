import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/currency/domain/entities/currency.dart';
import 'package:finance_tracker/features/currency/domain/entities/exchange_rate.dart';
import 'package:finance_tracker/features/currency/domain/usecases/convert_currency.dart';
import 'package:finance_tracker/features/currency/domain/usecases/get_base_currency.dart';
import 'package:finance_tracker/features/currency/domain/usecases/get_currencies.dart';
import 'package:finance_tracker/features/currency/domain/usecases/get_exchange_rates.dart';
import 'package:finance_tracker/features/currency/domain/usecases/update_base_currency.dart';
import 'package:finance_tracker/features/currency/presentation/bloc/currency_bloc.dart';
import 'package:finance_tracker/features/currency/presentation/bloc/currency_event.dart';
import 'package:finance_tracker/features/currency/presentation/bloc/currency_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'currency_bloc_test.mocks.dart';

@GenerateMocks([
  GetCurrencies,
  GetExchangeRates,
  ConvertCurrency,
  GetBaseCurrency,
  UpdateBaseCurrency,
])
void main() {
  late CurrencyBloc bloc;
  late MockGetCurrencies mockGetCurrencies;
  late MockGetExchangeRates mockGetExchangeRates;
  late MockConvertCurrency mockConvertCurrency;
  late MockGetBaseCurrency mockGetBaseCurrency;
  late MockUpdateBaseCurrency mockUpdateBaseCurrency;

  setUp(() {
    mockGetCurrencies = MockGetCurrencies();
    mockGetExchangeRates = MockGetExchangeRates();
    mockConvertCurrency = MockConvertCurrency();
    mockGetBaseCurrency = MockGetBaseCurrency();
    mockUpdateBaseCurrency = MockUpdateBaseCurrency();

    bloc = CurrencyBloc(
      getCurrencies: mockGetCurrencies,
      getExchangeRates: mockGetExchangeRates,
      convertCurrency: mockConvertCurrency,
      getBaseCurrency: mockGetBaseCurrency,
      updateBaseCurrency: mockUpdateBaseCurrency,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('CurrencyBloc', () {
    const tCurrencies = [
      Currency(
        code: 'USD',
        name: 'US Dollar',
        symbol: '\$',
        decimalPlaces: 2,
        flag: '🇺🇸',
        isActive: true,
      ),
      Currency(
        code: 'EUR',
        name: 'Euro',
        symbol: '€',
        decimalPlaces: 2,
        flag: '🇪🇺',
        isActive: true,
      ),
    ];

    final tExchangeRates = [
      ExchangeRate(
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        rate: 0.92,
        lastUpdated: DateTime(2025, 12, 19),
      ),
      ExchangeRate(
        fromCurrency: 'USD',
        toCurrency: 'GBP',
        rate: 0.79,
        lastUpdated: DateTime(2025, 12, 19),
      ),
    ];

    test('initial state should be CurrencyInitial', () {
      expect(bloc.state, const CurrencyInitial());
    });

    group('LoadCurrencies', () {
      blocTest<CurrencyBloc, CurrencyState>(
        'should emit [CurrencyLoading, CurrenciesLoaded] when successful',
        build: () {
          when(mockGetCurrencies())
              .thenAnswer((_) async => const Right(tCurrencies));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadCurrencies()),
        expect: () => [
          const CurrencyLoading(),
          const CurrenciesLoaded(currencies: tCurrencies),
        ],
        verify: (_) {
          verify(mockGetCurrencies()).called(1);
        },
      );

      blocTest<CurrencyBloc, CurrencyState>(
        'should emit [CurrencyLoading, CurrencyError] when fails',
        build: () {
          when(mockGetCurrencies())
              .thenAnswer((_) async => Left(ServerFailure('Server error')));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadCurrencies()),
        expect: () => [
          const CurrencyLoading(),
          const CurrencyError(message: 'Server error'),
        ],
        verify: (_) {
          verify(mockGetCurrencies()).called(1);
        },
      );

      blocTest<CurrencyBloc, CurrencyState>(
        'should emit [CurrencyLoading, CurrencyError] when cache fails',
        build: () {
          when(mockGetCurrencies())
              .thenAnswer((_) async => Left(CacheFailure('Cache error')));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadCurrencies()),
        expect: () => [
          const CurrencyLoading(),
          const CurrencyError(message: 'Cache error'),
        ],
        verify: (_) {
          verify(mockGetCurrencies()).called(1);
        },
      );
    });

    group('LoadExchangeRates', () {
      blocTest<CurrencyBloc, CurrencyState>(
        'should emit [CurrencyLoading, ExchangeRatesLoaded] when successful',
        build: () {
          when(mockGetExchangeRates(any))
              .thenAnswer((_) async => Right(tExchangeRates));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadExchangeRates(baseCurrency: 'USD')),
        expect: () => [
          const CurrencyLoading(),
          ExchangeRatesLoaded(exchangeRates: tExchangeRates),
        ],
        verify: (_) {
          verify(mockGetExchangeRates(
            const GetExchangeRatesParams(baseCurrency: 'USD'),
          )).called(1);
        },
      );

      blocTest<CurrencyBloc, CurrencyState>(
        'should emit [CurrencyLoading, ExchangeRatesLoaded] with null base currency',
        build: () {
          when(mockGetExchangeRates(any))
              .thenAnswer((_) async => Right(tExchangeRates));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadExchangeRates()),
        expect: () => [
          const CurrencyLoading(),
          ExchangeRatesLoaded(exchangeRates: tExchangeRates),
        ],
        verify: (_) {
          verify(mockGetExchangeRates(
            const GetExchangeRatesParams(baseCurrency: null),
          )).called(1);
        },
      );

      blocTest<CurrencyBloc, CurrencyState>(
        'should emit [CurrencyLoading, CurrencyError] when fails',
        build: () {
          when(mockGetExchangeRates(any))
              .thenAnswer((_) async => Left(ServerFailure('Failed to load rates')));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadExchangeRates(baseCurrency: 'USD')),
        expect: () => [
          const CurrencyLoading(),
          const CurrencyError(message: 'Failed to load rates'),
        ],
        verify: (_) {
          verify(mockGetExchangeRates(
            const GetExchangeRatesParams(baseCurrency: 'USD'),
          )).called(1);
        },
      );
    });

    group('ConvertCurrencyRequested', () {
      const tAmount = 100.0;
      const tFromCurrency = 'USD';
      const tToCurrency = 'EUR';
      const tConvertedAmount = 92.0;

      blocTest<CurrencyBloc, CurrencyState>(
        'should emit [CurrencyLoading, CurrencyConverted] when successful',
        build: () {
          when(mockConvertCurrency(any))
              .thenAnswer((_) async => const Right(tConvertedAmount));
          return bloc;
        },
        act: (bloc) => bloc.add(const ConvertCurrencyRequested(
          amount: tAmount,
          fromCurrency: tFromCurrency,
          toCurrency: tToCurrency,
        )),
        expect: () => [
          const CurrencyLoading(),
          const CurrencyConverted(
            originalAmount: tAmount,
            fromCurrency: tFromCurrency,
            toCurrency: tToCurrency,
            convertedAmount: tConvertedAmount,
          ),
        ],
        verify: (_) {
          verify(mockConvertCurrency(
            const ConvertCurrencyParams(
              amount: tAmount,
              fromCurrency: tFromCurrency,
              toCurrency: tToCurrency,
            ),
          )).called(1);
        },
      );

      blocTest<CurrencyBloc, CurrencyState>(
        'should emit [CurrencyLoading, CurrencyError] when conversion fails',
        build: () {
          when(mockConvertCurrency(any))
              .thenAnswer((_) async => Left(ServerFailure('Conversion failed')));
          return bloc;
        },
        act: (bloc) => bloc.add(const ConvertCurrencyRequested(
          amount: tAmount,
          fromCurrency: tFromCurrency,
          toCurrency: tToCurrency,
        )),
        expect: () => [
          const CurrencyLoading(),
          const CurrencyError(message: 'Conversion failed'),
        ],
        verify: (_) {
          verify(mockConvertCurrency(
            const ConvertCurrencyParams(
              amount: tAmount,
              fromCurrency: tFromCurrency,
              toCurrency: tToCurrency,
            ),
          )).called(1);
        },
      );

      blocTest<CurrencyBloc, CurrencyState>(
        'should emit [CurrencyLoading, CurrencyError] when amount is negative',
        build: () {
          when(mockConvertCurrency(any))
              .thenAnswer((_) async => Left(ValidationFailure('Amount cannot be negative')));
          return bloc;
        },
        act: (bloc) => bloc.add(const ConvertCurrencyRequested(
          amount: -10.0,
          fromCurrency: tFromCurrency,
          toCurrency: tToCurrency,
        )),
        expect: () => [
          const CurrencyLoading(),
          const CurrencyError(message: 'Amount cannot be negative'),
        ],
      );
    });

    group('LoadBaseCurrency', () {
      const tUserId = 'user_1';
      const tCurrencyCode = 'USD';

      blocTest<CurrencyBloc, CurrencyState>(
        'should emit [CurrencyLoading, BaseCurrencyLoaded] when successful',
        build: () {
          when(mockGetBaseCurrency(any))
              .thenAnswer((_) async => const Right(tCurrencyCode));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadBaseCurrency(userId: tUserId)),
        expect: () => [
          const CurrencyLoading(),
          const BaseCurrencyLoaded(currencyCode: tCurrencyCode),
        ],
        verify: (_) {
          verify(mockGetBaseCurrency(
            const GetBaseCurrencyParams(userId: tUserId),
          )).called(1);
        },
      );

      blocTest<CurrencyBloc, CurrencyState>(
        'should emit [CurrencyLoading, CurrencyError] when fails',
        build: () {
          when(mockGetBaseCurrency(any))
              .thenAnswer((_) async => Left(ServerFailure('Failed to load base currency')));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadBaseCurrency(userId: tUserId)),
        expect: () => [
          const CurrencyLoading(),
          const CurrencyError(message: 'Failed to load base currency'),
        ],
        verify: (_) {
          verify(mockGetBaseCurrency(
            const GetBaseCurrencyParams(userId: tUserId),
          )).called(1);
        },
      );
    });

    group('UpdateBaseCurrencyRequested', () {
      const tUserId = 'user_1';
      const tCurrencyCode = 'EUR';

      blocTest<CurrencyBloc, CurrencyState>(
        'should emit [CurrencyLoading, BaseCurrencyUpdated] when successful',
        build: () {
          when(mockUpdateBaseCurrency(any))
              .thenAnswer((_) async => const Right(null));
          return bloc;
        },
        act: (bloc) => bloc.add(const UpdateBaseCurrencyRequested(
          userId: tUserId,
          currencyCode: tCurrencyCode,
        )),
        expect: () => [
          const CurrencyLoading(),
          const BaseCurrencyUpdated(
            currencyCode: tCurrencyCode,
            message: 'Base currency updated to EUR',
          ),
        ],
        verify: (_) {
          verify(mockUpdateBaseCurrency(
            const UpdateBaseCurrencyParams(
              userId: tUserId,
              currencyCode: tCurrencyCode,
            ),
          )).called(1);
        },
      );

      blocTest<CurrencyBloc, CurrencyState>(
        'should emit [CurrencyLoading, CurrencyError] when update fails',
        build: () {
          when(mockUpdateBaseCurrency(any))
              .thenAnswer((_) async => Left(ServerFailure('Update failed')));
          return bloc;
        },
        act: (bloc) => bloc.add(const UpdateBaseCurrencyRequested(
          userId: tUserId,
          currencyCode: tCurrencyCode,
        )),
        expect: () => [
          const CurrencyLoading(),
          const CurrencyError(message: 'Update failed'),
        ],
        verify: (_) {
          verify(mockUpdateBaseCurrency(
            const UpdateBaseCurrencyParams(
              userId: tUserId,
              currencyCode: tCurrencyCode,
            ),
          )).called(1);
        },
      );

      blocTest<CurrencyBloc, CurrencyState>(
        'should emit [CurrencyLoading, CurrencyError] when validation fails',
        build: () {
          when(mockUpdateBaseCurrency(any))
              .thenAnswer((_) async => Left(ValidationFailure('Invalid currency code')));
          return bloc;
        },
        act: (bloc) => bloc.add(const UpdateBaseCurrencyRequested(
          userId: tUserId,
          currencyCode: '',
        )),
        expect: () => [
          const CurrencyLoading(),
          const CurrencyError(message: 'Invalid currency code'),
        ],
      );
    });
  });
}
