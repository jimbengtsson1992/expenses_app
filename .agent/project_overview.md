# Expenses App - Project Overview

## Project Summary

This is a personal expense tracking Flutter application that imports, categorizes, and visualizes financial transactions from multiple bank accounts and credit cards. The app supports both Nordea bank accounts and SAS Amex credit card CSV exports.

## Tech Stack

- **Framework**: Flutter (Dart SDK ^3.9.2)
- **State Management**: Riverpod (flutter_riverpod ^3.1.0)
- **Navigation**: GoRouter ^17.0.1
- **Data Models**: Freezed ^3.2.3 for immutable models
- **Charting**: fl_chart ^1.1.1
- **CSV Parsing**: csv ^6.0.0
- **Localization**: Swedish locale (sv) using Intl ^0.20.2
- **UI**: Google Fonts ^7.0.0

## Project Structure

```
lib/
├── main.dart                          # App entry point
└── src/
    ├── app.dart                       # App root widget
    ├── common_widgets/                # Reusable UI components
    │   ├── month_selector.dart
    │   └── scaffold_with_bottom_nav_bar.dart
    ├── features/
    │   ├── dashboard/                 # Dashboard feature
    │   │   └── presentation/
    │   │       └── dashboard_screen.dart
    │   └── expenses/                  # Core expenses feature
    │       ├── application/           # Business logic
    │       │   └── categorization_service.dart
    │       ├── data/                  # Data layer
    │       │   ├── expenses_providers.dart
    │       │   └── expenses_repository.dart
    │       ├── domain/                # Domain models
    │       │   ├── category.dart      # Expense categories enum
    │       │   └── expense.dart       # Expense model
    │       └── presentation/          # UI layer
    │           ├── expense_detail_screen.dart
    │           └── expenses_list_screen.dart
    └── routing/                       # App routing
        ├── app_router.dart
        └── routes.dart
```

## Key Features

### 1. **Multi-Source Transaction Import**
- **Nordea Bank Accounts**: Supports multiple accounts (Personkonto, Sparkonto, Gemensamt)
- **SAS Amex Credit Card**: Dedicated parser for Amex transaction exports
- CSV files are stored in `assets/data/`

### 2. **Automatic Categorization**
The app automatically categorizes expenses into:
- 🍔 **Mat & Dryck** (Food & Drinks) - Green
- 🛍️ **Shopping** - Pink
- 🚌 **Transport** - Orange
- 💪 **Hälsa & Träning** (Health & Fitness) - Blue
- 📄 **Räkningar & Bank** (Bills & Bank) - BlueGrey
- 💰 **Sparande** (Savings) - Purple
- 💵 **Inkomst** (Income) - Teal
- ❓ **Övrigt** (Other) - Grey

### 3. **Internal Transfer Filtering**
- Automatically filters out internal transfers between known accounts
- Deduplicates credit card payments (filters Amex bill payments from Nordea exports)
- Known accounts are tracked to prevent double-counting

### 4. **Data Model**

**Expense Model** (Freezed immutable):
- `id`: Unique identifier (UUID v4)
- `date`: Transaction date
- `amount`: Transaction amount (negative for expenses)
- `description`: Transaction description/memo
- `category`: Auto-assigned category
- `sourceAccount`: Origin account name
- `sourceFilename`: Source CSV filename for traceability

## CSV File Formats

### Nordea Format
- **Delimiter**: Semicolon (`;`)
- **Decimal**: Comma (`,`)
- **Columns**: Bokföringsdag;Belopp;Avsändare;Mottagare;Namn;Rubrik;Saldo;Valuta
- **Date Format**: `yyyy/MM/dd`

### SAS Amex Format
- **Delimiter**: Semicolon (`;`)
- **Decimal**: Period (`.`)
- **Columns**: Datum;Bokfört;Specifikation;Ort;Valuta;Utl. belopp;Belopp
- **Date Format**: `yyyy-MM-dd`
- **Section**: Transactions are in "Köp/uttag" section
- **Amount Handling**: Values are inverted (positive in file = expense = stored as negative)

## Known Accounts

The app tracks these accounts for transfer filtering:
- `1127 25 18949` - Jim Personkonto
- `3016 28 91261` - Jim Sparkonto
- `3016 05 24377` - Gemensamt
- `3016 28 91415` - Gemensamt Spar
- Transfers involving `RAGNAR,LOUISE` are also filtered

## Date Filtering

- Start date: **January 1, 2025** (hardcoded in `_startParams`)
- Only transactions on or after this date are imported

## Architecture Pattern

The app follows a clean architecture approach with feature-based organization:

1. **Domain Layer**: Business entities (`Expense`, `Category`)
2. **Data Layer**: Repository pattern for data access (`ExpensesRepository`)
3. **Application Layer**: Business logic services (`CategorizationService`)
4. **Presentation Layer**: Flutter widgets and screens

## Code Generation

The project uses build_runner for code generation:
- Riverpod providers (`.g.dart`)
- Freezed models (`.freezed.dart`)
- JSON serialization (`.g.dart`)
- GoRouter routes (`.g.dart`)

Run code generation with:
```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

## Recent Development

Based on recent conversation history, the project has been actively developed with focus on:
- SAS Amex CSV parsing debugging
- Ensuring proper section detection in CSV files
- Handling edge cases in transaction categorization
- Filtering internal transfers and duplicate payments

## Next Steps / Known Issues

- The CSV parsing logic is complex and has been recently debugged
- Consider adding unit tests for CSV parsing (one test file exists: `test/categorization_service_test.dart`)
- UI includes dashboard with charts (fl_chart) for expense visualization
