:- module(facade, [
    criar_conta/3,
    entrar/2,
    sair/0,
    usuario_logado/1,

    criar_nova_task/4,
    excluir_task/1,
    atualizar_status/2,
    atualizar_prioridade/2,

    listar_minhas_tasks/1,
    listar_por_status/2,
    listar_por_prioridade/2,
    listar_atrasadas/1,

    resumo_estatisticas/1
]).

:- use_module(auth).
:- use_module(task_manager).
:- use_module(filters).
:- use_module(stats).

% auth

criar_conta(Login, Nome, Senha) :-
    cadastrar_usuario(Login, Nome, Senha).

entrar(Login, Senha) :-
    login(Login, Senha).

sair :-
    logout.

usuario_logado(Login) :-
    user_loggado(Login).

& tasks

criar_nova_task(Titulo, Desc, Prioridade, Prazo) :-
    adicionar_task(Titulo, Desc, Prioridade, Prazo).

excluir_task(Id) :-
    remover_task(Id).

atualizar_status(Id, Status) :-
    alterar_status(Id, Status).

atualizar_prioridade(Id, Prioridade) :-
    alterar_prioridade(Id, Prioridade).

% filters

listar_minhas_tasks(Tarefas) :-
    listar_tasks(Tarefas).

listar_por_status(Status, Tarefas) :-
    filtrar_por_status(Status, Tarefas).

listar_por_prioridade(Prioridade, Tarefas) :-
    filtrar_por_prioridade(Prioridade, Tarefas).

listar_atrasadas(Tarefas) :-
    listar_atrasadas(Tarefas).

% stats

resumo_estatisticas(Resumo) :-
    gerar_resumo(Resumo).