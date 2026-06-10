module Models.Stats
    ( contarTasks
    , percentualConcluidas
    , tasksPendentes
    , gerarStatsGeral
    ) where

import Models.Task (Task)

-- conta o total de tasks de uma lista (filtrada ou não)
contarTasks :: [Task] -> Int
contarTasks tasks = length tasks

-- recebe uma lista de todas as tasks e outra lista com as feitas, e calcula o percentual
percentualConcluidas :: [Task] -> [Task] -> String
percentualConcluidas todas feitas =
    let total = length todas
        percent = if total == 0 
            then 0 
            else (length feitas * 100) `div` total
    in show percent ++ "% concluidas"

-- recebe uma lista de todas as tasks e outra lista com as pendentes, e calcula a razão
tasksPendentes :: [Task] -> [Task] -> String
tasksPendentes todas pendentes =
    show (length pendentes) ++ "/" ++ show (length todas) ++ " tasks pendentes"

-- resumo geral em string pro main
gerarStatsGeral :: [Task] -> [Task] -> [Task] -> [Task] -> [Task] -> String
gerarStatsGeral todas incompletas emAndamento feitas atrasadas =
    "Total: "         ++ show (contarTasks todas)        ++ "\n" ++
    "Nao iniciadas: " ++ show (contarTasks incompletas)  ++ "\n" ++
    "Em andamento: "  ++ show (contarTasks emAndamento)  ++ "\n" ++
    "Concluidas: "    ++ show (contarTasks feitas)       ++ "\n" ++
    percentualConcluidas todas feitas                     ++ "\n" ++
    tasksPendentes todas incompletas                      ++ "\n" ++
    "Atrasadas: "     ++ show (contarTasks atrasadas)