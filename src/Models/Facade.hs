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
import qualified Models.User as User

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
    -> Maybe AppState
criarNovaTask = adicionarTask

excluirTask :: AppState -> Int -> Maybe AppState
excluirTask = removerTask

atualizarStatus :: AppState -> Int -> Status -> Maybe AppState
atualizarStatus = alterarStatus

atualizarPrioridade :: AppState -> Int -> Priority -> Maybe AppState
atualizarPrioridade = alterarPrioridade

-- FILTROS

listarMinhasTasks :: AppState -> [Task]
listarMinhasTasks estado =
    Map.findWithDefault [] (User.userId user) (tasks estado)
  where
    Just user = currentUser estado

listarPorStatus :: Status -> AppState -> [Task]
listarPorStatus st estado =
    filterByStatus st (listarMinhasTasks estado)

listarPorPrioridade :: Priority -> AppState -> [Task]
listarPorPrioridade pr estado =
    filterByPriority pr (listarMinhasTasks estado)

listarAtrasadas :: Day -> AppState -> [Task]
listarAtrasadas hoje estado =
    tasksAtrasadas hoje (listarMinhasTasks estado)

-- ESTATÍSTICAS

resumoEstatisticas :: Day -> AppState -> String
resumoEstatisticas hoje estado =
    let todas       = listarMinhasTasks estado
        incompletas = listarPorStatus NaoFeito estado
        andamento   = listarPorStatus EmProgresso estado
        feitas      = listarPorStatus Feito estado
        atrasadas   = listarAtrasadas hoje estado

    in gerarStatsGeral
            todas
            incompletas
            andamento
            feitas
            atrasadas