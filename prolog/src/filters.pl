:- module(filters, [
    listar_tasks_usuario/2,
    filtrar_por_status/2,
    filtrar_por_prioridade/2,
    ordenar_por_prioridade/2,
    ordenar_por_prazo/2,
    listar_atrasadas/1
]).

:- use_module(db, [
    task/7,
    status/1,
    prioridade/1
]).
:- use_module(auth, [
    user_loggado/1
]).
:- use_module(library(pairs)).



%Listar todas as tarefas de um usuário


listar_tasks_usuario(Login, Tarefas) :-
    findall(
        task(Id, Login, Titulo, Descricao, Status, Prioridade, Prazo),
        task(Id, Login, Titulo, Descricao, Status, Prioridade, Prazo),
        Tarefas
    ).


%Filtros (sobre as tarefas do usuário logado)


filtrar_por_status(Status, Tarefas) :-
    status(Status),
    user_loggado(Login),
    findall(
        task(Id, Login, Titulo, Descricao, Status, Prioridade, Prazo),
        task(Id, Login, Titulo, Descricao, Status, Prioridade, Prazo),
        Tarefas
    ).

filtrar_por_prioridade(Prioridade, Tarefas) :-
    prioridade(Prioridade),
    user_loggado(Login),
    findall(
        task(Id, Login, Titulo, Descricao, Status, Prioridade, Prazo),
        task(Id, Login, Titulo, Descricao, Status, Prioridade, Prazo),
        Tarefas
    ).

% Ordenações


% Convenção explícita de prioridade
prioridade_valor(baixa, 1).
prioridade_valor(media, 2).
prioridade_valor(alta, 3).

% Ordenar tarefas por prioridade 
ordenar_por_prioridade(TarefasIn, TarefasOut) :-
    map_list_to_pairs(chave_prioridade, TarefasIn, Pares),
    keysort(Pares, ParesCrescente),
    reverse(ParesCrescente, ParesDecrescente),
    pairs_values(ParesDecrescente, TarefasOut).

chave_prioridade(task(_, _, _, _, _, Prioridade, _), Valor) :-
    (   prioridade_valor(Prioridade, V) -> Valor = V
    ;   Valor = 0 % Tratamento para evitar falhas 
    ).

% Ordenar tarefas por prazo (do prazo mais próximo para o mais distante)
ordenar_por_prazo(TarefasIn, TarefasOut) :-
    map_list_to_pairs(chave_prazo, TarefasIn, Pares),
    keysort(Pares, ParesOrdenados),
    pairs_values(ParesOrdenados, TarefasOut).

chave_prazo(task(_, _, _, _, _, _, Prazo), Prazo).

% Bônus / Atrasadas

listar_atrasadas(Tarefas) :-
    user_loggado(Login),
    get_time(Agora),
    format_time(string(HojeStr), '%Y-%m-%d', Agora),
    findall(
        task(Id, Login, Titulo, Descricao, Status, Prioridade, Prazo),
        (
            task(Id, Login, Titulo, Descricao, Status, Prioridade, Prazo),
            Status \= feito,
            Prazo @< HojeStr
        ),
        Tarefas
    ).