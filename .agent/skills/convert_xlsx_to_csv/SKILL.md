---
name: Convert XLSX to CSV
description: Converts an Amex/SAS XLSX transaction export to the semicolon-delimited CSV format required by the Expenses app.
---

# Convert XLSX to CSV

This skill converts Excel transaction files (commonly from Amex/SAS) into a semicolon-delimited CSV format. It handles date formatting (`yyyy-MM-dd`) and merges new data with existing CSV files to preserve history.

## Requirements

The script requires `pandas` and `openpyxl`. Install them via the `requirements.txt` in this folder.

```bash
pip3 install -r .agent/skills/convert_xlsx_to_csv/requirements.txt
```

## Usage

Run the `convert.py` script with the input XLSX path and the desired output CSV path.

```bash
python3 .agent/skills/convert_xlsx_to_csv/convert.py <input_file.xlsx> <output_file.csv>
```

### Example

```bash
python3 .agent/skills/convert_xlsx_to_csv/convert.py assets/transactions.xlsx assets/data/transactions.csv
```

## Notes

- The script reads the XLSX with `header=None` to preserve the exact row structure (including metadata rows at the top).
- Dates are forced to `yyyy-MM-dd` format.
- Output uses `;` as delimiter.
- Output is UTF-8 encoded.
- If the output CSV already exists, the script merges the new data with the existing data, removing duplicates and sorting by date.

## Testing & Validation

### Validate Output
The script automatically validates the output file (checks for duplicates and sorting) after conversion. You can skip this check with `--no-validate`:

```bash
python3 .agent/skills/convert_xlsx_to_csv/convert.py <input.xlsx> <output.csv> --no-validate
```

### Run Unit Tests
A test suite is available to verify merging, deduplication, and header cleaning logic:

```bash
python3 .agent/skills/convert_xlsx_to_csv/test_convert.py
```

## Recommended Workflow

For best results, use a single canonical CSV file to build up your transaction history:

```bash
# 1. Download new transactions as .xlsx
# 2. Manually move the file to: assets/data/latest_export.xlsx (or similar name)
# 3. Run conversion against the main history file:
python3 .agent/skills/convert_xlsx_to_csv/convert.py assets/data/latest_export.xlsx assets/data/amex_transactions.csv
```
