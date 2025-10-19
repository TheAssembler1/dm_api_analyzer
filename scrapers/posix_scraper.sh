#!/bin/bash

set -xeu

# Usage: ./posix_scraper.sh <repo_dir> <output_file>
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <repo_dir> <output_file>"
    exit 1
fi

repo_dir="$1"
outfile="$2"
repo_name=$(basename "$repo_dir")

# POSIX I/O functions like open, read, write, close, lseek, etc.
grep -RIn -E "\b(open|read|write|close|lseek|fsync|pread|pwrite)\s*\(" "$repo_dir" 2>/dev/null | grep -v "::" | while IFS=: read -r file line text; do
    [[ "$text" =~ ^[[:space:]]*(open|read|write|close|lseek|fsync|pread|pwrite)[[:space:]]*[:=] ]] && continue
    func=$(grep -o -E '\b(open|read|write|close|lseek|fsync|pread|pwrite)\s*\(' <<< "$text" | head -n1 | sed 's/($//' | xargs)
    [[ -n "$func" ]] && echo "$repo_name:$file:$line:$func:$text" >> "$outfile"
done

