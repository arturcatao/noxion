module Models.Task where

import Data.Time
import Models.Types

data Task = Task
    { taskId :: String
    , userId :: String
    , titulo :: String
    , desc :: String
    , status :: Status
    , dataLimite :: Maybe Day
    } deriving (Show)

criarTask :: String -> String -> String -> String ->  Maybe Day -> Task
criarTask tId uId t d date = 
    Task
        { taskId = tId
        , userId = uId
        , titulo = t
        , desc = d
        , status = NaoFeito
        , dataLimite = date
        }