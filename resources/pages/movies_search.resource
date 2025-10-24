*** Settings ***
Documentation    Testes relacionados à página de busca de filmes

Library    Browser
Library    Collections


Resource    ../variables.resource
Resource    ../base.resource
Resource    ../components/search_movies_input.resource
Resource    ../components/dropdown_filter_movies.resource
Resource    ../components/search_movie_card.resource

*** Variables ***
${SEARCH_MOVIES_URL}    ${URL_FRONT}/movies

*** Keywords ***
Navigate To Search Movies Page
    [Documentation]    Navega para a página de busca de filmes
    Go To    ${SEARCH_MOVIES_URL}

Verify Search Movies Page Loaded
    [Documentation]    Verifica se a página de busca carregou corretamente
    Get Url    contains    ${SEARCH_MOVIES_URL}
    Get Element        ${SEARCH_MOVIES_SECTION}
    Get Text           ${SEARCH_MOVIES_H1}    ==    ${EXPECTED_SEARCH_MOVIES_H1}
    Verify Search Input Is Visible
    Verify Search Input Placeholder
    Verify Dropdown Filter Is Visible
    Verify All Genre Options Are Present

Search And Filter Movies
    [Documentation]    Busca e filtra filmes
    [Arguments]        ${search_term}    ${genre}=All
    IF    "${search_term}" != "${EMPTY}"
        Search For Movie    ${search_term}
    END
    IF    "${genre}" != "All"
        Select Genre Filter    ${genre}
    END

Verify Search Results
    [Documentation]    Verifica os resultados da busca
    [Arguments]        ${expected_min_count}=1
    ${count}    Get Search Movie Cards Count
    Should Be True    ${count} >= ${expected_min_count}
    IF    ${count} > 0
        Verify Search Movie Card Structure
    END

Clear All Filters
    [Documentation]    Limpa todos os filtros
    Clear Search Input
    Select All Genres