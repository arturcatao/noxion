module Main where

import Data.Time (getCurrentTime, utctDay, Day, defaultTimeLocale, parseTimeM)
import Models.AppState (AppState, emptyState, currentUser)
import Models.Facade
import Models.Task (taskToString, taskId)
import Models.Types (Status(..), Priority(..))
import qualified Models.User as User
import System.Process (system)
import System.Info (os)

main :: IO()

main = do 
    putStrLn "=== NOXION ==="
    menuLogin emptyState

limparTela :: IO ()
limparTela = do
    _ <- if os == "mingw32"
            then system "cls"
            else system "clear"  
    return ()

pausar :: IO ()
pausar = do
    putStrLn "\nPressione Enter para continuar..."
    _ <- getLine
    limparTela
    return ()

menuLogin :: AppState -> IO()
menuLogin state = do
    putStrLn "\n[1] Login"
    putStrLn "[2] Cadastrar"
    putStrLn "[0] Sair"
    putStr "Escolha: "
    opcao <- getLine
    limparTela
    case opcao of
        "1" -> fazerLogin state
        "2" -> fazerCadastro state
        "0" -> putStrLn "Ate logo!"
        _   -> putStrLn "Opcao invalida." >> menuLogin state

fazerLogin :: AppState -> IO ()
fazerLogin state = do
    putStrLn "ID: "
    uid <- getLine
    putStrLn "Senha: "
    senha <- getLine
    case entrar state uid senha of
        Nothing -> putStrLn "Credenciais invalidas." >> menuLogin state
        Just novoState -> do
            let nomeUser = maybe "" User.nome (currentUser novoState)
            putStrLn ("Bem-vindo, " ++ nomeUser ++ "!")
            menuPrincipal novoState

fazerCadastro :: AppState -> IO ()
fazerCadastro state = do
    putStrLn "\n=== Cadastro de Usuario ==="
    putStrLn "Digite seu ID: "
    uid <- getLine
    putStrLn "Digite seu nome: "
    n <- getLine
    putStrLn "Digite sua senha: "
    senha <- getLine
    limparTela
    if null uid || null n || null senha
        then putStrLn "Erro: nenhum campo pode ser vazio." >> pausar >> menuLogin state
        else case criarConta state uid n senha of
            Nothing -> do
                putStrLn "\nErro: ID ja existe ou dados invalidos."
                pausar
                menuLogin state
            Just novoState -> do
                putStrLn "\nConta criada com sucesso!"
                let nomeUser = maybe "" User.nome (currentUser novoState)
                putStrLn ("Bem-vindo, " ++ nomeUser ++ "!")
                pausar
                menuPrincipal novoState
menuPrincipal :: AppState -> IO ()
menuPrincipal state = do
    putStrLn "\n=== Menu Principal ==="
    putStrLn "[1] Criar task"
    putStrLn "[2] Listar tasks"
    putStrLn "[3] Alterar status"
    putStrLn "[4] Alterar prioridade"
    putStrLn "[5] Excluir task"
    putStrLn "[6] Filtros"
    putStrLn "[7] Estatisticas"
    putStrLn "[8] Logout"
    putStrLn "[0] Sair"
    opcao <- getLine
    limparTela
    case opcao of
        "1" -> acaoCriarTask state     >>= menuPrincipal
        "2" -> acaoListar state        >>= menuPrincipal
        "3" -> acaoAlterarStatus state >>= menuPrincipal
        "4" -> acaoAlterarPrio state   >>= menuPrincipal
        "5" -> acaoExcluir state       >>= menuPrincipal
        "6" -> menuFiltros state       >>= menuPrincipal
        "7" -> acaoEstatisticas state  >>= menuPrincipal
        "8" -> putStrLn "Logout." >> menuLogin (sair state)
        "0" -> putStrLn "Ate logo!"
        _   -> putStrLn "Opcao invalida." >> menuPrincipal state

acaoCriarTask :: AppState -> IO AppState
acaoCriarTask state = do
    putStrLn "Titulo: "
    t <- getLine
    if null t
        then putStrLn "Erro: titulo nao pode ser vazio." >> pausar >> return state
        else do
            putStrLn "Descricao: "
            d <- getLine
            putStrLn "Prioridade: [1] Low  [2] Medium  [3] High"
            p <- getLine
            let prio = case p of
                         "2" -> Medium
                         "3" -> High
                         _   -> Low
            putStrLn "Data limite (DD/MM/AAAA) ou Enter para sem prazo: "
            dataStr <- getLine
            let prazo = if null dataStr
                            then Nothing
                            else parseTimeM True defaultTimeLocale "%d/%m/%Y" dataStr :: Maybe Day
            case criarNovaTask state t d prio prazo of
                Nothing -> putStrLn "Erro: sem usuario logado." >> pausar >> return state
                Just novoState -> putStrLn "Task criada!" >> pausar >> return novoState
        
acaoListar :: AppState -> IO AppState
acaoListar state = do
    let ts = listarMinhasTasks state

    if null ts
        then putStrLn "Nenhuma task." >> pausar
        else do
            putStrLn ""
            mapM_ (putStrLn . taskToString) ts
            putStrLn ""
            pausar
    return state

imprimirTaskPorId :: AppState -> Int -> IO ()
imprimirTaskPorId state tid = do
    let ts = listarMinhasTasks state
        task = filter (\t -> taskId t == tid) ts
    case task of
        []    -> putStrLn "Task nao encontrada."
        (t:_) -> putStrLn (taskToString t)

acaoAlterarStatus :: AppState -> IO AppState
acaoAlterarStatus state = do
    putStrLn "\nID da task:"
    tidStr <- getLine
    case reads tidStr of
        [(tid, "")] -> do
            let ts = listarMinhasTasks state
                task = filter (\t -> taskId t == tid) ts
            case task of
                [] -> putStrLn "Task nao encontrada." >> pausar >> return state
                (t:_) -> do
                    putStrLn (taskToString t)
                    putStrLn "\nAltere o status:"
                    putStrLn "[1] NaoFeito"
                    putStrLn "[2] EmProgresso"
                    putStrLn "[3] Feito"
                    putStr "Escolha: "
                    s <- getLine
                    let novoStatus = case s of
                            "2" -> EmProgresso
                            "3" -> Feito
                            _   -> NaoFeito
                    case atualizarStatus state tid novoStatus of
                        Nothing        -> putStrLn "Erro." >> pausar >> return state
                        Just novoState -> putStrLn "Status atualizado." >> pausar >> return novoState
        _ -> putStrLn "ID invalido." >> pausar >> return state


acaoAlterarPrio :: AppState -> IO AppState
acaoAlterarPrio state = do
    putStrLn "\nID da task: "
    tidStr <- getLine
    case reads tidStr of
        [(tid, "")] -> do
            let ts = listarMinhasTasks state
                task = filter (\t -> taskId t == tid) ts
            case task of
                [] -> putStrLn "Task nao encontrada." >> pausar >> return state
                (t:_) -> do
                    putStrLn (taskToString t)
                    putStrLn "[1] Low"
                    putStrLn "[2] Medium"
                    putStrLn "[3] High"
                    putStrLn "Nova prioridade: "
                    p <- getLine
                    let novaPrio = case p of
                                     "2" -> Medium
                                     "3" -> High
                                     _   -> Low
                    case atualizarPrioridade state tid novaPrio of
                        Nothing        -> putStrLn "Erro." >> pausar >> return state
                        Just novoState -> putStrLn "Prioridade atualizada." >> pausar >> return novoState
        _ -> putStrLn "ID invalido." >> pausar >> return state

acaoExcluir :: AppState -> IO AppState
acaoExcluir state = do
    putStrLn "\nID da task: "
    tidStr <- getLine
    case reads tidStr of
        [(tid, "")] -> case excluirTask state tid of
            Nothing        -> putStrLn "Task nao encontrada." >> pausar >> return state
            Just novoState -> putStrLn "Task removida."       >> pausar >> return novoState
        _ -> putStrLn "ID invalido." >> pausar >> return state

acaoEstatisticas :: AppState -> IO AppState
acaoEstatisticas state = do
    hoje <- utctDay <$> getCurrentTime
    putStrLn (resumoEstatisticas hoje state)
    pausar
    return state

menuFiltros :: AppState -> IO AppState
menuFiltros state = do
    putStrLn "\n=== Filtros ==="
    putStrLn "[1] Por status"
    putStrLn "[2] Por prioridade"
    putStrLn "[3] Atrasadas"
    putStrLn "[0] Voltar"
    putStr "Escolha: "
    opcao <- getLine
    limparTela
    case opcao of
        "1" -> acaoFiltroStatus state
        "2" -> acaoFiltroPrio state
        "3" -> acaoAtrasadas state
        "0" -> return state
        _   -> putStrLn "Opcao invalida." >> return state

acaoFiltroStatus :: AppState -> IO AppState
acaoFiltroStatus state = do
    putStrLn "\n[1] NaoFeito  [2] EmProgresso  [3] Feito"
    putStr "Status: "
    s <- getLine
    let st = case s of
               "2" -> EmProgresso
               "3" -> Feito
               _   -> NaoFeito
    let ts = listarPorStatus st state
    if null ts
        then putStrLn "Nenhuma task com esse status."
        else mapM_ (putStrLn . taskToString) ts
    return state

acaoFiltroPrio :: AppState -> IO AppState
acaoFiltroPrio state = do
    putStrLn "\n[1] Low  [2] Medium  [3] High"
    putStrLn "Prioridade: "
    p <- getLine
    let pr = case p of
               "2" -> Medium
               "3" -> High
               _   -> Low
    let ts = listarPorPrioridade pr state
    if null ts
        then putStrLn "\nNenhuma task com essa prioridade.\n"
        else mapM_ (putStrLn . taskToString) ts
    return state

acaoAtrasadas :: AppState -> IO AppState
acaoAtrasadas state = do
    hoje <- utctDay <$> getCurrentTime
    let ts = listarAtrasadas hoje state
    if null ts
        then putStrLn "\nNenhuma task atrasada.\n"
        else mapM_ (putStrLn . taskToString) ts
    return state