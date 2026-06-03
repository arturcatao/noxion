-- tudo que ficar nessa lista sera publico
module Models.User
    ( User
    , criarUser
    , verificaSenha
    , userId
    , nome
    ) where

data User = User 
    { userId :: String
    , nome :: String
    , senha :: String
    } deriving (Show, Eq)

criarUser :: String -> String -> String -> User
criarUser uId n s = 
    User
        { userId = uId
        , nome = n
        , senha = s
        } 

verificaSenha :: User -> String -> Bool
verificaSenha user s = s == senha user