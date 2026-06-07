module Models.Filters where

import Data.List (sortBy)
import Data.Ord (comparing, Down(..))
import Data.Time (Day)


import Models.Types (Status(..), Priority(..))
import Models.Task (Task(..))


listAllTasks :: [Task] -> [Task]
listAllTasks tasks = tasks


filterByStatus :: Status -> [Task] -> [Task]
filterByStatus target tasks = filter (\t -> status t == target) tasks


filterByPriority :: Priority -> [Task] -> [Task]
filterByPriority target tasks = filter (\t -> priority t == target) tasks


sortByPriorityDesc :: [Task] -> [Task]
sortByPriorityDesc tasks = sortBy (comparing (Down . priority)) tasks


sortByDeadlineAsc :: [Task] -> [Task]
sortByDeadlineAsc tasks = sortBy (comparing dataLimite) tasks