module Models.User where

data User = User 
    { userId :: String,
      nome :: String,
      senha :: String
    }