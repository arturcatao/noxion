module Models.Task where

import Data.Time
import Models.Types

data Task = Task
    { taskId :: Int
    , titulo :: String
    , desc :: String
    , status :: Status
    , dataLimite :: Maybe Day
    } deriving (Show)

criarTask :: Int -> String -> String ->  Maybe Day -> Task
criarTask tId t d date = 
    Task
        { taskId = tId
        , titulo = t
        , desc = d
        , status = NaoFeito
        , dataLimite = date
        }