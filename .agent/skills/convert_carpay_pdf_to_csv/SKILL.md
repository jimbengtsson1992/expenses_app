---
name: convert_carpay_pdf_to_csv
description: >
  Converts CarPay (Ziklo Bank) monthly PDF statements (kontoutdrag) to a
  semicolon-delimited CSV suitable for the expense tracker. Use this skill
  whenever the user mentions a CarPay PDF, a kontoutdrag file, or wants to
  import CarPay fuel transactions into the app — even if they don't explicitly
  say "convert" or "CSV".
---

# Convert CarPay PDF to CSV

This skill extracts transactions from CarPay/Ziklo Bank PDF statements and writes a semicolon-delimited CSV that the expense tracker app can parse.

It mirrors the workflow of `convert_xlsx_to_csv` but reads PDFs instead of Excel files.

## Requirements

```bash
pip3 install -r .agent/skills/convert_carpay_pdf_to_csv/requirements.txt
```

## Usage

```bash
python3 .agent/skills/convert_carpay_pdf_to_csv/convert.py <input.pdf> <output.csv> [--merge-source <existing.csv>]
```

### Standard (same output file, auto-merge)

```bash
python3 .agent/skills/convert_carpay_pdf_to_csv/convert.py \
  assets/data/kontoutdrag-202603.pdf \
  assets/data/carpay.csv
```

If `carpay.csv` already exists, the script merges and deduplicates automatically.

### New output file (explicit merge)

When writing to a **new filename**, provide the old file explicitly to preserve history:

```bash
python3 .agent/skills/convert_carpay_pdf_to_csv/convert.py \
  assets/data/kontoutdrag-202604.pdf \
  assets/data/carpay-2026.csv \
  --merge-source assets/data/carpay-old.csv
```

## Output CSV format

Semicolon-delimited, UTF-8, no metadata rows, sorted descending by date:

```
Datum;Händelse;Referens;Belopp
2026-03-21;St1 Sandsjobacka Vast;Lindome;659.71
2026-03-06;Circle K Ulricehamn;Ulricehamn;644.32
```

**Amounts**: positive = expense. The Flutter parser for `Account.carPay` inverts the sign, matching the SAS Mastercard convention.

**Filename convention**: name output files so they contain `carpay` (case-insensitive) for the Flutter app to detect them correctly, e.g. `carpay-202603.csv` or `carpay.csv`.

## Safe update workflow

1. Writes to `<output>.tmp`
2. Verifies new file has ≥ rows as existing file (aborts if data would be lost)
3. Backs up existing to `<output>.bak`
4. Renames `.tmp` → final output
5. If validation passes (no duplicates, descending sort), deletes `.bak`

## Notes

- The PDF transaction table has columns: Datum, Händelse, Referens, Belopp, Totalt. The `Totalt` (running balance) column is discarded.
- Subtotal and total rows (e.g. "Jim Bengtsson delsumma", "Summa") are filtered by checking that the first column matches `YYYY-MM-DD`.
- Amounts use Swedish format in the PDF (`644,32`) and are normalised to dot-decimal.
- Deduplication key: `[Datum, Händelse, Referens, Belopp]`.

## Testing

```bash
python3 .agent/skills/convert_carpay_pdf_to_csv/test_convert.py
```

The test suite includes unit tests for amount normalisation, row filtering, sorting, deduplication, and an integration test against `assets/data/kontoutdrag-202603.pdf` (skipped automatically if the file is absent).

## Flutter app parser (separate task)

The CSV output requires a corresponding parser in the Flutter app. When adding the parser, follow the pattern in `lib/src/features/transactions/data/transaction_csv_parser.dart`:

- **Detection**: filename contains `carpay` (case-insensitive) → `parseCarPayCsv()`
- **Columns**: `[0]` Datum (yyyy-MM-dd), `[1]` Händelse, `[2]` Referens, `[3]` Belopp
- **Account**: `Account.carPay`
- **Amount**: invert sign (positive in CSV = expense, same as SAS Mastercard)
- **Skip**: header row (row 0)
