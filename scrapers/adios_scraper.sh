#!/bin/bash
set -xeu

# Usage: ./adios_scraper.sh <repo_dir> <output_file>
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <repo_dir> <output_file>"
    exit 1
fi

repo_dir="$1"
outfile="$2"
repo_name=$(basename "$repo_dir")

# ADIOS functions usually start with "adios_" or "ADIOS_"
grep -RIn -E "adios_[A-Za-z0-9_]*\s*\(|ADIOS_[A-Za-z0-9_]*\s*\(" "$repo_dir" 2>/dev/null | grep -v "::" | while IFS=: read -r file line text; do
    [[ "$text" =~ ^[[:space:]]*(adios_|ADIOS_)[A-Za-z0-9_]*[[:space:]]*[:=] ]] && continue
    func=$(grep -o -E '(adios_[A-Za-z0-9_]*|ADIOS_[A-Za-z0-9_]*)\s*\(' <<< "$text" | head -n1 | sed 's/($//' | xargs)
    [[ -n "$func" ]] && echo "$repo_name:$file:$line:$func:$text" >> "$outfile"
done

