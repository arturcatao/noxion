:- use_module('src/fachada.pl').    
:- use_module(library(readutil)).
:- use_module(library(process)).

main :-
    writeln('=== NOXION ==='),
    nl,
    menu_login.

limpar_tela :-
    process_create(path(cmd), ['/c','cls'], []).

limpar_tela :-
    ( current_prolog_flag(windows, true)
    -> process_create(path(cmd), ['/c','cls'], [])
    ;  process_create(path(clear), [], [])
    ).

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