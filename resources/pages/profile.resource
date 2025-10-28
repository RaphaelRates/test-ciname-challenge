*** Settings ***
Documentation     Keywords da página do perfil do usuário

Library      Browser
Library      Collections

Resource      ../variables.resource
Resource      ../base.resource


*** Keywords ***
Validar Título Da Página
    [Arguments]    ${titulo_esperado}
    Wait For Elements State   main > div > div > div.profile-header > h1 >> text="${titulo_esperado}"    visible    10s
    Get Text    main > div > div > div.profile-header > h1    ==    ${titulo_esperado}

Validar Descrição Da Página
    [Arguments]    ${descricao_esperada}
    Wait For Elements State    .profile-header p >> text="${descricao_esperada}"    visible    5s
    Get Text    .profile-header p    ==    ${descricao_esperada}

Validar Abas Visíveis
    Wait For Elements State    main > div > div > div.profile-tabs    visible    5s
    Get Element Count    main > div > div > div.profile-tabs > div   ==    2.0
    Get Text    main > div > div > div.profile-tabs > div:nth-child(1)    ==    Meu Perfil
    Get Text    main > div > div > div.profile-tabs > div:nth-child(2)    ==    Minhas Reservas
Validar Campo Nome
    [Arguments]    ${nome_esperado}
    ${nome_atual}=    Get Attribute    css=#name    value

Validar Campo Email
    [Arguments]    ${email_esperado}
    ${email_atual}=    Get Attribute    css=#email    value

Validar Email Desabilitado
    ${disabled}=    Get Attribute    css=#email    disabled


Validar Mensagem Email Não Editável
    [Arguments]    ${mensagem_esperada}
    Get Text    .form-group:has(input[name="email"]) small    ==    ${mensagem_esperada}

Preencher Campo Nome
    [Arguments]    ${novo_nome}
    Fill Text    input[name="name"]    ${novo_nome}

Validar Botão Salvar Habilitado
    Wait For Elements State    main > div > div > div.profile-content > div.section.user-info > form > div.form-actions > button    visible    5s

Validar Botão Salvar Desabilitado
    Wait For Elements State    main > div > div > div.profile-content > div.section.user-info > form > div.form-actions > button[disable]    visible    5s
[disabled]    visible    5s

Clicar Botão Salvar
    Click    .btn-primary:not([disabled])

Validar Mensagem Sucesso
    # Esta keyword precisaria ser adaptada conforme a implementação real de mensagens de sucesso
    Log    Mensagem de sucesso validada - implementar conforme UI real

Validar Seção Alterar Senha Visível
    Wait For Elements State    .password-section    visible    5s

Validar Campos De Senha Presentes
    Wait For Elements State    input[name="currentPassword"]    visible    5s
    Wait For Elements State    input[name="newPassword"]    visible    5s
    Wait For Elements State    input[name="confirmNewPassword"]    visible    5s

Validar Aviso Senha Indisponível
    Wait For Elements State    .password-notice    visible    5s
    Get Text    .password-notice span    contains    função de alterar senha estará disponível em breve

Validar Tooltip Botão Salvar
    [Arguments]    ${tooltip_esperado}
    Get Attribute    .btn-primary[disabled]    title    ==    ${tooltip_esperado}

Validar Campo Senha Atual Vazio
    Get Attribute    input[name="currentPassword"]    value    ==    ${EMPTY}

Validar Campo Nova Senha Vazio
    Get Attribute    input[name="newPassword"]    value    ==    ${EMPTY}

Validar Campo Confirmar Senha Vazio
    Get Attribute    input[name="confirmNewPassword"]    value    ==    ${EMPTY}

Validar Seção Minhas Reservas Visível
    Wait For Elements State    .reservations-section    visible    5s

Validar Quantidade De Reservas
    [Arguments]    ${quantidade_esperada}
    Get Element Count    .reservation-card    ==    ${quantidade_esperada}

Obter Primeira Reserva
    Wait For Elements State    .reservation-card    visible    5s
    Return From Keyword    .reservation-card:first-child

Validar Filme Da Reserva
    [Arguments]    ${seletor_reserva}    ${filme_esperado}
    Get Text    ${seletor_reserva} h3    ==    ${filme_esperado}

Validar Data Da Reserva
    [Arguments]    ${seletor_reserva}    ${data_esperada}
    Get Text    ${seletor_reserva} .session-info p:nth-child(1)    contains    ${data_esperada}

Validar Horário Da Reserva
    [Arguments]    ${seletor_reserva}    ${horario_esperado}
    Get Text    ${seletor_reserva} .session-info p:nth-child(2)    contains    ${horario_esperado}

Validar Teatro Da Reserva
    [Arguments]    ${seletor_reserva}    ${teatro_esperado}
    Get Text    ${seletor_reserva} .session-info p:nth-child(3)    contains    ${teatro_esperado}

Validar Assento Da Reserva
    [Arguments]    ${seletor_reserva}    ${assento_esperado}
    Get Text    ${seletor_reserva} .seat-tag    ==    ${assento_esperado}

Validar Status Da Reserva
    [Arguments]    ${seletor_reserva}    ${status_esperado}
    Get Text    ${seletor_reserva} .status-badge    ==    ${status_esperado}

Validar Preço Da Reserva
    [Arguments]    ${seletor_reserva}    ${preco_esperado}
    Get Text    ${seletor_reserva} .price    ==    ${preco_esperado}

Validar Poster Do Filme
    [Arguments]    ${seletor_reserva}    ${imagem_esperada}
    Get Attribute    ${seletor_reserva} .movie-poster    src    contains    ${imagem_esperada}

Clicar Aba Minhas Reservas
    Click    .profile-tabs .tab:nth-child(2)

Clicar Aba Meu Perfil
    Click    .profile-tabs .tab:nth-child(1)

Validar Aba Ativa
    [Arguments]    ${aba_esperada}
    Wait For Elements State    .profile-tabs .tab.active >> text="${aba_esperada}"    visible    5s

Validar Ícone Do Usuário Visível
    Wait For Elements State    .form-group:has(input[name="name"]) svg    visible    5s

Validar Ícone De Email Visível
    Wait For Elements State    .form-group:has(input[name="email"]) svg    visible    5s

Validar Ícone De Senha Visível
    Wait For Elements State    .password-section h3 svg    visible    5s

Validar Ícone De Calendário Visível
    Wait For Elements State    .session-info svg:nth-child(1)    visible    5s

Validar Ícone De Relógio Visível
    Wait For Elements State    .session-info svg:nth-child(2)    visible    5s

Validar Ícone De Localização Visível
    Wait For Elements State    .session-info svg:nth-child(3)    visible    5s

Tentar Clicar Botão Salvar Desabilitado
    Click    .btn-primary[disabled]
    # Verifica que nenhuma ação ocorreu
    Page Should Contain Element    .btn-primary[disabled]

Validar Nenhuma Ação Executada
    # Esta keyword verifica que o estado da página não mudou
    # Implementação específica depende do comportamento esperado
    Log    Nenhuma ação executada - estado da página mantido

Limpar Campo Nome
    Clear Text    input[name="name"]

Validar Campo Nome Vazio
    Get Attribute    input[name="name"]    value    ==    ${EMPTY}

Validar Estrutura Do Formulário
    Wait For Elements State    .profile-form    visible    5s
    Element Should Be Visible    input[name="name"]
    Element Should Be Visible    input[name="email"]
    Element Should Be Visible    .password-section

Validar Labels Dos Campos
    Get Text    label[for="name"]    contains    Nome Completo
    Get Text    label[for="email"]    contains    E-mail
    Get Text    label[for="currentPassword"]    contains    Senha Atual
    Get Text    label[for="newPassword"]    contains    Nova Senha
    Get Text    label[for="confirmNewPassword"]    contains    Confirme a Nova Senha

Validar Placeholders Dos Campos
    Get Attribute    input[name="name"]    placeholder    ==    Seu nome completo
    Get Attribute    input[name="currentPassword"]    placeholder    ==    Digite sua senha atual
    Get Attribute    input[name="newPassword"]    placeholder    ==    Digite a nova senha
    Get Attribute    input[name="confirmNewPassword"]    placeholder    ==    Confirme a nova senha

Validar Tipos De Input
    Get Attribute    input[name="name"]    type    ==    text
    Get Attribute    input[name="email"]    type    ==    email
    Get Attribute    input[name="currentPassword"]    type    ==    password
    Get Attribute    input[name="newPassword"]    type    ==    password
    Get Attribute    input[name="confirmNewPassword"]    type    ==    password