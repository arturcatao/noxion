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
    {titulo :: String,
     desc :: String,
     status :: Status,
     dataLimite :: Day
    } deriving (Show)

criarTask :: String -> String -> Day -> Task
criarTask t d date = 
    Task
        { titulo = t
        , desc = d
        , status = NaoFeito
        , dataLimite = date
        }