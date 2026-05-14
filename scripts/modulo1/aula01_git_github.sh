#!/usr/bin/env bash
# =============================================================================
#
#   BIOINFORMÁTICA — PPGSIS/UFC 2026/1
#   Módulo 1 — Git e GitHub para Bioinformática
#   Dr. Yan Torres
#
# =============================================================================
#
#   Por que Git em bioinformática?
#   ─────────────────────────────────────────────────────────────────────────
#   • Rastreia todas as mudanças nos seus scripts — nunca perde uma versão
#   • Colaboração sem conflitos: quem mudou o quê e quando
#   • Padrão da área: artigos com pipelines publicados no GitHub
#   • Pull Request = forma moderna de entregar trabalhos e receber feedback
#   • Reprodutibilidade: qualquer pessoa clona e reproduz sua análise
#
# =============================================================================


# ═══════════════════════════════════════════════════════════════════════════
#  PARTE 1 — Configuração inicial (fazer UMA VEZ por máquina)
# ═══════════════════════════════════════════════════════════════════════════

# Identidade — aparece em cada commit
git config --global user.name  "Seu Nome Completo"
git config --global user.email "seu.email@alu.ufc.br"

# Editor de texto para mensagens de commit (nano é mais amigável)
git config --global core.editor "nano"

# Nome da branch principal
git config --global init.defaultBranch main

# Cores no terminal
git config --global color.ui auto

# Ver o que foi configurado:
git config --list

# ── Autenticação no GitHub (uma vez por Codespace) ──────────────────────
# O GitHub CLI (gh) já vem instalado no nosso ambiente

gh auth login
# Siga as instruções:
#   1. Escolha: GitHub.com
#   2. Protocolo: HTTPS
#   3. "Authenticate with your GitHub credentials": Yes
#   4. "Login with a web browser" → copie o código → autorize no browser

# Verificar se funcionou:
gh auth status


# ═══════════════════════════════════════════════════════════════════════════
#  PARTE 2 — Os três estados do Git
# ═══════════════════════════════════════════════════════════════════════════

# Seus arquivos existem em três lugares:
#
#  DISCO (Working Tree)
#    │  você edita aqui
#    │
#    │  git add arquivo.sh
#    ▼
#  STAGE (Index)
#    │  arquivos preparados para salvar
#    │
#    │  git commit -m "mensagem"
#    ▼
#  REPOSITÓRIO LOCAL (Commits)
#    │  histórico permanente na sua máquina
#    │
#    │  git push
#    ▼
#  GITHUB (Remoto)
#     backup na nuvem + colaboração


# ═══════════════════════════════════════════════════════════════════════════
#  PARTE 3 — Fluxo básico: add → commit → push
# ═══════════════════════════════════════════════════════════════════════════

# Vá para o diretório do seu fork (já foi clonado pelo Codespace):
cd ~/Bioinfo_PPGSis_2026.1

# ─────────────────────────────────────────────────
#  3.1 Verificar o estado do repositório
# ─────────────────────────────────────────────────

# git status é o comando que você vai usar mais
git status

# Saídas possíveis:
#   "nothing to commit" → tudo salvo, repositório limpo
#   "Untracked files"   → arquivos novos que o Git ainda não conhece
#   "Changes not staged"→ arquivos modificados mas não adicionados ao stage
#   "Changes to be committed" → no stage, prontos para commit

# ─────────────────────────────────────────────────
#  3.2 Criando e salvando seu primeiro arquivo
# ─────────────────────────────────────────────────

# Crie um script de exemplo:
cat > scripts/modulo1/meu_primeiro_script.sh << 'EOF'
#!/usr/bin/env bash
# meu_primeiro_script.sh
# Autor: Seu Nome
# Data: 2026-06-15
# Descrição: Conta sequências e amostras dos dados de exemplo

echo "=== Análise dos dados de exemplo ==="
echo ""
echo "Sequências no FASTA:"
grep -c ">" dados/sequencias_exemplo.fasta 2>/dev/null || echo "arquivo não encontrado"

echo ""
echo "Amostras nos metadados:"
tail -n +2 dados/metadados.tsv 2>/dev/null | wc -l || echo "arquivo não encontrado"

echo ""
echo "Biomas representados:"
cut -f5 dados/metadados.tsv 2>/dev/null | grep -v "bioma" | sort -u || echo "arquivo não encontrado"
EOF

# Ver o que mudou:
git status
# Vai aparecer: "Untracked files: scripts/modulo1/meu_primeiro_script.sh"

# Adicionar ao stage:
git add scripts/modulo1/meu_primeiro_script.sh

# Verificar:
git status
# Agora aparece: "Changes to be committed"

# Fazer o commit com uma mensagem descritiva:
git commit -m "feat: adiciona script de análise exploratória dos dados de exemplo"

# Verificar histórico:
git log --oneline

# Enviar para o GitHub:
git push

# Confirme no GitHub: abra github.com/SEU_USUARIO/Bioinfo_PPGSis_2026.1
# e veja o arquivo aparecer!

# ─────────────────────────────────────────────────
#  3.3 Boas mensagens de commit
# ─────────────────────────────────────────────────

# Uma boa mensagem de commit responde: "Se aplicado, este commit vai..."
#
#  ✅ BOM:
#     "feat: adiciona pipeline de QC com fastp para Módulo 2"
#     "fix: corrige caminho dos dados de entrada no script SPAdes"
#     "docs: atualiza README com instruções de uso do pipeline"
#     "results: adiciona tabela de N50 da montagem do CB_001"
#
#  ❌ RUIM:
#     "update"
#     "mudanças"
#     "wip"
#     "arrumei o bug"
#     "aaaaaa"
#
# Prefixos convencionais:
#   feat:    nova funcionalidade
#   fix:     correção de bug
#   docs:    documentação
#   style:   formatação (sem mudança de lógica)
#   refactor:refatoração de código
#   results: resultados de análise
#   data:    adição/modificação de dados


# ═══════════════════════════════════════════════════════════════════════════
#  PARTE 4 — Ver histórico e desfazer mudanças
# ═══════════════════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────
#  4.1 Explorando o histórico
# ─────────────────────────────────────────────────

# Log compacto (um commit por linha):
git log --oneline

# Log com data e autor:
git log --oneline --format="%h %ad %s" --date=short

# Log visual com branches:
git log --oneline --graph --all

# Ver o que mudou num commit específico:
git show HEAD          # último commit
git show HEAD~1        # penúltimo commit

# ─────────────────────────────────────────────────
#  4.2 Ver diferenças
# ─────────────────────────────────────────────────

# Edite o script:
echo "echo 'Script finalizado com sucesso!'" >> scripts/modulo1/meu_primeiro_script.sh

# Ver o que mudou (antes do add):
git diff

# Após o git add, ver o que vai para o commit:
git add scripts/modulo1/meu_primeiro_script.sh
git diff --staged

# ─────────────────────────────────────────────────
#  4.3 Desfazendo mudanças
# ─────────────────────────────────────────────────

# ⚠️  SITUAÇÃO 1: Arquivo modificado, NÃO adicionado ainda
#    → Descartar mudanças no arquivo (volta para o último commit)
#
#    git restore scripts/modulo1/meu_primeiro_script.sh

# ⚠️  SITUAÇÃO 2: Arquivo adicionado com git add, mas NÃO commitado
#    → Remover do stage (não perde as mudanças, só remove do preparo)
#
#    git restore --staged scripts/modulo1/meu_primeiro_script.sh

# ⚠️  SITUAÇÃO 3: Commit feito, mas não foi pushado
#    → Desfazer o último commit (mantém as mudanças nos arquivos)
#
#    git reset HEAD~1

# ⚠️  SITUAÇÃO 4: Commit feito e pushado (cuidado!)
#    → Criar um novo commit que reverte as mudanças
#
#    git revert HEAD

# Na dúvida: git status sempre mostra sugestões do que fazer!


# ═══════════════════════════════════════════════════════════════════════════
#  PARTE 5 — Colaboração: pull, branches e conflitos
# ═══════════════════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────
#  5.1 Manter seu fork atualizado com o repositório do professor
# ─────────────────────────────────────────────────

# Adicionar o repositório original como "upstream":
git remote add upstream https://github.com/yanttp/Bioinfo_PPGSis_2026.1.git

# Verificar os remotos configurados:
git remote -v
# Deve mostrar:
#   origin   https://github.com/SEU_USUARIO/Bioinfo_PPGSis_2026.1.git (fetch/push)
#   upstream https://github.com/yanttp/Bioinfo_PPGSis_2026.1.git (fetch/push)

# Baixar atualizações do professor (sem aplicar ainda):
git fetch upstream

# Aplicar as atualizações na sua branch main:
git merge upstream/main

# Enviar para o seu fork no GitHub:
git push origin main

# ─────────────────────────────────────────────────
#  5.2 Branches — trabalhando em paralelo
# ─────────────────────────────────────────────────

# Branch = linha paralela de desenvolvimento
# Use branches para: experimentos, módulos, projeto final

# Criar e entrar em uma nova branch:
git checkout -b modulo2/qc-pipeline

# Verificar em qual branch está:
git branch

# Fazer mudanças, commits normalmente...
echo "# Pipeline QC - Módulo 2" > scripts/modulo2/pipeline_qc.sh
git add scripts/modulo2/pipeline_qc.sh
git commit -m "feat: esqueleto do pipeline de QC para Módulo 2"

# Publicar a branch no GitHub:
git push -u origin modulo2/qc-pipeline

# Voltar para a main:
git checkout main

# Listar todas as branches:
git branch -a


# ═══════════════════════════════════════════════════════════════════════════
#  PARTE 6 — Pull Request: entregando o trabalho
# ═══════════════════════════════════════════════════════════════════════════

# Pull Request (PR) = pedido para incorporar suas mudanças ao repositório principal
# No contexto da disciplina: é como você entrega o projeto final

# Fluxo de entrega:
# 1. Finalize seu projeto na branch do grupo
# 2. Faça push de todos os commits
# 3. Abra um Pull Request para o repositório do professor

# Criar PR pelo GitHub CLI:
gh pr create \
    --title "[Projeto Final] Nome do Grupo — Montagem de Genoma" \
    --body "## Descrição
Análise de montagem de novo de Chromobacterium violaceum.

## Membros do grupo
- Aluno 1
- Aluno 2

## Módulo
Módulo 3 — Montagem de genomas

## Arquivos entregues
- scripts/modulo3/pipeline_montagem.sh
- resultados/quast_report.html
- figuras/n50_comparacao.png
- relatorio/artigo_final.pdf
" \
    --repo yanttp/Bioinfo_PPGSis_2026.1 \
    --base main

# Ou pelo browser:
#   1. github.com/SEU_USUARIO/Bioinfo_PPGSis_2026.1
#   2. Clique "Contribute" → "Open pull request"
#   3. Preencha título e descrição
#   4. "Create pull request"


# ═══════════════════════════════════════════════════════════════════════════
#  PARTE 7 — Comandos do dia a dia: cheatsheet
# ═══════════════════════════════════════════════════════════════════════════

# ──── Situação → Comando ────────────────────────────────────────────────

# Onde estou? O que mudou?
#   git status
#   git log --oneline

# Salvar progresso (o loop mais comum):
#   git add .
#   git commit -m "mensagem descritiva"
#   git push

# Baixar atualizações do GitHub:
#   git pull

# Criar/trocar de branch:
#   git checkout -b nova-branch
#   git checkout main

# Ver diferenças:
#   git diff               (mudanças não staged)
#   git diff --staged      (mudanças no stage)

# Desfazer mudanças em arquivo:
#   git restore arquivo.sh

# Ver histórico visual:
#   git log --oneline --graph --all

# ─────────────────────────────────────────────────────────────────────────

echo ""
echo "  ✅ Git configurado e pronto para uso!"
echo "  Próximo passo: exercicios_dia1.sh"
echo ""
