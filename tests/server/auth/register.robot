*** Settings ***
Documentation    Testes de registro de usuário

Library          RequestsLibrary
Library          Collections

Resource         ../../../resources/api/auth.resource
Resource         ../../../resources/base.resource
Resource         ../../../resources/variables.resource

Suite Setup      Create Session    cinema_api    http://localhost:3000
Suite Teardown   Delete All Sessions

*** Test Cases ***
Teste Registro Usuario Valido Com Fixture
    [Documentation]    Testa registro de usuário com fixture válida
    ${response}    ${user_data}    Register User With Fixture    valid_user
    Log To Console    \n[REGISTER USER RESPONSE]\n${response.json()}
    Verify Response Success    ${response}  201
    
    ${user}    Extract User From Response    ${response}
    Verify User Data Structure    ${user}
    
    Should Be Equal    ${user}[name]    ${user_data}[name]
    Should Be Equal    ${user}[email]    ${user_data}[email]
    Dictionary Should Contain Key    ${response.json()}    token

Teste Registro Usuario Randomico
    [Documentation]    Testa registro de usuário com dados aleatórios
    ${response}    ${user_data}    Register Random User
    Verify Response Success    ${response}  201
    
    ${user}    Extract User From Response    ${response}
    Verify User Data Structure    ${user}
    Should Be Equal    ${user}[name]    ${user_data}[name]
    Should Be Equal    ${user}[email]    ${user_data}[email]

Teste Registro Email Invalido Com Fixture
    [Documentation]    Testa registro com email inválido usando fixture
    ${response}    ${user_data}    Register User With Fixture    invalid_user_email
    Should Be Equal As Strings    ${response.status_code}    400
    Should Be Equal    ${response.json()}[success]    ${False}

Teste Registro Senha Curta Com Fixture
    [Documentation]    Testa registro com senha curta usando fixture
    ${response}    ${user_data}    Register User With Fixture    invalid_user_password
    Should Be Equal As Strings    ${response.status_code}    400
    Should Be Equal    ${response.json()}[success]    ${False}