
% "dynamic" avisa ao interpretador que esses fatos podem ser alterados, adicionados ou removidos em tempo de execução
:- dynamic perfil_ativo/1.
:- dynamic caminho_perfil_ativo/1.
:- dynamic assistiu/2.
:- dynamic salvar_anime/2.

/*
    'ensure_loaded' funciona como um 'import' ou 'include'.
    Ele carrega todo o conteúdo de 'X.pl' para a memória RAM.
    Se 'X.pl' não estiver na mesma pasta, o programa falha aqui.
 */
:- ensure_loaded('handlers.pl').

iniciar :-
    write('----------------------------------------------------------'), nl,
    write('                      TeiAnime - 提案                      '), nl,
    write('             Sugestão de animes personalizada             '), nl,
    write('----------------------------------------------------------'), nl, nl,
    menu
.

menu:-
    repeat,
    nl,
    write('-------- MENU PRINCIPAL --------'), nl, nl,
    write('[1] Criar perfil'), nl,
    write('[2] Carregar perfil'), nl,
    write('[3] Excluir perfil'), nl,
    write('[4] Meus animes'), nl,
    write('[5] Adicionar anime assitido'), nl,
    write('[6] Sugestão de anime'), nl,
    write('[7] Sugestão aleatória'), nl,
    write('[8] Sugerir animes populares'), nl,
    write('[9] Sugerir animes da season atual'), nl,
    write('[10] Sugerir animes da próxima season'), nl,
    write('[0] Sair'), nl,

    write('O que deseja fazer agora?'), nl,

    % Lê a linha inteira como string e converte para número para evitar resíduos no buffer
    read_line_to_string(user_input, OpcaoStr),
    (   number_string(Opcao, OpcaoStr)
    ->  true
    ;   Opcao = -1 % Valor inválido caso o usuário aperte Enter sem digitar nada
    ),
    
    tratar_opcao(Opcao),

    Opcao = 0,      % Condição de parada: Se Opcao for 0, a linha seguinte (Cut) é executada.
                    % Se Opcao não for 0, a linha 'Opcao = 0' falha e o Prolog faz
                    % backtracking até o 'repeat' e executa tudo novamente.

    !               % Cut (!): Quebra o 'repeat' e encerra o predicado menu_loop.
.