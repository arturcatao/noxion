:- module(auth, [
    cadastrar_user/3,
    login/2,
    logout/0,
    usuario_loggado
]).

:- use_module(db, [
    user/3,
    logged_in/1
]).

cadastrar_user(Login, Nome, Senha) :-
    \+ user(Login, _, _),
    assertz(user(Login, Nome, Senha))

login(Login, Senha) :-
    user(Login, _, Senha),
    assertz(logged_in(Login)).

logout :- retractall(logged_in(_))

usuario_loggado(Login) :- logged_in(Login)