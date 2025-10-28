*** Settings ***
Documentation    Testes relacionados ao componente de movie card
Library          Browser
Library          Collections
Resource         ../../resources/base.resource
Resource         ../../resources/variables.resource

*** Keywords ***
Verificar Cartão Filme Interstellar Renderiza Corretamente
    [Documentation]    Verifica se todos os elementos do cartão do filme são renderizados
    Get Element        ${MOVIE_CARD}:nth-child(1)
    Get Element        ${MOVIE_POSTER}:nth-child(1)
    Get Element        ${MOVIE_POSTER}:nth-child(1) img
    Get Element        ${MOVIE_CLASSIFICATION}
    Get Element        ${MOVIE_TITLE}
    Get Element        ${MOVIE_DURATION}
    Get Element        ${MOVIE_RELEASE}
    Get Element        ${MOVIE_GENRES}
    Get Element        ${MOVIE_SYNOPSIS}
    Get Element        ${MOVIE_DETAILS_BUTTON}
    Sleep    0.5

Validar Conteúdo do Cartão Interstellar
    [Documentation]    Valida o conteúdo textual do cartão do filme
    Get Text           ${MOVIE_TITLE}           ==              Interstellar
    Get Text           ${MOVIE_DURATION}        contains        169 min
    Get Text           ${MOVIE_RELEASE}
    Get Text           ${MOVIE_CLASSIFICATION}  ==              PG-13
    Sleep    0.5

Verificar Gêneros do Filme
    [Documentation]    Verifica se todos os gêneros estão presentes
    @{expected_genres}    Create List    Adventure    Drama    Science Fiction
    FOR    ${genre}    IN    @{expected_genres}
        Get Element    ${MOVIE_GENRES}> span >> text=${genre}
    END
    Sleep    0.5

Validar Poster Placeholder
    [Documentation]    Verifica se a imagem placeholder está presente
    Get Attribute      ${MOVIE_POSTER} img    alt    ==    Poster do filme Interstellar
    Get Attribute      ${MOVIE_POSTER} img    src    contains    /assets/images/no-image.svg
    Sleep    0.5

Clicar Botão Ver Detalhes
    [Documentation]    Clica no botão de detalhes e verifica navegação
    ${href}    Get Attribute    ${MOVIE_DETAILS_BUTTON}    href
    Should Start With    ${href}    /movies/
    Click               ${MOVIE_DETAILS_BUTTON}
    Sleep    0.5

Testar Layout Responsivo do Cartão
    [Documentation]    Testa o layout em diferentes tamanhos de tela
    Set Viewport Size    width=1920    height=1080
    Get Element        ${MOVIE_CARD}
    Set Viewport Size    width=768    height=1024
    Get Element        ${MOVIE_CARD}
    Set Viewport Size    width=375    height=667
    Get Element        ${MOVIE_CARD}
    Sleep    0.5

Resetar Layout Responsivo
    [Documentation]    Testa o layout em diferentes tamanhos de tela
    Set Viewport Size    width=768   height=1024
Verificar Acessibilidade
    [Documentation]    Verifica elementos de acessibilidade
    Get Attribute      ${MOVIE_POSTER} img    alt
    Get Element        ${MOVIE_TITLE}
    Get Element        ${MOVIE_DURATION} svg
    Get Element        ${MOVIE_RELEASE} svg

    Sleep    0.5

Verificar Seção de Filmes Existe
    [Documentation]    Verifica se a seção de filmes está presente na página
    Get Element        ${MOVIES_SECTION}
    Get Element        ${MOVIES_TITLE}
    Get Element        ${MOVIES_GRID}
    Sleep    0.5

Validar Grid de Filmes
    [Documentation]    Valida a estrutura do grid de filmes
    ${card_count}      Get Element Count     ${MOVIES_GRID} ${MOVIE_CARD}
    Get Element        ${MOVIES_GRID}
    Sleep    0.5

Verificar Múltiplos Cartões de Filme
    [Documentation]    Verifica se múltiplos cartões são renderizados corretamente
    ${cards}           Get Elements          ${MOVIES_GRID} ${MOVIE_CARD}
    FOR    ${card}     IN                    @{cards}
        Get Element    ${card} ${MOVIE_TITLE}
        Get Element    ${card} ${MOVIE_DETAILS_BUTTON}
    END
    Sleep    0.5

Navegar Para Detalhes do Primeiro Filme
    [Documentation]    Navega para os detalhes do primeiro filme do grid
    Wait For Elements State    css=#root > main > div > div.featured-movies > div > div:nth-child(1) > div.movie-info > a    visible    timeout=5s
    Click    css=#root > main > div > div.featured-movies > div > div:nth-child(1) > div.movie-info > a
