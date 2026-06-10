module Models.TaskManager where

import qualified Data.Map.Strict as Map
import Models.Task (Task(..), criarTask)
import Models.AppState (AppState(..), tasks)
import Models.Types (Status, Priority)
import qualified Models.User as User
import Data.Time (Day)

taskExiste :: Int -> AppState -> Bool
taskExiste tid estado =
    any (any (\t -> taskId t == tid)) (Map.elems (tasks estado))

adicionarTask :: AppState -> String -> String -> Priority -> Maybe Day -> Maybe AppState
adicionarTask estado novoTitulo novaDesc prioridade prazo =
    case currentUser estado of
    Nothing   -> Nothing
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

        in Just (estado {tasks = novoMapa})

removerTask :: AppState -> Int -> Maybe AppState
removerTask estado tid
    | not (taskExiste tid estado) = Nothing
    | otherwise =
        let listaAtualizada = Map.map (filter (\t -> taskId t /= tid)) (tasks estado)
        -- para cada task t, ele mantem se o id for diferente
        in Just (estado {tasks = listaAtualizada})

alterarStatus:: AppState -> Int -> Status -> Maybe AppState
alterarStatus estado tid novoStatus
    | not (taskExiste tid estado) = Nothing
    | otherwise = 
        let listaAtualizada = Map.map (map (\t ->
                if taskId t == tid
                    then t {status = novoStatus}
                    else t
                )) (tasks estado)
        in Just (estado {tasks = listaAtualizada})

alterarPrioridade :: AppState -> Int -> Priority -> Maybe AppState
alterarPrioridade estado tid novaPrioridade 
    | not (taskExiste tid estado) = Nothing
    | otherwise = 
        let listaAtualizada = Map.map (map (\t ->
                if taskId t == tid
                    then t {priority = novaPrioridade}
                    else t
                )) (tasks estado)
        in Just (estado {tasks = listaAtualizada})

--  pequena observação: nunca mudem o estado, cada função recebe oum AppState 
-- e devolve um AppState novo com  a alteração aplicada