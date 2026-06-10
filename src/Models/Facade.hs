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
import qualified Data.Map.Strict as Map

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
    Map.findWithDefault [] uid (tasks estado)

listarPorStatus :: String -> Status -> AppState -> [Task]
listarPorStatus uid st estado =
    filterByStatus uid st $
        Map.findWithDefault [] uid (tasks estado)

listarPorPrioridade :: String -> Priority -> AppState -> [Task]
listarPorPrioridade uid pr estado =
    filterByPriority uid pr $
        Map.findWithDefault [] uid (tasks estado)

listarAtrasadas :: String -> Day -> AppState -> [Task]
listarAtrasadas uid hoje estado =
    tasksAtrasadas uid hoje $
        Map.findWithDefault [] uid (tasks estado)

-- ESTATÍSTICAS

resumoEstatisticas :: String -> Day -> AppState -> String
resumoEstatisticas uid hoje estado =
    let userTasks   = Map.findWithDefault [] uid (tasks estado)

        todas       = userTasks
        incompletas = tasksIncompletas uid userTasks
        andamento   = tasksEmProgresso uid userTasks
        feitas      = tasksFeitas uid userTasks
        atrasadas   = tasksAtrasadas uid hoje userTasks

    in gerarStatsGeral
            todas
            incompletas
            andamento
            feitas
            atrasadas