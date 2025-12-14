import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../domain/entities/budget.dart';
import '../../domain/entities/budget_usage.dart';
import '../../domain/repositories/budget_repository.dart';
import '../datasources/budget_remote_datasource.dart';
import '../models/budget_model.dart';

/// Implementation of BudgetRepository
///
/// Handles budget operations using remote data source and
/// transaction repository for usage calculations.
class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteDataSource remoteDataSource;
  final TransactionRepository transactionRepository;

  const BudgetRepositoryImpl({
    required this.remoteDataSource,
    required this.transactionRepository,
  });

  @override
  Future<Either<Failure, List<Budget>>> getBudgets({
    required String userId,
    bool activeOnly = false,
  }) async {
    try {
      final budgets = await remoteDataSource.getBudgets(
        userId: userId,
        activeOnly: activeOnly,
      );
      return Right(budgets.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get budgets: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Budget>> getBudgetById({
    required String budgetId,
  }) async {
    try {
      final budget = await remoteDataSource.getBudgetById(budgetId: budgetId);
      return Right(budget.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get budget: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Budget>>> getBudgetsByCategory({
    required String categoryId,
  }) async {
    try {
      final budgets = await remoteDataSource.getBudgetsByCategory(
        categoryId: categoryId,
      );
      return Right(budgets.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Failed to get budgets by category: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Budget>> createBudget({
    required Budget budget,
  }) async {
    try {
      final budgetModel = BudgetModel.fromEntity(budget);
      final createdBudget = await remoteDataSource.createBudget(
        budget: budgetModel,
      );
      return Right(createdBudget.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to create budget: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Budget>> updateBudget({
    required Budget budget,
  }) async {
    try {
      final budgetModel = BudgetModel.fromEntity(budget);
      final updatedBudget = await remoteDataSource.updateBudget(
        budget: budgetModel,
      );
      return Right(updatedBudget.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update budget: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBudget({
    required String budgetId,
  }) async {
    try {
      await remoteDataSource.deleteBudget(budgetId: budgetId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to delete budget: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, BudgetUsage>> calculateBudgetUsage({
    required String budgetId,
  }) async {
    try {
      // Get the budget
      final budgetResult = await getBudgetById(budgetId: budgetId);
      if (budgetResult.isLeft()) {
        return Left((budgetResult as Left).value);
      }
      final budget = (budgetResult as Right).value as Budget;

      // Get period dates
      final periodStart = budget.getCurrentPeriodStart();
      final periodEnd = budget.getCurrentPeriodEnd();

      // Get transactions for this category in the period
      final transactionsResult = await transactionRepository.filterTransactions(
        userId: budget.userId,
        categoryId: budget.categoryId,
        startDate: periodStart,
        endDate: periodEnd,
      );

      if (transactionsResult.isLeft()) {
        return Left((transactionsResult as Left).value);
      }

      final transactions = (transactionsResult as Right).value as List<Transaction>;

      // Calculate total spent (only expense transactions)
      final spent = transactions
          .where((t) => t.type == TransactionType.expense)
          .fold<double>(0.0, (sum, t) => sum + t.amount);

      // Create budget usage
      final usage = BudgetUsage(
        budget: budget,
        spent: spent,
        periodStart: periodStart,
        periodEnd: periodEnd,
      );

      return Right(usage);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Failed to calculate budget usage: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Map<String, BudgetUsage>>> getBudgetUsages({
    required List<String> budgetIds,
  }) async {
    try {
      final Map<String, BudgetUsage> usages = {};

      for (final budgetId in budgetIds) {
        final usageResult = await calculateBudgetUsage(budgetId: budgetId);
        if (usageResult.isRight()) {
          final usage = (usageResult as Right).value as BudgetUsage;
          usages[budgetId] = usage;
        }
      }

      return Right(usages);
    } catch (e) {
      return Left(
        ServerFailure('Failed to get budget usages: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> shouldAlert({
    required String budgetId,
  }) async {
    try {
      final usageResult = await calculateBudgetUsage(budgetId: budgetId);
      if (usageResult.isLeft()) {
        return Left((usageResult as Left).value);
      }

      final usage = (usageResult as Right).value as BudgetUsage;
      return Right(usage.shouldAlert);
    } catch (e) {
      return Left(ServerFailure('Failed to check alert: ${e.toString()}'));
    }
  }
}
