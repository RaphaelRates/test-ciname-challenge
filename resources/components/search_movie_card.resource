*** Settings ***
Documentation    Testes relacionados ao componente de card de filme na busca

Library    Browser
Library    Collections

Resource    ../variables.resource
Resource    ../base.resource

*** Keywords ***
Verify Search Movie Card Structure
    [Documentation]    Verifica a estrutura do card de filme nos resultados
    [Arguments]        ${card_locator}=${SEARCH_MOVIE_CARD}
    Get Element        ${card_locator}
    Get Element        ${card_locator} ${SEARCH_MOVIE_POSTER}
    Get Element        ${card_locator} ${SEARCH_MOVIE_POSTER} img
    Get Element        ${card_locator} ${SEARCH_MOVIE_CLASSIFICATION}
    Get Element        ${card_locator} ${SEARCH_MOVIE_TITLE}
    Get Element        ${card_locator} ${SEARCH_MOVIE_DURATION}
    Get Element        ${card_locator} ${SEARCH_MOVIE_RELEASE}
    Get Element        ${card_locator} ${SEARCH_MOVIE_GENRES}
    Get Element        ${card_locator} ${SEARCH_MOVIE_SYNOPSIS}
    Get Element        ${card_locator} ${SEARCH_MOVIE_DETAILS_BUTTON}

Verify Movie Card Content In Search
    [Documentation]    Valida o conteúdo de um card de filme nos resultados
    [Arguments]        ${movie_data}    ${card_locator}=${SEARCH_MOVIE_CARD}
    Get Text           ${card_locator} ${SEARCH_MOVIE_TITLE}        ==    ${movie_data['title']}
    Get Text           ${card_locator} ${SEARCH_MOVIE_DURATION}     contains    ${movie_data['duration']}
    Get Text           ${card_locator} ${SEARCH_MOVIE_SYNOPSIS}     contains    ${movie_data['synopsis']}
    Get Text           ${card_locator} ${SEARCH_MOVIE_CLASSIFICATION}    ==    ${movie_data['classification']}

Verify Movie Genres In Search
    [Documentation]    Verifica os gêneros de um filme nos resultados
    [Arguments]        ${expected_genres}    ${card_locator}=${SEARCH_MOVIE_CARD}
    FOR    ${genre}    IN    @{expected_genres}
        Get Element    ${card_locator} ${SEARCH_MOVIE_GENRES} >> text=${genre}
    END

Click Movie Details Button In Search
    [Documentation]    Clica no botão de detalhes do filme nos resultados
    [Arguments]        ${card_locator}=${SEARCH_MOVIE_CARD}
    ${href}    Get Attribute    ${card_locator} ${SEARCH_MOVIE_DETAILS_BUTTON}    href
    Should Start With    ${href}    /movies/
    Click               ${card_locator} ${SEARCH_MOVIE_DETAILS_BUTTON}

Get Search Movie Cards Count
    [Documentation]    Retorna a quantidade de cards de filme exibidos nos resultados
    ${count}=    Get Element Count    main > div > div.movies-grid > div.movie-card
    Should Be True    ${count} > 0


Verify Movie Card Is Present In Search
    [Documentation]    Verifica se um card de filme específico está presente
    [Arguments]        ${movie_title}
    Get Element        ${SEARCH_MOVIE_CARD} >> text=${movie_title}