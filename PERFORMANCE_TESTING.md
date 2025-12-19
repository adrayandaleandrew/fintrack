# Performance Testing Guide

This guide explains how to test and optimize the Finance Tracker app's performance.

---

## Quick Start

### Generate Large Test Dataset

```dart
import 'package:finance_tracker/core/utils/test_data_generator.dart';

void main() {
  final generator = TestDataGenerator();

  // Generate 1000 transactions for testing
  final dataset = generator.generateCompleteDataset(
    accountCount: 10,
    categoryCount: 20,
    transactionCount: 1000,
  );

  generator.printDatasetSummary(dataset);
}
```

### Run Performance Tests

```bash
# Run all performance tests
flutter test test/performance/

# Run specific test
flutter test test/performance/large_dataset_test.dart

# Run with coverage
flutter test --coverage test/performance/
```

---

## Test Results ✅

**Dataset Generation Performance:**
- **1,000 transactions:** Generated in < 100ms
- **5,000 transactions:** Generated in 119ms
- **Memory usage:** Stable across multiple generations

**Transaction Distribution (1000 transactions):**
- Income: 29.1%
- Expense: 61.1%
- Transfer: 9.8%

**Data Quality:**
- ✅ Realistic amount ranges ($5 - $10,000)
- ✅ Proper date distribution (past 365 days)
- ✅ Sorted by date (most recent first)
- ✅ Valid account and category assignments

---

## Performance Profiling with Flutter DevTools

### 1. Launch DevTools

```bash
# Run app in profile mode
flutter run --profile

# Open DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

### 2. Performance Tab

**Key Metrics to Monitor:**
- **Frame rendering:** Target 60fps (16.67ms per frame)
- **Build times:** Should be < 16ms for smooth UI
- **Layout times:** Minimize layout passes
- **Paint times:** Check for expensive paint operations

**Warning Signs:**
- Red bars in timeline (dropped frames)
- Long build/layout/paint times
- Frequent garbage collection

### 3. Memory Tab

**What to Check:**
- Memory usage trends (should be stable)
- No memory leaks (gradually increasing usage)
- GC frequency (shouldn't be constant)

**Expected Memory Usage:**
- **Baseline (empty app):** ~50-100MB
- **With 1000 transactions:** ~100-150MB
- **With 5000 transactions:** ~150-200MB

### 4. CPU Profiler

**Profile These Scenarios:**
1. **List scrolling** with 1000+ transactions
2. **Search/filter** operations
3. **Chart rendering** in Reports
4. **Transaction creation** with balance updates

**How to Profile:**
```bash
1. Tap "Record" in CPU Profiler
2. Perform the action to test
3. Tap "Stop"
4. Analyze the flame chart
```

**Look for:**
- Functions taking > 16ms
- Unnecessary rebuilds
- Expensive computations in build methods

---

## Performance Optimization Checklist

### ✅ Widget Optimization

- [x] Use `const` constructors where possible
- [x] Implement `Equatable` for entities and states
- [x] Avoid rebuilds with proper keys
- [ ] Use `RepaintBoundary` for complex widgets
- [ ] Implement lazy loading for lists

### ✅ List Performance

- [x] Transactions sorted by date
- [ ] Implement pagination (50 items per page)
- [ ] Use `ListView.builder` for large lists
- [ ] Add scroll controller for infinite scroll
- [ ] Cache list items

### ✅ Data Management

- [x] Offline-first with Hive caching
- [x] Cache-first fallback strategy
- [ ] Implement data pagination
- [ ] Add background sync
- [ ] Optimize Hive box queries

### ✅ Chart Rendering

- [x] Using fl_chart library
- [ ] Limit data points (max 30-50)
- [ ] Use `RepaintBoundary` around charts
- [ ] Implement chart data caching
- [ ] Lazy load chart data

---

## Benchmark Tests

### Scrolling Performance

**Test:** Scroll through 1000+ transactions

**Target:**
- 60fps sustained
- No jank or stuttering
- Smooth animations

**How to Test:**
```bash
1. Generate 1000+ test transactions
2. Open transaction list
3. Scroll rapidly up and down
4. Monitor frame rate in DevTools
```

### Search Performance

**Test:** Search through 1000+ transactions

**Target:**
- Results in < 500ms
- Instant UI feedback
- No blocking operations

**How to Test:**
```dart
final stopwatch = Stopwatch()..start();
final results = await searchTransactions('grocery');
stopwatch.stop();

print('Search took ${stopwatch.elapsedMilliseconds}ms');
assert(stopwatch.elapsedMilliseconds < 500);
```

### Filter Performance

**Test:** Filter 1000+ transactions by multiple criteria

**Target:**
- Results in < 300ms
- Smooth filter UI
- No dropped frames

### Chart Rendering

**Test:** Render expense breakdown with 20+ categories

**Target:**
- Render in < 1000ms
- Smooth interactions
- No lag on touch

---

## Common Performance Issues & Solutions

### Issue 1: Slow List Scrolling

**Symptoms:**
- Dropped frames while scrolling
- Jank/stuttering

**Solutions:**
1. Use `ListView.builder` instead of `ListView`
2. Add `cacheExtent` to preload items
3. Simplify list item widgets
4. Use `RepaintBoundary` for complex items
5. Implement pagination

### Issue 2: Memory Leaks

**Symptoms:**
- Gradually increasing memory
- App slows down over time
- Crashes after extended use

**Solutions:**
1. Dispose controllers in `dispose()`
2. Cancel stream subscriptions
3. Close BLoCs properly
4. Remove listeners

### Issue 3: Expensive Build Operations

**Symptoms:**
- Red bars in DevTools timeline
- UI freezes

**Solutions:**
1. Move computations out of build methods
2. Use `compute()` for heavy operations
3. Cache expensive results
4. Use memoization

### Issue 4: Slow Database Queries

**Symptoms:**
- Long wait times for data
- Delayed UI updates

**Solutions:**
1. Add indexes to Hive boxes
2. Implement query pagination
3. Use background isolates
4. Cache query results

---

## Performance Testing Workflow

### 1. Baseline Measurement

```bash
# Profile with empty data
flutter run --profile
# Record metrics in DevTools
```

### 2. Load Test Data

```dart
// In app initialization
final generator = TestDataGenerator();
final dataset = generator.generateCompleteDataset(
  transactionCount: 1000,
);
// Load into app
```

### 3. Run Scenarios

Test these user flows:
1. App launch → Dashboard
2. View transactions → Scroll list
3. Search transactions
4. Filter transactions
5. View reports → Charts
6. Create transaction
7. Edit transaction
8. Delete transaction

### 4. Analyze Results

**For each scenario, check:**
- Frame rate (target: 60fps)
- Build times (target: < 16ms)
- Memory usage (should be stable)
- CPU usage (spikes are OK, sustained high is bad)

### 5. Optimize & Repeat

- Fix identified bottlenecks
- Re-run tests
- Compare results

---

## Automated Performance Tests

Run these regularly:

```bash
# Performance test suite
flutter test test/performance/

# With output
flutter test test/performance/ --reporter expanded

# Integration tests
flutter test integration_test/
```

**CI/CD Integration:**
```yaml
# Add to .github/workflows/
performance-tests:
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v2
    - uses: subosito/flutter-action@v2
    - run: flutter test test/performance/
```

---

## Performance Targets

### App Launch
- **Target:** < 2 seconds to dashboard
- **Measurement:** Time from tap to interactive UI

### List Scrolling
- **Target:** 60fps sustained
- **Measurement:** DevTools frame rate

### Search
- **Target:** < 500ms for 1000+ items
- **Measurement:** Stopwatch in code

### Filters
- **Target:** < 300ms for complex filters
- **Measurement:** Stopwatch in code

### Charts
- **Target:** < 1000ms to render
- **Measurement:** DevTools paint time

### Memory
- **Target:** < 200MB with 5000 transactions
- **Measurement:** DevTools memory profiler

---

## Tools

- **Flutter DevTools:** Frame rate, memory, CPU profiling
- **Stopwatch:** Code-level timing
- **flutter test:** Automated performance tests
- **flutter run --profile:** Profile mode for accurate metrics

---

## Next Steps

1. ✅ Generate large test dataset
2. ✅ Run automated performance tests
3. ⏳ Profile with Flutter DevTools
4. ⏳ Optimize identified bottlenecks
5. ⏳ Re-test and validate improvements

---

**Note:** Always test on real devices, not just emulators. Performance can vary significantly between platforms and device capabilities.
