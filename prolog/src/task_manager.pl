:-module(task_manager, [
    adicionar_task/4,
    remover_task/1,
    alterar_status/2,
    alterar_prioridade/2,
    task_existe/1,
    proximo_id/1
]).

:-use_module(auth).
:- use_module(db, [
    task/7,
    status/1,
    prioridade/1
]).

%fatos simples/validacoes

status_valido(Status) :-
    status(Status).

prioridade_valida(Prioridade) :-
    prioridade(Prioridade).

%gerar id unico (ainda vou ver como fazer)
proximo_id(Id) :-
    findall(X, task(X, _, _, _, _, _, _), Ids),
    ( Ids = []
    -> Id = 1
    ;  max_list(Ids, Max),
       Id is Max + 1
    ).

%TaskEXISTE: Tenta encontrar um fato task com o id passado. 

task_existe(Id) :-
    task(Id, _, _, _, _, _, _).

%adicionar uma task
adicionar_task(Titulo, Desc, Prioridade, Prazo) :-
    user_loggado(Login),
    prioridade_valida(Prioridade),
    proximo_id(Id),
    assertz(task(Id, Login, Titulo, Desc, nao_feito, Prioridade, Prazo)).

%aparentemente esse assertz adiciona o fato task(...) no banco de dados

remover_task(Id) :-
    task_existe(Id),
    retract(task(Id,_,_,_,_,_,_)).

alterar_status(Id, NovoStatus) :-
    task_existe(Id),
    status_valido(NovoStatus),
    retract(task(Id, Login, Titulo, Desc, _, Prioridade, Prazo)),
    assertz(task(Id, Login, Titulo, Desc, NovoStatus, Prioridade, Prazo)).

alterar_prioridade(Id, NovaPrioridade) :-
    task_existe(Id),
    prioridade_valida(NovaPrioridade),
    retract(task(Id, Login, Titulo, Desc, Status, _, Prazo)),
    assertz(task(Id, Login, Titulo, Desc, Status, NovaPrioridade, Prazo)).

%nos dois casos, excluimos o fato antigo e adicioa um novo, pois em PL nao existe modificar um fato existente