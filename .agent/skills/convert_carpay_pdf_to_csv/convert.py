import pdfplumber
import pandas as pd
import sys
import os
import re
import argparse

DATE_PATTERN = re.compile(r'^\d{4}-\d{2}-\d{2}$')
PENDING_MARKER = '[PENDING]'


def normalise_amount(s):
    """'1 304,03' or '644,32' -> '644.32' (dot-decimal string)"""
    s = str(s).strip().replace('\xa0', '').replace(' ', '')
    s = s.replace(',', '.')
    try:
        return str(float(s))
    except ValueError:
        return s


def _group_words_into_rows(words, y_tolerance=3):
    """Group word dicts by their vertical position (top) within y_tolerance pixels."""
    rows = {}
    for w in words:
        key = round(w['top'] / y_tolerance) * y_tolerance
        rows.setdefault(key, []).append(w)
    return {k: sorted(v, key=lambda w: w['x0']) for k, v in sorted(rows.items())}


def extract_transactions(pdf_path):
    """
    Extract transaction rows using word x-positions.

    The CarPay PDF has these visual columns (x positions from real data):
      Datum        x ≈  42  (date)
      Händelse     x ≈ 113  (merchant name, words end by x ≈ 200)
      [city]       x ≈ 215  (location, unlabeled — sits between Händelse and Referens headers)
      Referens     x ≈ 383  (TMN reference code — discarded)
      Belopp       x ≈ 470  (amount)
      Totalt       x ≈ 527  (running total — discarded)

    Column boundaries used:
      Datum:    x < 100
      Händelse: 100 ≤ x < 207
      City:     207 ≤ x < 375   → mapped to "Referens" in the output CSV
      TMN ref:  375 ≤ x < 455   → discarded
      Belopp:   455 ≤ x < 520
      Totalt:   x ≥ 520         → discarded
    """
    # Column x-boundaries: (col_name, x_start, x_end)
    # None for x_end means "up to next boundary"
    COL_DATUM_END   = 100
    COL_HANDELSE_END = 207
    COL_CITY_END    = 375
    COL_REF_END     = 455
    COL_BELOPP_END  = 520
    # x >= 520 is Totalt, discarded

    rows = []
    with pdfplumber.open(pdf_path) as pdf:
        for page in pdf.pages:
            word_rows = _group_words_into_rows(page.extract_words())
            for top, wlist in word_rows.items():
                # Transaction rows start with a YYYY-MM-DD date
                if not wlist or not DATE_PATTERN.match(wlist[0]['text']):
                    continue

                datum = handelse_parts = city_parts = belopp = None
                handelse_parts = []
                city_parts = []

                for w in wlist:
                    x = w['x0']
                    t = w['text']
                    if x < COL_DATUM_END:
                        datum = t
                    elif x < COL_HANDELSE_END:
                        handelse_parts.append(t)
                    elif x < COL_CITY_END:
                        city_parts.append(t)
                    elif x < COL_REF_END:
                        pass  # TMN reference code — discard
                    elif x < COL_BELOPP_END:
                        belopp = t
                    # else: Totalt — discard

                if datum and handelse_parts and belopp:
                    rows.append({
                        'Datum': datum,
                        'Händelse': ' '.join(handelse_parts),
                        'Referens': ' '.join(city_parts),
                        'Belopp': normalise_amount(belopp),
                    })

    return rows


def build_dataframe(rows):
    df = pd.DataFrame(rows, columns=['Datum', 'Händelse', 'Referens', 'Belopp'])
    df['Datum'] = pd.to_datetime(df['Datum'], format='%Y-%m-%d', errors='coerce').dt.strftime('%Y-%m-%d')
    df = df.dropna(subset=['Datum'])
    df['Belopp'] = pd.to_numeric(df['Belopp'], errors='coerce')
    df = df.dropna(subset=['Belopp'])
    return df


def clean_existing_csv(path):
    df = pd.read_csv(path, sep=';', encoding='utf-8')
    df['Datum'] = pd.to_datetime(df['Datum'], errors='coerce').dt.strftime('%Y-%m-%d')
    df = df.dropna(subset=['Datum'])
    df['Belopp'] = pd.to_numeric(df['Belopp'], errors='coerce')
    df = df.dropna(subset=['Belopp'])
    return df


def resolve_pending(df_old, df_new):
    """Remove pending transactions matched by date+amount in the new PDF data. Warn about unmatched ones."""
    pending_mask = df_old['Händelse'].str.contains(PENDING_MARKER, na=False, regex=False)
    if not pending_mask.any():
        return df_old

    df_pending = df_old[pending_mask]
    df_history = df_old[~pending_mask]

    kept_pending = []
    resolved_count = 0

    for _, row in df_pending.iterrows():
        match = df_new[
            (df_new['Datum'] == row['Datum']) &
            (abs(df_new['Belopp'] - row['Belopp']) < 0.01)
        ]
        if not match.empty:
            resolved_count += 1
        else:
            kept_pending.append(row)

    if resolved_count:
        print(f"Resolved {resolved_count} pending transaction(s) with PDF data.")

    if kept_pending:
        print(f"\nWARNING: {len(kept_pending)} pending transaction(s) NOT matched in PDF (kept in CSV):")
        for row in kept_pending:
            print(f"  ! {row['Datum']} | {row['Händelse']} | {row['Referens']} | {row['Belopp']}")
        print("Review these manually — they may belong to a different PDF period.\n")
        return pd.concat([df_history, pd.DataFrame(kept_pending)], ignore_index=True)

    return df_history


def sort_df(df):
    return df.sort_values(
        by=['Datum', 'Händelse', 'Belopp'],
        ascending=[False, True, True],
    ).reset_index(drop=True)


def convert_carpay_pdf_to_csv(input_path, output_path, merge_source=None):
    rows = extract_transactions(input_path)
    if not rows:
        print("ERROR: No transactions found in PDF.")
        sys.exit(1)

    df_new = build_dataframe(rows)
    print(f"Extracted {len(df_new)} transaction(s) from '{input_path}'")

    merge_file = merge_source if merge_source else (output_path if os.path.exists(output_path) else None)

    if merge_file:
        try:
            print(f"Merging with existing history from '{merge_file}'...")
            df_old = clean_existing_csv(merge_file)
            df_old = resolve_pending(df_old, df_new)
            df_final = pd.concat([df_new, df_old], ignore_index=True)
            dedup_cols = ['Datum', 'Händelse', 'Referens', 'Belopp']
            df_final = df_final.drop_duplicates(subset=dedup_cols, keep='first')
        except Exception as e:
            print(f"Warning: Could not merge '{merge_file}': {e}. Proceeding with new data only.")
            df_final = df_new
    else:
        df_final = df_new

    df_final = sort_df(df_final)

    temp_path = output_path + '.tmp'
    df_final.to_csv(temp_path, sep=';', index=False, encoding='utf-8')

    # Safety check: refuse to write fewer rows than the existing file
    old_count = 0
    if os.path.exists(output_path):
        try:
            old_count = len(pd.read_csv(output_path, sep=';', encoding='utf-8'))
        except Exception:
            pass

    new_count = len(df_final)
    if os.path.exists(output_path) and new_count < old_count:
        print(f"CRITICAL ERROR: New file has fewer rows ({new_count}) than existing ({old_count}). Aborting.")
        os.remove(temp_path)
        sys.exit(1)

    # Atomic swap with backup
    if os.path.exists(output_path):
        backup_path = output_path + '.bak'
        if os.path.exists(backup_path):
            os.remove(backup_path)
        os.rename(output_path, backup_path)
        print(f"Backed up existing file to '{backup_path}'")

    os.rename(temp_path, output_path)
    print(f"Successfully wrote {new_count} transaction(s) to '{output_path}'")


def validate_csv(file_path):
    print(f"\nValidating '{file_path}'...")
    try:
        df = pd.read_csv(file_path, sep=';', encoding='utf-8')
        is_valid = True

        dupes = df[df.duplicated()]
        if not dupes.empty:
            print(f"WARNING: Found {len(dupes)} duplicate rows!")
            print(dupes)
            is_valid = False
        else:
            print("No duplicate rows found.")

        if 'Datum' in df.columns:
            dates = pd.to_datetime(df['Datum'], errors='coerce')
            if not dates.is_monotonic_decreasing:
                print("WARNING: Data is not sorted descending by Datum.")
                is_valid = False
            else:
                print("Sorting: OK (descending)")

        print("Validation complete.")
        return is_valid
    except Exception as e:
        print(f"Validation failed: {e}")
        return False


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Convert CarPay PDF statement to CSV.")
    parser.add_argument('input_file', help='Path to the input PDF file')
    parser.add_argument('output_file', help='Path to the output CSV file')
    parser.add_argument('--merge-source', default=None, help='Existing CSV to merge history from')
    parser.add_argument('--no-validate', action='store_true', help='Skip validation')
    args = parser.parse_args()

    if not os.path.exists(args.input_file):
        print(f"Error: Input file '{args.input_file}' not found.")
        sys.exit(1)

    convert_carpay_pdf_to_csv(args.input_file, args.output_file, merge_source=args.merge_source)

    if not args.no_validate:
        if validate_csv(args.output_file):
            backup_path = args.output_file + '.bak'
            if os.path.exists(backup_path):
                os.remove(backup_path)
                print(f"Validation passed. Backup '{backup_path}' deleted.")
        else:
            print("Validation failed. Backup preserved.")
            sys.exit(1)
