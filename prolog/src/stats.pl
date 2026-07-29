:- module(stats, [
    contar_tasks/2,
    percentual_concluidas/3,
    razao_pendentes/4,
    gerar_stats_geral/10,
    gerar_resumo/1
]).

:- use_module(auth, [
    user_loggado/1
]).
:- use_module(filters, [
    listar_tasks_usuario/1,
    filtrar_por_status/2,
    filtrar_atrasadas/1
]).

% quantidade de tasks numa lista
contar_tasks(Tasks, N) :-
    length(Tasks, N).

% devolve só o numero do percentual (0 a 100)
percentual_concluidas(Todas, Feitas, Percent) :-
    length(Todas, Total),
    length(Feitas, NFeitas),
    ( Total =:= 0
    -> Percent = 0
    ;  Percent is (NFeitas * 100) // Total
    ).

% devolve a quantidade de pendentes e o total
razao_pendentes(Todas, Pendentes, NPendentes, Total) :-
    length(Todas, Total),
    length(Pendentes, NPendentes).

% monta um termo composto com todos os numeros calculados
% Todas, Incompletas, Andamento, Feitas, Atrasadas: listas de entrada (ja filtradas)
% TotalN, IncompletasN, AndamentoN, FeitasN, AtrasadasN: saídas
% uma saída para cada lista de entrada correspondente (sufixo N para demarcar que é um número)
gerar_stats_geral(Todas, Incompletas, Andamento, Feitas, Atrasadas, TotalN, IncompletasN, AndamentoN, FeitasN, AtrasadasN) :-
    contar_tasks(Todas, TotalN),
    contar_tasks(Incompletas, IncompletasN),
    contar_tasks(Andamento, AndamentoN),
    contar_tasks(Feitas, FeitasN),
    contar_tasks(Atrasadas, AtrasadasN).

% busca as listas do usuario logado e devolve todos os numeros separados
gerar_resumo(Resumo) :-
    listar_tasks_usuario(Todas),
    filtrar_por_status(nao_feito, Incompletas),
    filtrar_por_status(em_progresso, Andamento),
    filtrar_por_status(feito, Feitas),
    filtrar_atrasadas(Atrasadas),

    gerar_stats_geral(
        Todas,
        Incompletas,
        Andamento,
        Feitas,
        Atrasadas,
        TotalN,
        IncompletasN,
        AndamentoN,
        FeitasN,
        AtrasadasN
    ),

    percentual_concluidas(Todas, Feitas, Percent),

    razao_pendentes(
        Todas,
        Incompletas,
        NPendentes,
        TotalPendentes
    ),

    Resumo = resumo(
        TotalN,
        IncompletasN,
        AndamentoN,
        FeitasN,
        AtrasadasN,
        Percent,
        NPendentes,
        TotalPendentes
    ).