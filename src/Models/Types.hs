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

--toda vez que atualizar algo, um novo estado do programa tem que ser gerado
data AppState = AppState
  { users       :: [User]
  , tasks       :: [Task]
  , currentUser :: Maybe User
  } deriving (Show)

-- def do estado inicial/vazio
emptyState :: AppState
emptyState = AppState
  { users       = []
  , tasks       = []
  , currentUser = Nothing
  }