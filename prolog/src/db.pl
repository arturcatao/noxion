:- module(db, [
    user/3,
    task/7,
    logged_in/1
    status/1,
    prioridade/1
]).

:- dinamic user/3.
:- dinamic task/7.
:- dinamic logged_in/1

% user(Login, Nome, Senha)
% task(Id, Login, Titulo, Descricao, Status, Prioridade, Prazo)
% logged_in(Login)

status(nao_feito)
status(em_progresso)
status(feito)

prioridade(baixa)
prioridade(media)
prioridade(alta)