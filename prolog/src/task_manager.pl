:-module(task_manager, [
    adicionar_task/4,
    remover_task/1,
    alterar_status/2,
    alterar_prioridade/2,
    task_existe/1,
    proximo_id/1
]).

:-use_module(auth).
:- dynamic task/7.

%fatos simples/validacoes

status_valido(nao_feito).
status_valido(em_progresso).
status_valido(feito).

prioridade_valida(low).
prioridade_valida(medium).
prioridade_valida(high).

%gerar id unico (ainda vou ver como fazer)
proximo_id(Id).

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

alterar_status(Id, novoStatus) :-
    task_existe(Id),
    status_valido(novoStatus),
    retract(task(Id, Login, Titulo, Desc, _, Prioridade, Prazo)),
    assertz(task(Id, Login, Titulo, Desc, novoStatus, Prioridade, Prazo)).

alterar_prioridade(Id, novaPrioridade) :-
    task_existe(Id),
    prioridade_valida(novaPrioridade),
    retract(task(Id, Login, Titulo, Desc, Status, _, Prazo)),
    assertz(task(Id, Login, Titulo, Desc, Status, novaPrioridade, Prazo)).

%nos dois casos, excluimos o fato antigo e adicioa um novo, pois em PL nao existe modificar um fato existente