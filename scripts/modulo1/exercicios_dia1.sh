#!/usr/bin/env bash
# =============================================================================
#
#   BIOINFORMÁTICA — PPGSIS/UFC 2026/1
#   Módulo 1 — Exercícios da Aula 1
#   Dr. Yan Torres
#
# =============================================================================
#
#   INSTRUÇÕES
#   ─────────────────────────────────────────────────────────────────────────
#   • Faça os exercícios EM ORDEM — cada um prepara o próximo
#   • Escreva seus comandos nos espaços indicados abaixo de cada exercício
#   • Compare com o gabarito DEPOIS de tentar (professor fornece ao final)
#   • Se travar: releia a aula, tente de novo, depois pergunte
#
#   Dados disponíveis em:  scripts/modulo1/dados/
#     • sequencias_exemplo.fasta  — 5 sequências de bactérias brasileiras
#     • metadados.tsv             — 10 amostras com metadados
#     • exemplo_reads.fastq       — 5 reads simulados de sequenciamento
#
# =============================================================================


# ─────────────────────────────────────────────────────────────────────────
#  BLOCO A — Navegação e exploração (básico)
# ─────────────────────────────────────────────────────────────────────────

# A1. Vá para o diretório de dados do Módulo 1 e liste seu conteúdo
#     mostrando tamanho legível e ordem por data.
#     Resultado esperado: 3 arquivos listados com tamanhos em KB/B
# ── Seu comando: ────────────────────────────────────────────────────────


# A2. Quantas linhas tem o arquivo metadados.tsv?
#     (Dica: use wc -l)
#     Resultado esperado: 11 linhas (1 cabeçalho + 10 amostras)
# ── Seu comando: ────────────────────────────────────────────────────────


# A3. Mostre apenas as 3 primeiras linhas do metadados.tsv.
#     Resultado esperado: cabeçalho + 2 primeiras amostras (CB_001, CB_002)
# ── Seu comando: ────────────────────────────────────────────────────────


# A4. Mostre as últimas 2 linhas do metadados.tsv.
#     Resultado esperado: FT_001 e FT_002
# ── Seu comando: ────────────────────────────────────────────────────────


# ─────────────────────────────────────────────────────────────────────────
#  BLOCO B — grep e filtragem
# ─────────────────────────────────────────────────────────────────────────

# B1. Liste todas as amostras coletadas na Caatinga.
#     Resultado esperado: 4 linhas (BS_001, BS_002, SM_001, SM_002)
# ── Seu comando: ────────────────────────────────────────────────────────


# B2. Quantas amostras têm qualidade de DNA "boa"?
#     (Dica: grep -c)
#     Resultado esperado: 6
# ── Seu comando: ────────────────────────────────────────────────────────


# B3. Encontre todas as amostras coletadas pelo coletor "R.Costa".
#     Resultado esperado: AN_001 e AN_002
# ── Seu comando: ────────────────────────────────────────────────────────


# B4. Liste os cabeçalhos (headers) do arquivo FASTA.
#     Resultado esperado: 5 linhas, cada uma começando com ">"
#     (Dica: em FASTA, cabeçalhos começam com ">")
# ── Seu comando: ────────────────────────────────────────────────────────


# ─────────────────────────────────────────────────────────────────────────
#  BLOCO C — cut, sort, uniq e pipes
# ─────────────────────────────────────────────────────────────────────────

# C1. Extraia apenas a coluna "estado" (coluna 4) do metadados.tsv,
#     sem o cabeçalho, e ordene alfabeticamente.
#     Resultado esperado: AM, CE, DF, GO, MS, MT, PA, PE, PI, RN
# ── Seu comando: ────────────────────────────────────────────────────────


# C2. Quantos estados únicos estão representados nos dados?
#     Resultado esperado: 10
#     (Dica: encadeie cut | grep | sort | uniq | wc)
# ── Seu comando: ────────────────────────────────────────────────────────


# C3. Faça um ranking de quantas amostras há por bioma,
#     da mais representada para a menos.
#     Resultado esperado:
#       4 Caatinga
#       2 Amazônia
#       2 Cerrado
#       2 Pantanal
# ── Seu comando: ────────────────────────────────────────────────────────


# C4. Liste os organismos únicos presentes no arquivo,
#     com o PRIMEIRO NOME em maiúscula.
#     Resultado esperado: 5 organismos
# ── Seu comando: ────────────────────────────────────────────────────────


# ─────────────────────────────────────────────────────────────────────────
#  BLOCO D — Redirecionamento e criação de arquivos
# ─────────────────────────────────────────────────────────────────────────

# D1. Salve a lista de todas as amostras da Amazônia em um arquivo
#     chamado "amostras_amazonia.txt" dentro de pratica/aula01/resultados/
#     Verifique com cat depois.
# ── Seu comando: ────────────────────────────────────────────────────────


# D2. Crie um arquivo chamado "resumo_qualidade.txt" com:
#     - Uma linha dizendo "=== Qualidade de DNA por amostra ==="
#     - Em seguida, as colunas amostra_id e qualidade_dna do metadados
#     (Dica: use echo para a primeira linha e >> para acrescentar)
# ── Seu comando: ────────────────────────────────────────────────────────


# ─────────────────────────────────────────────────────────────────────────
#  BLOCO E — seqkit (ferramentas de sequências)
# ─────────────────────────────────────────────────────────────────────────

# E1. Obtenha estatísticas básicas do arquivo FASTA.
#     Quantas sequências há? Qual o comprimento total?
# ── Seu comando: ────────────────────────────────────────────────────────


# E2. Liste apenas os IDs (sem a descrição completa) das sequências FASTA.
#     Resultado esperado: 5 linhas com apenas o nome do organismo
#     (Dica: seqkit seq --name --only-id)
# ── Seu comando: ────────────────────────────────────────────────────────


# E3. Extraia apenas a sequência de Bacillus subtilis do arquivo FASTA
#     e salve em "bacillus.fasta" em pratica/aula01/resultados/
#     (Dica: seqkit grep -p "Bacillus")
# ── Seu comando: ────────────────────────────────────────────────────────


# E4. Quantos reads tem o arquivo exemplo_reads.fastq?
#     Calcule de duas formas: (a) wc -l dividido por 4, (b) seqkit stats
# ── Seus comandos: ──────────────────────────────────────────────────────


# ─────────────────────────────────────────────────────────────────────────
#  BLOCO F — Scripts e loops (avançado)
# ─────────────────────────────────────────────────────────────────────────

# F1. Crie um script chamado "listar_caatinga.sh" que:
#     - Imprime "=== Amostras da Caatinga ==="
#     - Lista todas as amostras coletadas na Caatinga
#     - Imprime o total ao final: "Total: X amostras"
#     Salve em pratica/aula01/scripts/ e execute com bash
# ── Seu script: ─────────────────────────────────────────────────────────


# F2. Escreva um loop que itere pelos biomas únicos do metadados.tsv
#     e para cada um imprima:
#     "Bioma: NOME → N amostras"
#
#     Resultado esperado:
#     Bioma: Amazônia → 2 amostras
#     Bioma: Caatinga → 4 amostras
#     Bioma: Cerrado → 2 amostras
#     Bioma: Pantanal → 2 amostras
#
#     (Dica: use um while para ler os biomas únicos e grep -c para contar)
# ── Seu loop: ───────────────────────────────────────────────────────────


# ─────────────────────────────────────────────────────────────────────────
#  BLOCO G — Git: salve seu trabalho (obrigatório!)
# ─────────────────────────────────────────────────────────────────────────

# G1. Verifique o status do repositório para ver o que mudou
# ── Seu comando: ────────────────────────────────────────────────────────


# G2. Adicione TODOS os arquivos da sua pasta pratica/aula01/ ao stage
# ── Seu comando: ────────────────────────────────────────────────────────


# G3. Faça um commit com a mensagem:
#     "feat: exercícios da Aula 1 — linux e bash"
# ── Seu comando: ────────────────────────────────────────────────────────


# G4. Envie para o GitHub
# ── Seu comando: ────────────────────────────────────────────────────────


# G5. Confirme: abra github.com/SEU_USUARIO/Bioinfo_PPGSis_2026.1
#     e verifique se os arquivos aparecem lá.
# ── Verificado? ─────────────────────────────────────────────────────────


# ═══════════════════════════════════════════════════════════════════════════
#  DESAFIO EXTRA (opcional — para quem terminar cedo)
# ═══════════════════════════════════════════════════════════════════════════

# DESAFIO: Crie um script chamado "painel_amostras.sh" que:
#
#   1. Recebe como argumento um bioma (ex: bash painel_amostras.sh Caatinga)
#   2. Se o argumento não for fornecido, usa "Caatinga" como padrão
#   3. Imprime um painel no terminal com:
#      - Quantas amostras são desse bioma
#      - Lista de amostra_id | organismo | estado | qualidade_dna
#      - Quantas têm qualidade "excelente" vs "boa" vs "regular"
#   4. Salva o painel também em resultados/painel_BIOMA.txt
#
# Exemplo de saída esperada:
#
#   ╔═════════════════════════════════════════╗
#   ║  Painel de amostras — Caatinga          ║
#   ╚═════════════════════════════════════════╝
#
#   Total de amostras: 4
#
#   ID       Organismo               Estado  Qualidade
#   BS_001   Bacillus subtilis       CE      excelente
#   BS_002   Bacillus subtilis       PI      boa
#   SM_001   Serratia marcescens     PE      boa
#   SM_002   Serratia marcescens     RN      boa
#
#   Qualidade:  excelente: 1  |  boa: 3  |  regular: 0
#
# ── Seu script: ─────────────────────────────────────────────────────────


# =============================================================================
#  Quando terminar: faça commit e push de tudo!
#  Você pode consultar o gabarito após a aula.
# =============================================================================
