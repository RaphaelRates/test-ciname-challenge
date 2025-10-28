*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource   ../../resources/variables.resource
Resource   ../../resources/api/auth.resource
Test Setup    Create API Session

*** Test Cases ***
TC001 - Cadastro de Usuário com Email Já Existente
    [Documentation]    Tenta cadastrar usuário com email já registrado - CORRIGIDO
    ${timestamp}=    Get Time    epoch
    ${existing_email}=    Catenate    SEPARATOR=    teste_existente_${timestamp}@email.com
    ${token}=    Register And Perform Login    ${existing_email}    ${NEW_USER_PASSWORD}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${body}=    Create Dictionary    name=Duplicate User    email=${existing_email}    password=${NEW_USER_PASSWORD}
    ${response}=    POST On Session    cinema_api    /auth/register    json=${body}    headers=${headers}    expected_status=400
    Should Be Equal As Strings    ${response.status_code}    400
    Log    Response da duplicação: ${response.json()}

TC002 - Cadastro com Dados Inválidos
    [Documentation]    Testa registro com dados faltantes/inválidos - CORRIGIDO
    ${timestamp}=    Get Time    epoch
    
    @{test_cases}=    Create List
    ...    ${{{"name": "", "email": "teste${timestamp}@email.com", "password": "123456"}}}   
    ...    ${{{"name": "Test User", "email": "email-invalido", "password": "123456"}}}  
    ...    ${{{"name": "Test User", "email": "teste${timestamp}2@email.com", "password": "123"}}}    # FALTAVA FECHAR ESTA LINHA
    ...    ${{{"name": "Test User", "email": "", "password": "123456"}}}   

    FOR    ${test_case}    IN    @{test_cases}
        ${headers}=    Create Dictionary    Content-Type=application/json
        ${response}=    POST On Session    cinema_api    /auth/register    json=${test_case}    headers=${headers}    expected_status=400
        Should Be Equal As Strings    ${response.status_code}    400
        Log    Response para caso inválido: ${response.json()}
    END

TC003 - Login com Credenciais Inválidas
    [Documentation]    Testa login com email/senha incorretos - CORRIGIDO
    ${timestamp}=    Get Time    epoch
    ${valid_email}=    Catenate    SEPARATOR=    teste_login_invalido_${timestamp}@email.com
    
    ${token}=    Register And Perform Login    ${valid_email}    ${NEW_USER_PASSWORD}
    
    @{invalid_credentials}=    Create List
    ...    ${{{"email": "naoexiste@email.com", "password": "${NEW_USER_PASSWORD}"}}}
    ...    ${{{"email": "${valid_email}", "password": "senhaerrada"}}}

    FOR    ${credentials}    IN    @{invalid_credentials}
        ${headers}=    Create Dictionary    Content-Type=application/json
        ${response}=    POST On Session    cinema_api    /auth/login    json=${credentials}    headers=${headers}    expected_status=401
        Should Be Equal As Strings    ${response.status_code}    401
        Should Be Equal As Strings    ${response.json()}[success]    False
        Log    Response login inválido: ${response.json()}
    END

TC004 - Acesso ao Perfil com Token Inválido
    [Documentation]    Tenta acessar /auth/me com token inválido - CORRIGIDO
    ${headers}=    Create Dictionary    
    ...    Content-Type=application/json    
    ...    Authorization=Bearer token_invalido_123
    
    ${response}=    GET On Session    cinema_api    /auth/me    headers=${headers}    expected_status=401
    
    Should Be Equal As Strings    ${response.status_code}    401
    Should Be Equal As Strings    ${response.json()}[success]    False


TC005 - Fluxo Completo de Autenticação
    [Documentation]    Testa fluxo completo: registro → login → perfil → update → CORRIGIDO
    ${timestamp}=    Get Time    epoch
    ${flow_email}=    Catenate    SEPARATOR=    teste_fluxo_${timestamp}@email.com
    ${new_name}=    Set Variable    Usuário Fluxo Completo
    
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${register_body}=    Create Dictionary    name=Usuario Inicial    email=${flow_email}    password=${NEW_USER_PASSWORD}
    ${register_response}=    POST On Session    cinema_api    /auth/register    json=${register_body}    headers=${headers}
    Should Be Equal As Strings    ${register_response.status_code}    201
    
    ${token}=    Perform Valid Login    ${flow_email}    ${NEW_USER_PASSWORD}
    Should Not Be Empty    ${token}
    
    ${profile_headers}=    Create Dictionary    
    ...    Content-Type=application/json    
    ...    Authorization=Bearer ${token}
    ${profile_response}=    GET On Session    cinema_api    /auth/me    headers=${profile_headers}
    Should Be Equal As Strings    ${profile_response.status_code}    200
    Should Be Equal As Strings    ${profile_response.json()}[data][email]    ${flow_email}
    
    ${update_body}=    Create Dictionary    name=${new_name}
    ${update_response}=    PUT On Session    cinema_api    /auth/profile    json=${update_body}    headers=${profile_headers}
    Should Be Equal As Strings    ${update_response.status_code}    200
    Should Be Equal As Strings    ${update_response.json()}[data][name]    ${new_name}
    
    Log    Fluxo completo de autenticação executado com sucesso!

TC006 - Login com Credenciais do Raphael
    [Documentation]    Testa login com email: raphaelrates.dev@gmail.com e senha: 12345678
    ${specific_email}=    Set Variable    raphaelrates.dev@gmail.com
    ${specific_password}=    Set Variable    12345678
    
    ${token}=    Perform Valid Login    ${specific_email}    ${specific_password}
    
    Should Not Be Empty    ${token}
    Log    Login realizado com sucesso! Token obtido: ${token}