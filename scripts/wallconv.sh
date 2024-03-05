#!/bin/bash

# Directory where the wallpapers are stored
wallpaper_dir="Pictures/walls"

# Test if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "ImageMagick is not installed"
    exit 1
fi

# Check if the input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path-to-image>"
    exit 1
fi

# Input file
input_file="$1"

# Check if the file exists
if [ ! -f "$input_file" ]; then
    echo "File not found: $input_file"
    exit 1
fi

# Extract filename without extension
filename=$(basename -- "$input_file")
filename="${filename%.*}"

# Move the file to the wallpaper directory
mv "$input_file" "$wallpaper_dir/$filename"

# Convert to WebP format using ImageMagick
convert "$wallpaper_dir/$filename" "$wallpaper_dir/$filename.webp"

# Remove the original file after conversion
rm "$wallpaper_dir/$filename"

# Renaming the file to follow a specific pattern
# Get the highest number in existing files and add 1
next_num=$(ls "$wallpaper_dir" | grep -oP 'wall-\K\d+' | sort -nr | head -n1)
next_num=$((next_num+1))

# Rename the webp file
mv "$wallpaper_dir/$filename.webp" "$wallpaper_dir/wall-$next_num.webp"

echo "File converted and moved as wall-$next_num.webp"
