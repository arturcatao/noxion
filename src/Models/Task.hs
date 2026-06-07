module Models.Task where

import Data.Time
import Models.Types

data Task = Task
    { taskId :: Int
    , userId :: String
    , titulo :: String
    , desc :: String
    , status :: Status
    , priority :: Priority
    , dataLimite :: Maybe Day
    } deriving (Show)

criarTask :: Int -> String -> String -> String -> Priority -> Maybe Day -> Task
criarTask tId uId t d p date = 
    Task
        { taskId = tId
        , userId = uId
        , titulo = t
        , desc = d
        , status = NaoFeito
        , priority = p
        , dataLimite = date
        }