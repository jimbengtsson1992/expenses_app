# GEMINI.md - Agent Guide

## 🚨 Critical: Command Usage
**ALWAYS** use `fvm` for Flutter and Dart commands:
- `fvm flutter run`
- `fvm flutter pub get`
- `fvm dart format .`
- `fvm flutter test`

## 🚨 Critical: Testing Requirements
You **MUST** create/update tests when modifying:
1. **CSV Parsing Logic**: Any changes to how files are read or parsed.
2. **Exclusion Logic**: Changes affecting `excludeFromOverview`.
3. **Categorization Rules**: Updates to `CategorizationService` or category matching.


## 🛠 Tech Stack
- **Flutter**: Dart SDK ^3.10.0
- **State**: Riverpod (`flutter_riverpod`, `riverpod_generator`)
- **Navigation**: GoRouter
- **Models**: Freezed & JSON Serializable
- **Charts**: fl_chart
- **Localization**: Intl (sv)

## 🏗 Architecture & Structure
Clean architecture with feature-based organization in `lib/src/features/`.
- **Core Feature**: `expenses` (Transactions, Categories, CSV parsing)
- **Data**: `assets/data/` (Nordea & Amex CSVs)
- **Logic**: `CategorizationService` (Auto-categorization rules)

## ⚡️ Common Tasks
- **Code Generation**:
  ```bash
  fvm flutter pub run build_runner build --delete-conflicting-outputs
  ```
- **Tests**:
  - CSV parsing & Categorization logic are critical.
  - Run: `fvm flutter test`

## 📝 Parsing & Categories
- **Nordea**: Semicolon delimited, `yyyy/MM/dd`.
- **Amex**: Semicolon delimited, `yyyy-MM-dd`.
- **Exclusions**: Internal transfers are filtered based on account numbers in `ExpensesRepository`.
