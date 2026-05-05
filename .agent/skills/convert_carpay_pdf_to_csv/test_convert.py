import unittest
import os
import sys
import tempfile
import pandas as pd

sys.path.insert(0, os.path.dirname(__file__))
from convert import normalise_amount, build_dataframe, sort_df, clean_existing_csv, DATE_PATTERN


class TestNormaliseAmount(unittest.TestCase):
    def test_simple_decimal(self):
        self.assertEqual(normalise_amount('644,32'), '644.32')

    def test_thousands_space(self):
        self.assertEqual(normalise_amount('1 304,03'), '1304.03')

    def test_already_dot(self):
        self.assertEqual(normalise_amount('659.71'), '659.71')

    def test_nbsp(self):
        # Non-breaking space as thousands separator
        self.assertEqual(normalise_amount('1\xa0304,03'), '1304.03')


class TestDatePattern(unittest.TestCase):
    def test_valid_date(self):
        self.assertTrue(DATE_PATTERN.match('2026-03-06'))

    def test_header_not_date(self):
        self.assertIsNone(DATE_PATTERN.match('Datum'))

    def test_subtotal_not_date(self):
        self.assertIsNone(DATE_PATTERN.match('Jim Bengtsson delsumma'))

    def test_summa_not_date(self):
        self.assertIsNone(DATE_PATTERN.match('Summa'))

    def test_empty_not_date(self):
        self.assertIsNone(DATE_PATTERN.match(''))


class TestBuildDataframe(unittest.TestCase):
    def test_basic(self):
        rows = [
            {'Datum': '2026-03-06', 'Händelse': 'Circle K Ulricehamn', 'Referens': 'Ulricehamn', 'Belopp': '644.32'},
            {'Datum': '2026-03-21', 'Händelse': 'St1 Sandsjobacka Vast', 'Referens': 'Lindome', 'Belopp': '659.71'},
        ]
        df = build_dataframe(rows)
        self.assertEqual(len(df), 2)
        self.assertEqual(list(df.columns), ['Datum', 'Händelse', 'Referens', 'Belopp'])

    def test_invalid_date_filtered(self):
        rows = [
            {'Datum': 'not-a-date', 'Händelse': 'X', 'Referens': 'Y', 'Belopp': '100.0'},
            {'Datum': '2026-03-06', 'Händelse': 'Circle K', 'Referens': 'Ulricehamn', 'Belopp': '644.32'},
        ]
        df = build_dataframe(rows)
        self.assertEqual(len(df), 1)


class TestSortDf(unittest.TestCase):
    def test_descending_date(self):
        rows = [
            {'Datum': '2026-03-06', 'Händelse': 'A', 'Referens': '', 'Belopp': '100.0'},
            {'Datum': '2026-03-21', 'Händelse': 'B', 'Referens': '', 'Belopp': '200.0'},
        ]
        df = build_dataframe(rows)
        df = sort_df(df)
        self.assertEqual(df.iloc[0]['Datum'], '2026-03-21')
        self.assertEqual(df.iloc[1]['Datum'], '2026-03-06')


class TestMergeAndDedup(unittest.TestCase):
    def test_dedup_on_same_row(self):
        """Rows identical across both imports should be deduplicated."""
        rows = [
            {'Datum': '2026-03-06', 'Händelse': 'Circle K Ulricehamn', 'Referens': 'Ulricehamn', 'Belopp': '644.32'},
        ]
        df_new = build_dataframe(rows)

        with tempfile.NamedTemporaryFile(suffix='.csv', mode='w', delete=False, encoding='utf-8') as f:
            df_new.to_csv(f, sep=';', index=False)
            tmp_path = f.name

        try:
            df_old = clean_existing_csv(tmp_path)
            import pandas as pd
            df_combined = pd.concat([df_new, df_old], ignore_index=True)
            dedup_cols = ['Datum', 'Händelse', 'Referens', 'Belopp']
            df_combined = df_combined.drop_duplicates(subset=dedup_cols, keep='first')
            self.assertEqual(len(df_combined), 1)
        finally:
            os.unlink(tmp_path)


class TestIntegration(unittest.TestCase):
    """Integration test against the real PDF (skipped if not present)."""

    PDF_PATH = os.path.join(
        os.path.dirname(__file__), '..', '..', '..', 'assets', 'data', 'kontoutdrag-202603.pdf'
    )

    def setUp(self):
        self.pdf_path = os.path.normpath(self.PDF_PATH)
        if not os.path.exists(self.pdf_path):
            self.skipTest(f"PDF not found at {self.pdf_path}")

    def test_extracts_two_transactions(self):
        from convert import extract_transactions
        rows = extract_transactions(self.pdf_path)
        self.assertEqual(len(rows), 2)

    def test_correct_dates(self):
        from convert import extract_transactions
        rows = extract_transactions(self.pdf_path)
        dates = sorted(r['Datum'] for r in rows)
        self.assertEqual(dates, ['2026-03-06', '2026-03-21'])

    def test_correct_amounts(self):
        from convert import extract_transactions
        rows = extract_transactions(self.pdf_path)
        amounts = sorted(float(r['Belopp']) for r in rows)
        self.assertAlmostEqual(amounts[0], 644.32, places=2)
        self.assertAlmostEqual(amounts[1], 659.71, places=2)

    def test_full_conversion(self):
        from convert import convert_carpay_pdf_to_csv, validate_csv
        with tempfile.NamedTemporaryFile(suffix='.csv', delete=False) as f:
            out_path = f.name
        os.unlink(out_path)  # let the script create it

        try:
            convert_carpay_pdf_to_csv(self.pdf_path, out_path)
            df = pd.read_csv(out_path, sep=';', encoding='utf-8')
            self.assertEqual(len(df), 2)
            self.assertTrue(validate_csv(out_path))
        finally:
            for p in [out_path, out_path + '.bak', out_path + '.tmp']:
                if os.path.exists(p):
                    os.unlink(p)


if __name__ == '__main__':
    unittest.main()
