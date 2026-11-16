:- dynamic caminho_perfil_ativo/1.


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
    ->  format('o arquivo "~w" já existe!~n', [NomeArquivo])
    ;   criar_perfil(NomeAtom)
    )   
.

salvar_perfil_ativo(CaminhoCompleto):-
    % Limpa o anterior e salva o átomo na base dinâmica
    retractall(caminho_perfil_ativo(_)),
    assertz(caminho_perfil_ativo(CaminhoCompleto))
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


% Opção 2: Carregar perfil
tratar_opcao(2) :-
    write('-------- CARREGAR PERFIL --------'), nl,
    
    (   exists_directory('../profiles')
    ->  directory_files('../profiles', TodosArquivos),
        include(eh_arquivo_pl, TodosArquivos, Perfis),
        (   Perfis == []
        ->  write('Nenhum perfil encontrado.'), nl
        ;   listar_perfis(Perfis, 1),
            nl,
            write('Digite o número do perfil que deseja carregar: '), nl,
            read_line_to_string(user_input, EscolhaStr),
            (   number_string(Indice, EscolhaStr),
                nth1(Indice, Perfis, NomeArquivo)
            ->  atom_concat('../profiles/', NomeArquivo, CaminhoCompleto),
                
                % Limpa os dados e o perfil ativo anterior da memória RAM
                retractall(assistiu(_, _)),
                retractall(caminho_perfil_ativo(_)),
                retractall(perfil_ativo(_)),
                
                % Carrega os fatos do arquivo escolhido
                consult(CaminhoCompleto),
                
                
                % Extrai o nome do perfil (removendo a extensão .pl) e define como ativo
                file_name_extension(NomePerfil, '.pl', NomeArquivo),
                assertz(perfil_ativo(NomePerfil)),
                
                format('Perfil "~w" carregado com sucesso!~n', [NomePerfil]),
                salvar_perfil_ativo(CaminhoCompleto)
            ;   write('Opção inválida.'), nl
            )
        )
    ;   write('Diretório de perfis não encontrado.'), nl
    ),
    !,
    nl.

% Auxiliares necessários
eh_arquivo_pl(Arquivo) :-
    atom_concat(_, '.pl', Arquivo).

listar_perfis([], _).
listar_perfis([H|T], N) :-
    format('[~w] ~w~n', [N, H]),
    N1 is N + 1,
    listar_perfis(T, N1).


% Opção 3: Excluir perfil
tratar_opcao(3):- 
    write('Qual perfil você gostaria de exluir?'), nl,
    read_line_to_string(user_input, NomeString),
    atom_string(NomeAtom, NomeString),
    
    % Encontra o caminho para o arquivo do perfil
    atom_concat(NomeAtom, '.pl', NomeArquivo),
    atom_concat('../profiles/', NomeArquivo, DirArquivo),

    % Verifica se o perfil existe
    (
        exists_file(DirArquivo) -> delete_file(DirArquivo),
        format('Perfil "~w" apagado com sucesso! ~n', [NomeAtom]) ;
        format('Aviso: O perfil "~w" não foi encontrado. ~n', [NomeAtom]) 
    )
.


% Opção 4: Meus animes


salvar_anime(Titulo, Avaliacao) :-
    % 1. Recupera o caminho salvo na base dinâmica
    (   caminho_perfil_ativo(CaminhoArquivo)
    ->  % 2. Abre o arquivo no modo 'append' e escreve o formato desejado (ex: meu_fato(Arg1, Arg2))
        setup_call_cleanup(
            open(CaminhoArquivo, append, Stream),
            format(Stream, 'assistiu(~q, ~q).~n', [Titulo, Avaliacao]),
            close(Stream)
        ),
        format('Fato salvo com sucesso no arquivo do perfil!~n')
    ;   write('Erro: Nenhum perfil está carregado no momento.'), nl
    ).


/*
salvar_anime(Titulo, Avaliacao):-
    setup_call_cleanup(
    open(caminho_perfil_ativo, append, Stream),
    format(Stream, 'assistiu(~q, ~q).~n', [Titulo, Avaliacao]),
    close(Stream)
    )
.
*/

% Opção 5: Adicionar anime assitido
tratar_opcao(5):-
    % Lê o título do anime que o usuário deseja adicionar ao seu perfil
    write('Qual o título do anime: '),
    read_line_to_string(user_input, Titulo),
    % atom_string(NomeAnime, String),

    /*
    -> Ao fazer a integração com a API do Anilist, o sistema deve primeiramente
    buscar o nome desse anime na base de dados para garantir que o usuário não inseriu
    um anime inválido ou que ele escreveu o título errado
        1. Se o anime for válido, prossegue para a avaliação
        2. Se o anime for inválido, avisa para o usuário e pergunta se ele quer inserir outro anime ou verificar se escreveu corretamente
    */

    % Pergunta qual é a sua opinião sobre ele, o que é importante para decidir o peso que as características desse anime terão na recomendação de outros animes ao usuário
    write('O que você achou desse anime? Você amou, gostou, não gostou ou odiou?'),
    read_line_to_string(user_input, Avaliacao),
    % atom_string(PesoAtom, String),

    % Armazena o anime no arquivo do perfil como um fato
    salvar_anime(Titulo, Avaliacao)
.

% Opção 6: Sugestão de anime


% Opção 7: Sugestão aleatória


% Opção 8: Sugerir animes populares
tratar_opcao(8):- use_module(library(http/http_client)).       % Bibliotecas necessárias para fazer requisições HTTP
:- use_module(library(http/http_json)).
:- dynamic anime/4, genero/2.                                  % Esses predicados podem ser alterados

write('----- ANIMES POPULARES -----')

consulta_catalogo("                                            % Consulta GraphQL, que pede animes com id, titulo, genero e ano específico de acordo com cada página, e é ordenado por ID
    query ($page: Int, $perPage: Int){
        Page(page: $page, perPage: $perPage){
            pageInfo {hasNextPage}
            media(type: ANIME, sort: ID){
                id
                title { romaji english }
                genres
                seasonYear
            }
        }
    }
").

buscar_pagina(Pagina, page) :-                                                          % Define o predicado que busca uma página 
    consulta_catalogo(Q),
Corpo = _{query: Q, variables: _{page: Pagina, perPage: 10}},                           % Define o corpo da requisição, a consulta (query) e os valores das variáveis (página pedida e 10 itens por página)
    http_post('https://graphql.anilist.co', json(Corpo), Resp, [json_object(dict)]),    % Envia POST para a API, transformando Corpo em JSON, em resposta se tem em Resp, e logo depois se converte o JSON em dicionário Prolog
    Page = Resp.data.'Page'.                                                            % Extrai da resposta data -> page

carregar_catalogo(Max) :- carregar(1, Max).                                             % Começa na pag 1 e vai até Max

/* carregar(P, Max) :-
    P = < Max, !,
    buscar_pagina(P, Page),
    forall(member(M, Page.media), salvar_anime(Titulo, Avaliacao)),
    ( Page.pageInfo.hasNextPage == true
    -> sleep(1), P1 is P + 1, carregar(P1, Max)
    ; true).
*/

:- dynamic avaliacao/3.

num_avaliacoes(Id, Q) :-
    aggregate_all(count, avaliacao(_, Id, N), Notas),

media(Id, Media) :-
    aggregate_all(bag(N), avaliacao(_, Id, N), Notas),
    Notas \= [],
    sum_list(Notas, S),
    length(Notas, Q),
    Media is S/Q.
    
/* populares(K, Top) :-
    findall(M-T, 
        (anime(Id, T, _,_), 
        num_avaliacoes(Id, Q), Q >= 3, 
        media(Id, M)), 
        Pares),
    sort(0, @>=, Pares, Ordenados),
    length(Ordenados, Tam),
    Min is min(K, Tam),
    length(Top, Min),
    append(Top, _, Ordenados).
*/


% Opção 9: Sugerir animes da season atual


% Opção 10: Sugerir animes da próxima season
