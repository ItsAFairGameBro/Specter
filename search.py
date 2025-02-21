import os

def search_for_line(folder_path, target_line_num=502, target_text="Text"):
    """
    Search all files in the specified folder for the target text on the specified line number.
    
    Args:
        folder_path (str): The directory to search in (default is current directory).
        target_line_num (int): The line number to check (1-based indexing, default is 502).
        target_text (str): The text to search for on that line (default is "Text").
    """
    # Supported file extensions (add more if needed)
    valid_extensions = ('.lua', '.py', '.txt', '.rbxs', '.rbxl')

    # Walk through the directory
    for root, _, files in os.walk(folder_path):
        for filename in files:
            if filename.lower().endswith(valid_extensions):
                file_path = os.path.join(root, filename)
                try:
                    with open(file_path, 'r', encoding='utf-8') as file:
                        # Read all lines into a list (1-based indexing for line numbers)
                        lines = file.readlines()
                        # Check if the file has at least target_line_num lines
                        if len(lines) >= target_line_num:
                            line = lines[target_line_num - 1]  # Adjust to 0-based index
                            if target_text in line:
                                print(f"Found '{target_text}' on line {target_line_num} in: {file_path}")
                                print(f"Line content: {line.strip()}")
                                print("-" * 50)
                except (UnicodeDecodeError, IOError) as e:
                    print(f"Error reading {file_path}: {e}")

def main():
    # Use the current working directory
    current_folder = os.getcwd()
    print(f"Searching in: {current_folder}")
    print(f"Looking for 'Text' on line 502 in all script files...")
    print("=" * 50)
    
    # Run the search
    search_for_line(current_folder)

if __name__ == "__main__":
    main()