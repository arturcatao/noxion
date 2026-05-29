module Models.Task where

import Data.Time

data Status 
    = NaoFeito
    | EmProgresso 
    | Feito
    deriving (Show, Eq, Enum) 

data Priority
    = Low
    | Medium
    | High
    deriving (Show, Eq, Ord, Enum)

data Task = Task
    { taskId :: Int
    , titulo :: String
    , desc :: String
    , status :: Status
    , dataLimite :: Day
    } deriving (Show)

criarTask :: Int -> String -> String -> Day -> Task
criarTask tId t d date = 
    Task
        { taskId = tId
        , titulo = t
        , desc = d
        , status = NaoFeito
        , dataLimite = date
        }