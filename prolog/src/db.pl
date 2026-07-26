:- module(db, [
    user/3,
    task/7,
    logged_in/1,
    status/1,
    prioridade/1
]).

:- dynamic user/3.
:- dynamic task/7.
:- dynamic logged_in/1.

% user(Login, Nome, Senha)
% task(Id, Login, Titulo, Descricao, Status, Prioridade, Prazo)
% logged_in(Login)

status(nao_feito).
status(em_progresso).
status(feito).

prioridade(baixa).
prioridade(media).
prioridade(alta).