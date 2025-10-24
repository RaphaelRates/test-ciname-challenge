*** Settings ***
Library    Browser
Library    Collections
Library    String

Resource   ../../variables.resource
Resource   ../../base.resource

*** Keywords ***
Abrir Página de Login
    New Page    http://localhost:3002/login
    Wait For Elements State    css=.login-form    visible    timeout=10s

Verificar Elementos da Página de Login
    Get Element States    css=.login-form    contains    visible
    Get Element States    css=.login-header h1    contains    visible
    Get Text    css=.login-header h1    ==    Login
    Get Text    css=.login-header p    contains    Entre com suas credenciais
    Get Element    id=email
    Get Element    id=password
    Get Element    css=.login-btn
    Get Text    css=label[for="email"]    ==    E-mail
    Get Text    css=label[for="password"]    ==    Senha
    Get Attribute    id=email    placeholder    ==    Seu e-mail
    Get Attribute    id=password    placeholder    ==    Sua senha
    Get Element States    css=.form-group:nth-child(1) svg    contains    visible
    Get Element States    css=.form-group:nth-child(2) svg    contains    visible
    Get Text    css=.login-footer    contains    Não tem uma conta?
    Get Text    css=#root > header > div > nav > ul > li:nth-child(4) > a    ==    Cadastrar

Preencher Formulário de Login
    [Arguments]    ${email}    ${senha}
    Fill Text    css=#email    ${email}
    Fill Text    css=#password    ${senha}
    Click    css=main > div > div > form > button
    Sleep   2s
    

Verificar Login Bem Sucedido
    [Documentation]    Verifica se o login foi bem-sucedido e se o link do menu está visível
    ${current_url}=    Get Url
    Should Be Equal As Strings    ${current_url}    http://localhost:3002/
    Wait For Elements State    css=#root > header > div > nav > ul > li:nth-child(4) > a    visible    timeout=5s


Verificar Erro Login
    [Documentation]    Verifica se o login deu errado
    ${current_url}=    Get Url
    Should Be Equal As Strings    ${current_url}    http://localhost:3002/login

Verificar Validação Campos Obrigatórios
    Click    css=.login-btn
    Get Element States    id=email    contains    visible
    Get Element States    id=password    contains    visible

Clicar Link Registrar
    Click    css=#root > main > div > div > div.login-footer > p > a
    Wait For Elements State    css=.register-form    visible    timeout=10s

Verificar Página Registro Carregou
    Get Url    contains    /register
    Get Element States    css=.register-form    contains    visible

Gerar Email Aleatório
    ${random_string}=    Generate Random String    8    [LOWER]
    [Return]    ${random_string}@example.com

Gerar Senha Aleatória
    ${random_senha}=    Generate Random String    12    [LETTERS][NUMBERS]
    [Return]    ${random_senha}

Tirar Print
    Browser.Take Screenshot    

Configurar Teste
    New Browser    chromium    headless=False
    New Context    viewport={'width': 1920, 'height': 1080}

Finalizar Teste
    Close Browser
