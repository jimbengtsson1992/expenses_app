import pandas as pd
import sys
import os

def convert_xlsx_to_csv(input_path, output_path):
    try:
        # Read the Excel file without assuming a header, to preserve original structure
        df = pd.read_excel(input_path, header=None, engine='openpyxl')
        
        # Function to format dates
        def format_date(x):
            if isinstance(x, pd.Timestamp):
                return x.strftime('%Y-%m-%d')
            return x

        # Apply date formatting to all elements in the dataframe
        df = df.map(format_date)
        
        # Write to CSV
        # sep=';' for semicolon delimiter
        # index=False to avoid writing row numbers
        # header=False because we read without header and want to keep original headers/rows as is
        df.to_csv(output_path, sep=';', index=False, header=False, encoding='utf-8')
        print(f"Successfully converted '{input_path}' to '{output_path}'")
        
    except Exception as e:
        print(f"Error converting file: {e}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 convert.py <input_xlsx_path> <output_csv_path>")
        sys.exit(1)
        
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    
    if not os.path.exists(input_file):
        print(f"Error: Input file '{input_file}' not found.")
        sys.exit(1)
        
    convert_xlsx_to_csv(input_file, output_file)
