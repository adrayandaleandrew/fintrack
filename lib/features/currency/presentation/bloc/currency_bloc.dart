import 'package:bloc/bloc.dart';
import 'package:finance_tracker/features/currency/domain/usecases/convert_currency.dart';
import 'package:finance_tracker/features/currency/domain/usecases/get_base_currency.dart';
import 'package:finance_tracker/features/currency/domain/usecases/get_currencies.dart';
import 'package:finance_tracker/features/currency/domain/usecases/get_exchange_rates.dart';
import 'package:finance_tracker/features/currency/domain/usecases/update_base_currency.dart';
import 'package:finance_tracker/features/currency/presentation/bloc/currency_event.dart';
import 'package:finance_tracker/features/currency/presentation/bloc/currency_state.dart';

/// BLoC for currency operations
///
/// Handles loading currencies, exchange rates, conversions, and base currency management.
class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final GetCurrencies getCurrencies;
  final GetExchangeRates getExchangeRates;
  final ConvertCurrency convertCurrency;
  final GetBaseCurrency getBaseCurrency;
  final UpdateBaseCurrency updateBaseCurrency;

  CurrencyBloc({
    required this.getCurrencies,
    required this.getExchangeRates,
    required this.convertCurrency,
    required this.getBaseCurrency,
    required this.updateBaseCurrency,
  }) : super(const CurrencyInitial()) {
    on<LoadCurrencies>(_onLoadCurrencies);
    on<LoadExchangeRates>(_onLoadExchangeRates);
    on<ConvertCurrencyRequested>(_onConvertCurrency);
    on<LoadBaseCurrency>(_onLoadBaseCurrency);
    on<UpdateBaseCurrencyRequested>(_onUpdateBaseCurrency);
  }

  Future<void> _onLoadCurrencies(
    LoadCurrencies event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(const CurrencyLoading());

    final result = await getCurrencies();

    result.fold(
      (failure) => emit(CurrencyError(message: failure.message)),
      (currencies) => emit(CurrenciesLoaded(currencies: currencies)),
    );
  }

  Future<void> _onLoadExchangeRates(
    LoadExchangeRates event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(const CurrencyLoading());

    final result = await getExchangeRates(
      GetExchangeRatesParams(baseCurrency: event.baseCurrency),
    );

    result.fold(
      (failure) => emit(CurrencyError(message: failure.message)),
      (rates) => emit(ExchangeRatesLoaded(exchangeRates: rates)),
    );
  }

  Future<void> _onConvertCurrency(
    ConvertCurrencyRequested event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(const CurrencyLoading());

    final result = await convertCurrency(
      ConvertCurrencyParams(
        amount: event.amount,
        fromCurrency: event.fromCurrency,
        toCurrency: event.toCurrency,
      ),
    );

    result.fold(
      (failure) => emit(CurrencyError(message: failure.message)),
      (convertedAmount) => emit(
        CurrencyConverted(
          originalAmount: event.amount,
          fromCurrency: event.fromCurrency,
          toCurrency: event.toCurrency,
          convertedAmount: convertedAmount,
        ),
      ),
    );
  }

  Future<void> _onLoadBaseCurrency(
    LoadBaseCurrency event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(const CurrencyLoading());

    final result = await getBaseCurrency(
      GetBaseCurrencyParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(CurrencyError(message: failure.message)),
      (currencyCode) => emit(BaseCurrencyLoaded(currencyCode: currencyCode)),
    );
  }

  Future<void> _onUpdateBaseCurrency(
    UpdateBaseCurrencyRequested event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(const CurrencyLoading());

    final result = await updateBaseCurrency(
      UpdateBaseCurrencyParams(
        userId: event.userId,
        currencyCode: event.currencyCode,
      ),
    );

    result.fold(
      (failure) => emit(CurrencyError(message: failure.message)),
      (_) => emit(
        BaseCurrencyUpdated(
          currencyCode: event.currencyCode,
          message: 'Base currency updated to ${event.currencyCode}',
        ),
      ),
    );
  }
}
