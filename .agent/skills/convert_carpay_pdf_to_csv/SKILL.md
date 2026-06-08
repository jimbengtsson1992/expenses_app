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

> [!IMPORTANT]
> **AI AGENT INSTRUCTIONS**:
> CarPay PDFs are monthly — each PDF contains only that month's transactions, not the full history.
> Always target `assets/data/carpay.csv` as the single canonical output file.
> If it already exists the script merges automatically. If a dated file exists instead
> (e.g. `carpay-202603.csv`), use `--merge-source <dated_file.csv>` and delete the dated
> file afterwards to avoid loading duplicate data in the Flutter app.

This skill extracts transactions from CarPay/Ziklo Bank PDF statements and **merges** them into a single accumulating `carpay.csv`. Since each PDF contains only one month of data, history is preserved across runs.

## Requirements

```bash
pip3 install -r .agent/skills/convert_carpay_pdf_to_csv/requirements.txt
```

## Usage

Always target the single canonical CSV:

```bash
python3 .agent/skills/convert_carpay_pdf_to_csv/convert.py <input.pdf> assets/data/carpay.csv
```

If `assets/data/carpay.csv` already exists, the script merges the new PDF's transactions into it, deduplicates, and re-sorts. No extra flags needed.

### First time / migration from a dated file

If `carpay.csv` doesn't exist yet but a dated file does (e.g. `carpay-202603.csv`), seed history from it:

```bash
python3 .agent/skills/convert_carpay_pdf_to_csv/convert.py \
  assets/data/kontoutdrag-202604.pdf \
  assets/data/carpay.csv \
  --merge-source assets/data/carpay-202603.csv
```

Then **delete the dated file** — the Flutter app loads every `carpay*.csv` it finds, so keeping both causes duplicate March transactions in the app.

```bash
rm assets/data/carpay-202603.csv
```

From now on, always pass `assets/data/carpay.csv` as the output.

## Output CSV format

Semicolon-delimited, UTF-8, no metadata rows, sorted descending by date:

```
Datum;Händelse;Referens;Belopp
2026-03-21;St1 Sandsjobacka Vast;Lindome;659.71
2026-03-06;Circle K Ulricehamn;Ulricehamn;644.32
```

**Amounts**: positive = expense. The Flutter parser for `Account.carPay` inverts the sign, matching the SAS Mastercard convention.

**Filename**: the output file must contain `carpay` (case-insensitive) for the Flutter app to detect it correctly.

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
- Pending entries added via `add_pending_carpay` are automatically resolved when the matching PDF data arrives (matched by date + amount ±0.01 SEK). Unresolved ones generate a warning for manual review.

## Testing

```bash
python3 .agent/skills/convert_carpay_pdf_to_csv/test_convert.py
```

The test suite includes unit tests for amount normalisation, row filtering, sorting, deduplication, and an integration test against `assets/data/kontoutdrag-202603.pdf` (skipped automatically if the file is absent).
