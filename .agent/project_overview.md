# Project Overview

## ⚡️ Summary
Personal expense tracker for 1 user. Imports CSVs (Nordea, Amex), auto-categorizes, and visualizes expenses.
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
- **Amex**: (`SAS Amex`) -> `Date;Booked;Spec;Loc;Curr;ForeignAmt;Amount`. `yyyy-MM-dd`. *Requires section parsing*.

## 🔑 Key Logic
- **Categorization**: Keyword matching in `CategorizationService`.
- **Transfer Filter**: Excludes internal transfers between hardcoded accounts (`1127 25 18949`, etc).
- **Deduplication**: Filters "Bill Payments" in Amex to avoid double counting from Nordea.
- **Date Filter**: Hardcoded start date (`2024-12-01`).
