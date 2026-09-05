# Project Overview

## ⚡️ Summary
Personal expense tracker for 1 user. Imports CSVs (Nordea, SAS Mastercard), auto-categorizes, and visualizes expenses.
**Codebase**: Pure Flutter, clear clean architecture (`features/expenses`), Riverpod state.

## 🏗 Architecture
**Feature-first**: `lib/src/features/expenses/`
- **Domain**: `Expense` (Freezed), `Category` (Enum).
- **Data**: `ExpensesRepository` (CSV parsing, filtering).
- **Logic**: `CategorizationService` (Regex/Keyword matching).
- **UI**: `ExpensesListScreen`, `DashboardScreen`.

**Trips**: `lib/src/features/trips/` — `domain/trip.dart` (`allTrips`, `knownTripTransactions`, `matchKnownTrip`), `application/trip_providers.dart` (`tripTransactionsProvider`), `presentation/trip_card.dart`.

## 💾 Data & parsing
**Files**: `assets/data/*.csv`. Detected via filename keywords.
- **Nordea**: (`Personkonto`, `Sparkonto`) -> `Date;Amount;Sender;Receiver;Name;Title;Balance;Currency`. `yyyy/MM/dd`.
- **Mastercard**: (`SAS Mastercard`) -> `Date;Booked;Spec;Loc;Curr;ForeignAmt;Amount`. `yyyy-MM-dd`. *Requires section parsing*.

## 🔑 Key Logic
- **Categorization**: Keyword matching in `CategorizationService`.
- **Transfer Filter**: Excludes internal transfers between hardcoded accounts (`1127 25 18949`, etc).
- **Deduplication**: Filters "Bill Payments" in Mastercard to avoid double counting from Nordea.
- **Date Filter**: Hardcoded start date (`2024-12-01`).
- **Estimation**: Predicts month-end totals via `EstimationService`. See `.agent/estimation_rules.md`.
- **Trips**: `Transaction.tripId` (nullable) groups manually tagged transactions for a cross-month total (dashboard `TripCard`, period-independent net sum). Tagging: transaction detail screen → `UserRulesRepository.assignTrip` (SharedPreferences key `trip_assignments`; leaves any category override untouched). Parser: `tripId` = prefs ?? `matchKnownTrip(desc, amount, date)`; category is resolved independently (`override ?? rule ?? categorize`), so a trip restaurant bill stays Food/Restaurant. Excluded from estimates. Persist to code via export prompt → `knownTripTransactions`. `clearAll()` wipes trip assignments.
