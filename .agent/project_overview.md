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
- **Trips**: `Transaction.tripId` (nullable) groups manually tagged transactions (e.g. Florence trip) for a cross-month total. Registry: `lib/src/features/trips/domain/trip.dart` (`allTrips`). Assignments persist in `UserRulesRepository` (SharedPreferences, key `trip_assignments`); parser populates `tripId` per row. Parser categorizes any `tripId != null` row as `(entertainment, travel)` (priority: user override > trip > user rule > `CategorizationService`); tagging in the detail screen removes any existing override so this applies. Dashboard shows a `TripCard` per trip (period-independent net total via `tripTransactionsProvider`). Trip-tagged transactions are excluded from estimates. **Persist to code**: "Exportera Regler & Overrides" emits a `### Trip Assignments` section; the agent adds each as a `KnownTripTransaction` to `knownTripTransactions` in `trip.dart` (parser falls back to `matchKnownTrip(description, amount, date)` when no SharedPreferences assignment exists). `clearAll()` wipes trip assignments like rules/overrides.
