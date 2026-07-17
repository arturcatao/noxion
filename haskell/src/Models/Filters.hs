module Models.Filters where


import Data.List (sortBy)
import Data.Ord (comparing, Down(..))
import Data.Time (Day)
import Models.Types (Status(..), Priority(..))
import Models.Task (Task(..))



filterByStatus :: Status -> [Task] -> [Task]
filterByStatus targetStatus tasks = filter (\t -> status t == targetStatus) tasks


filterByPriority :: Priority -> [Task] -> [Task]
filterByPriority targetPriority tasks = filter (\t -> priority t == targetPriority) tasks


sortByPriorityDesc :: [Task] -> [Task]
sortByPriorityDesc tasks = sortBy (comparing (Down . priority)) tasks


sortByDeadlineAsc :: [Task] -> [Task]
sortByDeadlineAsc tasks = sortBy (comparing dataLimite) tasks




tasksIncompletas :: [Task] -> [Task]
tasksIncompletas tasks = filterByStatus NaoFeito tasks


tasksEmProgresso :: [Task] -> [Task]
tasksEmProgresso tasks = filterByStatus EmProgresso tasks

tasksFeitas :: [Task] -> [Task]
tasksFeitas tasks = filterByStatus Feito tasks


tasksAtrasadas :: Day -> [Task] -> [Task]
tasksAtrasadas hoje tasks = filter (\t -> status t /= Feito && estaAtrasada (dataLimite t)) tasks
  where
    estaAtrasada Nothing     = False
    estaAtrasada (Just dLim) = dLim < hoje