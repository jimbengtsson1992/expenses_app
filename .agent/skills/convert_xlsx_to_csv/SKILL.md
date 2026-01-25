---
name: Convert XLSX to CSV
description: Converts an Amex/SAS XLSX transaction export to the semicolon-delimited CSV format required by the Expenses app.
---

# Convert XLSX to CSV

This skill converts Excel transaction files (commonly from Amex/SAS) into a semicolon-delimited CSV format. It handles date formatting (`yyyy-MM-dd`) ensures the structure matches what the `transaction_csv_parser.dart` expects.

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
