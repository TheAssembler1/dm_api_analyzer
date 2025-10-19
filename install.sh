#!/bin/bash

set -xeu

# List of GitHub repository URLs
repos=(
    "https://github.com/lammps/lammps"
    "https://github.com/OpenFOAM/OpenFOAM-dev"
    "https://github.com/cp2k/cp2k"
    "https://github.com/MPAS-Dev/MPAS-Model"
    "https://gitlab.kitware.com/paraview/paraview"
    "https://github.com/visit-dav/visit"
    "https://github.com/SENSEI-insitu/SENSEI"
    "https://github.com/deepmodeling/deepmd-kit"
    "ahttps://github.com/MLforPhysics/ML4Physics"
    "https://github.com/DeepChem/DeepChem"
    "https://github.com/google-deepmind/graph_nets"
    "https://github.com/Mantevo/miniFE"
    "https://github.com/hpc/ior"
    "https://github.com/IO500/IO500"
    "https://github.com/QEF/q-e"
    "https://gitlab.com/gromacs/gromacs"
    "https://github.com/UIUC-PPL/charm"
    "https://github.com/MPAS-Dev/MPAS-Model"
)

mkdir ./repositories || true

for repo in "${repos[@]}"; do
    echo "Checking $repo ..."
    if git ls-remote "$repo" &> /dev/null; then
        echo "✅ Repo exists... Downloading."
	pushd ./repositories
	git clone "$repo"
	popd
    else
        echo "❌ Repo does not exist or is inaccessible"
    fi
done
