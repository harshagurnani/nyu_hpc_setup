#!/bin/bash
#SBATCH --account=torch_pr_468_general
#SBATCH --job-name=build_img
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=16G
#SBATCH --time=00:55:00
#SBATCH --output=/scratch/hg3206/logs/build-img-%j.log
#SBATCH --error=/scratch/hg3206/logs/build-img-%j.err


IMAGE="test_50G"
OVERLAY_TYPE="overlay-50G-10M.ext3.gz"
OVERLAY_SRC="/share/apps/overlay-fs-ext3/${OVERLAY_TYPE}"
DEST_FILE="/scratch/${USER}/${IMAGE}.ext3"
SIF_PATH="/scratch/${USER}/images/${IMAGE}.sif"
DOCKER_URL="docker://harshagurnani/nyu_hpc_py310"

mkdir -p /scratch/${USER}/images
cp -rp ${OVERLAY_SRC} ${DEST_FILE}.gz
gunzip -f ${DEST_FILE}.gz
singularity build --force ${SIF_PATH} ${DOCKER_URL}