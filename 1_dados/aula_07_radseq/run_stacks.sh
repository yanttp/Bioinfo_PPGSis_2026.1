#!/usr/bin/env bash
# =============================================================================
#  run_stacks.sh — Script auxiliar: montagem de loci com denovo_map.pl
#  Aula 07 — CHS0007 Bioinformática (PPGSIS/UFC)
#  Prof. Dr. Yan Torres | 2026
# =============================================================================
# Este script roda a etapa mais demorada do pipeline Stacks (~5–15 min).
# Inicie-o no início da discussão teórica sobre parâmetros M/n/m.
#
# Uso:
#   bash run_stacks.sh &> stacks_run.log &
#   tail -f stacks_run.log
# =============================================================================

set -uo pipefail

SAMPLES_DIR="2_demux"
POPMAP="1_seqs/popmap_reduzido.txt"
CATALOG="1_seqs/catalog_popmap.txt"
OUT_DIR="4_stacks"
THREADS=2   # Codespace: 2 cores disponíveis

echo "============================================="
echo " run_stacks.sh iniciado: $(date)"
echo " Threads: ${THREADS}"
echo " Samples: ${SAMPLES_DIR}"
echo " Output:  ${OUT_DIR}"
echo "============================================="

mkdir -p "${OUT_DIR}"

# -----------------------------------------------------------------------------
# denovo_map.pl: wrapper que executa:
#   ustacks  → monta stacks por indivíduo
#   cstacks  → constrói catálogo de loci
#   sstacks  → busca amostras contra o catálogo
#   tsv2bam  → converte para BAM
#   gstacks  → genotyping
#
# O populations será rodado separadamente (bloco 8 do espelho)
# para permitir controle explícito dos filtros de qualidade.
#
# Parâmetros:
#   -M 2 : mismatches máximos entre alelos dentro de um indivíduo
#   -n 1 : mismatches máximos entre loci no catálogo entre indivíduos
#   -T   : número de threads
#   -d   : log detalhado
# -----------------------------------------------------------------------------

denovo_map.pl \
    -M 2 \
    -n 1 \
    -T "${THREADS}" \
    --samples "${SAMPLES_DIR}" \
    --popmap "${POPMAP}" \
    --catalog-popmap "${CATALOG}" \
    -o "${OUT_DIR}"

echo ""
echo "============================================="
echo " denovo_map.pl concluído: $(date)"
echo " Verifique os resultados em: ${OUT_DIR}/"
echo "============================================="

echo ""
echo "--- Arquivos gerados ---"
ls "${OUT_DIR}/"

echo ""
echo "--- Cobertura por amostra ---"
grep -A3 "cov_per_sample" "${OUT_DIR}/denovo_map.log" || true

echo ""
echo "Próximo passo: rodar populations manualmente"
echo "  ver bloco 8 do espelho aula07_espelho.sh"