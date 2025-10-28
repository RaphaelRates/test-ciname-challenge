*** Settings ***
Documentation     Keywords da página de reservas

Library    Browser
Library    Collections

Resource     ../variables.resource
Resource     ../base.resource
Resource    ../components/search_movie_card.resource

*** Variables ***
${CARD_RESERVATION}    main > div > div > div.reservations-list > div

*** Keywords ***
Acessar Página de Reservas
    Click              header > div > nav > ul > li:nth-child(3) > a
    Sleep    1s
    Wait For Elements State     main > div.reservations-page   visible    10

Validar Página de Reservas Carregada
    Wait For Elements State    .reservations-header h1 >> text="Minhas Reservas"    visible    10s
    Get Element    .reservations-list

# Keywords de Validação de Estrutura
Validar Header da Página de Reservas
    Get Text    .reservations-header h1    ==    Minhas Reservas

Validar Estrutura do Card de Reserva
    ${card_selector}=    Set Variable    main > div > div > div.reservations-list > div
    Wait For Elements State     ${card_selector}   visible    5s
    Get Element    main > div > div > div.reservations-list > div > div.reservation-header
    Get Element    main > div > div > div.reservations-list > div > div.movie-info
    Get Element    main > div > div > div.reservations-list > div > div.reservation-footer
    Sleep     1s


Validar Elementos do Header da Reserva
    [Arguments]    ${index}=1
    ${card_selector}=    Set Variable    main > div > div > div.reservations-list > div:nth-child(${index})
    Get Element    ${card_selector} .reservation-header h3
    Get Element    ${card_selector} .status-badge

Validar Informações do Filme
    [Arguments]    ${index}=1
    ${card_selector}=    Set Variable    main > div > div > div.reservations-list > div:nth-child(${index})
    Get Element    ${card_selector} .movie-poster
    Get Element    ${card_selector} h4
    Get Element    ${card_selector} > div.movie-info > div > div

Validar Detalhes da Sessão
    ${detail_count}=    Get Element Count    main > div > div > div.reservations-list > div > div.movie-info > div > div.detail-item
    Should Be True    ${detail_count} >= 4

Validar Footer da Reserva
    Get Element     main > div > div > div.reservations-list > div > div.reservation-footer > div.price-info
    Get Element     main > div > div > div.reservations-list > div > div.reservation-footer > div.payment-info

# Keywords de Validação de Conteúdo
Validar Número da Reserva
    ${texto}=    Get Text    #root > main > div > div > div.reservations-list > div > div.reservation-header > h3
    Should Contain    ${texto}    Reserva #

Validar Status da Reserva
    [Arguments]    ${index}   ${status_esperado}=Confirmada
    ${card_selector}=    Set Variable    main > div > div > div.reservations-list > div:nth-child(${index})
    Get Text    ${card_selector} .status-badge    ==    ${status_esperado}

Validar Nome do Filme
    [Arguments]    ${filme_esperado}
    Get Text     main > div > div > div.reservations-list > div > div.movie-info > div > h4    ==    ${filme_esperado}

Validar Data da Sessão
    [Arguments]      ${data_esperada}
    Get Text    main > div > div > div.reservations-list > div > div.movie-info > div > div:nth-child(2) > span    ==    ${data_esperada}

Validar Horário da Sessão
    [Arguments]    ${horario_esperado}
    Get Text    main > div > div > div.reservations-list > div > div.movie-info > div > div:nth-child(3) > span   ==    ${horario_esperado}

Validar Teatro da Sessão
    [Arguments]    ${index}   ${teatro_esperado}
    ${card_selector}=    Set Variable    main > div > div > div.reservations-list > div:nth-child(${index})
    Get Text    main > div > div > div.reservations-list > div > div.movie-info > div > div:nth-child(4) > span   ==    ${teatro_esperado}

Validar Assento da Reserva
    [Arguments]    ${index}    ${assento_esperado}
    ${card_selector}=    Set Variable    main > div > div > div.reservations-list > div:nth-child(${index})
    Get Text    main > div > div > div.reservations-list > div > div.movie-info > div > div:nth-child(5) > span    ==    ${assento_esperado}

Validar Preço da Reserva
    [Arguments]    ${index}   ${preco_esperado}
    ${card_selector}=    Set Variable    main > div > div > div.reservations-list > div:nth-child(${index})
    Get Text    ${card_selector} .price    ==    ${preco_esperado}

Validar Forma de Pagamento
    [Arguments]    ${index}   ${pagamento_esperado}
    ${card_selector}=    Set Variable    main > div > div > div.reservations-list > div:nth-child(${index})
    ${texto}=    Get Text    ${card_selector} .payment-info
    Should Contain    ${texto}    ${pagamento_esperado}

Validar Poster do Filme
    [Arguments]    ${index}   ${imagem_esperada}
    ${card_selector}=    Set Variable    main > div > div > div.reservations-list > div:nth-child(${index})
    Get Attribute    ${card_selector} .movie-poster    src    contains    ${imagem_esperada}

# Keywords de Validação de Ícones
Validar Ícones dos Detalhes
    [Arguments]    ${index}
    ${card_selector}=    Set Variable    main > div > div > div.reservations-list > div:nth-child(${index})
    ${icon_count}=    Get Element Count    ${card_selector} > div.movie-info > div > div > svg
    Should Be Equal As Numbers    ${icon_count}    4

# Keywords de Navegação e Ações
Validar Botões de Ação Presentes
    Wait For Elements State    .page-actions    visible    5s
    Get Element    .btn-secondary
    Get Element    .btn-primary

Clicar Voltar para Página Inicial
    Click    .btn-secondary

Clicar Ver Filmes em Cartaz
    Click    .btn-primary

Validar Navegação para Página Inicial
    Clicar Voltar para Página Inicial
    Wait For Elements State    //h1[contains(text(), "Bem-vindo")]    visible    10s

Validar Navegação para Filmes em Cartaz
    Clicar Ver Filmes em Cartaz
    Wait For Elements State    //h1[contains(text(), "Filmes")]    visible    10s

# Keywords de Validação de Múltiplas Reservas
Validar Quantidade de Reservas
    [Arguments]    ${quantidade_esperada}
    ${count}=    Get Element Count    main > div > div > div.reservations-list > div
    Should Be Equal As Numbers    ${count}    ${quantidade_esperada}

Validar Todas as Reservas Com Estrutura Completa
    ${count}=    Get Element Count    main > div > div > div.reservations-list > div
    FOR    ${index}    IN RANGE    1    ${count} + 1
        Validar Estrutura do Card de Reserva 
        Validar Elementos do Header da Reserva    ${index}
        Validar Informações do Filme    ${index}
        Validar Detalhes da Sessão 
        Validar Footer da Reserva   
        Validar Ícones dos Detalhes    ${index}
    END

# Keywords para Cenários Específicos
Validar Reserva Específica do Avengers
    [Arguments]    ${index}=1
    Validar Nome do Filme       The Avengers
    Validar Data da Sessão      21 de outubro de 2025
    Validar Horário da Sessão       12:00
    Validar Teatro da Sessão    ${index}    Theater 1
    Validar Assento da Reserva    ${index}    C8
    Validar Preço da Reserva    ${index}    R$ 15.00
    Validar Forma de Pagamento    ${index}    Cartão de Crédito
    Validar Status da Reserva    ${index}    Confirmada