*** Settings ***
Documentation    Recursos relacionados ao formulário de registro de usuários via interface web

Library          Browser
Library          Collections

Resource  ../../variables.resource
Resource  ../../base.resource

*** Keywords ***
Verificar Elementos Formulário Registro
    [Documentation]    Verifica todos os elementos do formulário de registro

    Get Element States    ${REGISTER_FORM}    contains    visible
    Get Element States    ${REGISTER_HEADER}    contains    visible
    Get Text    ${REGISTER_HEADER}    ==    Cadastro
    Get Text    ${REGISTER_SUBHEADER}    contains    Crie sua conta

    Get Element States    ${NAME_INPUT}    contains    visible
    Get Element States    ${EMAIL_INPUT}    contains    visible  
    Get Element States    ${PASSWORD_INPUT}    contains    visible
    Get Element States    ${CONFIRM_PASSWORD_INPUT}    contains    visible

    Get Text    css=#root > main > div > div > form > div:nth-child(1) > label    ==    Nome
    Get Text    css=#root > main > div > div > form > div:nth-child(2) > label    ==    E-mail
    Get Text    css=#root > main > div > div > form > div:nth-child(3) > label    ==    Senha
    Get Text    css=#root > main > div > div > form > div:nth-child(4) > label    ==    Confirmar Senha

    Get Element States    ${REGISTER_BUTTON}    contains    visible
    Get Text    ${REGISTER_BUTTON}    ==    Cadastrar
    

Preencher Formulário Registro
    [Documentation]    Preenche todos os campos do formulário de registro
    [Arguments]    ${nome}    ${email}    ${senha}    ${confirmar_senha}
    
    Fill Text    ${NAME_INPUT}    ${nome}
    Fill Text    ${EMAIL_INPUT}    ${email}
    Fill Text    ${PASSWORD_INPUT}    ${senha}
    Fill Text    ${CONFIRM_PASSWORD_INPUT}    ${confirmar_senha}

Preencher Nome
    [Arguments]    ${nome}
    Fill Text    ${NAME_INPUT}    ${nome}

Preencher Email
    [Arguments]    ${email}
    Fill Text    ${EMAIL_INPUT}    ${email}

Preencher Senha
    [Arguments]    ${senha}
    Fill Text    ${PASSWORD_INPUT}    ${senha}

Preencher Confirmar Senha
    [Arguments]    ${confirmar_senha}
    Fill Text    ${CONFIRM_PASSWORD_INPUT}    ${confirmar_senha}

Clicar Botão Cadastrar
    [Documentation]    Clica no botão de cadastrar
    Click    ${REGISTER_BUTTON}

Clicar Link Login
    [Documentation]    Clica no link para fazer login
    Click    ${LOGIN_LINK}

Limpar Formulário Registro
    [Documentation]    Limpa todos os campos do formulário
    Clear Text    ${NAME_INPUT}
    Clear Text    ${EMAIL_INPUT}
    Clear Text    ${PASSWORD_INPUT}
    Clear Text    ${CONFIRM_PASSWORD_INPUT}


Gerar Nome Aleatório
    ${random_string}=    Generate Random String    8    [LOWER]
    [Return]    ${random_string}