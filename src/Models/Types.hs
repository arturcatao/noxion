module Models.Types where

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