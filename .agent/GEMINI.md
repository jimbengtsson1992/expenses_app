# GEMINI.md - Critical Rules

## 🚨 Commands
- **Run**: `fvm flutter run`
- **Deps**: `fvm flutter pub get`
- **Gen**: `fvm flutter pub run build_runner build --delete-conflicting-outputs`
- **Test**: `fvm flutter test`
- **Format**: `fvm dart format .`

## 🚨 Testing Mandates
**MUST** test changes to:
1. **CSV Parsing**: Any Logic/Regex changes.
2. **Exclusions**: `excludeFromOverview` logic.
3. **Categorization**: `CategorizationService` & rules. See `.agent/categorization_rules.md`.

## ⚡️ Quick Context
- **Stack**: Flutter, Riverpod (Generator), GoRouter, Freezed, fl_chart, Intl.
- **Data**: `assets/data/*.csv`. Filtered > `2024-12-01`.
- **Parsing**:
  - **Nordea**: Semicolon, `yyyy/MM/dd`, Filter internal transfers (`_isInternalTransfer`).
  - **Amex**: Semicolon, `yyyy-MM-dd`, Section-based ("Köp/uttag"), Inverted amounts.
