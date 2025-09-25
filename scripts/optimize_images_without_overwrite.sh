#!/usr/bin/env bash

ROOT_DIR=$( realpath $( dirname "${BASH_SOURCE[0]}" ) )/..

# Default value for overwrite is false (do not overwrite)
OVERWRITE=false

# Parse command line arguments
while getopts ":o" opt; do
  case ${opt} in
    o )
      OVERWRITE=true
      ;;
    \? )
      echo "Usage: $0 [-o]"
      echo "  -o    Overwrite existing optimized image files"
      exit 1
      ;;
  esac
done

optimize_images () {
    directory=$1
    size=$2
    format=$3
    quality=$4
    input_directory="${ROOT_DIR}/images/${1}"
    output_directory="${ROOT_DIR}/images/optimized/${1}-${2}"

    if [ ! -d "$input_directory" ]; then
        echo "Input directory $input_directory does not exist. Skipping..."
        return
    fi

    echo "Optimizing images in images/${1}, saving to images/optimized/${1}-${2} ..."
    
    mkdir -p "$output_directory"

    cd "$input_directory"
    for file in *; do
        if [[ "$file" != *.svg ]]; then
            output_file="${output_directory}/${file%.*}.${format}"
            if [ "$OVERWRITE" = true ] || [ ! -f "$output_file" ]; then
                echo "Processing $file..."
                convert "$file" -adaptive-resize "${size}>" -quality "${quality}" "$output_file"
            else
                echo "Skipping $file (already exists)"
            fi
        fi
    done
    cd "$ROOT_DIR"
}

# Optimize images of organizers and advisory-board
optimize_images organizers 300x300 webp 90
optimize_images advisory-board 300x300 webp 90

# Optimize images of speakers
optimize_images previous-speakers 300x300 webp 90
optimize_images speakers 600x600 webp 90
optimize_images cfc 600x600 webp 90
optimize_images tutorials 600x600 webp 90

# Optimize sponsors and partners logos
optimize_images sponsors 600x600 webp 90
optimize_images partners 600x600 webp 90
optimize_images previous-sponsors 300x300 webp 90
optimize_images honorary-patronages 600x600 webp 90

# Optimize AI-generated images
optimize_images ai-generated 800x800 webp 90