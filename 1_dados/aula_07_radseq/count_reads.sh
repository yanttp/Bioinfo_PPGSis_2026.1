#!/usr/bin/env bash

# Contar reads por amostra em ordem decrescente
for f in 2_demux/*.fq.gz; do
    n=$(( $(zcat "$f" | wc -l) / 4 ))
    pop=$(basename "$f" | grep -oP "^[^_]+_[^_]+")
    echo -e "$n\t$(basename $f .fq.gz)\t$pop"
done | sort -k1 -rn | tee reads_por_amostra.txt
