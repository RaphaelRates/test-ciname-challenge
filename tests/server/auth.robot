*** Settings ***
Documentation    Testes relacionados à autenticação de usuários via API

Library          RequestsLibrary
Library          Collections

Resource    ../../resources/variables.resource
Resource    ../../resources/base.resource

Resource    ../../resources/api/auth.resource




Suite Setup    Create Session    api    ${URL_FRONT}

*** Test Cases ***
# Testes POST /auth/register
Test Register New User Successfully
    [Documentation]    Deve registrar um novo usuário com sucesso
    ${random}=    Evaluate    str(__import__('time').time()).replace('.','')
    ${email}=    Set Variable    user${random}@gmail.com
    ${response}=    Register New User    Usuario Teste    ${email}    senha123
    Verify Success Response    ${response}    201
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal    ${json['data']['email']}    ${email}
    Should Be Equal    ${json['data']['role']}    user
    Dictionary Should Contain Key    ${json['data']}    token

Test Register With Existing Email
    [Documentation]    Não deve registrar usuário com email já cadastrado
    ${email}=    Set Variable    duplicate@example.com
    Register New User    Usuario 1    ${email}    senha123
    ${response}=    Register New User    Usuario 2    ${email}    senha123
    Verify Error Response    ${response}    404    already exists

Test Register With Invalid Data
    [Documentation]    Não deve registrar com dados inválidos
    ${response}=    Register New User    ${EMPTY}    email-invalido    123
    Should Be Equal As Numbers    ${response.status_code}    404

Test Login With Valid Credentials
    [Documentation]    Deve fazer login com credenciais válidas
    ${random}=    Evaluate    str(__import__('time').time()).replace('.','')
    ${email}=    Set Variable    login${random}@example.com
    Register New User    Usuario Login    ${email}    senha123
    ${response}=    Login User    ${email}    senha123
    Verify Success Response    ${response}    200
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal    ${json['data']['email']}    ${email}
    Dictionary Should Contain Key    ${json['data']}    token

Test Login With Invalid Email
    [Documentation]    Não deve fazer login com email inexistente
    ${response}=    Login User    naoexiste@example.com    senha123
    Verify Error Response    ${response}    404    Invalid credentials

Test Login With Wrong Password
    [Documentation]    Não deve fazer login com senha incorreta
    ${random}=    Evaluate    str(__import__('time').time()).replace('.','')
    ${email}=    Set Variable    wrongpass${random}@example.com
    Register New User    Usuario    ${email}    senha123
    ${response}=    Login User    ${email}    senhaerrada
    Verify Error Response    ${response}    404    Invalid credentials

# Testes GET /auth/me
Test Get Profile With Valid Token
    [Documentation]    Deve retornar perfil do usuário com token válido
    ${email}=    Set Variable    raphaelrates.dev@gmail.com
    ${response}=    Register New User    Usuario Profile    ${email}    12345678
    ${token}=    Extract Token From Response    ${response}
    ${response}=    Get User Profile    ${token}
    Verify Success Response    ${response}    200
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal    ${json['data']['email']}    ${email}

Test Get Profile Without Token
    [Documentation]    Não deve retornar perfil sem token
    ${response}=    Get User Profile    ${EMPTY}
    Should Be Equal As Numbers    ${response.status_code}    401

Test Get Profile With Invalid Token
    [Documentation]    Não deve retornar perfil com token inválido
    ${response}=    Get User Profile    token-invalido-12345
    Should Be Equal As Numbers    ${response.status_code}    403

# Testes PUT /auth/profile
Test Update Profile Name Successfully
    [Documentation]    Deve atualizar nome do usuário
    ${random}=    Evaluate    str(__import__('time').time()).replace('.','')
    ${email}=    Set Variable    update${random}@example.com
    ${response}=    Register New User    Nome Antigo    ${email}    senha123
    ${token}=    Extract Token From Response    ${response}
    ${response}=    Update User Profile    ${token}    name=Nome Novo
    Verify Success Response    ${response}    200
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal    ${json['data']['name']}    Nome Novo

Test Update Profile Password Successfully
    [Documentation]    Deve atualizar senha do usuário
    ${random}=    Evaluate    str(__import__('time').time()).replace('.','')
    ${email}=    Set Variable    passupdate${random}@example.com
    ${response}=    Register New User    Usuario    ${email}    senha123
    ${token}=    Extract Token From Response    ${response}
    ${response}=    Update User Profile    ${token}    current_password=senha123    new_password=novaSenha456
    Verify Success Response    ${response}    200
    # Testa login com nova senha
    ${response}=    Login User    ${email}    novaSenha456
    Verify Success Response    ${response}    200

Test Update Profile With Wrong Current Password
    [Documentation]    Não deve atualizar com senha atual incorreta
    ${random}=    Evaluate    str(__import__('time').time()).replace('.','')
    ${email}=    Set Variable    wrongcurrent${random}@example.com
    ${response}=    Register New User    Usuario    ${email}    senha123
    ${token}=    Extract Token From Response    ${response}
    ${response}=    Update User Profile    ${token}    current_password=senhaerrada    new_password=novaSenha
    Should Be Equal As Numbers    ${response.status_code}    401

Test Update Profile Without Token
    [Documentation]    Não deve atualizar perfil sem token
    ${response}=    Update User Profile    ${EMPTY}    name=Novo Nome
    Should Be Equal As Numbers    ${response.status_code}    401