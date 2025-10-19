#!/bin/bash

set -xeu

# Usage: ./hdf5_scraper.sh <repo_dir> <output_file>
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <repo_dir> <output_file>"
    exit 1
fi

repo_dir="$1"
outfile="$2"
repo_name=$(basename "$repo_dir")

grep -RIn "H5[A-Za-z0-9_]*(" "$repo_dir" 2>/dev/null | grep -v "::" | while IFS=: read -r file line text; do
    [[ "$text" =~ ^[[:space:]]*H5[A-Za-z0-9_]*[[:space:]]*[:=] ]] && continue
    func=$(grep -o 'H5[A-Za-z0-9_]*(' <<< "$text" | head -n1 | sed 's/($//' | xargs)
    [[ -n "$func" ]] && echo "$repo_name:$file:$line:$func:$text" >> "$outfile"
done
