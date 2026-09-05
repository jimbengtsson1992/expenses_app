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
4. **Trips**: `tripId` parser priority, `matchKnownTrip`, estimation exclusion. Tests in `test/features/trips/`, `test/parsers/`.

## ⚡️ Quick Context
- **Stack**: Flutter, Riverpod (Generator), GoRouter, Freezed, fl_chart, Intl.
- **Data**: `assets/data/*.csv`. Filtered > `2024-12-01`.
- **Parsing**:
  - **Nordea**: Semicolon, `yyyy/MM/dd`, Filter internal transfers (`_isInternalTransfer`).
  - **Mastercard**: Semicolon, `yyyy-MM-dd`, Section-based ("Köp/uttag"), Inverted amounts.
- **Trips**: `Transaction.tripId` only groups spend for the dashboard trip total; it does **NOT** affect category. Hardcode via `knownTripTransactions` in `trips/domain/trip.dart`; category overrides/rules for trip transactions are added normally.
