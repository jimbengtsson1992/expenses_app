import unittest
import os
import pandas as pd
import shutil
from openpyxl import Workbook
from convert import convert_xlsx_to_csv

class TestConvert(unittest.TestCase):
    def setUp(self):
        self.test_dir = 'test_temp'
        if not os.path.exists(self.test_dir):
            os.makedirs(self.test_dir)
            
        self.xlsx_path = os.path.join(self.test_dir, 'new_transactions.xlsx')
        self.csv_path = os.path.join(self.test_dir, 'merged.csv')
        
    def tearDown(self):
        if os.path.exists(self.test_dir):
            shutil.rmtree(self.test_dir)

    def create_dummy_xlsx(self, data, metadata=None):
        wb = Workbook()
        ws = wb.active
        
        # Write metadata
        if metadata:
            for row in metadata:
                ws.append(row)
        else:
            ws.append(['Transaktionsexport', '', '', '', '', '', '2026-02-08 14:00:00'])
            ws.append([])
            ws.append(['Totalt övriga händelser', '', '', '', '', '', '']) # This should be cleaned!
            
        # Write Header (Row 4)
        ws.append(['Datum', 'Bokfört', 'Specifikation', 'Ort', 'Valuta', 'Utl. belopp', 'Belopp'])
        
        # Write Data
        for row in data:
            ws.append(row)
            
        wb.save(self.xlsx_path)

    def create_dummy_csv(self, data):
        # Create user-like CSV with 3 metadata lines + header + data
        with open(self.csv_path, 'w') as f:
            f.write("Transaktionsexport;;;;;;2025-01-01 12:00:00\n")
            f.write(";;;;;;\n")
            f.write(";;;;;;\n") # Cleaned header
            f.write("Datum;Bokfört;Specifikation;Ort;Valuta;Utl. belopp;Belopp\n")
            for row in data:
                # row is list
                line = ';'.join(map(str, row))
                f.write(line + '\n')

    def test_basic_conversion(self):
        # 2026-02-01
        data = [['2026-02-01', '2026-02-02', 'Test Transaction', 'City', 'SEK', 0, 100.0]]
        self.create_dummy_xlsx(data)
        
        convert_xlsx_to_csv(self.xlsx_path, self.csv_path)
        
        with open(self.csv_path, 'r') as f:
            content = f.read()
            # Output is now forced to float, so we expect 0.0 and 100.0
            self.assertIn('2026-02-01;2026-02-02;Test Transaction;City;SEK;0.0;100.0', content)
            
    def test_merge_with_overlap(self):
        # OLD DATA: Transaction A, Transaction B
        # NEW DATA: Transaction B (overlap), Transaction C
        
        old_data = [
            ['2026-01-01', '2026-01-02', 'Transaction A', 'City', 'SEK', 0, 100],
            ['2026-01-02', '2026-01-03', 'Transaction B', 'City', 'SEK', 0, 200]
        ]
        self.create_dummy_csv(old_data)
        
        new_data = [
            ['2026-01-02', '2026-01-03', 'Transaction B', 'City', 'SEK', 0, 200], # Duplicate
            ['2026-01-03', '2026-01-04', 'Transaction C', 'City', 'SEK', 0, 300]
        ]
        self.create_dummy_xlsx(new_data)
        
        convert_xlsx_to_csv(self.xlsx_path, self.csv_path)
        
        # Read result
        # Check that we have A, B, C exactly once
        df = pd.read_csv(self.csv_path, sep=';', skiprows=3)
        self.assertEqual(len(df), 3)
        self.assertEqual(df.iloc[0]['Specifikation'], 'Transaction C') # Sorted desc?
        self.assertEqual(df.iloc[2]['Specifikation'], 'Transaction A')

    def test_header_cleaning(self):
        # Metadata with "Totalt övriga händelser"
        data = [['2026-02-01', '2026-02-02', 'Test', 'City', 'SEK', 0, 100]]
        self.create_dummy_xlsx(data)
        
        convert_xlsx_to_csv(self.xlsx_path, self.csv_path)
        
        with open(self.csv_path, 'r') as f:
            lines = f.readlines()
            # Line 3 (index 2) should NOT contain "Totalt övriga"
            self.assertNotIn('Totalt övriga', lines[2])
            
    def test_garbage_row_deduplication(self):
        # Create CSV with a garbage footer row that mimics data but isn't
        with open(self.csv_path, 'w') as f:
            f.write("Meta\nMeta\nMeta\n")
            f.write("Datum;Bokfört;Specifikation;Ort;Valuta;Utl. belopp;Belopp\n")
            f.write("2026-01-01;2026-01-02;Test Old;City;SEK;0;100\n")
            f.write("Summa köp/uttag;;;;100\n") # Garbage
            
        new_data = [['2026-01-02', '2026-01-03', 'Test New', 'City', 'SEK', 0, 200]]
        self.create_dummy_xlsx(new_data)
        
        convert_xlsx_to_csv(self.xlsx_path, self.csv_path)
        
        df = pd.read_csv(self.csv_path, sep=';', skiprows=3)
        # Should have 2 rows: Test New, Test Old. Garbage should be gone.
        self.assertEqual(len(df), 2)
        specs = df['Specifikation'].tolist()
        self.assertIn('Test Old', specs)
        self.assertIn('Test New', specs)
        self.assertNotIn('Summa köp/uttag', specs)

    def test_specific_row_existence(self):
        # Test specific row requested by user:
        # 2024-11-27;2024-12-02;W*MMSPORTS.SE;ASKIM;SEK;0.0;1581.0
        
        # Note: In create_dummy_xlsx, we pass raw values.
        # If we pass floats 0.0 and 1581.0, pandas might format them as 0.0 and 1581.0
        # or it might truncate .0 depending on dtype.
        # However, to guarantee the EXACT string output the user wants,
        # we should ensure the data mimics how it comes from the real Excel file 
        # (which might be numeric or text). 
        # I'll use floats here as they are most likely in Excel.
        data = [['2024-11-27', '2024-12-02', 'W*MMSPORTS.SE', 'ASKIM', 'SEK', 0.0, 1581.0]]
        self.create_dummy_xlsx(data)
        
        convert_xlsx_to_csv(self.xlsx_path, self.csv_path)
        
        with open(self.csv_path, 'r') as f:
            content = f.read()
            # The user explicitly asked for this exact string
            expected = "2024-11-27;2024-12-02;W*MMSPORTS.SE;ASKIM;SEK;0.0;1581.0"
            self.assertIn(expected, content)

if __name__ == '__main__':
    unittest.main()
