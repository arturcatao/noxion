module Models.AppState
    ( AppState(..)
    , emptyState
    , usuarioLogado
    ) where

import qualified Data.Map.Strict as Map

import Models.User (User)
import Models.Task (Task (Task))

--toda vez que atualizar algo, um novo estado do programa tem que ser gerado
data AppState = AppState
  { users       :: Map.Map String User
  , tasks       :: Map.Map String [Task]
  , currentUser :: Maybe User
  } deriving (Show)

-- def do estado inicial/vazio
emptyState :: AppState
emptyState = AppState
  { users       = Map.empty
  , tasks       = Map.empty
  , currentUser = Nothing
  }

usuarioLogado :: AppState -> Bool
usuarioLogado state = currentUser state /= Nothing