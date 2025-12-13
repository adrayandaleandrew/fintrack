# Finance Tracker

A comprehensive personal finance management application built with Flutter, featuring multi-currency support, budget tracking, recurring transactions, and detailed analytics.

## 📱 Features

- **Transaction Management** - Track income, expenses, and transfers with categories
- **Multi-Account Support** - Manage bank accounts, cash, credit cards, and investments
- **Budget Tracking** - Set budgets with customizable periods and receive alerts
- **Reports & Analytics** - Visualize spending patterns with charts and graphs
- **Recurring Transactions** - Automate regular income and expense entries
- **Multi-Currency** - Support for 20+ currencies with conversion
- **Dashboard** - Real-time financial overview with summary cards
- **Dark Mode** - Full light and dark theme support

## 🏗️ Architecture

This project follows **Clean Architecture** with **BLoC** state management pattern:

```
Presentation Layer (UI + BLoC)
    ↓ (depends on)
Domain Layer (Entities + Use Cases + Repository Interfaces)
    ↑ (implemented by)
Data Layer (Models + Repository Implementations + Data Sources)
```

### Key Principles

- **Dependency Rule** - Dependencies point inward; domain layer has no external dependencies
- **Single Responsibility** - Each class/function has one reason to change
- **Testability** - Each layer can be tested independently
- **Flexibility** - Easy to swap implementations (mock → real API)

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point with DI setup
├── app/
│   ├── router/                        # Navigation configuration (go_router)
│   └── theme/                         # Theme, colors, typography
├── core/
│   ├── di/                            # Dependency injection (GetIt)
│   ├── errors/                        # Failures and exceptions
│   ├── utils/                         # Helpers, formatters, validators
│   ├── constants/                     # App-wide constants
│   ├── network/                       # API client wrapper
│   └── storage/                       # Local/secure storage wrappers
├── features/                          # Feature-based organization
│   ├── auth/                          # Authentication
│   ├── accounts/                      # Account management
│   ├── transactions/                  # Transaction CRUD
│   ├── categories/                    # Category management
│   ├── budgets/                       # Budget tracking
│   ├── recurring_transactions/        # Recurring transactions
│   ├── reports/                       # Analytics & reports
│   ├── currency/                      # Multi-currency
│   └── dashboard/                     # Dashboard overview
└── shared/
    └── widgets/                       # Reusable UI components

test/
├── unit/                              # Unit tests
├── widget/                            # Widget tests
└── integration/                       # Integration tests
```

Each feature follows Clean Architecture with 3 layers:
- **data/** - Remote/Local data sources, models, repository implementations
- **domain/** - Entities, repository interfaces, use cases
- **presentation/** - BLoC (events, states, bloc), pages, widgets

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10.4 or higher
- Dart SDK 3.10.4 or higher
- Android Studio or VS Code with Flutter/Dart extensions
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd finance_tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Check Flutter setup**
   ```bash
   flutter doctor
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

### Running on Specific Devices

```bash
flutter run -d chrome              # Web
flutter run -d "iPhone 14"         # iOS Simulator
flutter run -d emulator-5554       # Android Emulator
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Run specific test file
flutter test test/features/transactions/domain/usecases/create_transaction_test.dart

# Run integration tests
flutter test integration_test/
```

**Coverage Targets:**
- Overall: 80%+ (enforced in CI/CD)
- Use Cases: 100%
- Repositories: 90%+
- BLoCs: 85%+
- Utilities: 95%+

## 🏗️ Building

### Android
```bash
flutter build apk --release           # APK
flutter build appbundle --release     # AAB (for Play Store)
```

### iOS
```bash
flutter build ios --release
# Then open Xcode to archive and submit to App Store
```

### Web
```bash
flutter build web --release
# Deploy build/web/ directory to hosting
```

## 📦 Key Dependencies

### State Management
- `flutter_bloc` ^8.1.3 - BLoC state management
- `bloc` ^8.1.2 - Core BLoC library
- `equatable` ^2.0.5 - Value equality

### Dependency Injection
- `get_it` ^7.6.4 - Service locator
- `injectable` ^2.3.2 - Code generation for DI

### Functional Programming
- `dartz` ^0.10.1 - Either type for error handling

### Local Storage
- `hive` ^2.2.3 - Fast NoSQL database
- `hive_flutter` ^1.1.0 - Hive integration
- `shared_preferences` ^2.2.2 - Key-value storage
- `flutter_secure_storage` ^9.0.0 - Encrypted storage

### UI Components
- `go_router` ^12.1.1 - Declarative routing
- `fl_chart` ^0.65.0 - Charts for analytics
- `shimmer` ^3.0.0 - Loading skeletons
- `flutter_slidable` ^3.0.1 - Swipe actions

### Networking
- `dio` ^5.3.3 - HTTP client
- `connectivity_plus` ^5.0.1 - Network detection

### Testing
- `mockito` ^5.4.3 - Mocking
- `bloc_test` ^9.1.5 - BLoC testing
- `faker` ^2.1.0 - Fake test data

## 🎨 Code Style

This project follows strict coding standards:

- **Files:** `snake_case.dart`
- **Classes:** `PascalCase`
- **Functions/Methods:** `camelCase`
- **Constants:** `lowerCamelCase` (private), `UPPER_SNAKE_CASE` (public)
- **Line Length:** 80 characters
- **Indentation:** 2 spaces
- **Quotes:** Single quotes

### Linting

```bash
# Format code
dart format .

# Analyze code
flutter analyze
```

We use:
- `flutter_lints` ^6.0.0 - Standard Flutter rules
- `very_good_analysis` ^5.1.0 - Stricter linting

## 📚 Documentation

- **[Implementation Plan](.claude/plans/jolly-riding-badger.md)** - Comprehensive 12-week roadmap
- **[Best Practices](bestpractices.md)** - Engineering guidelines (1880 lines)
- **[Anti-Patterns](antipatterns.md)** - Common mistakes to avoid (1388 lines)
- **[Claude Context](claude.md)** - Project-specific conventions and architecture
- **[Usage Guide](USAGE_GUIDE.md)** - How to use the documentation system

## 🔄 Development Workflow

### Adding a New Feature

1. **Domain Layer First** - Define entities, repository interface, use cases
2. **Data Layer** - Create models, repository implementation, data sources (mock)
3. **Presentation Layer** - Build BLoC, pages, widgets
4. **Register Dependencies** - Add to `injection_container.dart`
5. **Run Code Generation** - `flutter pub run build_runner build`
6. **Write Tests** - Ensure 80%+ coverage

### Commit Message Format

We use **Conventional Commits**:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:** feat, fix, docs, style, refactor, test, chore, perf

**Example:**
```
feat(transactions): add multi-currency transaction support

Implemented currency selection in transaction form.
Added currency conversion logic in transaction use case.

Closes #45
```

## 🛠️ Tech Stack

- **Framework:** Flutter 3.x (Cross-platform)
- **Language:** Dart 3.10.4+
- **State Management:** BLoC Pattern
- **Architecture:** Clean Architecture
- **Local Database:** Hive (NoSQL)
- **Navigation:** go_router
- **Dependency Injection:** GetIt
- **Testing:** Flutter Test, Mockito, BLoC Test
- **Charts:** fl_chart
- **Code Generation:** build_runner, json_serializable, injectable_generator

## 📊 Implementation Status

### ✅ Phase 1: Foundation (COMPLETE - 100%)

**Completed Features:**
- ✅ Dependencies setup (30+ packages installed and configured)
- ✅ Error handling system (7 failure types, 6 exception types)
- ✅ Core utilities (currency formatter, date utils, validators, extensions)
- ✅ Constants (100+ app constants, API endpoints, default categories)
- ✅ Theme configuration (complete Material Design 3 with light/dark themes)
- ✅ Dependency injection (GetIt fully configured with auth feature)
- ✅ Shared widgets library (8 reusable components: buttons, text fields, cards, etc.)
- ✅ Navigation/routing (go_router with 40+ route definitions)
- ✅ Authentication feature - Complete Clean Architecture implementation:
  - Domain layer: User entity, AuthRepository, 7 use cases
  - Data layer: UserModel, mock data source, local storage, repository implementation
  - Presentation layer: AuthBloc, Splash/Login/Register pages
- ✅ App initialization (main.dart with BLoC observer and multi-provider setup)
- ✅ Code generation (JSON serialization working)

**What Works Right Now:**
- 🎯 Complete authentication flow (login, register, logout)
- 🎯 Session persistence (login state saved locally)
- 🎯 Form validation with error messages
- 🎯 Loading states and error handling
- 🎯 Navigation between pages
- 🎯 Mock API with test user (test@example.com)

**Files Created:** 40+ files (~6,500 lines of code)

### 📋 Next Phases:
- **Phase 2:** Account Management (CRUD operations, multi-currency)
- **Phase 3:** Categories (default + custom categories)
- **Phase 4:** Transactions (income/expense/transfer with filtering)
- **Phase 5:** Dashboard (summary cards, charts, recent transactions)
- **Phase 6:** Budget Tracking (alerts, progress indicators)
- **Phase 7:** Recurring Transactions (auto-generation)
- **Phase 8:** Reports & Analytics (charts, trends, insights)
- **Phase 9:** Multi-Currency (exchange rates, conversion)
- **Phase 10:** Polish & Optimization (performance, dark mode, onboarding)

See [Implementation Plan](.claude/plans/jolly-riding-badger.md) for detailed roadmap.

## 🤝 Contributing

This is a personal finance tracker project. Contributions, issues, and feature requests are welcome!

### Development Guidelines

1. Follow the established architecture (Clean Architecture + BLoC)
2. Write tests for all new features (80%+ coverage required)
3. Use meaningful commit messages (Conventional Commits)
4. Reference `bestpractices.md` before writing code
5. Check `antipatterns.md` to avoid common mistakes
6. Follow the code style guide in `claude.md`

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter Team for the amazing framework
- BLoC Library for state management
- Clean Architecture principles by Uncle Bob
- Material Design 3 guidelines

## 📞 Contact & Support

- **Issues:** GitHub Issues
- **Discussions:** GitHub Discussions
- **Documentation:** See `claude.md` for comprehensive project context

---

**Last Updated:** 2025-12-13
**Version:** 1.0.0
**Status:** Phase 1 - Foundation (COMPLETE ✅) | Ready for Phase 2
