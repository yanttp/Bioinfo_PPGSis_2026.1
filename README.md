# Bioinformática — PPGSIS/UFC 2026/1

**Programa:** Sistemática, Uso e Conservação da Biodiversidade  
**Instituição:** Universidade Federal do Ceará  
**Nível:** Mestrado e Doutorado  
**Docente:** Dr. Yan Torres  
**Período:** 15 de junho a 03 de julho de 2026 · 08h00–12h00  
**Carga horária:** 40h (20h teórica + 20h prática) · 4 créditos  

---

## Ementa

Boas práticas em bioinformática: organização, reprodutibilidade e documentação de análises. Fundamentos de linha de comando (Linux/Unix) e operação em ambientes de computação em nuvem via GitHub Codespaces. Fluxo de análise de dados de sequenciamento de nova geração (NGS): controle de qualidade e pré-processamento. Princípios e prática de montagem *de novo* de genomas. Estratégias e ferramentas para análises metagenômicas (amplicon). Fundamentos da identificação de variantes (SNP calling) a partir de dados de sequenciamento, com foco em RAD-seq.

---

## Objetivos

- Operar em ambiente Linux via linha de comando com boas práticas de reprodutibilidade
- Controlar versões de código e colaborar com Git e GitHub
- Realizar controle de qualidade e pré-processamento de dados NGS
- Executar a montagem *de novo* de genomas e avaliar sua qualidade
- Realizar análises metagenômicas para caracterização de comunidades
- Identificar variantes (SNP calling) a partir de dados de sequenciamento RAD-seq

---

## Módulos e cronograma

| Data | Módulo | Conteúdo | Ferramentas |
|------|--------|----------|-------------|
| 15/06 | **1** | Linux/Unix — navegação, pipes, bash, boas práticas | `bash` `git` `tree` |
| 16/06 | **1** | Git/GitHub + setup Conda/Mamba | `git` `gh` `mamba` |
| 17/06 | **2** | NGS: formatos, Phred score, controle de qualidade | `FastQC` `MultiQC` `seqkit` |
| 18/06 | **2** | Pré-processamento de reads — trimagem e filtragem | `fastp` `Trimmomatic` |
| 19/06 | **3** | Montagem de genomas: teoria + submissão SPAdes | `SPAdes` |
| 22/06 | **3** | Avaliação e anotação de montagens | `QUAST` `BUSCO` `Prokka` |
| 23/06 | **4** | Metagenômica: eDNA, amplicons, pipeline QIIME2/PIMBA | `QIIME2` `PIMBA` |
| 24/06 | **4** | Diversidade alfa e beta no R | `phyloseq` `vegan` `ggplot2` |
| 25/06 | **5** | RAD-seq e SNP Calling: teoria + Stacks | `BWA-MEM2` `Stacks` |
| 26/06 | **5** | Filtragem de variantes e genética de populações no R | `VCFtools` `adegenet` |
| 29/06 | **Projeto** | Orientação + download de dados reais (SRA) | — |
| 30/06 | — | ~~Sem aula — Qualificação PPGSIS~~ | — |
| 01/07 | **Projeto** | Desenvolvimento e análises | — |
| 02/07 | **Projeto** | Finalização do artigo e slides | — |
| 03/07 | **Projeto** | Apresentações finais | — |

---

## Ambiente computacional

A disciplina utiliza **GitHub Codespaces** — um ambiente Linux completo acessível pelo navegador, sem necessidade de instalação local. Cada aluno trabalha no próprio Codespace criado a partir do fork deste repositório.

**Configuração (fazer uma vez):**

1. Faça fork deste repositório para a sua conta GitHub
2. No seu fork: `<> Code` → `Codespaces` → `New with options`
3. Selecione a máquina **2-core · 8 GB RAM · 32 GB**
4. Aguarde ~20 minutos — o ambiente configura automaticamente
5. Verifique a instalação:

```bash
conda activate bioinfo
bash .devcontainer/verificar.sh
```

> Consulte o [TUTORIAL_ALUNOS.md](TUTORIAL_ALUNOS.md) para o passo a passo completo.

**Ambientes disponíveis:**

| Ambiente | Ativar com | Módulos |
|----------|-----------|---------|
| `bioinfo` | `conda activate bioinfo` | 1, 2, 3, 5 |
| `qiime2-amplicon` | `conda activate qiime2-amplicon` | 4 |

---

## Avaliação

O projeto final consiste em uma análise de dados em uma das três linhas:

- **Montagem de genoma** *de novo* (Módulo 3)
- **Análise metagenômica** de comunidades por amplicons (Módulo 4)
- **Identificação de variantes** a partir de dados RAD-seq (Módulo 5)

**Entregáveis:**
- Artigo no formato IMRD (Introdução, Métodos, Resultados, Discussão) — ~3 a 5 páginas
- Apresentação oral de 10 minutos + 5 minutos de perguntas
- Pipeline reproduzível commitado neste repositório

**Grupos:** duplas ou trios  
**Entrega do artigo:** 02/07/2026 até 23:59 via Pull Request  
**Apresentações:** 03/07/2026

---

## Estrutura do repositório

```
Bioinfo_PPGSis_2026.1/
├── .devcontainer/          ← configuração automática do ambiente
├── scripts/
│   ├── modulo1/            ← Linux, Git, dados de prática
│   ├── modulo2/            ← QC e pré-processamento
│   ├── modulo3/            ← montagem de genomas
│   ├── modulo4/            ← metagenômica
│   └── modulo5/            ← SNP calling
├── dados/
│   ├── brutos/             ← dados originais (não modificar)
│   ├── limpos/             ← após QC e trimagem
│   └── resultados/         ← outputs das análises
├── projetos/               ← trabalhos finais dos grupos
├── figuras/
├── relatorio/
├── TUTORIAL_ALUNOS.md      ← guia de configuração do Codespace
└── README.md
```

---

## Dúvidas e comunicação

Utilize o **[Discussions](../../discussions)** deste repositório:

| Categoria | Para quê |
|-----------|---------|
| 📢 Avisos | Comunicados do professor |
| 🐧 Módulo 1–5 | Dúvidas técnicas por módulo |
| 📁 Projetos Finais | Dúvidas sobre o trabalho do grupo |
| 💬 Off-topic | Conversas livres |

> Dúvidas postadas no Discussions beneficiam toda a turma. Evite enviar por e-mail questões técnicas que possam ser compartilhadas.

---

## Bibliografia

- BAXEVANIS, A. D.; BADER, G. D.; WISHART, D. S. **Bioinformatics**. 4. ed. John Wiley & Sons, 2020.
- DINIZ, W. J. S.; CANDURI, F. Bioinformatics: an overview and its applications. *Genetics and Molecular Research*, v. 16, n. 1, 2017.
- JUNG, H. et al. Twelve quick steps for genome assembly and annotation in the classroom. *PLOS Computational Biology*, v. 16, n. 11, p. e1008325, 2020.
- ROUMPEKA, D. D. et al. A Review of Bioinformatics Tools for Bio-Prospecting from Metagenomic Sequence Data. *Frontiers in Genetics*, v. 8, 2017.
- SIMPSON, J. T.; POP, M. The Theory and Practice of Genome Sequence Assembly. *Annual Review of Genomics and Human Genetics*, v. 16, p. 153–172, 2015.

---

*Universidade Federal do Ceará · PPGSIS · 2026/1*
