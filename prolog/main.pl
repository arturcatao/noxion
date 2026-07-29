:- use_module('src/fachada').    
:- use_module(library(readutil)).
:- use_module(library(process)).
:- use_module('src/db.pl', [user/3]).

main :-
    limpar_tela,
    writeln('=== NOXION ==='),
    nl,
    menu_login.

limpar_tela :-
    current_prolog_flag(windows, true),
    !,
    process_create(path(cmd), ['/c', 'cls'], []).

limpar_tela :-
    process_create(path(clear), [], []).


pausar :-
    nl,
    writeln('Pressione Enter para continuar...'),
    read_line_to_string(user_input, _),
    limpar_tela.

menu_login :-
    nl,
    writeln('  ███╗   ██╗ ██████╗ ██╗  ██╗██╗ ██████╗ ███╗   ██╗'),
    writeln('  ████╗  ██║██╔═══██╗╚██╗██╔╝██║██╔═══██╗████╗  ██║'),
    writeln('  ██╔██╗ ██║██║   ██║ ╚███╔╝ ██║██║   ██║██╔██╗ ██║'),
    writeln('  ██║╚██╗██║██║   ██║ ██╔██╗ ██║██║   ██║██║╚██╗██║'),
    writeln('  ██║ ╚████║╚██████╔╝██╔╝ ██╗██║╚██████╔╝██║ ╚████║'),
    writeln('  ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝'),
    nl,
    writeln('  ╔══════════════════════════════════╗'),
    writeln('  ║          [1] Login               ║'),
    writeln('  ║          [2] Cadastrar           ║'),
    writeln('  ║          [3] Ajuda               ║'),
    writeln('  ║          [0] Sair                ║'),
    writeln('  ╚══════════════════════════════════╝'),
    nl,
    write('Escolha: '),
    read_line_to_string(user_input, Opcao),
    limpar_tela,
    tratar_opcao_login(Opcao).

tratar_opcao_login("1") :-
    fazer_login.

tratar_opcao_login("2") :-
    fazer_cadastro.

tratar_opcao_login("3") :-
    mostrar_ajuda.

tratar_opcao_login("0") :-
    writeln('Até logo!').

tratar_opcao_login(_) :-
    writeln('Opção inválida.'),
    menu_login.

fazer_login :-
    writeln('Login:'),
    read_line_to_string(user_input, Login),

    writeln('Senha:'),
    read_line_to_string(user_input, Senha),

    limpar_tela,

    ( entrar(Login, Senha) ->
        format('Bem-vindo, ~w!~n', [Login]),
        menu_principal
    ;
        writeln('Credenciais inválidas.'),
        pausar,
        menu_login
    ).

fazer_cadastro :-
    writeln('=== Cadastro de Usuario ==='),

    writeln('Digite seu login:'),
    read_line_to_string(user_input, Login),

    writeln('Digite seu nome:'),
    read_line_to_string(user_input, Nome),

    writeln('Digite sua senha:'),
    read_line_to_string(user_input, Senha),

    limpar_tela,

    (
        campos_vazios(Login, Nome, Senha)
    ->
        writeln('Erro: nenhum campo pode ser vazio.'),
        pausar,
        menu_login
    ;
        cadastrar_e_entrar(Login, Nome, Senha)
    ).

campos_vazios(Login, Nome, Senha) :-
    Login == "";
    Nome == "";
    Senha == "".

cadastrar_e_entrar(Login, Nome, Senha) :-
    criar_conta(Login, Nome, Senha),
    !,
    entrar(Login, Senha),
    format('Conta criada com sucesso!~n'),
    format('Bem-vindo, ~w!~n', [Nome]),
    pausar,
    menu_principal.

cadastrar_e_entrar(_, _, _) :-
    writeln('Erro: login já existe ou dados inválidos.'),
    pausar,
    menu_login.

mostrar_ajuda :-
    nl,
    writeln('  ╔══════════════════════════════════════════════════════╗'),
    writeln('  ║                 NOXION - Ajuda                       ║'),
    writeln('  ╠══════════════════════════════════════════════════════╣'),
    writeln('  ║  Noxion e um sistema de gerenciamento de tarefas     ║'),
    writeln('  ║  via terminal, desenvolvido em Prolog.               ║'),
    writeln('  ╠══════════════════════════════════════════════════════╣'),
    writeln('  ║  CADASTRO                                            ║'),
    writeln('  ║    1. Escolha [2] Cadastrar no menu inicial          ║'),
    writeln('  ║    2. Digite um login unico                          ║'),
    writeln('  ║    3. Digite seu nome                                ║'),
    writeln('  ║    4. Digite uma senha                               ║'),
    writeln('  ║    Apos o cadastro, voce sera logado automaticamente ║'),
    writeln('  ╠══════════════════════════════════════════════════════╣'),
    writeln('  ║  LOGIN                                               ║'),
    writeln('  ║    1. Escolha [1] Login no menu inicial              ║'),
    writeln('  ║    2. Digite seu login                               ║'),
    writeln('  ║    3. Digite sua senha                               ║'),
    writeln('  ║    Credenciais invalidas retornam ao menu            ║'),
    writeln('  ╠══════════════════════════════════════════════════════╣'),
    writeln('  ║  FUNCIONALIDADES                                     ║'),
    writeln('  ║    - Criar tasks com titulo, descricao e prazo       ║'),
    writeln('  ║    - Status: Nao Feito, Em Progresso, Feito          ║'),
    writeln('  ║    - Prioridade: Baixa, Media, Alta                  ║'),
    writeln('  ║    - Filtros por status, prioridade e atraso         ║'),
    writeln('  ║    - Estatisticas gerais das suas tasks              ║'),
    writeln('  ╚══════════════════════════════════════════════════════╝'),
    pausar,
    menu_login.

spaces(0, "").

spaces(N, String) :-
    N > 0,
    N1 is N - 1,
    spaces(N1, Rest),
    string_concat(" ", Rest, String).

menu_principal :-
    usuario_logado(Login),
    user(Login, Nome, _),

    string_length(Nome, Tamanho),
    Espacos is max(0, 19 - Tamanho),
    spaces(Espacos, Padding),

    nl,
    writeln(' ╔══════════════════════════════════╗'),
    writeln(' ║         NOXION - Tasks           ║'),
    format(' ║         Ola, ~w~w ║~n', [Nome, Padding]),
    writeln(' ╠══════════════════════════════════╣'),
    writeln(' ║      [1] Criar task              ║'),
    writeln(' ║      [2] Listar tasks            ║'),
    writeln(' ║      [3] Alterar status          ║'),
    writeln(' ║      [4] Alterar prioridade      ║'),
    writeln(' ║      [5] Excluir task            ║'),
    writeln(' ║      [6] Filtros                 ║'),
    writeln(' ║      [7] Estatisticas            ║'),
    writeln(' ║      [8] Logout                  ║'),
    writeln(' ║      [0] Sair                    ║'),
    writeln(' ╚══════════════════════════════════╝'),
    nl,

    read_line_to_string(user_input, Opcao),

    limpar_tela,

    tratar_opcao_principal(Opcao).

tratar_opcao_principal("1") :-
    acao_criar_task,
    menu_principal.

tratar_opcao_principal("2") :-
    acao_listar,
    menu_principal.

tratar_opcao_principal("3") :-
    acao_alterar_status,
    menu_principal.

tratar_opcao_principal("4") :-
    acao_alterar_prio,
    menu_principal.

tratar_opcao_principal("5") :-
    acao_excluir,
    menu_principal.

tratar_opcao_principal("6") :-
    menu_filtros,
    menu_principal.

tratar_opcao_principal("7") :-
    acao_estatisticas,
    menu_principal.

tratar_opcao_principal("8") :-
    sair,
    writeln('Logout.'),
    menu_login.

tratar_opcao_principal("0") :-
    writeln('Até logo!').

tratar_opcao_principal(_) :-
    writeln('Opção inválida.'),
    menu_principal.

acao_criar_task :-
    writeln('Titulo:'),
    read_line_to_string(user_input, Titulo),

    ( Titulo == "" ->
        writeln('Erro: titulo nao pode ser vazio.'),
        pausar
    ;
        writeln('Descricao:'),
        read_line_to_string(user_input, Descricao),

        writeln('Prioridade: [1] Low  [2] Medium  [3] High'),
        read_line_to_string(user_input, OpcaoPrio),

        escolher_prioridade(OpcaoPrio, Prioridade),

        writeln('Data limite (DD/MM/AAAA) ou Enter para sem prazo:'),
        read_line_to_string(user_input, Prazo),

        ( criar_nova_task(Titulo, Descricao, Prioridade, Prazo) ->
            writeln('Task criada!'),
            pausar
        ;
            writeln('Erro: sem usuario logado.'),
            pausar
        )
    ).

escolher_prioridade("2", media).
escolher_prioridade("3", alta).
escolher_prioridade(_, baixa).

acao_listar :-
    listar_minhas_tasks(Tarefas),

    ( Tarefas == [] ->
        writeln('Nenhuma task.'),
        pausar
    ;
        nl,
        imprimir_tasks(Tarefas),
        nl,
        pausar
    ).

imprimir_tasks([]).

imprimir_tasks([
    task(Id, _, Titulo, Descricao, Status, Prioridade, Prazo) | Rest
]) :-
    format('ID: ~w~n', [Id]),
    format('Título: ~w~n', [Titulo]),
    format('Descrição: ~w~n', [Descricao]),
    format('Status: ~w~n', [Status]),
    format('Prioridade: ~w~n', [Prioridade]),
    format('Prazo: ~w~n', [Prazo]),
    writeln('------------------------------'),
    imprimir_tasks(Rest).

listar_sem_pausa :-
    listar_minhas_tasks(Tarefas),

    ( Tarefas == [] ->
        writeln('Nenhuma task.')
    ;
        nl,
        imprimir_tasks(Tarefas),
        nl
    ).

acao_alterar_status :-
    listar_sem_pausa,

    write('\nID da task: '),
    read_line_to_string(user_input, TidStr),

    ( number_string(Tid, TidStr) ->
        listar_minhas_tasks(Tasks),

        ( member(Task, Tasks),
          Task = task(Tid, _, Titulo, Desc, StatusAtual, Prioridade, Prazo) ->

            limpar_tela,

            format('ID: ~w~nTitulo: ~w~nDescricao: ~w~nStatus: ~w~nPrioridade: ~w~nPrazo: ~w~n',
                   [Tid, Titulo, Desc, StatusAtual, Prioridade, Prazo]),

            writeln('\nAltere o status:'),
            writeln('[1] NaoFeito'),
            writeln('[2] EmProgresso'),
            writeln('[3] Feito'),
            write('Escolha: '),

            read_line_to_string(user_input, S),
            novo_status(S, NovoStatus),

            ( atualizar_status(Tid, NovoStatus) ->
                writeln('Status atualizado.')
            ;
                writeln('Erro.')
            ),
            pausar

        ;
            writeln('Task nao encontrada.'),
            pausar
        )

    ;
        writeln('ID invalido.'),
        pausar
    ).

novo_status("2", emProgresso).
novo_status("3", feito).
novo_status(_, naoFeito).

acao_alterar_prio :-
    listar_sem_pausa,

    write('\nID da task: '),
    read_line_to_string(user_input, TidStr),

    ( number_string(Tid, TidStr) ->
        listar_minhas_tasks(Tasks),

        ( member(Task, Tasks),
          Task = task(Tid, _, Titulo, Desc, Status, Prioridade, Prazo) ->

            limpar_tela,

            format('ID: ~w~nTitulo: ~w~nDescricao: ~w~nStatus: ~w~nPrioridade: ~w~nPrazo: ~w~n',
                   [Tid, Titulo, Desc, Status, Prioridade, Prazo]),

            writeln('[1] Low'),
            writeln('[2] Medium'),
            writeln('[3] High'),
            write('Nova prioridade: '),

            read_line_to_string(user_input, P),
            nova_prio(P, NovaPrio),

            ( atualizar_prioridade(Tid, NovaPrio) ->
                writeln('Prioridade atualizada.')
            ;
                writeln('Erro.')
            ),
            pausar

        ;
            writeln('Task nao encontrada.'),
            pausar
        )

    ;
        writeln('ID invalido.'),
        pausar
    ).

acao_excluir :-
    listar_minhas_tasks(Tasks),

    (
        Tasks == []
    ->
        writeln('Nenhuma task cadastrada.'),
        pausar
    ;
        writeln('=== Suas Tasks ==='),
        imprimir_tasks(Tasks),

        nl,
        write('ID da task que deseja excluir: '),
        read_line_to_string(user_input, IdStr),

        (
            catch(number_string(Id, IdStr), _, fail)
        ->
            (
                excluir_task(Id)
            ->
                writeln('Task removida com sucesso!'),
                pausar
            ;
                writeln('Task nao encontrada.'),
                pausar
            )
        ;
            writeln('ID invalido.'),
            pausar
        )
    ).

acao_estatisticas :-
    resumo_estatisticas(resumo(TotalN, IncompletasN, AndamentoN, FeitasN, AtrasadasN, Percent, NPendentes, TotalPendentes)),
    nl,
    writeln('  ╔══════════════════════════════════╗'),
    writeln('  ║        NOXION - Estatísticas     ║'),
    writeln('  ╠══════════════════════════════════╣'),
    format('  ║  Total de tasks:        ~w~n', [TotalN]),
    format('  ║  Não iniciadas:         ~w~n', [IncompletasN]),
    format('  ║  Em progresso:          ~w~n', [AndamentoN]),
    format('  ║  Concluídas:            ~w~n', [FeitasN]),
    format('  ║  Atrasadas:             ~w~n', [AtrasadasN]),
    writeln('  ╠══════════════════════════════════╣'),
    format('  ║  Percentual concluído:  ~w%~n', [Percent]),
    format('  ║  Pendentes:             ~w de ~w~n', [NPendentes, TotalPendentes]),
    writeln('  ╚══════════════════════════════════╝'),
    nl,
    pausar.

menu_filtros :-
    nl,
    writeln('  ╔══════════════════════════════════╗'),
    writeln('  ║         NOXION - Filtros         ║'),
    writeln('  ╠══════════════════════════════════╣'),
    writeln('  ║      [1] Por status              ║'),
    writeln('  ║      [2] Por prioridade          ║'),
    writeln('  ║      [3] Atrasadas               ║'),
    writeln('  ║      [0] Voltar                  ║'),
    writeln('  ╚══════════════════════════════════╝'),
    nl,
    write('Escolha: '),
    read_line_to_string(user_input, Opcao),

    limpar_tela,

    tratar_opcao_filtros(Opcao).

tratar_opcao_filtros("1") :-
    acao_filtro_status.

tratar_opcao_filtros("2") :-
    acao_filtro_prio.

tratar_opcao_filtros("3") :-
    acao_atrasadas.

tratar_opcao_filtros("0").

tratar_opcao_filtros(_) :-
    writeln('Opcao invalida.').

acao_filtro_status :-
    writeln('[1] NaoFeito  [2] EmProgresso  [3] Feito'),
    write('Status: '),
    read_line_to_string(user_input, Opcao),

    escolher_status(Opcao, Status),

    listar_por_status(Status, Tarefas),

    ( 
        Tarefas == []
    ->
        writeln('Nenhuma task com esse status.')
    ;
        imprimir_tasks(Tarefas)
    ),
    pausar.

escolher_status("2", em_progresso).
escolher_status("3", feito).
escolher_status(_, nao_feito).

acao_filtro_prio :-
    writeln('\n[1] Low  [2] Medium  [3] High'),
    write('Prioridade: '),
    read_line_to_string(user_input, P),

    nova_prio(P, Prioridade),

    listar_por_prioridade(Prioridade, Tasks),

    (
        Tasks = []
    ->
        writeln('\nNenhuma task com essa prioridade.\n')
    ;
        imprimir_tasks(Tasks)
    ),
    pausar.

nova_prio("1", baixa).
nova_prio("2", media).
nova_prio("3", alta).

acao_atrasadas :-
    listar_atrasadas(Tasks),
    ( Tasks == [] ->
        writeln('\nNenhuma task atrasada.\n')
    ;
        imprimir_tasks(Tasks)
    ),
    pausar.