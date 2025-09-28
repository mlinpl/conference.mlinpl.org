import os
import re
import sys
import unicodedata


def normalize(text):
    nfkd =  unicodedata.normalize("NFKD", text)
    ascii_only = "".join([c for c in nfkd if not unicodedata.combining(c)])
    ascii_only = ascii_only.replace("ł", "l").replace("Ł", "L")
    return "".join(ascii_only)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python rename_files_polish_to_ascii.py <directory>")
        sys.exit(1)

    input_directory = sys.argv[1]

    for filename in os.listdir(input_directory):
        new_filename = normalize(filename)
        src = os.path.join(input_directory, filename)
        dst = os.path.join(input_directory, new_filename)
        os.rename(src, dst)
        print(f"Renamed: {src} -> {dst}")
