module Models.User where
import Models.Task (Task)

data User = User 
    { userId :: String,
      nome :: String,
      senha :: String,
      tasks :: [Task]
    }