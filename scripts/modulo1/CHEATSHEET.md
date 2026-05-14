# 📋 Cheatsheet — Bioinformática PPGSIS 2026

## Linux/Bash

| Comando | O que faz | Exemplo |
|---------|-----------|---------|
| `pwd` | Onde estou? | `pwd` |
| `ls -lh` | Listar com tamanho legível | `ls -lh dados/` |
| `cd` | Entrar em diretório | `cd scripts/modulo1` |
| `cd ..` | Voltar um nível | `cd ..` |
| `cd ~` | Ir para home | `cd ~` |
| `mkdir -p` | Criar pasta (com intermediárias) | `mkdir -p dados/brutos` |
| `cp` | Copiar | `cp dados.fasta backup.fasta` |
| `mv` | Mover/renomear | `mv old.sh novo.sh` |
| `rm -i` | Remover (com confirmação) | `rm -i arquivo.txt` |
| `cat` | Ver conteúdo inteiro | `cat metadados.tsv` |
| `head -n 5` | Ver primeiras 5 linhas | `head -n 5 arquivo.tsv` |
| `tail -n 5` | Ver últimas 5 linhas | `tail -n 5 arquivo.tsv` |
| `less` | Paginador interativo (q = sair) | `less sequencias.fasta` |
| `wc -l` | Contar linhas | `wc -l metadados.tsv` |
| `grep "padrão"` | Buscar linhas com padrão | `grep "Caatinga" metadados.tsv` |
| `grep -c` | Contar ocorrências | `grep -c ">" arquivo.fasta` |
| `grep -v` | Excluir padrão | `grep -v "cabeçalho"` |
| `cut -f2` | Pegar coluna 2 (TSV) | `cut -f5 metadados.tsv` |
| `sort` | Ordenar | `sort nomes.txt` |
| `sort -u` | Ordenar e remover duplicatas | `sort -u biomas.txt` |
| `uniq -c` | Contar repetidos consecutivos | `sort \| uniq -c \| sort -rn` |
| `echo` | Imprimir texto | `echo "Olá mundo"` |
| `>` | Redirecionar para arquivo (sobrescreve) | `ls > lista.txt` |
| `>>` | Acrescentar ao arquivo | `echo "fim" >> lista.txt` |
| `\|` | Pipe: encadeia comandos | `cat arquivo \| head -5` |
| `history` | Ver últimos comandos | `history \| tail -20` |
| `Ctrl+R` | Buscar no histórico | `Ctrl+R` depois digite |
| `Ctrl+C` | Cancelar comando em execução | `Ctrl+C` |
| `Tab` | Autocompletar | `cd scri`+Tab |

---

## seqkit

| Comando | O que faz |
|---------|-----------|
| `seqkit stats arquivo.fasta` | Estatísticas básicas |
| `seqkit stats -a arquivo.fastq` | Estatísticas detalhadas |
| `seqkit seq --name arquivo.fasta` | Listar nomes das sequências |
| `seqkit seq --name --only-id` | Listar apenas IDs |
| `seqkit grep -p "Bacillus"` | Extrair sequência por nome |
| `seqkit fx2tab --length --name` | Tabela ID + comprimento |
| `seqkit fq2fa arquivo.fastq` | Converter FASTQ → FASTA |

---

## Git — fluxo diário

```bash
# 1. Ver o que mudou
git status

# 2. Adicionar arquivos
git add arquivo.sh          # arquivo específico
git add scripts/modulo1/    # pasta inteira
git add .                   # TUDO (cuidado)

# 3. Salvar com mensagem
git commit -m "feat: adiciona pipeline de QC"

# 4. Enviar para GitHub
git push

# 5. Baixar atualizações do professor
git fetch upstream
git merge upstream/main
git push
```

## Git — ver histórico

```bash
git log --oneline           # log compacto
git log --oneline --graph   # com árvore visual
git diff                    # o que mudou (antes do add)
git diff --staged           # o que vai no próximo commit
git show HEAD               # detalhes do último commit
```

## Git — desfazer

```bash
git restore arquivo.sh      # descarta mudanças (antes do add)
git restore --staged arq.sh # remove do stage (não perde mudanças)
git reset HEAD~1            # desfaz último commit (mantém mudanças)
```

---

## Formatos essenciais

### FASTA
```
>ID_da_sequencia descricao_opcional
ATCGATCGATCGATCGATCGATCGATCG
ATCGATCGATCGATCG
```

### FASTQ (4 linhas por read)
```
@SRR123.1 identificador
ATCGATCGATCGATCGATCGATCG      ← sequência
+                              ← separador (sempre +)
IIIIIIIIIIIIIIIIIIIIIIIII     ← qualidade Phred (ASCII)
```

### Phred score rápido
| Caractere | Q | Prob. erro |
|-----------|---|------------|
| `#` | 2 | 63% — LIXO |
| `5` | 20 | 1% — aceitável |
| `?` | 30 | 0.1% — bom |
| `I` | 40 | 0.01% — excelente |

---

## Estrutura de projeto padrão

```
projeto/
├── dados/
│   ├── brutos/       ← NUNCA modifique estes!
│   ├── limpos/
│   └── referencia/
├── scripts/          ← numerados: 01_qc.sh, 02_montagem.sh
├── resultados/
├── figuras/
├── relatorio/
└── README.md
```

---

## Conda

```bash
conda activate bioinfo          # ativar ambiente principal
conda activate qiime2-amplicon  # ativar ambiente QIIME2
conda deactivate                # desativar
conda env list                  # listar ambientes
```

---

*Bioinformática PPGSIS/UFC 2026 · Dr. Yan Torres*
