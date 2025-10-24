*** Settings ***
Documentation    Testes de login de usuário

Library          RequestsLibrary
Library          Collections

Resource         ../../../resources/api/auth.resource
Resource         ../../../resources/base.resource
Resource         ../../../resources/variables.resource

Suite Setup      Create Session    cinema_api    ${URL_API}    headers=${DEFAULT_HEADERS}
Suite Teardown   Delete All Sessions


*** Test Cases ***
Test Register New User
    Create API Session
    ${body}=    Register User    John Doe    john@example.com    MyPassword123
    Log To Console    \n[REGISTER SUCCESS ✅]\n${body}

Test Login Existing User
    Create API Session
    ${body}=    Login User    john@example.com    MyPassword123
    Log To Console    \n[LOGIN SUCCESS ✅]\n${body}

Test Login Invalid Credentials
    Create API Session
    ${resp}=    Login User    john@example.com    WrongPass    ${expected_status}=400
    ${body}=    Evaluate    ${resp.json()}
    Should Be False    ${body['success'] is True}
    Log To Console    \n[LOGIN FAILED ❌]\n${body}