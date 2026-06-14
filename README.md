# NOXION - Sistema de Gerenciamento

**Introdução**

NOXION é um sistema de gerenciamento de tarefas (tasks) que permite ao usuário cadastrar e acompanhar tarefas, atribuir diferentes prioridades e listar as tarefas.

Projeto para a disciplina Paradigmas de Linguagens de Programação do curso 
de Ciência da Computação UFCG.

Este `README` explica como preparar o ambiente, construir e executar o projeto localmente.

**Pré-requisitos**

- `GHC` (Glasgow Haskell Compiler). Versão recomendada: a mesma usada no CI/build local (ex.: `9.6.x`).
- `cabal` (versões modernas mapearão `cabal build`/`cabal run` para o estilo new‑build).

Se não tiver o GHC/cabal instalados no Linux, instale via seu gerenciador (ex.: `ghcup`) ou pacotes da sua distribuição.

**Como compilar**

No diretório raiz do projeto (onde está `noxion.cabal`), rode:

```bash
cabal update
cabal build
```

O comando `cabal build` compilará a biblioteca e o(s) executável(is) definidos no arquivo `.cabal`.

**Como executar**

Se o pacote expõe um executável chamado `noxion`, execute:

```bash
cabal run noxion
```

**Estrutura do projeto**

- `noxion.cabal` — configuração do pacote Haskell.
- `app/Main.hs` — ponto de entrada do executável.
- `src/` — código-fonte do projeto.
- `dist-newstyle/` — diretório de build gerado pelo `cabal`.

**Solução de problemas comuns**

- Erro: `ghc: command not found` — instale o GHC (via `ghcup` ou gerenciador da distro).
- Erro de dependências: rode `cabal update` e tente `cabal build` novamente.
- Versões incompatíveis: verifique a versão do GHC listada no seu ambiente e ajuste se necessário.
