#!/bin/bash
# Build standalone HTML presentation with embedded images
# Usage: ./build-standalone.sh [presentation-folder]
#   If no folder specified, uses current directory

PRESENTATION_DIR="${1:-.}"
cd "$PRESENTATION_DIR" || exit 1

INPUT="index.html"
DIRNAME=$(basename "$(pwd)")
OUTPUT="${DIRNAME}-standalone.html"

if [ ! -f "$INPUT" ]; then
    echo "Error: $INPUT not found in $(pwd)"
    exit 1
fi

cp "$INPUT" "$OUTPUT"

# Embed each PNG as base64
for img in *.png; do
    if [ -f "$img" ]; then
        base64_data=$(base64 -i "$img")
        sed -i '' "s|src=\"./$img\"|src=\"data:image/png;base64,$base64_data\"|g" "$OUTPUT"
        echo "Embedded: $img"
    fi
done

echo "Created: $OUTPUT ($(wc -c < "$OUTPUT" | tr -d ' ') bytes)"
