*** Settings ***
Library    Collections
Library    RequestsLibrary
Library    Faker
Library    String

Resource   ../variables.resource
Resource   ../base.resource

*** Keywords ***
Create Admin User
    [Arguments]    ${admin_data}
    [Documentation]    Cria um usuário admin via endpoint /setup/admin
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session    cinema_api    /setup/admin    json=${admin_data}    headers=${headers}    expected_status=Anything
    [Return]    ${response}

Create Test Users
    [Documentation]    Cria usuários de teste via endpoint /setup/test-users
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session    cinema_api    /setup/test-users    headers=${headers}
    [Return]    ${response}

Create Valid Admin Data
    [Arguments]    ${name}=Admin User    ${email}=admin@example.com    ${password}=admin123
    [Documentation]    Cria dados válidos para criação de admin
    ${admin_data}=    Create Dictionary
    ...    name=${name}
    ...    email=${email}
    ...    password=${password}
    [Return]    ${admin_data}

Verify Admin User Response Structure
    [Arguments]    ${response}
    [Documentation]    Verifica a estrutura da resposta de criação de admin
    Should Be Equal As Strings    ${response.status_code}    201
    Should Be Equal As Strings    ${response.json()}[success]    True
    Should Be Equal As Strings    ${response.json()}[message]    Admin user created successfully
    Dictionary Should Contain Key    ${response.json()}    data

Verify Test Users Response Structure
    [Arguments]    ${response}
    [Documentation]    Verifica a estrutura da resposta de criação de test users
    ${status_code}=    Convert To Integer    ${response.status_code}
    Should Be True    ${status_code} == 200 or ${status_code} == 201
    Should Be Equal As Strings    ${response.json()}[success]    True
    Dictionary Should Contain Key    ${response.json()}    message

Verify Error Response Structure
    [Arguments]    ${response}   
    [Documentation]    Verifica estrutura de resposta de erro
    Should Be Equal As Strings    ${response.json()}[success]    False
    Dictionary Should Contain Key    ${response.json()}    message

Verify Production Environment Error
    [Arguments]    ${response}
    [Documentation]    Verifica erro específico de ambiente de produção
    Verify Error Response Structure    ${response}   
    Should Contain    ${response.json()}[message]    only available in development environment

Admin User Should Have Correct Structure
    [Arguments]    ${admin_data}
    [Documentation]    Verifica estrutura dos dados do admin criado
    Dictionary Should Contain Key    ${admin_data}    _id
    Dictionary Should Contain Key    ${admin_data}    name
    Dictionary Should Contain Key    ${admin_data}    email
    Dictionary Should Contain Key    ${admin_data}    role
    Should Be Equal As Strings    ${admin_data}[role]    admin

Test Users Data Should Have Correct Structure
    [Arguments]    ${test_users_data}
    [Documentation]    Verifica estrutura dos dados dos test users
    Dictionary Should Contain Key    ${test_users_data}    users
    ${users}=    Set Variable    ${test_users_data}[users]
    Should Be True    len(${users}) > 0
    FOR    ${user}    IN    @{users}
        Dictionary Should Contain Key    ${user}    email
        Dictionary Should Contain Key    ${user}    password
        Dictionary Should Contain Key    ${user}    role
    END

Setup Test Environment
    [Documentation]    Cria ambiente de teste com usuários padrão
    ${response}=    Create Test Users
    [Return]    ${response}

