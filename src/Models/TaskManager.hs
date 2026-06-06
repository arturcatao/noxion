module Models.TaskManager where 

import Models.Task (Task(..), criarTask)
import Models.AppState (AppState(..), tasks)
import Models.Types (Status, Priority)
import qualified Models.User as User  
import Data.Time (Day)

adicionarTask :: AppState -> String -> String -> Priority -> Maybe Day -> AppState
adicionarTask estado novoTitulo novaDesc prioridade prazo =
    case currentUser estado of
    Nothing   -> estado
    -- primeiro caso: nao tem ngm logado, então devolve o estado sem modificar
    Just user ->
        let uid = User.userId user
            novoId =  show (length (tasks estado) + 1)
            -- esse id é gerado baseado no tamanho da lista, mas podemos mudar a forma de fazer isso depois
            novaTask = criarTask novoId uid novoTitulo novaDesc prioridade prazo
        in estado {tasks = tasks estado ++ [novaTask]}

removerTask :: AppState -> String -> AppState
removerTask estado tid =
    let listaAtualizada = filter (\t -> taskId t /= tid) (tasks estado)
    -- para cada task t, ele mantem se o id for diferente
    in estado {tasks = listaAtualizada}

alterarStatus:: AppState -> String -> Status -> AppState
alterarStatus estado tid novoStatus =
    let listaAtualizada = map (\t -> 
            if taskId t == tid 
                then t {status = novoStatus} 
                else t 
            ) (tasks estado)
    in estado {tasks = listaAtualizada}

alterarPrioridade :: AppState -> String -> Priority -> AppState
alterarPrioridade estado tid novaPrioridade =
    let listaAtualizada = map (\t -> 
            if taskId t == tid 
                then t {priority = novaPrioridade}
                else t
            ) (tasks estado)
    in estado {tasks = listaAtualizada}

--  pequena observação: nunca mudem o estado, cada função recebe oum AppState 
-- e devolve um AppState novo com  a alteração aplicada
