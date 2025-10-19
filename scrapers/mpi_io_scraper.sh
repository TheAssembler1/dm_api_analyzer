#!/bin/bash
set -xeu

# Usage: ./mpiio_scraper.sh <repo_dir> <output_file>
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <repo_dir> <output_file>"
    exit 1
fi

repo_dir="$1"
outfile="$2"
repo_name=$(basename "$repo_dir")

# MPI-IO functions usually start with MPI_File_ or MPI_
grep -RIn -E "MPI_File_[A-Za-z0-9_]*\s*\(|MPI_[A-Za-z0-9_]*\s*\(" "$repo_dir" 2>/dev/null | grep -v "::" | while IFS=: read -r file line text; do
    [[ "$text" =~ ^[[:space:]]*(MPI_File_|MPI_)[A-Za-z0-9_]*[[:space:]]*[:=] ]] && continue
    func=$(grep -o -E '(MPI_File_[A-Za-z0-9_]*|MPI_[A-Za-z0-9_]*)\s*\(' <<< "$text" | head -n1 | sed 's/($//' | xargs)
    [[ -n "$func" ]] && echo "$repo_name:$file:$line:$func:$text" >> "$outfile"
done

