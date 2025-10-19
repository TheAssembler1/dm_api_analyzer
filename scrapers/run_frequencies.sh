#!/bin/bash
set -xeu

# Usage: ./frequency.sh
# Loops over all scraper .dat files in the scrapers folder and counts function frequency

ROOT_DIR=/home/ta1/src/dm_api_analyzer

# List of scraper scripts
scrapers=(
    "$ROOT_DIR/scrapers/hdf5_scraper.sh"
    "$ROOT_DIR/scrapers/posix_scraper.sh"
    "$ROOT_DIR/scrapers/adios_scraper.sh"
    "$ROOT_DIR/scrapers/stdio_scraper.sh"
    "$ROOT_DIR/scrapers/mpi_io_scraper.sh"
)

for scraper in "${scrapers[@]}"; do
    dat_file="$scraper.dat"

    if [[ ! -f "$dat_file" ]]; then
        echo "Warning: $dat_file not found, skipping."
        continue
    fi

    echo "Processing frequency for $dat_file"

    # Count frequency per repo:function
    awk -F':' '{count[$1 ":" $4]++} END {for (k in count) print k ":" count[k]}' "$dat_file" \
        | sort -t':' -k1,1 -k3,3nr \
        > "${dat_file%.sh}_frequency.dat"

    echo "Output written to ${dat_file%.sh}_frequency.dat"
done

