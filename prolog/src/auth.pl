:- module(auth, [
    cadastrar_usuario/3,
    login/2,
    logout/0,
    user_loggado/1
]).

:- use_module(db, [
    user/3,
    logged_in/1
]).

cadastrar_usuario(Login, Nome, Senha) :-
    string(Login),
    string(Nome),
    string(Senha),
    Login \= "",
    Nome \= "",
    Senha \= "",
    \+ db:user(Login, _, _),
    assertz(db:user(Login, Nome, Senha)).

login(Login, Senha) :-
    db:user(Login, _, Senha),
    retractall(db:logged_in(_)),
    assertz(db:logged_in(Login)).

logout :-
    retractall(db:logged_in(_)).

user_loggado(Login) :- logged_in(Login).