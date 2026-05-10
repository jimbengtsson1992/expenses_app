---
name: add-pending-carpay
description: Add a manual pending CarPay fuel transaction to the carpay CSV before it appears in the official PDF export. Use whenever the user mentions a recent fuel fill-up, a CarPay transaction that hasn't been exported yet, or wants to record a pending transaction so it shows up in the expense app immediately. Trigger on phrases like "I just filled up", "add a carpay transaction", "add a pending fuel transaction", or "record a CarPay purchase".
---

# Add Pending CarPay Transaction

Adds a `[PENDING]`-marked transaction to the carpay CSV so it shows up in the app immediately. When the official PDF is later imported via `convert_carpay_pdf_to_csv`, the pending entry is automatically removed if matched by date + amount.

## Steps

1. **Gather transaction details** (ask the user for any missing fields):
   - **Date**: YYYY-MM-DD
   - **Station name**: as it will appear on the receipt / PDF (e.g. "Circle K Ulricehamn", "St1 Sandsjobacka Vast")
   - **City**: the location field (e.g. "Ulricehamn", "Lindome")
   - **Amount**: in SEK, positive (e.g. 659.71)

2. **Find the carpay CSV** — look for `assets/data/carpay*.csv`. If multiple exist, use the one with the most recent date in its name (or ask the user).

3. **Run the script**:
   ```bash
   python3 .agent/skills/add_pending_carpay/add_pending.py \
     assets/data/carpay-YYYYMM.csv \
     --date YYYY-MM-DD \
     --station "Station Name" \
     --city "City" \
     --amount 000.00
   ```

4. **Confirm** — report what was added and the CSV path.

## Notes

- The entry is stored as `{station} [PENDING]` in the Händelse column so it's visually distinguishable in the app.
- When `convert_carpay_pdf_to_csv` is run next, it matches pending entries by **date + amount** (±0.01 SEK). Matched entries are silently removed; unmatched ones generate a warning for manual review.
- If the station name on the receipt differs slightly from what ends up in the PDF, the pending entry won't be auto-removed — the warning from `convert.py` will flag it.
