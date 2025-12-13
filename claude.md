# Project Context for Claude

## Project Overview

**Project Name:** Finance Tracker
**Primary Language:** Dart
**Framework:** Flutter 3.x (Cross-platform mobile framework)
**Type:** Mobile Application (Android, iOS, Web)

### Purpose

Finance Tracker is a comprehensive personal finance management application that helps users track income and expenses, manage multiple accounts, create budgets with alerts, analyze spending patterns through visual reports, and handle multi-currency transactions. The app provides insights into financial health through analytics and charts, enabling better financial decision-making.

### Key Features

- **Transaction Management:** Record income, expenses, and transfers with categorization
- **Multi-Account Support:** Manage bank accounts, cash, credit cards, and investments
- **Budget Tracking:** Set budgets with customizable periods and receive alerts when approaching limits
- **Reports & Analytics:** Visualize spending patterns with pie charts, line graphs, and bar charts
- **Recurring Transactions:** Automate regular income and expense entries
- **Multi-Currency:** Support for 20+ currencies with conversion capabilities
- **Dashboard:** Real-time financial overview with summary cards and recent activity
- **Dark Mode:** Full light/dark theme support with system detection

## Project Structure

```
finance_tracker/
├── lib/
│   ├── main.dart                          # App entry point with DI setup
│   ├── app/
│   │   ├── app.dart                       # Main app widget
│   │   ├── router/
│   │   │   ├── app_router.dart           # Route definitions (go_router)
│   │   │   └── route_guards.dart         # Auth guards
│   │   └── theme/
│   │       ├── app_theme.dart            # Theme configuration
│   │       ├── colors.dart               # Color palette
│   │       └── text_styles.dart          # Typography
│   ├── core/
│   │   ├── di/
│   │   │   └── injection_container.dart  # GetIt DI configuration
│   │   ├── constants/
│   │   │   ├── app_constants.dart        # Global constants
│   │   │   └── api_endpoints.dart        # API paths (mock/real)
│   │   ├── errors/
│   │   │   ├── exceptions.dart           # Custom exceptions
│   │   │   └── failures.dart             # Failure classes
│   │   ├── utils/
│   │   │   ├── date_utils.dart           # Date helpers
│   │   │   ├── currency_formatter.dart   # Money formatting
│   │   │   ├── validators.dart           # Input validation
│   │   │   └── extensions.dart           # Dart extensions
│   │   ├── network/
│   │   │   ├── network_info.dart         # Connectivity check
│   │   │   └── api_client.dart           # HTTP client wrapper
│   │   └── storage/
│   │       ├── local_storage.dart        # SharedPreferences wrapper
│   │       └── secure_storage.dart       # Secure storage wrapper
│   ├── features/                          # Feature-based organization
│   │   ├── auth/                         # Authentication
│   │   ├── accounts/                     # Account management
│   │   ├── transactions/                 # Transaction CRUD
│   │   ├── categories/                   # Category management
│   │   ├── budgets/                      # Budget tracking
│   │   ├── recurring_transactions/       # Recurring transactions
│   │   ├── reports/                      # Analytics & reports
│   │   ├── currency/                     # Multi-currency
│   │   └── dashboard/                    # Dashboard overview
│   └── shared/
│       └── widgets/                      # Reusable UI components
├── test/                                  # All test files
│   ├── unit/                             # Unit tests
│   ├── widget/                           # Widget tests
│   └── integration/                      # Integration tests
├── android/                               # Android platform code
├── ios/                                   # iOS platform code
├── web/                                   # Web platform code
├── pubspec.yaml                           # Dependencies
├── analysis_options.yaml                  # Dart analyzer config
├── bestpractices.md                       # Engineering best practices
├── antipatterns.md                        # Common mistakes to avoid
└── USAGE_GUIDE.md                         # How to use this documentation

Each feature follows Clean Architecture with 3 layers:
├── data/
│   ├── datasources/     # Remote/Local data sources (Mock initially)
│   ├── models/          # JSON serializable models
│   └── repositories/    # Repository implementations
├── domain/
│   ├── entities/        # Pure Dart business objects
│   ├── repositories/    # Repository interfaces
│   └── usecases/        # Single-responsibility operations
└── presentation/
    ├── bloc/            # BLoC (events, states, bloc)
    ├── pages/           # Full-screen pages
    └── widgets/         # Feature-specific widgets
```

## Development Environment

### Prerequisites

- **Flutter SDK:** 3.10.4 or higher (stable channel)
- **Dart SDK:** 3.10.4 or higher
- **Android Studio** or **VS Code** with Flutter/Dart extensions
- **Android SDK:** For Android development
- **Xcode:** For iOS development (macOS only)
- **Git:** For version control

### Setup Instructions

```bash
# Clone the repository
git clone <repository-url>
cd finance_tracker

# Install Flutter dependencies
flutter pub get

# Run code generation for models and DI
flutter pub run build_runner build --delete-conflicting-outputs

# Check Flutter setup
flutter doctor

# Enable web (optional)
flutter config --enable-web
```

### Running the Project

```bash
# Development (hot reload enabled)
flutter run

# Run on specific device
flutter run -d chrome              # Web
flutter run -d "iPhone 14"         # iOS Simulator
flutter run -d emulator-5554       # Android Emulator

# Production build
flutter build apk --release        # Android APK
flutter build ios --release        # iOS
flutter build web --release        # Web

# Tests
flutter test                       # All tests
flutter test --coverage            # With coverage report
flutter test test/unit/            # Specific folder

# Code generation (after model changes)
flutter pub run build_runner build --delete-conflicting-outputs

# Code generation (watch mode)
flutter pub run build_runner watch
```

## Code Standards & Conventions

### Naming Conventions

- **Files:** `snake_case.dart` (e.g., `transaction_repository.dart`)
- **Classes:** `PascalCase` (e.g., `TransactionBloc`, `AccountModel`)
- **Functions/Methods:** `camelCase` (e.g., `getTransactions()`, `calculateBalance()`)
- **Variables:** `camelCase` (e.g., `totalAmount`, `isActive`)
- **Constants:** `lowerCamelCase` for private, `UPPER_SNAKE_CASE` for public (e.g., `const maxRetries = 3`, `const API_TIMEOUT = 30`)
- **Private members:** Prefix with underscore `_privateMethod()`

### Code Style

- **Line Length:** 80 characters (Flutter standard)
- **Indentation:** 2 spaces (Dart convention)
- **Quotes:** Single quotes for strings (e.g., `'Hello World'`)
- **Linter/Formatter:**
  - `flutter_lints` package for standard Flutter rules
  - `very_good_analysis` for stricter linting
  - Use `dart format .` before committing

### Language-Specific Guidelines

- **Always use `const` constructors** where possible for performance
- **Prefer `final` over `var`** for immutability
- **Use null-safety features:** Avoid `!` operator, use `?.` and `??`
- **Use named parameters** for functions with more than 2 parameters
- **Prefer composition over inheritance**
- **Use `async`/`await`** for asynchronous operations (no callbacks)
- **Use `Equatable`** for value equality in entities and states
- **Use extension methods** to add functionality to existing classes
- **Avoid deeply nested code:** Use early returns and extract methods

Example:
```dart
// Good
class User extends Equatable {
  final String id;
  final String email;

  const User({required this.id, required this.email});

  @override
  List<Object?> get props => [id, email];
}

// Avoid
class User {
  String? id;
  String? email;
}
```

## Architecture & Design Patterns

### Architecture Style

**Clean Architecture with BLoC State Management**

The application follows Clean Architecture with clear separation of concerns:

```
Presentation Layer (UI + BLoC)
    ↓ (depends on)
Domain Layer (Entities + Use Cases + Repository Interfaces)
    ↑ (implemented by)
Data Layer (Models + Repository Implementations + Data Sources)
```

**Key Principles:**
- **Dependency Rule:** Dependencies point inward. Domain layer has NO dependencies on outer layers.
- **Single Responsibility:** Each class/function has one reason to change
- **Testability:** Each layer can be tested independently
- **Flexibility:** Easy to swap implementations (mock → real API)

### Key Design Patterns Used

- **Repository Pattern:** Abstracts data sources (mock/real API) from business logic
  - Domain defines interfaces, Data implements them
  - Use case calls repository interface, not concrete implementation

- **BLoC Pattern (Business Logic Component):** Separates business logic from UI
  - Events: User actions (LoadTransactions, CreateTransaction)
  - States: UI states (Loading, Loaded, Error)
  - BLoC: Transforms events into states using use cases

- **Use Case Pattern:** Single-responsibility business operations
  - Each use case does one thing (GetAccounts, CreateBudget)
  - Encapsulates business rules
  - Returns `Either<Failure, Success>` for error handling

- **Dependency Injection:** Uses GetIt service locator
  - All dependencies registered in `injection_container.dart`
  - Testable (easy to inject mocks)

- **Factory Pattern:** For creating models from JSON
  - `fromJson()` factory constructors
  - Generated with `json_serializable`

### Data Flow

```
User Interaction (UI)
    ↓
Event dispatched to BLoC
    ↓
BLoC calls Use Case
    ↓
Use Case calls Repository (interface)
    ↓
Repository Implementation calls Data Source (Mock/Real API)
    ↓
Data flows back up the chain
    ↓
BLoC emits new State
    ↓
UI rebuilds based on new State
```

**Example Flow - Adding a Transaction:**
1. User taps "Save" on Add Transaction screen
2. `CreateTransactionEvent` dispatched to `TransactionBloc`
3. BLoC calls `CreateTransaction` use case
4. Use case validates transaction, calls `TransactionRepository.createTransaction()`
5. Repository calls `TransactionRemoteDataSource.createTransaction()` (mock API)
6. Mock API simulates network delay, stores transaction in memory
7. Transaction returned up through repository → use case → BLoC
8. BLoC emits `TransactionCreatedState`
9. UI shows success message and navigates back
10. Account balance updates via separate use case

## Dependencies & Libraries

### Core Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_bloc` | ^8.1.3 | BLoC state management |
| `bloc` | ^8.1.2 | Core BLoC library |
| `equatable` | ^2.0.5 | Value equality for entities/states |
| `get_it` | ^7.6.4 | Dependency injection (service locator) |
| `injectable` | ^2.3.2 | Code generation for DI setup |
| `dartz` | ^0.10.1 | Functional programming (Either type) |
| `json_annotation` | ^4.8.1 | JSON serialization annotations |
| `dio` | ^5.3.3 | HTTP client for API calls |
| `connectivity_plus` | ^5.0.1 | Network connectivity detection |
| `shared_preferences` | ^2.2.2 | Simple key-value storage |
| `hive` | ^2.2.3 | Fast local NoSQL database |
| `hive_flutter` | ^1.1.0 | Hive integration for Flutter |
| `flutter_secure_storage` | ^9.0.0 | Encrypted storage for tokens |
| `go_router` | ^12.1.1 | Declarative routing with deep linking |
| `fl_chart` | ^0.65.0 | Beautiful charts for analytics |
| `intl` | ^0.18.1 | Internationalization and formatting |
| `timeago` | ^3.6.0 | Relative time formatting |
| `uuid` | ^4.2.1 | Generate unique IDs |
| `flutter_svg` | ^2.0.9 | SVG support for icons |
| `cached_network_image` | ^3.3.0 | Image caching |
| `shimmer` | ^3.0.0 | Loading skeleton screens |
| `flutter_slidable` | ^3.0.1 | Swipe actions on list items |
| `formz` | ^0.6.1 | Form validation |
| `font_awesome_flutter` | ^10.6.0 | Icon library |

### Development Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_lints` | ^3.0.1 | Official Flutter linting rules |
| `very_good_analysis` | ^5.1.0 | Stricter linting |
| `build_runner` | ^2.4.6 | Code generation runner |
| `json_serializable` | ^6.7.1 | Generate JSON serialization |
| `injectable_generator` | ^2.4.1 | Generate DI code |
| `hive_generator` | ^2.0.1 | Generate Hive adapters |
| `mockito` | ^5.4.3 | Mocking for unit tests |
| `bloc_test` | ^9.1.5 | BLoC-specific testing utilities |
| `faker` | ^2.1.0 | Generate fake test data |

## Testing Strategy

### Testing Framework

- **Flutter Test:** Built-in testing framework
- **Bloc Test:** BLoC-specific testing utilities
- **Mockito:** Mocking dependencies in unit tests
- **Integration Test:** End-to-end testing

### Test Coverage Requirements

- **Overall:** Minimum 80% coverage (enforced in CI/CD)
- **Use Cases:** 100% coverage (business logic is critical)
- **Repositories:** 90%+ coverage
- **BLoCs:** 85%+ coverage
- **Utilities:** 95%+ coverage
- **Widgets:** 70%+ coverage
- **Critical Paths:** 95%+ coverage (auth, transactions, budgets)

### Testing Guidelines

- **Test file naming:** `<filename>_test.dart` (e.g., `transaction_bloc_test.dart`)
- **Test organization:** Mirror source structure in `test/` directory
- **Mocking strategy:**
  - Mock all external dependencies (repositories, data sources)
  - Use `Mockito` to generate mocks with `@GenerateMocks` annotation
  - Never mock entities or value objects
  - Mock only at architectural boundaries

**Test Pyramid:**
```
     /\        5-10% Integration Tests (E2E flows)
    /  \
   /────\      20-25% Widget Tests (UI components)
  /      \
 /────────\    70% Unit Tests (Use cases, BLoCs, Utils)
```

### Running Tests

```bash
# All tests
flutter test

# Specific test file
flutter test test/features/transactions/domain/usecases/create_transaction_test.dart

# With coverage
flutter test --coverage

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html  # View in browser

# Watch mode (re-run on changes)
flutter test --watch

# Integration tests
flutter test integration_test/

# Generate mocks
flutter pub run build_runner build
```

## Database & Data

### Database Type

**Local Storage:** Hive (NoSQL, key-value database)
- Fast, lightweight
- No native dependencies
- Type-safe with generated adapters
- Supports encryption

**Remote Storage:** Mock APIs initially, designed for REST API integration

### Schema Overview

**Primary Entities:**
- **User:** Authentication and profile data
- **Account:** Bank accounts, cash, credit cards (id, name, type, balance, currency)
- **Transaction:** Income/expense/transfer records (id, amount, type, category, date, description)
- **Category:** Transaction categories (id, name, type, icon, color)
- **Budget:** Budget tracking (id, categoryId, amount, period, alertThreshold)
- **RecurringTransaction:** Automated transactions (id, frequency, startDate, lastProcessed)
- **Currency:** Currency data with exchange rates (code, symbol, rate)

### Migration Strategy

- **Code Generation:** Use `hive_generator` to create type adapters
- **Versioning:** Track schema version in Hive box
- **Migration Scripts:** Write migration functions for schema changes
- **Backward Compatibility:** Maintain compatibility for at least one version back

### Data Models

All entities follow this pattern:
1. **Entity** (domain layer): Pure Dart class with business logic
2. **Model** (data layer): Extends entity, adds JSON serialization

```dart
// Domain Entity
class Transaction extends Equatable {
  final String id;
  final double amount;
  final TransactionType type;
  // ... business logic
}

// Data Model
@JsonSerializable()
@HiveType(typeId: 1)
class TransactionModel extends Transaction {
  // fromJson, toJson factories
  // Hive adapter fields
}
```

## API & Integrations

### API Style

**Mock REST API** (initial development)
- RESTful principles
- JSON payloads
- Standard HTTP methods (GET, POST, PUT, DELETE)

**Future Real API:** RESTful backend

### Authentication

- **Mock:** In-memory user storage with JWT-style token simulation
- **Future:** JWT tokens with refresh token mechanism
- **Storage:** `flutter_secure_storage` for tokens

### Key Endpoints

**Mock API Endpoints:**
```
POST   /api/v1/auth/login
POST   /api/v1/auth/register
GET    /api/v1/accounts
POST   /api/v1/accounts
PUT    /api/v1/accounts/:id
DELETE /api/v1/accounts/:id
GET    /api/v1/transactions
POST   /api/v1/transactions
PUT    /api/v1/transactions/:id
DELETE /api/v1/transactions/:id
GET    /api/v1/categories
POST   /api/v1/budgets
GET    /api/v1/budgets
GET    /api/v1/reports/expense-by-category
GET    /api/v1/reports/income-vs-expense
```

### External Services

- **None currently** (fully offline-capable with mock APIs)
- **Future Possibilities:**
  - Bank API integration (Plaid, Open Banking)
  - Cloud backup (Firebase, AWS S3)
  - Exchange rate API (for real-time currency conversion)
  - Push notifications (Firebase Cloud Messaging)

## Error Handling & Logging

### Error Handling Strategy

**Failure-Based Error Handling:**
- Use `Either<Failure, Success>` pattern from `dartz` package
- All repository methods return `Either<Failure, T>`
- BLoC catches failures and emits error states with user-friendly messages

**Failure Hierarchy:**
```dart
abstract class Failure {
  final String message;
}

class ServerFailure extends Failure {}
class CacheFailure extends Failure {}
class NetworkFailure extends Failure {}
class ValidationFailure extends Failure {}
```

**Exception → Failure Mapping:**
- Data layer throws exceptions
- Repository catches exceptions, converts to failures
- BLoC receives failures, converts to user messages

### Logging

- **Logger:** `logger` package (colorized console output)
- **Log Levels:**
  - DEBUG: Development details
  - INFO: General information
  - WARNING: Unexpected but handled situations
  - ERROR: Error conditions
  - CRITICAL: Severe errors (rare)

- **Log Format:** Structured logging with context
  ```dart
  logger.info('Transaction created',
    extra: {'transactionId': id, 'amount': amount});
  ```

### Monitoring

- **Development:** Console logging with `logger` package
- **Production:** Error tracking (future: Sentry, Firebase Crashlytics)
- **Performance:** Flutter DevTools for profiling

## Security Considerations

### Authentication & Authorization

- **Mock Implementation:** Simulated JWT tokens stored in secure storage
- **Session Management:** Auto-logout on token expiration
- **Future:** Real JWT with refresh tokens, role-based access control

### Input Validation

- **Client-Side:** All user inputs validated before submission
  - Amount must be > 0
  - Required fields checked
  - Date ranges validated
  - Email format validation

- **Use `formz` package** for form validation
- **Never trust client validation** (validate on server when real API added)

### Secrets Management

- **Development:** No real secrets (mock APIs)
- **Production:**
  - Use `flutter_secure_storage` for tokens
  - Environment variables for API keys
  - Never commit secrets to git
  - Use `.env` files (in `.gitignore`)

### Security Best Practices

- **No hardcoded credentials** anywhere in code
- **Encrypt sensitive data** at rest (use secure storage)
- **HTTPS only** when real API is added
- **Input sanitization** to prevent injection attacks
- **Rate limiting** on API calls (future)
- **Secure password hashing** (bcrypt) on backend (future)

## Performance Considerations

### Optimization Priorities

1. **Smooth UI:** 60fps scrolling and animations
2. **Fast Startup:** < 2 seconds to dashboard
3. **Responsive Lists:** Handle 1000+ transactions without lag
4. **Efficient Memory:** No memory leaks from BLoCs or streams
5. **Small Bundle Size:** < 15MB app size

### Known Bottlenecks

- **Large Transaction Lists:** Potential performance issue with 1000+ items
  - **Solution:** Implement pagination and lazy loading

- **Chart Rendering:** Complex charts can slow down on older devices
  - **Solution:** Optimize chart data, use `RepaintBoundary`

- **Widget Rebuilds:** Unnecessary rebuilds can cause jank
  - **Solution:** Use `const` constructors, keys, and `Equatable`

### Caching Strategy

- **Local Caching:** Hive database for offline-first approach
  - Cache all user data locally
  - Sync with server when online (future)

- **Image Caching:** `cached_network_image` for profile pictures and receipts

- **API Response Caching:** Cache GET responses for 5 minutes
  - Reduce unnecessary API calls
  - Improve perceived performance

## Common Tasks & Workflows

### Adding a New Feature

1. **Create Feature Structure** in `lib/features/<feature_name>/`
   ```
   <feature>/
   ├── data/
   ├── domain/
   └── presentation/
   ```

2. **Domain Layer First** (entities, repository interface, use cases)
   - Define entity in `domain/entities/`
   - Create repository interface in `domain/repositories/`
   - Write use cases in `domain/usecases/`
   - Write unit tests for use cases

3. **Data Layer** (models, repository impl, data sources)
   - Create model extending entity in `data/models/`
   - Implement repository in `data/repositories/`
   - Create mock data source in `data/datasources/`
   - Write repository tests

4. **Presentation Layer** (BLoC, pages, widgets)
   - Create BLoC with events and states in `presentation/bloc/`
   - Build UI pages in `presentation/pages/`
   - Create reusable widgets in `presentation/widgets/`
   - Write BLoC tests and widget tests

5. **Dependency Injection** - Register in `injection_container.dart`

6. **Run Code Generation** - `flutter pub run build_runner build`

7. **Test Everything** - Ensure 80%+ coverage

### Debugging Guide

**Common Tools:**
- **Flutter DevTools:** Performance profiling, widget inspector, network inspector
- **VS Code Debugger:** Breakpoints, step-through debugging
- **Print Debugging:** Use `debugPrint()` or `logger` package
- **BLoC Observer:** Log all BLoC events and states

**Debugging BLoC Issues:**
```dart
class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('Event: $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('Transition: $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('Error: $error');
    super.onError(bloc, error, stackTrace);
  }
}
```

### Common Issues & Solutions

**Issue:** "The getter 'props' isn't defined for the class"
**Solution:** Ensure entity/state extends `Equatable` and implements `props` getter

**Issue:** BLoC not updating UI
**Solution:** Check that states are immutable and create new instances (don't mutate)

**Issue:** "Bad state: Cannot emit new states after calling close"
**Solution:** Don't emit states after BLoC is closed, check `isClosed` before emitting

**Issue:** Code generation not working
**Solution:** Run `flutter pub run build_runner build --delete-conflicting-outputs`

**Issue:** Dependency injection errors
**Solution:** Ensure all dependencies are registered in `injection_container.dart` and call `await setupLocator()` in main

## Documentation

### Code Documentation

- **Public APIs:** Always include dartdoc comments
  ```dart
  /// Creates a new transaction and updates the account balance.
  ///
  /// Returns [Right(Transaction)] on success or [Left(Failure)] on error.
  /// Throws [ValidationException] if amount is <= 0.
  Future<Either<Failure, Transaction>> createTransaction(Transaction transaction);
  ```

- **Complex Logic:** Add inline comments explaining "why" not "what"
- **TODOs:** Use `// TODO(name): description` for future work
- **Avoid obvious comments:** Code should be self-documenting with good naming

### API Documentation

- **Mock API:** Documented in `lib/core/constants/api_endpoints.dart`
- **Real API:** Will be documented with OpenAPI/Swagger (future)

### Architecture Documentation

- **This File:** Primary architecture documentation
- **Plan File:** `~/.claude/plans/jolly-riding-badger.md` - Comprehensive implementation plan
- **Best Practices:** `bestpractices.md` - Engineering guidelines
- **Anti-Patterns:** `antipatterns.md` - What to avoid

## Deployment

### Environments

- **Development:** Local development with mock APIs
  - Hot reload enabled
  - Debug mode
  - Verbose logging

- **Staging:** Testing environment (future)
  - Production-like but separate backend
  - Test data

- **Production:** End-user environment (future)
  - Release builds only
  - Real backend APIs
  - Error tracking enabled

### Deployment Process

**Android:**
```bash
flutter build apk --release
# APK located at: build/app/outputs/flutter-apk/app-release.apk

flutter build appbundle --release
# AAB located at: build/app/outputs/bundle/release/app-release.aab
```

**iOS:**
```bash
flutter build ios --release
# Open Xcode to archive and submit to App Store
```

**Web:**
```bash
flutter build web --release
# Deploy build/web/ directory to hosting (Firebase, Netlify, etc.)
```

### Configuration Management

- **Environment Variables:** Use `.env` files (not committed)
- **Build Flavors:** Configure different app variants (future)
  ```bash
  flutter run --flavor dev
  flutter run --flavor prod
  ```

## Version Control

### Branching Strategy

**Git Flow:**
- `main` - Production-ready code
- `develop` - Integration branch for features
- `feature/<name>` - Individual features
- `bugfix/<name>` - Bug fixes
- `hotfix/<name>` - Production hotfixes

### Commit Message Format

**Conventional Commits:**
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Formatting (no code change)
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance tasks
- `perf`: Performance improvement

**Examples:**
```
feat(transactions): add multi-currency transaction support

Implemented currency selection in transaction form.
Added currency conversion logic in transaction use case.

Closes #45

fix(budgets): correct budget calculation for monthly period

Budget was calculating incorrectly for months with different days.
Now uses proper date range comparison.

Fixes #78
```

### Pull Request Guidelines

- **Small PRs:** < 400 lines changed (easier to review)
- **One feature per PR:** Single logical change
- **Tests included:** All PRs must include tests
- **Documentation updated:** Update relevant docs
- **Self-review first:** Review your own code before requesting review
- **Link issues:** Reference related issue numbers
- **CI passing:** All tests must pass

## When Working with Claude

### ⚠️ CRITICAL: Always Reference Best Practices

**BEFORE writing any code, Claude MUST:**
1. **Review bestpractices.md** for relevant patterns and principles
2. **Check antipatterns.md** to avoid common mistakes
3. **Apply project-specific conventions** from this claude.md file

**These documents are mandatory references - not optional suggestions.**

Every code change, no matter how small, should be evaluated against:
- ✅ Does it follow bestpractices.md principles?
- ✅ Does it avoid antipatterns.md mistakes?
- ✅ Does it match this project's conventions?

### Preferred Communication Style

- **Concise and direct** - Get to the point quickly
- **Technical accuracy** - Use proper terminology
- **Show examples** - Code examples > long explanations
- **Explain trade-offs** - When multiple approaches exist, explain pros/cons

### Code Generation Preferences

- **ALWAYS cross-reference with bestpractices.md** before writing code
- **ALWAYS check antipatterns.md** to avoid known pitfalls
- **Follow Clean Architecture** - Respect layer boundaries
- **BLoC pattern consistency** - All state management via BLoC
- **Immutability** - Use `final`, create new instances instead of mutating
- **Null-safety** - Leverage Dart's null-safety features
- **Test-first mindset** - Write tests alongside code
- **Use `const` constructors** wherever possible for performance
- **Meaningful names** - Self-documenting code over comments

### What to Always Include

- **Unit tests for use cases** (see bestpractices.md → Testing Strategy) - 100% coverage
- **BLoC tests** for all events and states
- **Widget tests** for custom UI components
- **Error handling** via Either<Failure, Success> pattern
- **Equatable** for entities and states
- **Dartdoc comments** for public APIs
- **Input validation** for all user inputs

### What to Avoid

- **God Objects** (see antipatterns.md) - Keep classes focused
- **Spaghetti Code** (see antipatterns.md) - Use early returns, extract methods
- **Magic Numbers** (see antipatterns.md) - Use named constants
- **Skipping tests** - Every feature needs tests
- **Breaking Clean Architecture** - Don't violate dependency rules
- **Mutable state** - Use immutable data structures
- **Null-unsafe code** - Use `?`, `??`, avoid `!`
- **Deep nesting** - Maximum 3-4 levels of indentation

### Review Checklist

When Claude generates code, verify:
- [ ] ✅ Reviewed bestpractices.md for relevant sections
- [ ] ✅ Checked antipatterns.md to avoid common mistakes
- [ ] Follows naming conventions (snake_case files, PascalCase classes, camelCase methods)
- [ ] Includes appropriate error handling (Either<Failure, T>)
- [ ] Has test coverage (80%+ minimum)
- [ ] Matches architectural patterns (Clean Architecture + BLoC)
- [ ] Includes dartdoc comments for public APIs
- [ ] No security vulnerabilities (input validation, no hardcoded secrets)
- [ ] Adheres to performance guidelines (const constructors, efficient widgets)
- [ ] Uses established design patterns (Repository, Use Case, BLoC)
- [ ] Avoids known anti-patterns (God Objects, Magic Numbers, Copy-Paste)
- [ ] Follows Dart/Flutter best practices
- [ ] Uses `Equatable` for entities and states
- [ ] Immutable data structures

## Project-Specific Context

### Domain Knowledge

**Personal Finance Domain:**
- **Transaction Types:** Income (money in), Expense (money out), Transfer (between accounts)
- **Account Types:** Bank (checking/savings), Cash, Credit Card, Investment
- **Budget Periods:** Daily, Weekly, Monthly, Yearly
- **Currency Handling:** Different decimal places (JPY has 0, USD has 2)
- **Recurring Patterns:** Daily, Weekly (7 days), Monthly (same day), Yearly (same month/day)

### Business Logic

**Key Business Rules:**

1. **Account Balance:**
   - Increases with income transactions
   - Decreases with expense transactions
   - Transfers: decrease from account, increase to account
   - Must update atomically (both accounts or neither)

2. **Budget Alerts:**
   - Alert threshold as percentage (e.g., 0.8 = 80%)
   - Alert when spent >= threshold * budget amount
   - Budget period determines date range for calculation

3. **Recurring Transactions:**
   - Process only if current date >= next occurrence
   - Update last processed date after generation
   - Respect end date and max occurrences

4. **Currency Conversion:**
   - Convert to base currency first, then to target
   - Formula: `amount / from_rate * to_rate`
   - Round to currency's decimal places

5. **Transaction Validation:**
   - Amount must be > 0
   - Date cannot be in future (unless recurring)
   - Account and category must exist
   - Currency must be valid

### Constraints & Limitations

**Technical Constraints:**
- **Offline-first:** App must work without internet (mock APIs in memory)
- **Mobile performance:** Smooth scrolling with 1000+ transactions
- **Cross-platform:** Must work on Android, iOS, and Web
- **Bundle size:** Keep under 15MB for app stores

**Business Constraints:**
- **Data privacy:** All data stored locally initially (no cloud sync yet)
- **Multi-currency:** Must support at least 20 major currencies
- **Accessibility:** Must be usable by screen readers

### Future Roadmap

**Phase 1-10 (12 weeks):** Comprehensive implementation plan in `~/.claude/plans/jolly-riding-badger.md`

**Future Enhancements (beyond 12 weeks):**
- Real backend API integration
- Cloud sync across devices
- Bank account integration (Plaid, Open Banking)
- Shared budgets (family/household)
- Bill reminders and notifications
- Receipt OCR scanning
- Investment tracking
- Tax report generation
- AI-powered spending insights
- Voice commands for adding transactions

## Resources & References

### Internal Documentation

- **Implementation Plan:** `~/.claude/plans/jolly-riding-badger.md` (comprehensive 12-week plan)
- **Best Practices:** `bestpractices.md` (1880 lines of engineering guidelines)
- **Anti-Patterns:** `antipatterns.md` (1388 lines of mistakes to avoid)
- **Usage Guide:** `USAGE_GUIDE.md` (how to use this documentation)

### External Resources

- **Flutter Documentation:** https://docs.flutter.dev/
- **Dart Language Tour:** https://dart.dev/guides/language/language-tour
- **BLoC Library:** https://bloclibrary.dev/
- **Clean Architecture:** https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
- **Flutter Best Practices:** https://dart.dev/guides/language/effective-dart
- **Material Design 3:** https://m3.material.io/

### Related Projects

- **Flutter Samples:** https://github.com/flutter/samples
- **BLoC Examples:** https://github.com/felangel/bloc/tree/master/examples
- **Very Good CLI:** https://verygood.ventures/blog/very-good-cli (for project templates)

## Contact & Support

### Key Contributors

- **Development Team:** Solo developer initially, expandable to 2-3 developers

### Getting Help

- **Flutter Issues:** https://github.com/flutter/flutter/issues
- **Stack Overflow:** Tag questions with `flutter`, `dart`, `flutter-bloc`
- **Flutter Community:** https://flutter.dev/community
- **BLoC Discord:** https://discord.gg/bloc

---

**Last Updated:** 2025-12-13
**Claude Version Used:** Claude Sonnet 4.5
**Implementation Status:** Phase 1 Ready to Begin
