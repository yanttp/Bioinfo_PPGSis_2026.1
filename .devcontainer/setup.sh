#!/usr/bin/env bash
set -euo pipefail

source /home/vscode/miniforge3/etc/profile.d/conda.sh
source /home/vscode/miniforge3/etc/profile.d/mamba.sh
export MAMBA_ROOT_PREFIX=/home/vscode/miniforge3

echo "╔══════════════════════════════════════════════════════════╗"
echo "║   Bioinformática PPGSIS 2026 — Configuração do ambiente  ║"
echo "╚══════════════════════════════════════════════════════════╝"

# 1. Ambiente principal
echo "[1/4] Criando ambiente bioinfo..."
mamba env create -f .devcontainer/environment.yml

# 2. Ativa e instala pacotes R via Bioconductor
echo "[2/4] Instalando pacotes R..."
conda run -n bioinfo Rscript -e "
  install.packages('BiocManager', repos='https://cloud.r-project.org', quiet=TRUE)
  BiocManager::install('phyloseq', ask=FALSE, quiet=TRUE)
  install.packages('poppr', repos='https://cloud.r-project.org', quiet=TRUE)
"

# 3. InSilicoSeq para datasets sintéticos
echo "[3/4] Instalando InSilicoSeq..."
conda run -n bioinfo pip install InSilicoSeq --quiet

# 4. Ativa bioinfo por padrão
echo "[4/4] Configurando shell..."
echo "source /home/vscode/miniforge3/etc/profile.d/conda.sh" >> ~/.bashrc
echo "source /home/vscode/miniforge3/etc/profile.d/mamba.sh" >> ~/.bashrc
echo "export MAMBA_ROOT_PREFIX=/home/vscode/miniforge3" >> ~/.bashrc
echo "conda activate bioinfo" >> ~/.bashrc

echo ""
echo "✅ Ambiente configurado! Rode: bash .devcontainer/verificar.sh"
