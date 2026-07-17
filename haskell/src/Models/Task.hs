module Models.Task where

import Data.Time
import Data.Time.Format (formatTime, defaultTimeLocale)
import Models.Types

data Task = Task
    { taskId :: Int
    , loginU :: String
    , titulo :: String
    , desc :: String
    , status :: Status
    , priority :: Priority
    , dataLimite :: Maybe Day
    } deriving (Show)

criarTask :: Int -> String -> String -> String -> Priority -> Maybe Day -> Task
criarTask tId l t d p date = 
    Task
        { taskId = tId
        , loginU = l
        , titulo = t
        , desc = d
        , status = NaoFeito
        , priority = p
        , dataLimite = date
        }

taskToString :: Task -> String
taskToString t =
    "[" ++ show (taskId t) ++ "] "
    ++ titulo t
    ++ "\nDescricao: " ++ desc t
    ++ "\nStatus: " ++ show (status t)
    ++ "\nPrioridade: " ++ show (priority t)
    ++ "\nPrazo: " ++ prazoStr
    ++ "\n"
  where
    prazoStr = case dataLimite t of
        Nothing  -> "sem prazo"
        Just dia -> formatTime defaultTimeLocale "%d/%m/%Y" dia