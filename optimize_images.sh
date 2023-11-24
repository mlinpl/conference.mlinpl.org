#!/usr/bin/env bash

ROOT_DIR=$( realpath $( dirname "${BASH_SOURCE[0]}" ) )

optimize_images () {
    directory=$1
    size=$2
    format=$3
    quality=$4
    input_directory="${ROOT_DIR}/images/${1}"
    output_directory="${ROOT_DIR}/images/optimized/${1}-${2}"

    echo "Optimizing images in images/${1}, saving to images/optimized/${1}-${2} ..."
    
    mkdir -p images/optimized
    rm -rf $output_directory
    cp -r $input_directory $output_directory
    cd $output_directory
    GLOBIGNORE="*.svg"
    #mogrify -resize ${size}^ -gravity Center -extent ${size} -format ${format} -quality ${quality} *
    mogrify -adaptive-resize ${size}\> -format ${format} -quality ${quality} *
    rm -f *.jpg *.jpeg *.png *.gif
    unset GLOBIGNORE
    cd $ROOT_DIR
}


# Optimize images of organizers and scientific board
optimize_images organizers 300x300 webp 90
optimize_images scientific-board 300x300 webp 90

# Optimize images of speakers
optimize_images previous-speakers 300x300 webp 90
optimize_images speakers 600x600 webp 90
optimize_images cfc 600x600 webp 90

# Optimize sponsors and partners logos
optimize_images sponsors 600x600 webp 90
optimize_images partners 600x600 webp 90
optimize_images previous-sponsors 300x300 webp 90
optimize_images honorary-patronages 600x600 webp 90

# Optimize AI-generated images
optimize_images ai-generated 800x800 webp 90
