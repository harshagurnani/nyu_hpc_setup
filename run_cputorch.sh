#!/bin/bash
#SBATCH --account=torch_pr_468_general
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=12G
#SBATCH --time=2:55:00
#SBATCH --job-name=runcpu
#SBATCH --error=/scratch/hg3206/logs/%x-%j.err
#SBATCH --output=/scratch/hg3206/logs/%x-%j.out
#SBATCH --gres=gpu:0
#SBATCH --cpus-per-task=8
#SBATCH --mail-type=BEGIN
#SBATCH --mail-user=hg3206@nyu.edu

set -euo pipefail
ENTRYPOINT_FILE=$(mktemp)
ENTRYPOINT_REPO="harshagurnani/nyu_hpc_setup"
ENTRYPOINT_COMMIT="7b3d468c7296232bcf87da84e7cd13730be6169c"
ENTRYPOINT_PATH="entrypoint.sh"
SCRIPT_URL="https://raw.githubusercontent.com/${ENTRYPOINT_REPO}/${ENTRYPOINT_COMMIT}/${ENTRYPOINT_PATH}"

curl -fsSL ${SCRIPT_URL} -o $ENTRYPOINT_FILE
exec 3<"$ENTRYPOINT_FILE"
rm "$ENTRYPOINT_FILE"

TMP_DIR_2=/scratch/hg3206/sing_tmp
SING_IMG=/scratch/hg3206/images/test_50G.sif
OVERLAY_PATH=/scratch/hg3206/test_50G.ext3
mkdir -p $TMP_DIR_2

singularity exec --nv --fakeroot --containall --cleanenv --no-home \
  --overlay ${OVERLAY_PATH}:rw \
  --bind /home/$USER/.ssh:/root/.ssh,/scratch/$USER/Github,${TMP_DIR_2}:/tmp,/scratch/$USER/CRCNS/,/scratch/$USER/DynamicsFits/ \
  ${SING_IMG} \
    bash <&3
