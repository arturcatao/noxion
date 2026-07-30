```text
███╗   ██╗ ██████╗ ██╗  ██╗██╗ ██████╗ ███╗   ██╗
████╗  ██║██╔═══██╗╚██╗██╔╝██║██╔═══██╗████╗  ██║
██╔██╗ ██║██║   ██║ ╚███╔╝ ██║██║   ██║██╔██╗ ██║
██║╚██╗██║██║   ██║ ██╔██╗ ██║██║   ██║██║╚██╗██║
██║ ╚████║╚██████╔╝██╔╝ ██╗██║╚██████╔╝██║ ╚████║
╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝
```

**Introdução**

NOXION é um sistema de gerenciamento de tarefas (tasks) que permite ao usuário cadastrar e acompanhar tarefas, atribuir diferentes prioridades e listar as tarefas.

Projeto para a disciplina Paradigmas de Linguagens de Programação do curso 
de Ciência da Computação UFCG. Neste projeto, utilizamos duas implementações com linguagens diferentes para um mesmo sistema: uma em Haskell e outra em Prolog.

Este `README` explica como preparar o ambiente, construir e executar o projeto localmente.

**Pré-requisitos**

Para a versão em Haskell:
- `GHC` (Glasgow Haskell Compiler). Versão recomendada: a mesma usada no CI/build local (ex.: `9.6.x`).
- `cabal` (versões modernas mapearão `cabal build`/`cabal run` para o estilo new‑build).

Para a versão em Prolog:
- `SWI-Prolog` instalado e disponível no terminal como `swipl`.

Se não tiver o GHC/cabal instalados no Linux, instale via seu gerenciador (ex.: `ghcup`) ou pacotes da sua distribuição. Se não tiver SWI-Prolog, instale pelo gerenciador da sua distribuição ou pelo site oficial.

**Como compilar e executar com Haskell**

No diretório raiz do projeto (onde está `noxion.cabal`), rode:

```bash
cabal update
cabal build
```

O comando `cabal build` compilará a biblioteca e o(s) executável(is) definidos no arquivo `.cabal`.

Para executar:

```bash
cabal run noxion
```

**Como executar com Prolog**

Entre na pasta `prolog` e execute o programa principal:

```bash
swipl -s main.pl
```

Se preferir carregar o arquivo e interagir no REPL:

```bash
swipl
?- [main].
```

**Estrutura do projeto**

- `haskell/noxion.cabal` — configuração do pacote Haskell.
- `haskell/app/Main.hs` — ponto de entrada do executável em Haskell.
- `haskell/src/` — código-fonte do projeto em Haskell.
- `prolog/main.pl` — ponto de entrada do programa Prolog.
- `prolog/src/` — módulos Prolog do projeto.
- `dist-newstyle/` — diretório de build gerado pelo `cabal`.

**Solução de problemas comuns**

- Erro: `ghc: command not found` — instale o GHC (via `ghcup` ou gerenciador da distro).
- Erro: `swipl: command not found` — instale o Prolog e confirme que o comando `swipl` está no `PATH`.
- Erro de dependências: rode `cabal update` e tente `cabal build` novamente.
- Versões incompatíveis: verifique a versão do GHC listada no seu ambiente e ajuste se necessário.
