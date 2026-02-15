---
name: Convert XLSX to CSV
description: Converts an Amex/SAS XLSX transaction export to the semicolon-delimited CSV format required by the Expenses app.
---

# Convert XLSX to CSV

> [!IMPORTANT]
> **AI AGENT INSTRUCTIONS**:
> When converting a new export to a *new filename*, you **MUST** identify the previous transaction CSV and use `--merge-source <old_file.csv>` to preserve history. Failure to do so will result in data loss.


This skill converts Excel transaction files (commonly from Amex/SAS) into a semicolon-delimited CSV format. It handles date formatting (`yyyy-MM-dd`) and merges new data with existing CSV files to preserve history.

## Requirements

The script requires `pandas` and `openpyxl`. Install them via the `requirements.txt` in this folder.

```bash
pip3 install -r .agent/skills/convert_xlsx_to_csv/requirements.txt
```

## Usage
 
 Run the `convert.py` script with the input XLSX path and the desired output CSV path.
 
 ```bash
 python3 .agent/skills/convert_xlsx_to_csv/convert.py <input_file.xlsx> <output_file.csv> [--merge-source <existing_file.csv>]
 ```
 
 ### Example
 
 #### Standard (Same filename, auto-merge)
 ```bash
 # If output file exists, it will be automatically merged
 python3 .agent/skills/convert_xlsx_to_csv/convert.py assets/transactions.xlsx assets/data/transactions.csv
 ```
 
 #### New Filename (Explicit merge)
 ```bash
 # When creating a NEW dated file, you MUST provide the old file to merge history from
 python3 .agent/skills/convert_xlsx_to_csv/convert.py \
   assets/data/transactions-new.xlsx \
   assets/data/transactions-new.csv \
   --merge-source assets/data/transactions-old.csv
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

## Safe (Atomic) Update Workflow
 
The script now implements an **atomic update** strategy to prevent data loss.
 
1.  **Writes to Temp**: New data is written to `<output>.tmp`.
2.  **Verifies**: It checks that the new file has *at least* as many rows as the old one (if it exists).
3.  **Backs Up**: The old file is moved to `<output>.bak`.
4.  **Swaps**: The `.tmp` file is renamed to `<output>`.
 
### Recommended Usage
 
Use a single canonical filename (e.g., `assets/data/transactions.csv`) for your main history.
 
```bash
# 1. Download new transactions as .xlsx
# 2. Run conversion targeting your MAIN CSV file:
python3 .agent/skills/convert_xlsx_to_csv/convert.py \
  assets/data/new_export.xlsx \
  assets/data/transactions.csv
```
 
If the update is successful AND the output passes validation (no duplicates, sorted correctly), the script will automatically **delete** the `.bak` file to keep the directory clean.
 93: 
 94: If validation fails (e.g. duplicate rows found), the `.bak` file is PRESERVED so you can revert if needed.
