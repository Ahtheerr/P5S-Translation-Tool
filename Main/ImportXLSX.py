import pandas as pd
import csv
import os
import argparse
import sys

def apply_translations(excel_path, csv_folder):
    # 1. Check if inputs exist
    if not os.path.exists(excel_path):
        print(f"Error: Excel file not found at {excel_path}")
        sys.exit(1)
    if not os.path.exists(csv_folder):
        print(f"Error: CSV folder not found at {csv_folder}")
        sys.exit(1)

    print(f"Loading Excel file: {excel_path}...")
    try:
        # Load the Excel file object to access sheet names
        xls = pd.ExcelFile(excel_path)
    except Exception as e:
        print(f"Error opening Excel file: {e}")
        sys.exit(1)

    # ==========================================
    # PART 1: Process 'Main' Sheet (Update 96+)
    # ==========================================
    if 'Main' in xls.sheet_names:
        print("\n--- Processing 'Main' Sheet (Updating Translations) ---")
        
        # Read Main sheet
        # Ensure Line is integer and handle potential NaN in Translation
        df_main = pd.read_excel(xls, 'Main')
        
        # Verify columns exist
        required_cols = ['FileName', 'Line', 'Translation']
        if not all(col in df_main.columns for col in required_cols):
            print(f"Error: 'Main' sheet is missing one of these columns: {required_cols}")
            sys.exit(1)

        # Fill NaN translations with empty string
        df_main['Translation'] = df_main['Translation'].fillna('').astype(str)
        
        # Group by FileName to open each CSV only once
        grouped = df_main.groupby('FileName')

        for filename, group in grouped:
            file_path = os.path.join(csv_folder, filename)
            
            if not os.path.exists(file_path):
                print(f"Warning: {filename} not found in folder. Skipping.")
                continue

            # Read the original CSV content
            rows = []
            try:
                with open(file_path, 'r', encoding='utf-8', newline='') as f:
                    reader = csv.reader(f)
                    rows = list(reader)
            except Exception as e:
                print(f"Error reading {filename}: {e}")
                continue

            # Apply updates
            updates_count = 0
            for _, row in group.iterrows():
                line_num = int(row['Line'])
                new_text = row['Translation']
                
                # Calculate list index (Line 1 = Index 0)
                idx = line_num - 1

                # Safety check: ensure line exists and row is not empty
                if 0 <= idx < len(rows) and len(rows[idx]) > 0:
                    # Update ONLY the first column (OriginalText position)
                    rows[idx][0] = new_text
                    updates_count += 1
            
            # Write the updated CSV back
            try:
                with open(file_path, 'w', encoding='utf-8', newline='') as f:
                    writer = csv.writer(f)
                    writer.writerows(rows)
                # Optional: print(f"Updated {filename}: {updates_count} lines changed.")
            except Exception as e:
                print(f"Error writing {filename}: {e}")
    else:
        print("Warning: 'Main' sheet not found. Skipping translation updates.")

    # ==========================================
    # PART 2: Process Other Sheets (0-88)
    # ==========================================
    print("\n--- Extracting Individual Sheets (Overwriting 0-88) ---")
    
    for sheet_name in xls.sheet_names:
        if sheet_name == 'Main':
            continue

        # Construct filename (e.g., sheet "0" -> "0.csv")
        # If sheet names are just numbers, this works perfectly.
        target_filename = f"{sheet_name}.csv"
        target_path = os.path.join(csv_folder, target_filename)

        try:
            # Read sheet without header (assuming raw data)
            df_sheet = pd.read_excel(xls, sheet_name=sheet_name, header=None)
            
            # Write to CSV (overwrite)
            df_sheet.to_csv(target_path, index=False, header=False, encoding='utf-8')
            print(f"Extracted: {sheet_name} -> {target_filename}")
            
        except Exception as e:
            print(f"Error processing sheet '{sheet_name}': {e}")

    print("\n--- Operation Complete ---")

if __name__ == "__main__":
    # Set up CLI Argument Parsing
    parser = argparse.ArgumentParser(description="Apply translations from XLSX back to CSV files.")
    parser.add_argument("xlsx_file", help="Path to the input Excel (.xlsx) file")
    parser.add_argument("csv_folder", help="Path to the folder containing CSV files")

    args = parser.parse_args()

    apply_translations(args.xlsx_file, args.csv_folder)