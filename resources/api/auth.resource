*** Settings ***
Documentation    Recursos relacionados à autenticação de usuários via API

Library    RequestsLibrary
Library    Collections

Resource    ../variables.resource
Resource    ../base.resource

*** Keywords ***
*** Keywords ***
Create API Session
    [Arguments]    ${alias}=api
    Create Session    ${alias}    ${URL_API}    headers=${DEFAULT_HEADERS}

Register User
    [Arguments]    ${name}    ${email}    ${password}    ${expected_status}=201
    ${payload}=    Create Dictionary    name=${name}    email=${email}    password=${password}
    ${resp}=    POST on Session   api    /auth/register    json=${payload}
    Status Should Be    ${resp}    ${expected_status}
    ${body}=    Evaluate    ${resp.json()}
    Should Be True    ${body['success'] is True}
    [Return]    ${body}

Register User With Fixture
    [Arguments]    ${fixture_name}    ${expected_status}=201
    ${user_data}=    Get Auth Fixture    ${fixture_name}
    Log To Console    ${user_data}
    ${response}=    Register User    ${user_data['name']}    ${user_data['email']}    ${user_data['password']}    ${expected_status}
    [Return]    ${response}    ${user_data}

Register Random User
    [Documentation]    Registra um usuário com dados únicos gerados dinamicamente
    ${user_data}=     Generate User with Faker
    ${response}=      Register User    ${user_data['name']}    ${user_data['email']}    ${user_data['password']}    201
    [Return]          ${response}    ${user_data}

Login User
    [Arguments]    ${email}    ${password}    ${expected_status}=200
    ${payload}=    Create Dictionary    email=${email}    password=${password}
    ${resp}=    POST on Session   ${URL_API}    /auth/login    json=${payload}
    Status Should Be    ${resp}    ${expected_status}
    ${body}=    Evaluate    ${resp.json()}
    [Return]    ${body}