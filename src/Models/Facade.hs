module Models.Facade
    ( criarConta
    , entrar
    , sair

    , criarNovaTask
    , excluirTask
    , atualizarStatus
    , atualizarPrioridade

    , listarMinhasTasks
    , listarPorStatus
    , listarPorPrioridade
    , listarAtrasadas

    , resumoEstatisticas
    ) where

import Data.Time (Day)

import Models.AppState
import Models.Auth
import Models.TaskManager
import Models.Filters
import Models.Stats
import Models.Task
import Models.Types

-- AUTENTICAÇÃO

criarConta :: AppState -> String -> String -> String -> Maybe AppState
criarConta = cadastraUser

entrar :: AppState -> String -> String -> Maybe AppState
entrar = login

sair :: AppState -> AppState
sair = logout

-- TASKS

criarNovaTask
    :: AppState
    -> String
    -> String
    -> Priority
    -> Maybe Day
    -> AppState
criarNovaTask = adicionarTask

excluirTask :: AppState -> Int -> Maybe AppState
excluirTask = removerTask

atualizarStatus :: AppState -> Int -> Status -> Maybe AppState
atualizarStatus = alterarStatus

atualizarPrioridade :: AppState -> Int -> Priority -> Maybe AppState
atualizarPrioridade = alterarPrioridade

-- FILTROS

listarMinhasTasks :: String -> AppState -> [Task]
listarMinhasTasks uid estado =
    listAllTasks uid (tasks estado)

listarPorStatus :: String -> Status -> AppState -> [Task]
listarPorStatus uid st estado =
    filterByStatus uid st (tasks estado)

listarPorPrioridade :: String -> Priority -> AppState -> [Task]
listarPorPrioridade uid pr estado =
    filterByPriority uid pr (tasks estado)

listarAtrasadas :: String -> Day -> AppState -> [Task]
listarAtrasadas uid hoje estado =
    tasksAtrasadas uid hoje (tasks estado)

-- ESTATÍSTICAS

resumoEstatisticas :: String -> Day -> AppState -> String
resumoEstatisticas uid hoje estado =
    let todas       = listAllTasks uid (tasks estado)
        incompletas = tasksIncompletas uid (tasks estado)
        andamento   = tasksEmProgresso uid (tasks estado)
        feitas      = tasksFeitas uid (tasks estado)
        atrasadas   = tasksAtrasadas uid hoje (tasks estado)
    in gerarStatsGeral
            todas
            incompletas
            andamento
            feitas
            atrasadas