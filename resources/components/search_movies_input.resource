*** Settings ***
Documentation    Testes relacionados ao componente de search movies input

Library    Browser


Resource    ../base.resource
Resource    ../variables.resource

*** Keywords ***
Verify Search Input Is Visible
    [Documentation]    Verifica se o input de busca está visível
    Get Element        ${SEARCH_MOVIES_INPUT}

Verify Search Input Placeholder
    [Documentation]    Verifica o placeholder do input de busca
    Get Attribute      ${SEARCH_MOVIES_INPUT}    placeholder    ==    ${EXPECTED_SEARCH_PLACEHOLDER}

Type In Search Input
    [Documentation]    Digita texto no input de busca
    [Arguments]        ${search_text}
    Fill Text          ${SEARCH_MOVIES_INPUT}    ${search_text}

Clear Search Input
    [Documentation]    Limpa o input de busca
    Clear Text         ${SEARCH_MOVIES_INPUT}

Submit Search
    [Documentation]    Submete a busca pressionando Enter
    Press Keys         ${SEARCH_MOVIES_INPUT}    Enter

Search For Movie
    [Documentation]    Realiza uma busca completa por um filme
    [Arguments]        ${movie_title}
    Type In Search Input    ${movie_title}
    Submit Search