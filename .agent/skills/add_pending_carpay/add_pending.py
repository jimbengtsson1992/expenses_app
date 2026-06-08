#!/usr/bin/env python3
"""Add a pending CarPay transaction to the CSV before the official PDF export arrives."""

import pandas as pd
import sys
import os
import argparse
from datetime import datetime

PENDING_MARKER = '[PENDING]'


def normalise_amount(s):
    s = str(s).strip().replace('\xa0', '').replace(' ', '')
    s = s.replace(',', '.')
    return float(s)


def add_pending_transaction(csv_path, date, station, city, amount_str):
    try:
        datetime.strptime(date, '%Y-%m-%d')
    except ValueError:
        print(f"ERROR: Date must be YYYY-MM-DD, got: {date}")
        sys.exit(1)

    try:
        amount = normalise_amount(amount_str)
        if amount <= 0:
            print(f"ERROR: Amount must be positive, got: {amount}")
            sys.exit(1)
    except (ValueError, AttributeError):
        print(f"ERROR: Invalid amount: {amount_str}")
        sys.exit(1)

    handelse = f"{station} {PENDING_MARKER}"

    new_row = {
        'Datum': date,
        'Händelse': handelse,
        'Referens': city,
        'Belopp': amount,
    }

    if os.path.exists(csv_path):
        df = pd.read_csv(csv_path, sep=';', encoding='utf-8')
        df['Belopp'] = pd.to_numeric(df['Belopp'], errors='coerce')
        df = df.dropna(subset=['Belopp'])
    else:
        df = pd.DataFrame(columns=['Datum', 'Händelse', 'Referens', 'Belopp'])

    already_exists = (
        (df['Datum'] == date) &
        (df['Händelse'] == handelse) &
        (df['Referens'] == city) &
        (abs(df['Belopp'] - amount) < 0.01)
    ).any()

    if already_exists:
        print("WARNING: Identical pending transaction already exists. Not adding duplicate.")
        sys.exit(0)

    df_new = pd.concat([df, pd.DataFrame([new_row])], ignore_index=True)
    df_new = df_new.sort_values(
        by=['Datum', 'Händelse', 'Belopp'],
        ascending=[False, True, True],
    ).reset_index(drop=True)

    temp_path = csv_path + '.tmp'
    df_new.to_csv(temp_path, sep=';', index=False, encoding='utf-8')

    backup_path = csv_path + '.bak'
    if os.path.exists(csv_path):
        if os.path.exists(backup_path):
            os.remove(backup_path)
        os.rename(csv_path, backup_path)

    os.rename(temp_path, csv_path)

    if os.path.exists(backup_path):
        os.remove(backup_path)

    print(f"Added: {date} | {handelse} | {city} | {amount}")
    print(f"CSV now has {len(df_new)} row(s): {csv_path}")


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="Add a pending CarPay transaction to the CSV."
    )
    parser.add_argument('csv_path', help='Path to the carpay CSV file')
    parser.add_argument('--date', required=True, help='Transaction date (YYYY-MM-DD)')
    parser.add_argument('--station', required=True, help='Station name as it will appear in the PDF receipt')
    parser.add_argument('--city', required=True, help='City/location')
    parser.add_argument('--amount', required=True, help='Amount in SEK (positive, e.g. 659.71)')
    args = parser.parse_args()

    add_pending_transaction(args.csv_path, args.date, args.station, args.city, args.amount)
