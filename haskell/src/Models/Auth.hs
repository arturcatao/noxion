-- Controller
module Models.Auth
    ( login
    , logout
    , cadastraUser
    , credenciaisValidas
    ) where

import qualified Data.Map.Strict as Map

import Models.AppState (AppState(..))
import Models.User (verificaSenha, criarUser)

login :: AppState -> String -> String -> Maybe AppState
login state userId senha  
    | not (Map.member userId (users state)) = Nothing
    | verificaSenha user senha = Just (state { currentUser = Just user })
    | otherwise = Nothing 
    where user = users state Map.! userId

logout :: AppState -> AppState
logout state = state {currentUser = Nothing}

credenciaisValidas :: String -> String -> Bool
credenciaisValidas userId senha = not (null userId) && not (null senha)

usuarioExistente :: AppState -> String -> Bool
usuarioExistente state userId = Map.member userId (users state)

--assim que cadastra tmb se faz o login
cadastraUser :: AppState -> String -> String -> String -> Maybe AppState
cadastraUser state userId nome senha
    | usuarioExistente state userId = Nothing
    | not (credenciaisValidas userId senha) = Nothing
    | otherwise =
        login estadoComUsuario userId senha
  where
    novoUser = criarUser userId nome senha

    estadoComUsuario = state { users = Map.insert userId novoUser (users state) }