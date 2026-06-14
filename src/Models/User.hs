-- tudo que ficar nessa lista sera publico
module Models.User
    ( User
    , criarUser
    , verificaSenha
    , loginU
    , nome
    ) where

data User = User 
    { loginU :: String
    , nome :: String
    , senha :: String
    } deriving (Show, Eq)

criarUser :: String -> String -> String -> User
criarUser l n s = 
    User
        { loginU = l
        , nome = n
        , senha = s
        } 

verificaSenha :: User -> String -> Bool
verificaSenha user s = s == senha user