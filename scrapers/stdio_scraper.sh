#!/bin/bash
set -xeu

# Usage: ./stdio_scraper.sh <repo_dir> <output_file>
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <repo_dir> <output_file>"
    exit 1
fi

repo_dir="$1"
outfile="$2"
repo_name=$(basename "$repo_dir")

# STDIO functions like fopen, fclose, fread, fwrite, fprintf, fscanf
grep -RIn -E "\b(fopen|fclose|fread|fwrite|fprintf|fscanf|fseek|ftell)\s*\(" "$repo_dir" 2>/dev/null | grep -v "::" | while IFS=: read -r file line text; do
    [[ "$text" =~ ^[[:space:]]*(fopen|fclose|fread|fwrite|fprintf|fscanf|fseek|ftell)[[:space:]]*[:=] ]] && continue
    func=$(grep -o -E '\b(fopen|fclose|fread|fwrite|fprintf|fscanf|fseek|ftell)\s*\(' <<< "$text" | head -n1 | sed 's/($//' | xargs)
    [[ -n "$func" ]] && echo "$repo_name:$file:$line:$func:$text" >> "$outfile"
done
