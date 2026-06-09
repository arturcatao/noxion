module Models.Stats
    ( contarTasks
    , contarPorStatus
    , tasksAtrasadas
    , StatsGeral(..)
    , gerarStatsGeral
    ) where

import Data.Time (Day)
import Models.Task (Task(..))
import Models.Types (Status(..))
import Models.Filters (listAllTasks)

-- ! ! ! se quiser contar a quantidade de tasks dos metodos, fica pro main fazer o length

-- retorna uma lista de todas as tasks do usuario
contarTasks :: String -> [Task] -> [Task]
contarTasks uid tasks = listAllTasks uid tasks

-- filtra as tasks do usuario e depois filtra pelo status, e retorna a lista
contarPorStatus :: String -> Status -> [Task] -> [Task]
contarPorStatus uid s tasks = filter (\t -> status t == s) (listAllTasks uid tasks)

-- case Nothing significa que a task não tem prazo, Just dia significa que tem prazo, comparamos os dias para verificar atraso
taskAtrasada :: Day -> Task -> Bool
taskAtrasada hoje task =
    case dataLimite task of
        Nothing  -> False
        Just dia -> dia < hoje && status task /= Feito

-- lista de tasks atrasadas do usuario
tasksAtrasadas :: String -> Day -> [Task] -> [Task]
tasksAtrasadas uid hoje tasks =
    filter (taskAtrasada hoje) (listAllTasks uid tasks)

-- o main só acessa os campos e exibe
data StatsGeral = StatsGeral
    { totalTasks :: [Task]
    , naoIniciadas :: [Task]
    , emAndamento :: [Task]
    , concluidas :: [Task]
    , atrasadas :: [Task]
    } deriving (Show)

-- chama as funções acima e gera o resumo geral
gerarStatsGeral :: String -> Day -> [Task] -> StatsGeral
gerarStatsGeral uid hoje tasks =
    StatsGeral
        { totalTasks   = contarTasks uid tasks
        , naoIniciadas = contarPorStatus uid NaoFeito tasks
        , emAndamento  = contarPorStatus uid EmProgresso tasks
        , concluidas   = contarPorStatus uid Feito tasks
        , atrasadas    = tasksAtrasadas uid hoje tasks
        }