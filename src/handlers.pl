
% Cria um arquivo .pl vazio identificado pelo nome inserido pelo usuário
criar_perfil(NomeAtom) :-
    % Cria o caminho para o arquivo .pl com o nome de usuário como identificador
    atom_concat(NomeAtom, '.pl', NomeArquivo),
    atom_concat('../profiles/', NomeArquivo, DirArquivo),

    % Abre o arquivo para escrita garantindo o fechamento seguro com setup_call_cleanup
    setup_call_cleanup(
        open(DirArquivo, write, Stream),
        (
            % Arquivo criado vazio
            true
        ),
        close(Stream)
    ),
    nl,
    write('Perfil criado com sucesso!'), nl
.


% Verifica se já existe perfil com o nome de usuário inserido
    % Caso já haja, avisa que já existe perfil com esse nome e volta para o menu principal
    % Caso ainda não haja, chama o predicado de criação de perfil
verificar_arquivo_existente(NomeAtom, NomeArquivo, DirArquivo) :-
    (   exists_file(DirArquivo)
    ->  format('O arquivo "~w" já existe!~n', [NomeArquivo])
    ;   criar_perfil(NomeAtom)
    )   
.

% _______________________________________________________________________________________________________________________
%    Tratando as opções de ação
% -----------------------------------------------------------------------------------------------------------------------

% Opção 0: Salvar e sair (por enquanto só sai, não salva)
tratar_opcao(0) :- 
    write('Espero que goste da recomendação!'),
    !
.


% Opção 1: Criar perfil
tratar_opcao(1) :-
    write('Insira o nome de usuário: '), nl,
    read_line_to_string(user_input, NomeString),
    atom_string(NomeAtom, NomeString),

    atom_concat(NomeAtom, '.pl', NomeArquivo),
    atom_concat('../profiles/', NomeArquivo, DirArquivo),

    % Verifica se já existe um perfil salvo com esse nome de usuário
    verificar_arquivo_existente(NomeAtom, NomeArquivo, DirArquivo).



% Opção 2
% Opção 3
% Opção 4
% Opção 5
% Opção 6
% Opção 7
% Opção 8
% Opção 9