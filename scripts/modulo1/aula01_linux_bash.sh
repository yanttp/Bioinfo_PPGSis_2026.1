#!/usr/bin/env bash
# =============================================================================
#
#   BIOINFORMÁTICA — PPGSIS/UFC 2026/1
#   Módulo 1, Aula 1 — Fundamentos de Linux e Bash para Bioinformática
#   Dr. Yan Torres · 15 de junho de 2026
#
# =============================================================================
#
#   COMO USAR ESTE TUTORIAL
#   ─────────────────────────────────────────────────────────────────────────
#   Este arquivo é um tutorial interativo. Leia cada bloco de comentários e
#   depois EXECUTE os comandos no seu terminal, um por um.
#
#   NÃO copie e cole tudo de uma vez — o objetivo é entender o que cada
#   comando faz ANTES de executá-lo.
#
#   Comandos para executar aparecem assim (sem o #):
#
#       pwd
#
#   Comentários explicativos aparecem com #:
#
#       # Isso é uma explicação — não execute
#
# =============================================================================


# ═══════════════════════════════════════════════════════════════════════════
#  PARTE 0 — Antes de começar: ativando o ambiente
# ═══════════════════════════════════════════════════════════════════════════

# Primeiro, ative o ambiente conda da disciplina.
# Isso garante que todas as ferramentas estão disponíveis.

conda activate bioinfo

# Verifique que o ambiente está ativo — você deve ver (bioinfo) no prompt:
#   (bioinfo) vscode@xxxxx:~$

# Vamos para o diretório da disciplina:
cd ~/Bioinfo_PPGSis_2026.1

# Confirme onde você está:
pwd

# Resultado esperado:
#   /home/vscode/Bioinfo_PPGSis_2026.1


# ═══════════════════════════════════════════════════════════════════════════
#  PARTE 1 — Navegação no sistema de arquivos
# ═══════════════════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────
#  1.1 Onde estou? O que tem aqui?
# ─────────────────────────────────────────────────

# pwd = print working directory (onde estou agora)
pwd

# ls = list (listar o que tem no diretório atual)
ls

# ls com flags úteis:
ls -l          # formato longo: permissões, tamanho, data
ls -lh         # -h = human readable (mostra 1.2K em vez de 1234)
ls -la         # -a = all (mostra arquivos ocultos, que começam com .)
ls -lhS        # -S = ordena por tamanho (maior primeiro)
ls -lht        # -t = ordena por data de modificação (mais recente primeiro)

# tree mostra a estrutura de pastas visualmente:
tree -L 2      # mostra até 2 níveis de profundidade

# ─────────────────────────────────────────────────
#  1.2 Movendo-se entre diretórios
# ─────────────────────────────────────────────────

# cd = change directory
cd scripts/modulo1

# Confirme onde está:
pwd

# Voltar um nível:
cd ..

# Voltar dois níveis:
cd ../..

# Ir diretamente para o diretório home:
cd ~

# Voltar para onde estava antes:
cd -

# Ir para o diretório da disciplina com caminho absoluto:
cd ~/Bioinfo_PPGSis_2026.1

# ─────────────────────────────────────────────────
#  1.3 Criando sua estrutura de trabalho
# ─────────────────────────────────────────────────

# mkdir = make directory
mkdir -p pratica/aula01

# O -p cria diretórios intermediários se não existirem.
# Sem -p, daria erro se 'pratica' não existisse.

# Entre no diretório criado:
cd pratica/aula01

# Crie vários diretórios de uma vez:
mkdir -p {dados_brutos,dados_limpos,resultados,figuras,scripts}

# Veja o resultado:
ls -l
tree .


# ═══════════════════════════════════════════════════════════════════════════
#  PARTE 2 — Manipulação de arquivos
# ═══════════════════════════════════════════════════════════════════════════

# Vamos trabalhar com os dados de exemplo da disciplina.
# Volte ao diretório principal:
cd ~/Bioinfo_PPGSis_2026.1

# ─────────────────────────────────────────────────
#  2.1 Visualizando arquivos
# ─────────────────────────────────────────────────

# cat = exibe todo o conteúdo de uma vez (bom para arquivos pequenos)
cat scripts/modulo1/dados/metadados.tsv

# head = mostra as primeiras linhas (padrão: 10)
head scripts/modulo1/dados/metadados.tsv

# head com número específico de linhas:
head -n 3 scripts/modulo1/dados/metadados.tsv

# tail = mostra as últimas linhas
tail -n 5 scripts/modulo1/dados/metadados.tsv

# less = visualizador interativo (use q para sair, / para buscar)
less scripts/modulo1/dados/sequencias_exemplo.fasta
# Dentro do less:
#   q       = sair
#   /palavra = buscar
#   n        = próxima ocorrência
#   G        = ir para o final
#   gg       = ir para o início

# ─────────────────────────────────────────────────
#  2.2 Contando coisas
# ─────────────────────────────────────────────────

# wc = word count
wc scripts/modulo1/dados/metadados.tsv
# Mostra: linhas  palavras  bytes  arquivo

# Só o número de linhas:
wc -l scripts/modulo1/dados/metadados.tsv

# Quantas sequências tem no FASTA?
# Em FASTA, cada sequência começa com ">"
grep -c ">" scripts/modulo1/dados/sequencias_exemplo.fasta

# ─────────────────────────────────────────────────
#  2.3 Copiando, movendo e renomeando
# ─────────────────────────────────────────────────

# cp = copy
cp scripts/modulo1/dados/metadados.tsv pratica/aula01/dados_brutos/

# mv = move (também renomeia!)
cd pratica/aula01/dados_brutos

# Renomear um arquivo:
cp metadados.tsv metadados_backup.tsv
mv metadados_backup.tsv metadados_v1.tsv
ls

# ⚠️  CUIDADO: mv sobrescreve sem aviso. Use -i para confirmar:
mv -i metadados_v1.tsv metadados_original.tsv

# Remover arquivo (cuidado: não vai para lixeira!):
# rm arquivo    ← PERMANENTE
# rm -i arquivo ← pede confirmação (use sempre!)
# rm -r pasta/  ← remove pasta recursivamente

# Por segurança, vamos apenas listar o que criamos:
ls -lh
cd ~/Bioinfo_PPGSis_2026.1


# ═══════════════════════════════════════════════════════════════════════════
#  PARTE 3 — O poder dos pipes e redirecionamentos
# ═══════════════════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────
#  3.1 Redirecionamento: salvando output em arquivo
# ─────────────────────────────────────────────────

# >  = cria/sobrescreve arquivo com o output
# >> = acrescenta ao final do arquivo (append)

# Salvar a lista de arquivos em um arquivo de texto:
ls -lh scripts/modulo1/dados/ > pratica/aula01/lista_arquivos.txt
cat pratica/aula01/lista_arquivos.txt

# Acrescentar uma linha ao final:
echo "=== Gerado em $(date) ===" >> pratica/aula01/lista_arquivos.txt
tail -3 pratica/aula01/lista_arquivos.txt

# ─────────────────────────────────────────────────
#  3.2 O pipe | — encadeando comandos
# ─────────────────────────────────────────────────

# O pipe pega o OUTPUT de um comando e passa como INPUT para o próximo.
# Leitura: "e então..."

# Exemplo sem pipe (dois passos):
cat scripts/modulo1/dados/metadados.tsv > /tmp/temp.txt
head -5 /tmp/temp.txt

# Mesmo resultado COM pipe (um passo):
cat scripts/modulo1/dados/metadados.tsv | head -5

# Mais prático ainda: head aceita arquivo diretamente:
head -5 scripts/modulo1/dados/metadados.tsv

# Pipes são poderosos quando encadeados:
# "mostre os 3 maiores arquivos nesta pasta"
ls -lhS scripts/modulo1/dados/ | head -4

# "conte quantos organismos únicos há nos metadados"
cut -f2 scripts/modulo1/dados/metadados.tsv | sort -u | grep -v "organismo"

# Vamos ler isso passo a passo:
# cut -f2          → pega só a coluna 2 (organismo)
# sort -u          → ordena e remove duplicatas (-u = unique)
# grep -v "organismo" → remove a linha de cabeçalho

# ─────────────────────────────────────────────────
#  3.3 grep — buscar padrões
# ─────────────────────────────────────────────────

# grep = global regular expression print
# Busca linhas que contêm um padrão

# Amostras coletadas no Ceará:
grep "CE" scripts/modulo1/dados/metadados.tsv

# Amostras de qualidade "excelente":
grep "excelente" scripts/modulo1/dados/metadados.tsv

# Contar quantas amostras são da Caatinga:
grep -c "Caatinga" scripts/modulo1/dados/metadados.tsv

# Mostrar número da linha junto:
grep -n "Amazônia" scripts/modulo1/dados/metadados.tsv

# Busca sem diferenciar maiúsculas/minúsculas:
grep -i "bacillus" scripts/modulo1/dados/metadados.tsv

# Buscar em múltiplos arquivos:
grep ">" scripts/modulo1/dados/sequencias_exemplo.fasta

# Inverter: linhas que NÃO contêm o padrão:
grep -v "^amostra" scripts/modulo1/dados/metadados.tsv | head -5

# ─────────────────────────────────────────────────
#  3.4 cut, sort, uniq — manipulando colunas e listas
# ─────────────────────────────────────────────────

# cut = recorta colunas de um arquivo tabular
# -f = field (coluna), -d = delimiter (separador)

# Pegar só as colunas amostra_id e organismo do TSV:
cut -f1,2 scripts/modulo1/dados/metadados.tsv

# Pegar só a coluna de bioma (coluna 5):
cut -f5 scripts/modulo1/dados/metadados.tsv

# Listar biomas únicos:
cut -f5 scripts/modulo1/dados/metadados.tsv | sort -u | grep -v "bioma"

# Contar amostras por bioma:
cut -f5 scripts/modulo1/dados/metadados.tsv \
    | grep -v "bioma" \
    | sort \
    | uniq -c \
    | sort -rn

# Lendo o pipeline acima:
# cut -f5          → pega coluna "bioma"
# grep -v "bioma"  → remove cabeçalho
# sort             → ordena (necessário para uniq funcionar)
# uniq -c          → conta ocorrências consecutivas idênticas
# sort -rn         → ordena por contagem decrescente (-r) numérico (-n)


# ═══════════════════════════════════════════════════════════════════════════
#  PARTE 4 — Formato FASTQ: a moeda do sequenciamento
# ═══════════════════════════════════════════════════════════════════════════

# Vamos explorar o formato FASTQ — você vai trabalhar com ele em todos os módulos.

# O formato FASTQ tem 4 linhas por read:
#   Linha 1: @identificador  (começa com @)
#   Linha 2: sequência       (as bases: ATCGN)
#   Linha 3: +               (separador)
#   Linha 4: qualidade       (caracteres ASCII = Phred score)

cat scripts/modulo1/dados/exemplo_reads.fastq

# Quantos reads tem neste arquivo?
# Cada read = 4 linhas, então: linhas ÷ 4
wc -l scripts/modulo1/dados/exemplo_reads.fastq

# Ou diretamente:
grep -c "^@SRR" scripts/modulo1/dados/exemplo_reads.fastq

# Extrair só os identificadores dos reads:
grep "^@" scripts/modulo1/dados/exemplo_reads.fastq

# Extrair só as sequências (linha 2 de cada bloco de 4):
# Padrão: linhas 2, 6, 10, 14... (toda linha após um @)
grep -A1 "^@" scripts/modulo1/dados/exemplo_reads.fastq | grep -v "^@" | grep -v "^--"

# Decodificando a qualidade:
# Phred score: Q = -10 × log10(P_erro)
# Q20 = 1% de chance de erro  (Phred char: '5')
# Q30 = 0.1% de chance de erro (Phred char: '?')
# Q40 = 0.01% de chance de erro (Phred char: 'I')
# '#' = Q2 (muito ruim)  'I' = Q40 (ótimo)

# Veja a qualidade do último read (mais baixa):
tail -2 scripts/modulo1/dados/exemplo_reads.fastq


# ═══════════════════════════════════════════════════════════════════════════
#  PARTE 5 — Variáveis e scripts bash
# ═══════════════════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────
#  5.1 Variáveis
# ─────────────────────────────────────────────────

# Definindo uma variável (sem espaços ao redor do =):
PROJETO="bioinfo_ppgsis_2026"
AMOSTRA="CB_001"
DADOS_DIR="scripts/modulo1/dados"

# Usando a variável (com $):
echo "Projeto: $PROJETO"
echo "Processando amostra: $AMOSTRA"
echo "Dados em: $DADOS_DIR"

# Variáveis em caminhos:
ls $DADOS_DIR/
head -3 $DADOS_DIR/metadados.tsv

# Variáveis especiais úteis:
echo "Diretório atual: $PWD"
echo "Usuário: $USER"
echo "Data: $(date +%Y-%m-%d)"    # $() executa um comando e usa o resultado

# ─────────────────────────────────────────────────
#  5.2 Loops — repetindo operações
# ─────────────────────────────────────────────────

# Loop básico com lista:
for BIOMA in Caatinga Amazônia Cerrado Pantanal; do
    echo "Processando amostras do bioma: $BIOMA"
done

# Loop com arquivos:
for ARQUIVO in scripts/modulo1/dados/*; do
    echo "Arquivo: $ARQUIVO"
    echo "  Linhas: $(wc -l < $ARQUIVO)"
    echo "  Tamanho: $(ls -lh $ARQUIVO | awk '{print $5}')"
done

# Loop lendo linhas de um arquivo:
# Vamos processar cada amostra dos metadados:
while IFS=$'\t' read -r ID ORGANISMO ORIGEM ESTADO BIOMA RESTO; do
    # Pula o cabeçalho
    [[ "$ID" == "amostra_id" ]] && continue
    echo "Amostra $ID: $ORGANISMO ($BIOMA)"
done < scripts/modulo1/dados/metadados.tsv

# ─────────────────────────────────────────────────
#  5.3 Escrevendo seu primeiro script
# ─────────────────────────────────────────────────

# Vamos criar um script que gera um relatório dos dados:
cat > pratica/aula01/scripts/relatorio_amostras.sh << 'SCRIPT'
#!/usr/bin/env bash
# relatorio_amostras.sh — gera relatório resumido dos metadados
# Uso: bash relatorio_amostras.sh <arquivo_metadados.tsv>

set -euo pipefail  # boas práticas: para em qualquer erro

METADADOS="${1:-scripts/modulo1/dados/metadados.tsv}"

echo "╔══════════════════════════════════════╗"
echo "║  Relatório de amostras               ║"
echo "║  Gerado: $(date +%Y-%m-%d\ %H:%M)       ║"
echo "╚══════════════════════════════════════╝"
echo ""

# Total de amostras (exclui cabeçalho)
TOTAL=$(tail -n +2 "$METADADOS" | wc -l)
echo "Total de amostras: $TOTAL"
echo ""

echo "── Amostras por bioma ──────────────────"
cut -f5 "$METADADOS" | grep -v "bioma" | sort | uniq -c | sort -rn
echo ""

echo "── Amostras por qualidade de DNA ───────"
cut -f8 "$METADADOS" | grep -v "qualidade" | sort | uniq -c | sort -rn
echo ""

echo "── Organismos únicos ───────────────────"
cut -f2 "$METADADOS" | grep -v "organismo" | sort -u
echo ""
SCRIPT

# Tornar executável:
chmod +x pratica/aula01/scripts/relatorio_amostras.sh

# Executar:
bash pratica/aula01/scripts/relatorio_amostras.sh


# ═══════════════════════════════════════════════════════════════════════════
#  PARTE 6 — seqkit: ferramenta essencial para sequências
# ═══════════════════════════════════════════════════════════════════════════

# seqkit é a sua navalha suíça para arquivos FASTA/FASTQ

# Informações básicas sobre o FASTA:
seqkit stats scripts/modulo1/dados/sequencias_exemplo.fasta

# Informações detalhadas:
seqkit stats -a scripts/modulo1/dados/sequencias_exemplo.fasta

# Listar nomes das sequências:
seqkit seq --name scripts/modulo1/dados/sequencias_exemplo.fasta

# Listar apenas os IDs (sem a descrição):
seqkit seq --name --only-id scripts/modulo1/dados/sequencias_exemplo.fasta

# Ver comprimento de cada sequência:
seqkit fx2tab --length --name scripts/modulo1/dados/sequencias_exemplo.fasta

# Buscar sequência específica por nome:
seqkit grep -p "Bacillus" scripts/modulo1/dados/sequencias_exemplo.fasta

# Converter FASTQ para FASTA:
seqkit fq2fa scripts/modulo1/dados/exemplo_reads.fastq

# Estatísticas do FASTQ:
seqkit stats -a scripts/modulo1/dados/exemplo_reads.fastq

# Salvar resultado:
seqkit stats -a scripts/modulo1/dados/*.fasta scripts/modulo1/dados/*.fastq \
    > pratica/aula01/resultados/stats_sequencias.tsv

cat pratica/aula01/resultados/stats_sequencias.tsv


# ═══════════════════════════════════════════════════════════════════════════
#  PARTE 7 — Boas práticas: organização e reprodutibilidade
# ═══════════════════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────
#  7.1 Nomeando arquivos
# ─────────────────────────────────────────────────

# ✅ BOM: descritivo, sem espaços, com data
#   CB_001_reads_brutos_20260615.fastq.gz
#   pipeline_qc_v2.sh
#   resultados_busco_bacillus_2026-06-22.txt

# ❌ RUIM: genérico, com espaços, sem contexto
#   dados.fastq
#   análise final (2).sh
#   resultados novo.txt

# ─────────────────────────────────────────────────
#  7.2 Estrutura de projeto padrão
# ─────────────────────────────────────────────────

# Uma boa estrutura para qualquer análise bioinformática:
#
#  projeto/
#  ├── dados/
#  │   ├── brutos/      ← nunca modificar estes arquivos!
#  │   ├── limpos/      ← após QC e trimagem
#  │   └── referencia/  ← genomas de referência, bancos de dados
#  ├── scripts/         ← seus scripts numerados (01_qc.sh, 02_montagem.sh)
#  ├── resultados/      ← outputs das análises
#  ├── figuras/         ← gráficos e visualizações
#  ├── relatorio/       ← documentos e apresentações
#  └── README.md        ← explica o projeto para você do futuro

# ─────────────────────────────────────────────────
#  7.3 Documentando comandos com history
# ─────────────────────────────────────────────────

# Ver os últimos 20 comandos executados:
history | tail -20

# Buscar no histórico:
history | grep "seqkit"

# Salvar o histórico desta sessão:
history > pratica/aula01/historico_aula01.txt

# Reutilizar comando anterior:
#   !! = repete o último comando
#   !seqkit = repete o último comando que começa com 'seqkit'
#   Ctrl+R = busca interativa no histórico


# ═══════════════════════════════════════════════════════════════════════════
#  RESUMO — O que aprendemos hoje
# ═══════════════════════════════════════════════════════════════════════════

echo ""
echo "═══════════════════════════════════════════════"
echo "  Comandos da Aula 1 — para referência rápida  "
echo "═══════════════════════════════════════════════"
echo ""
echo "Navegação:    pwd  ls  cd  tree"
echo "Arquivos:     cat  head  tail  less  wc"
echo "Manipulação:  cp  mv  mkdir  rm"
echo "Busca:        grep  cut  sort  uniq"
echo "Pipes:        |  >  >>"
echo "Sequências:   seqkit stats/seq/grep/fx2tab"
echo "Variáveis:    VAR=valor  \$VAR  \$(comando)"
echo "Loops:        for ... in ...; do ... done"
echo ""
echo "Próxima aula: Git/GitHub + setup Conda"
echo ""

# ═══════════════════════════════════════════════════════════════════════════
#  FIM — Agora faça os exercícios em exercicios_dia1.sh
# ═══════════════════════════════════════════════════════════════════════════
