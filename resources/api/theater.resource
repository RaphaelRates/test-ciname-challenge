*** Settings ***
Library    Collections
Library    RequestsLibrary
Library    String
Library    Faker

Resource    ../api/setup.resource
Resource    ../variables.resource
Resource    ../base.resource

*** Variables ***
${THEATER_TYPES}    standard    3D    IMAX    VIP

*** Keywords ***
Get Admin Token For Theaters
    [Documentation]    Obtém token JWT para admin
    ${token}=    Get Admin Token
    [Return]    ${token}

Get All Theaters
    [Arguments]    ${params}=${None}
    [Documentation]    Busca todos os theaters
    ${response}=    GET On Session    cinema_api    /theaters    params=${params}
    [Return]    ${response}

Get Theater By ID
    [Arguments]    ${theater_id}
    [Documentation]    Busca theater por ID
    ${response}=    GET On Session    cinema_api    /theaters/${theater_id}
    [Return]    ${response}

Create Theater
    [Arguments]    ${theater_data}    ${auth_token}=${None}
    [Documentation]    Cria um novo teatro
    ${auth_token}=        Get Admin Token For Theaters
    
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    ${response}=    POST On Session    cinema_api    /theaters    json=${theater_data}    headers=${headers}    expected_status=any
    [Return]    ${response}

Update Theater
    [Arguments]    ${theater_id}    ${update_data}    ${auth_token}=${None}
    [Documentation]    Atualiza um theater existente
    ${token}=    Run Keyword If    $auth_token is ${None}    Get Admin Token For Theaters
    ...    ELSE    Set Variable    ${auth_token}
    ${headers}=    Create Dictionary    
    ...    Content-Type=application/json    
    ...    Authorization=${token}
    ${response}=    PUT On Session    cinema_api    /theaters/${theater_id}    json=${update_data}    headers=${headers}    expected_status=Anything
    [Return]    ${response}

Delete Theater
    [Arguments]    ${theater_id}    ${auth_token}=${None}
    [Documentation]    Deleta um theater
    ${token}=    Run Keyword If    $auth_token is ${None}    Get Admin Token For Theaters
    ...    ELSE    Set Variable    ${auth_token}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${response}=    DELETE On Session    cinema_api    /theaters/${theater_id}    headers=${headers}    expected_status=Anything
    [Return]    ${response}

Generate Fake Theater Data
    [Arguments]    ${name}=${None}    ${capacity}=${None}
    [Documentation]    Gera dados fake para theater com type fixo 'standard'
    ${timestamp}=    Get Time    epoch
    ${random_num}=    Evaluate    random.randint(1, 10)
    ${fake_name}=    Run Keyword If    '${name}' == '${None}'    Set Variable    Theater_${timestamp}_${random_num}
    ...    ELSE    Set Variable    ${name}
    ${fake_capacity}=    Run Keyword If    '${capacity}' == '${None}'    Evaluate    random.randint(50, 300)
    ...    ELSE    Set Variable    ${capacity}
    ${theater_data}=    Create Dictionary
    ...    name=${fake_name}
    ...    capacity=${fake_capacity}
    ...    type=standard
    [Return]    ${theater_data}


Verify Theater Response Structure
    [Arguments]    ${response}
    [Documentation]    Verifica estrutura da resposta de theater
    
    Should Be Equal As Strings    ${response.status_code}    200
    
    ${json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json}    success
    Should Be True    ${json["success"]}

    Dictionary Should Contain Key    ${json}    data
    ${data}=    Set Variable    ${json["data"]}
    
    Dictionary Should Contain Key    ${data}    id
    Dictionary Should Contain Key    ${data}    name
    Dictionary Should Contain Key    ${data}    capacity
    Dictionary Should Contain Key    ${data}    type
    Dictionary Should Contain Key    ${data}    createdAt


Verify Theater List Structure
    [Arguments]    ${response}
    [Documentation]    Verifica estrutura da lista de theaters
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json}    data
    Dictionary Should Contain Key    ${json}    count

Verify Theater Created Successfully
    [Arguments]    ${response}
    [Documentation]    Verifica criação bem-sucedida de theater
    Should Be Equal As Strings    ${response.status_code}    201
    ${json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json}    id
    Dictionary Should Contain Key    ${json}    name
    Dictionary Should Contain Key    ${json}    capacity
    Dictionary Should Contain Key    ${json}    type
    Dictionary Should Contain Key    ${json}    createdAt

Verify Error Response
    [Arguments]    ${response}    ${expected_status}
    [Documentation]    Verifica resposta de erro
    Should Be Equal As Strings    ${response.status_code}    ${expected_status}
    ${json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json}    success
    Should Be Equal    ${json}[success]    ${False}

Create Theater And Get ID
    [Arguments]    ${theater_data}=${None}
    [Documentation]    Cria theater e retorna o ID
    ${theater_data}=    Run Keyword If    $theater_data is ${None}    Generate Fake Theater Data
    ...    ELSE    Set Variable    ${theater_data}
    ${response}=    Create Theater    ${theater_data}
    Verify Theater Created Successfully    ${response}
    ${theater_id}=    Set Variable    ${response.json()}[_id]
    [Return]    ${theater_id}