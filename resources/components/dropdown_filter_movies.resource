*** Settings ***
Documentation    Testes relacionados ao componente de dropdown filter de filmes

Library    Browser
Library    Collections

Resource    ../base.resource
Resource    ../variables.resource

*** Keywords ***
Verify Dropdown Filter Is Visible
    [Documentation]    Verifica se o dropdown de filtro está visível
    Get Element        ${SEARCH_MOVIES_SELECT_FILTER}

Verify All Genre Options Are Present
    [Documentation]    Verifica se todas as opções de gênero estão presentes
    FOR    ${genre}    IN    @{EXPECTED_GENRE_OPTIONS}
        Get Element    ${SEARCH_MOVIES_SELECT_FILTER} >> option:has-text("${genre}")
    END

Select Genre Filter
    [Documentation]    Seleciona um filtro de gênero
    [Arguments]        ${genre}
    Select Options By    ${SEARCH_MOVIES_SELECT_FILTER}    text    ${genre}

Get Selected Genre
    [Documentation]    Retorna o gênero selecionado atual
    ${selected}=    Get Selected Options    ${SEARCH_MOVIES_SELECT_FILTER}    label
    RETURN    ${selected}[0]

Select All Genres
    [Documentation]    Seleciona a opção "All" (todos os gêneros)
    Select Options By    ${SEARCH_MOVIES_SELECT_FILTER}    text    All

Verify Genre Option Is Available
    [Documentation]    Verifica se uma opção de gênero específica está disponível
    [Arguments]        ${genre}
    Get Element        ${SEARCH_MOVIES_SELECT_FILTER} >> option:has-text("${genre}")