#!/bin/bash

set -xeu

ROOT_DIR=/home/ta1/src/dm_api_analyzer

# List of scraper scripts
scrapers=(
    "$ROOT_DIR/scrapers/hdf5_scraper.sh"
    "$ROOT_DIR/scrapers/posix_scraper.sh"
    "$ROOT_DIR/scrapers/adios_scraper.sh"
    "$ROOT_DIR/scrapers/stdio_scraper.sh"
    "$ROOT_DIR/scrapers/mpi_io_scraper.sh"
)

# Automatically pick up all directories in the repositories folder
repos=( "$ROOT_DIR/repositories"/*/ )

# Remove trailing slashes from repo names
repos=( "${repos[@]%/}" )

for repo in "${repos[@]}"; do
    echo "Processing repository: $repo"

    for scraper in "${scrapers[@]}"; do
        echo "  Running scraper: $scraper"
        bash "$scraper" "$repo" "$scraper.dat"
    done
done

