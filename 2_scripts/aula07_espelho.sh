#!/usr/bin/env bash
# =============================================================================
#  AULA 07 — RAD-seq & SNP Calling: Stacks + Genética de Populações
#  Disciplina: CHS0007 — Bioinformática (PPGSIS/UFC)
#  Prof. Dr. Yan Torres | Junho–Julho 2026
#  Dataset: Gasterosteus aculeatus, 2 populações, Catchen et al. 2013
#  Acesso SRA: SRR034310 (SRP001747)
# =============================================================================
# ATENÇÃO: Este espelho NÃO é um script para rodar diretamente.
# Cada bloco é executado ao vivo com os alunos, um comando por vez.
# =============================================================================

# -----------------------------------------------------------------------------
# BLOCO 1 — Contexto e estrutura de diretórios
# -----------------------------------------------------------------------------
# O que faremos hoje:
#   - Entender o princípio do RAD-seq e como ele gera SNPs
#   - Demultiplexar reads brutos com process_radtags
#   - Montar loci de novo com denovo_map.pl (Stacks)
#   - Filtrar variantes com populations
#   - Visualizar estrutura populacional com PCA em R

# Primeiro: onde estamos?
pwd
ls

# Criar estrutura de pastas do projeto
mkdir -p ~/aula07_radseq/{raw,demux,stacks_out,populations_out,logs,info}
cd ~/aula07_radseq
ls

# -----------------------------------------------------------------------------
# BLOCO 2 — Download dos dados
# -----------------------------------------------------------------------------
# Dataset: SRR034310 — Gasterosteus aculeatus (espinheiro-de-três-espinhos)
#   16 indivíduos | 2 populações | Single-end ~36 bp | Enzima SbfI
#   Catchen et al. 2013, Mol. Ecology
#
# As reads brutas estão disponíveis no ENA (espelho europeu do SRA)
# wget é suficiente — não precisa instalar SRA Toolkit

wget -q "https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR034/SRR034310/SRR034310.fastq.gz" \
    -O 1_seqs/SRR034310.fastq.gz


ls -lh 1_seqs/SRR034310.fastq
zcat 1_seqs/SRR034310.fastq.gz | head -8
echo "Total de reads: $(( $(wc -l < 1_seqs/SRR034310.fastq) / 4 ))"

# -----------------------------------------------------------------------------
# BLOCO 3 — Preparar metadados
# -----------------------------------------------------------------------------
# Download do arquivo de metadados (barcode, população, indivíduo, acesso SRA)
wget -q "https://zenodo.org/record/1134547/files/Details_Barcode_Population_SRR034310.txt" \
     -O Details_Barcode_Population_SRR034310.txt

# Details_Barcode_Population_SRR034310.txt já está em 1_seqs/
# Colunas: barcode | população | nº indivíduo | acesso SRA | sem header

cat 1_seqs/Details_Barcode_Population_SRR034310.txt
wc -l 1_seqs/Details_Barcode_Population_SRR034310.txt

# Gerar barcodes_radtags.txt → formato exigido pelo process_radtags
# barcode <TAB> nome_amostra  (população sem espaço + número)
awk '{print $1"\t"$2"_"$3"_"$4}' \
    1_seqs/Details_Barcode_Population_SRR034310.txt > 1_seqs/barcodes_radtags.txt
cat 1_seqs/barcodes_radtags.txt

# Gerar popmap.txt → formato exigido pelo populations
# nome_amostra <TAB> população
# barcodes_radtags.txt: barcode <TAB> Pop_Num
awk '{print $2"_"$3"_"$4"\t"$2"_"$3}' \
    1_seqs/Details_Barcode_Population_SRR034310.txt > 1_seqs/popmap.txt
cat 1_seqs/popmap.txt

## Bloco novo (mudar o número)
bash count_reads.sh
nano 1_seqs/catalog_popmap.txt

head -8 reads_por_amostra.txt | awk '{print $2"\t"$3}' > 1_seqs/popmap_reduzido.txt
cat 1_seqs/popmap_reduzido.txt

printf "Rabbit_Slough_5\tRabbit_Slough\nRabbit_Slough_7\tRabbit_Slough\nBear_Paw_6\tBear_Paw\nBear_Paw_8\tBear_Paw\n" \
    > 1_seqs/catalog_popmap.txt
cat -A 1_seqs/catalog_popmap.txt

# -----------------------------------------------------------------------------
# BLOCO 4 — Demultiplexação com process_radtags
# -----------------------------------------------------------------------------
# process_radtags faz três coisas ao mesmo tempo:
#   1) Demultiplexa: separa as reads por barcode → um arquivo por indivíduo
#   2) Filtra qualidade: descarta reads ruins (-c e -q)
#   3) Trunca: garante comprimento uniforme (-t) — OBRIGATÓRIO para o Stacks
#
# Flags:
#   -f  : arquivo de reads brutos (single-end)
#   -o  : diretório de saída
#   -b  : arquivo de barcodes (barcode <TAB> nome_amostra)
#   -e  : enzima de restrição (sbfI)
#   -r  : corrige barcodes com até 1 erro (rescue)
#   -c  : descarta reads com bases N
#   -q  : descarta reads com qualidade média < 10 (janela deslizante)
#   -t 30 : trunca todas as reads para 30 bp após remover barcode + sítio
#
# Por que -t 30 e não Trimmomatic?
#   Este dataset tem reads de 36 bp (Illumina GAIIx, 2010).
#   Reads tão curtas raramente alcançam o adaptador — não há contaminação.
#   O Stacks exige comprimento UNIFORME: -t resolve QC e uniformidade juntos.
#
#   DADOS MODERNOS (150 bp PE): o fluxo muda —
#     1) Trimmomatic/Fastp → remove adaptadores e trimming 3'
#     2) process_radtags -t <comprimento_final> → demultiplexa + trunca

process_radtags \
    -f 1_seqs/SRR034310.fastq \
    -o 2_demux/ \
    -b 1_seqs/barcodes_radtags.txt \
    -e sbfI \
    -r -c -q \
    -t 30 \
    --out-type gzfastq

# Ver os arquivos de saída (um .fq.gz por amostra)
ls 2_demux/

# Quantas reads foram recuperadas por amostra?
for f in 2_demux/*.fq.gz; do
    n=$(zcat "$f" | wc -l)
    echo "$(basename $f .fq.gz): $(( n/4 )) reads"
done

# Arquivo de log — mostra retenção, rejeição por barcode, por qualidade
cat 2_demux/process_radtags.log | head -30


# -----------------------------------------------------------------------------
# BLOCO 5 — Inspeção dos dados demultiplexados
# -----------------------------------------------------------------------------
# Confirmar comprimento uniforme das reads (requisito do Stacks)
zcat 2_demux/Bear_Paw_1.fq.gz| awk 'NR%4==2 {print length($0)}' | sort | uniq -c
# Esperado: todos os valores = 30 (comprimento que definimos com -t 30)

# FastQC em uma amostra para confirmar qualidade pós-demultiplexação
fastqc 2_demux/Bear_Paw_1.fq.gz -o 3_fastqc/ 
echo "FastQC concluído → abrir 3_fastqc/Bear_Paw_1_fastqc.html"
# Observar: queda de qualidade nas bases 1–6 (sítio de corte SbfI = TGCAGG)
# Esse artefato é NORMAL em RAD-seq — todos os clusters iluminam juntos
# nessa posição, reduzindo a confiança do basecalling do sequenciador

# Opcional: FastQC em todas as amostras + MultiQC para visão geral
# fastqc 2_demux/*.fq -o logs/ --quiet -t 2
# multiqc logs/ -o logs/multiqc_report/


# -----------------------------------------------------------------------------
# BLOCO 6 — Montagem de loci de novo com denovo_map.pl
# -----------------------------------------------------------------------------
# O Stacks monta "pilhas" (stacks) de reads idênticas dentro de cada indivíduo,
# depois agrupa loci homólogos entre indivíduos via catálogo.
#
# Parâmetros principais do denovo_map.pl:
#   -M : distância máxima entre alelos dentro de uma amostra (padrão: 2)
#   -n : distância máxima entre loci no catálogo entre amostras (padrão: 1)
#   -m : cobertura mínima para criar um locus (padrão: 3)
#
# ATENÇÃO: esta etapa demora ~5–10 min no Codespace.
# Vamos iniciar o script auxiliar run_stacks.sh e continuar a aula.

echo "Iniciando run_stacks.sh em background..."
bash run_stacks.sh &> stacks_run.log &
echo "PID do processo: $!"
echo "Acompanhe o progresso: tail -f logs/stacks_run.log"

# Enquanto roda: discutir os parâmetros M, n, m nos slides
# e a lógica de construção do catálogo de loci

# Verificar se terminou:
# ls stacks_out/

# -----------------------------------------------------------------------------
# BLOCO 7 — Inspecionar saída do Stacks
# -----------------------------------------------------------------------------
# (executar após conclusão do denovo_map)

# Quantos loci foram montados?
cat stacks_out/denovo_map.log | grep "Assembled loci"
# ou inspecionar o arquivo de log do gstacks:
grep "assembled" stacks_out/gstacks.log

# Ver arquivos gerados por amostra
ls stacks_out/ | head -20

# Arquivo de loci de uma amostra (formato tsv comprimido)
zcat stacks_out/cs_1335.01.tags.tsv.gz | head -20

# Arquivo de SNPs brutos de uma amostra
zcat stacks_out/cs_1335.01.snps.tsv.gz | head -20
# Coluna 8 = tipo (E=erro, O=observado), coluna 9 = frequência do alelo

# -----------------------------------------------------------------------------
# BLOCO 8 — Filtragem e genética de populações com populations
# -----------------------------------------------------------------------------
# populations: último módulo do Stacks
# Aplica filtros, calcula estatísticas populacionais e exporta SNPs
#
# Flags principais:
#   -P  : diretório com output do Stacks
#   -O  : diretório de saída
#   -M  : population map
#   -p  : SNP deve estar presente em pelo menos N populações
#   -r  : SNP deve estar em pelo menos X% dos indivíduos de cada pop
#   --min-maf      : frequência mínima do alelo menor (MAF)
#   --write-single-snp : 1 SNP por locus (evita ligação)
#   --fstats       : calcula FST, π, Ho, He por população
#   --vcf          : exportar no formato VCF
#   --plink        : exportar no formato PLINK (.ped/.map)

populations \
    -P stacks_out/ \
    -O populations_out/ \
    -M info/popmap.txt \
    -p 2 \
    -r 0.75 \
    --min-maf 0.05 \
    --write-single-snp \
    --fstats \
    --vcf \
    --plink \
    -t 2

# Quantos SNPs passaram nos filtros?
grep -v "^#" populations_out/populations.snps.vcf | wc -l

# Ver as primeiras variantes no VCF
grep -v "^##" populations_out/populations.snps.vcf | head -4

# Quais arquivos foram gerados?
ls populations_out/

# -----------------------------------------------------------------------------
# BLOCO 9 — Estatísticas populacionais: diversidade + diferenciação
# -----------------------------------------------------------------------------
# O --fstats já calculou tudo. Vamos ler os TSVs diretamente.

# --- 9a. Diversidade por população ---
# sumstats_summary.tsv: π (diversidade nucleotídica), Ho, He por pop
echo "=== Diversidade por população ==="
cat populations_out/populations.sumstats_summary.tsv

# Extrair e comparar π entre populações com awk
echo ""
echo "=== π (diversidade nucleotídica) por população ==="
awk 'NR>1 {printf "Pop: %-12s  π = %.6f  Ho = %.6f  He = %.6f\n", $1, $7, $8, $9}' \
    populations_out/populations.sumstats_summary.tsv

# --- 9b. Diferenciação entre populações (FST) ---
# O arquivo fst_fw-oc.tsv tem FST por locus entre as duas populações
echo ""
echo "=== FST por locus (primeiros 10) ==="
awk 'NR<=11' populations_out/populations.fst_fw-oc.tsv

# Calcular FST médio e distribuição com awk
echo ""
echo "=== Sumário do FST (fw vs oc) ==="
awk 'NR>1 && $9!="nan" {
    n++; s+=$9;
    if ($9>max) max=$9;
    if (min=="" || $9<min) min=$9
}
END {
    print "N loci com FST:  " n
    print "FST médio:       " s/n
    print "FST mínimo:      " min
    print "FST máximo:      " max
}' populations_out/populations.fst_fw-oc.tsv

# Loci com FST alto (> 0.3) — candidatos a seleção divergente
echo ""
echo "=== Loci com FST > 0.3 (candidatos à seleção) ==="
awk 'NR>1 && $9>0.3 {print "Locus:", $1, "  FST:", $9}' \
    populations_out/populations.fst_fw-oc.tsv

# --- 9c. PCA com PLINK (100% shell) ---
echo ""
echo "=== PCA com PLINK ==="

# Verificar arquivos PLINK gerados pelo populations
ls populations_out/populations.ped populations_out/populations.map

# Rodar PCA: PLINK calcula os eigenvectors sem precisar de R
plink \
    --file populations_out/populations \
    --allow-extra-chr \
    --pca 10 \
    --out populations_out/pca_result

# Arquivos gerados:
#   pca_result.eigenval : variância explicada por cada PC
#   pca_result.eigenvec : coordenadas de cada indivíduo nos PCs

ls populations_out/pca_result.*

# Variância explicada pelos primeiros PCs
echo ""
echo "=== Variância explicada por PC ==="
awk '{total+=$1} END{t=total; rewind=1}
     FNR==NR{vals[NR]=$1; total+=$1; next}
     {printf "PC%d: %.2f%%\n", FNR, vals[FNR]/total*100}' \
    populations_out/pca_result.eigenval \
    populations_out/pca_result.eigenval

# Coordenadas dos indivíduos no PC1 e PC2 (por população)
echo ""
echo "=== Posição de cada indivíduo no PC1 / PC2 ==="
awk '{printf "%-20s pop=%-4s  PC1=%8.5f  PC2=%8.5f\n", $2, $1, $3, $4}' \
    populations_out/pca_result.eigenvec

# Verificar separação: média do PC1 por população
echo ""
echo "=== PC1 médio por população (separação esperada) ==="
awk '{pop[$1]+=$3; n[$1]++}
     END{for(p in pop) printf "Pop %-4s : PC1 médio = %8.5f\n", p, pop[p]/n[p]}' \
    populations_out/pca_result.eigenvec

# -----------------------------------------------------------------------------
# BLOCO 10 — Interpretação e fechamento
# -----------------------------------------------------------------------------

echo ""
echo "=== Interpretação dos resultados ==="

# Referência de valores de FST (Wright 1978):
# FST 0.00–0.05 → diferenciação pequena
# FST 0.05–0.15 → diferenciação moderada
# FST 0.15–0.25 → diferenciação grande
# FST > 0.25    → diferenciação muito grande

# Conexão com biodiversidade brasileira:
# A mesma abordagem (RAD-seq → Stacks → populations → PLINK PCA) é usada para:
#   - Arapaima gigas    : estrutura de estoques pesqueiros na Amazônia
#   - Podocnemis expansa: unidades de manejo de tartarugas
#   - Bothrops jararaca : filogeografia e conservação de serpentes
#   - Manacus manacus   : genômica de populações em fragmentos florestais

echo ""
echo "============================================="
echo " Aula 07 concluída!"
echo " Saídas principais:"
echo "   - demux/              : reads demultiplexadas (16 amostras)"
echo "   - stacks_out/         : loci montados + genótipos brutos"
echo "   - populations_out/    : SNPs filtrados, VCF, PLINK"
echo "   - populations.sumstats_summary.tsv : π, Ho, He por pop"
echo "   - populations.fst_fw-oc.tsv        : FST por locus"
echo "   - pca_result.eigenvec              : PCA (PLINK)"
echo ""
echo " Para análises avançadas (DAPC, divMigrate):"
echo "   Rscript analise_popgen_R.R"
echo "============================================="
