-- tudo que ficar nessa lista sera publico
module Models.User
    ( User
    , criarUser
    , verificaSenha
    , userId
    , nome
    , tasks
    ) where

import Models.Task (Task)

data User = User 
    { userId :: String
    , nome :: String
    , senha :: String
    }

criarUser :: String -> String -> String -> User
criarUser uId n s = 
    User
        { userId = uId
        , nome = n
        , senha = s
        }

verificaSenha :: User -> String -> Bool
verificaSenha user s = s == senha user