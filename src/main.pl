

:- ensure_loaded('handlers.pl').
:- ensure_loaded('ui.pl').
:- ensure_loaded('data.pl').

iniciar :-
    write('----------------------------------------------------------'), nl,
    write('                      TeiAnime - 提案                      '), nl,
    write('             Sugestão de animes personalizada             '), nl,
    write('----------------------------------------------------------'), nl, nl,
    menu
.

menu:-
    write('-------- MENU PRINCIPAL --------'), nl,
    write('[1] Criar perfil'), nl,
    write('[2] Meus animes'), nl,
    write('[3] Adicionar anime assitido'), nl,
    write('[4] Sugestão de anime'), nl,
    write('[5] Sugestão aleatória'), nl,
    write('[6] Sugerir animes populares'), nl,
    write('[7] Sugerir animes da season atual'), nl,
    write('[8] Sugerir animes da próxima season'), nl,
    write('[9] Salvar e sair'), nl,

    write('O que deseja fazer agora?'), nl,
    read(Opcao),
    % tratar_opcao(Opcao),

    Opcao = 0,      % Condição de parada: Se Opcao for 0, a linha seguinte (Cut) é executada.
                    % Se Opcao não for 0, a linha 'Opcao = 0' falha e o Prolog faz
                    % backtracking até o 'repeat' e executa tudo novamente.

    !               % Cut (!): Quebra o 'repeat' e encerra o predicado menu_loop.
.