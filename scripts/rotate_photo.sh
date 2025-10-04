#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input.webp> <output.webp>"
    exit 1
fi

INPUT_FILE=$1
OUTPUT_FILE=$2

# Check if the input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' not found!"
    exit 1
fi

# Temporary file for intermediate PNG
TEMP_FILE=$(mktemp --suffix=.png)

# Decode WebP to PNG
dwebp "$INPUT_FILE" -o "$TEMP_FILE"
if [ $? -ne 0 ]; then
    echo "Error: Failed to decode WebP file."
    rm -f "$TEMP_FILE"
    exit 1
fi

# Rotate the PNG by 90 degrees
convert "$TEMP_FILE" -rotate 90 "$TEMP_FILE"
if [ $? -ne 0 ]; then
    echo "Error: Failed to rotate the image."
    rm -f "$TEMP_FILE"
    exit 1
fi

# Encode the rotated PNG back to WebP
cwebp "$TEMP_FILE" -o "$OUTPUT_FILE"
if [ $? -ne 0 ]; then
    echo "Error: Failed to encode the rotated image to WebP."
    rm -f "$TEMP_FILE"
    exit 1
fi

# Clean up temporary file
rm -f "$TEMP_FILE"

echo "Rotation complete: '$INPUT_FILE' -> '$OUTPUT_FILE'"