module Models.TaskManager where 

import qualified Data.Map.Strict as Map
import Models.Task (Task(..), criarTask)
import Models.AppState (AppState(..), tasks)
import Models.Types (Status, Priority)
import qualified Models.User as User  
import Data.Time (Day)

adicionarTask :: AppState -> String -> String -> Priority -> Maybe Day -> AppState
adicionarTask estado novoTitulo novaDesc prioridade prazo =
    case currentUser estado of
    Nothing   -> estado
    Just user ->
        let uid = User.userId user
            userTasks = 
                Map.findWithDefault [] uid (tasks estado)
            
            novoId =  
                case userTasks of 
                        [] -> 1
                        ts -> taskId (last ts) + 1
            
            novaTask = 
                criarTask novoId uid novoTitulo novaDesc prioridade prazo
        
            novoMapa = 
                Map.insert uid (userTasks ++ [novaTask]) (tasks estado)

        in estado {tasks = novoMapa}

removerTask :: AppState -> Int -> AppState
removerTask estado tid =
    let listaAtualizada = Map.map (filter (\t -> taskId t /= tid)) (tasks estado)
    -- para cada task t, ele mantem se o id for diferente
    in estado {tasks = listaAtualizada}

alterarStatus:: AppState -> Int -> Status -> AppState
alterarStatus estado tid novoStatus =
    let listaAtualizada = Map.map (map (\t -> 
            if taskId t == tid 
                then t {status = novoStatus} 
                else t 
            )) (tasks estado)
    in estado {tasks = listaAtualizada}

alterarPrioridade :: AppState -> Int -> Priority -> AppState
alterarPrioridade estado tid novaPrioridade =
    let listaAtualizada = Map.map (map (\t -> 
            if taskId t == tid 
                then t {priority = novaPrioridade}
                else t
            )) (tasks estado)
    in estado {tasks = listaAtualizada}

--  pequena observação: nunca mudem o estado, cada função recebe oum AppState 
-- e devolve um AppState novo com  a alteração aplicada