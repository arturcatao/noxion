module Models.Filters where


import Data.List (sortBy)
import Data.Ord (comparing, Down(..))
import Data.Time (Day)
import Models.Types (Status(..), Priority(..))
import Models.Task (Task(..))

--  retorna APENAS as tasks daquele userId específico
listAllTasks :: String -> [Task] -> [Task]
listAllTasks targetUid tasks = filter (\t -> userId t == targetUid) tasks

-- Filtra por status (apenas as tarefas do usuário)
filterByStatus :: String -> Status -> [Task] -> [Task]
filterByStatus targetUid targetStatus tasks = 
    filter (\t -> status t == targetStatus) (listAllTasks targetUid tasks)

-- Filtra por prioridade (apenas as tarefas do usuário)
filterByPriority :: String -> Priority -> [Task] -> [Task]
filterByPriority targetUid targetPriority tasks = 
    filter (\t -> priority t == targetPriority) (listAllTasks targetUid tasks)

-- Ordena por prioridade (maior primeiro - apenas as tarefas do usuário)
sortByPriorityDesc :: String -> [Task] -> [Task]
sortByPriorityDesc targetUid tasks = 
    sortBy (comparing (Down . priority)) (listAllTasks targetUid tasks)

-- Ordena por deadline (mais próxima primeiro - apenas as tarefas do usuário)
sortByDeadlineAsc :: String -> [Task] -> [Task]
sortByDeadlineAsc targetUid tasks = 
    sortBy (comparing dataLimite) (listAllTasks targetUid tasks)