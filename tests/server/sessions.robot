*** Settings ***
Documentation     Testes das Sessões de filmes

Library        RequestsLibrary
Library        Collections
Library        String
Library        DateTime

Resource        ../../resources/api/sessions.resource
Resource        ../../resources/api/movies.resource
Resource        ../../resources/api/theater.resource
Resource        ../../resources/api/auth.resource
Resource        ../../resources/variables.resource
Resource        ../../resources/base.resource

Suite Setup    Setup API Session
Suite Teardown    Teardown API Session

Test Setup    Log    Starting test: ${TEST_NAME}
Test Teardown    Log    Finished test: ${TEST_NAME}

*** Test Cases ***
TC042 - Get All Data Sessions With Public Access
    [Documentation]    Listar todas as sessões com acesso público
    [Tags]    sessions    read    public
    ${response}=    Get All Data Sessions    expected_status=200
    Should Be Success Response    ${response}    200
    Dictionary Should Contain Key    ${response.json()}    data
    Dictionary Should Contain Key    ${response.json()}    count
    Log    Total de sessões: ${response.json()}[count]

TC043 - Get Sessions With Pagination
    [Documentation]    Listar sessões com paginação
    [Tags]    sessions    read    pagination
    ${response}=    Get All Data Sessions    page=1    limit=5    expected_status=200
    Should Be Success Response    ${response}    200
    ${has_pagination}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${response.json()}    pagination
    Run Keyword If    ${has_pagination}    Log    Paginação: ${response.json()}[pagination]

TC044 - Get Sessions Filtered By Movie
    [Documentation]    Filtrar sessões por filme
    [Tags]    sessions    read    filter
    ${response}=    Get All Data Sessions    expected_status=200
    ${sessions_count}=    Get Length    ${response.json()}[data]
    
    Run Keyword If    ${sessions_count} > 0
    ...    Run Keywords
    ...    ${movie_id}=    Set Variable    ${response.json()}[data][0][movie][_id]
    ...    AND    ${filtered_response}=    Get All Data Sessions    movie=${movie_id}    expected_status=200
    ...    AND    Should Be Success Response    ${filtered_response}    200
    ...    ELSE
    ...    Log    Não há sessões disponíveis para filtrar

TC045 - Get Sessions Filtered By Theater
    [Documentation]    Filtrar sessões por sala
    [Tags]    sessions    read    filter
    ${response}=    Get All Data Sessions    expected_status=200
    ${sessions_count}=    Get Length    ${response.json()}[data]
    
    Run Keyword If    ${sessions_count} > 0
    ...    Run Keywords
    ...    ${theater_id}=    Set Variable    ${response.json()}[data][0][theater][_id]
    ...    AND    ${filtered_response}=    Get All Data Sessions    theater=${theater_id}    expected_status=200
    ...    AND    Should Be Success Response    ${filtered_response}    200
    ...    ELSE
    ...    Log    Não há sessões disponíveis para filtrar

TC046 - Get Sessions Filtered By Date
    [Documentation]    Filtrar sessões por data
    [Tags]    sessions    read    filter
    ${today}=    Get Current Date    result_format=%Y-%m-%d
    ${response}=    Get All Data Sessions    date=${today}    expected_status=200
    Should Be Success Response    ${response}    200

TC047 - Get Session By Valid ID
    [Documentation]    Buscar sessão por ID válido
    [Tags]    sessions    read
    ${response}=    Get All Data Sessions    expected_status=200
    ${sessions_count}=    Get Length    ${response.json()}[data]
    
    Run Keyword If    ${sessions_count} > 0
    ...    Run Keywords
    ...    ${session_id}=    Set Variable    ${response.json()}[data][0][_id]
    ...    AND    ${get_response}=    Get Session By ID    ${session_id}    expected_status=200
    ...    AND    Should Be Success Response    ${get_response}    200
    ...    AND    Should Be Equal As Strings    ${get_response.json()}[data][_id]    ${session_id}
    ...    ELSE
    ...    Log    Não há sessões disponíveis para testar

TC048 - Get Session By Invalid ID
    [Documentation]    Tentativa de buscar sessão com ID inválido
    [Tags]    sessions    read    error
    ${response}=    Get Session By ID    invalid_id_123    expected_status=400
    Should Be Error Response    ${response}    400

TC049 - Get Non-Existent Session
    [Documentation]    Tentativa de buscar sessão que não existe
    [Tags]    sessions    read    error
    ${response}=    Get Session By ID    60d0fe4f53112398988a109c    expected_status=404
    Should Be Error Response    ${response}    404

TC050 - Create Data Session As Admin
    [Documentation]    Criar nova sessão como administrador
    [Tags]    sessions    create    admin
    ${admin_token}=    Get Admin Token
    
    # Obtém um filme e sala válidos
    ${movies_response}=    Get All Movies    expected_status=200
    ${theaters_response}=    Get All Theaters    expected_status=200
    
    ${movies_count}=    Get Length    ${movies_response.json()}[data]
    ${theaters_count}=    Get Length    ${theaters_response.json()}[data]
    
    Run Keyword If    ${movies_count} > 0 and ${theaters_count} > 0
    ...    Create Valid Session    ${admin_token}    ${movies_response}    ${theaters_response}
    ...    ELSE
    ...    Log    Não há filmes ou salas disponíveis para criar sessão

TC051 - Create Data Session With Invalid Movie ID
    [Documentation]    Tentativa de criar sessão com ID de filme inválido
    [Tags]    sessions    create    admin    error
    ${admin_token}=    Get Admin Token
    ${theaters_response}=    Get All Theaters    expected_status=200
    ${theaters_count}=    Get Length    ${theaters_response.json()}[data]
    
    Run Keyword If    ${theaters_count} > 0
    ...    Run Keywords
    ...    ${theater_id}=    Set Variable    ${theaters_response.json()}[data][0][_id]
    ...    AND    ${future_datetime}=    Get Future Datetime    hours=24
    ...    AND    ${response}=    Create Data Session    ${admin_token}    invalid_movie_id    ${theater_id}    ${future_datetime}    20    10    expected_status=404
    ...    AND    Should Be Error Response    ${response}    404
    ...    ELSE
    ...    Log    Não há salas disponíveis para teste

TC052 - Create Data Session With Invalid Theater ID
    [Documentation]    Tentativa de criar sessão com ID de sala inválido
    [Tags]    sessions    create    admin    error
    ${admin_token}=    Get Admin Token
    ${movies_response}=    Get All Movies    expected_status=200
    ${movies_count}=    Get Length    ${movies_response.json()}[data]
    
    Run Keyword If    ${movies_count} > 0
    ...    Run Keywords
    ...    ${movie_id}=    Set Variable    ${movies_response.json()}[data][0][_id]
    ...    AND    ${future_datetime}=    Get Future Datetime    hours=24
    ...    AND    ${response}=    Create Data Session    ${admin_token}    ${movie_id}    invalid_theater_id    ${future_datetime}    20    10    expected_status=404
    ...    AND    Should Be Error Response    ${response}    404
    ...    ELSE
    ...    Log    Não há filmes disponíveis para teste

TC053 - Create Data Session With Invalid Data
    [Documentation]    Tentativa de criar sessão com dados inválidos
    [Tags]    sessions    create    admin    error
    ${admin_token}=    Get Admin Token
    ${headers}=    Create Auth Headers    ${admin_token}
    ${body}=    Create Dictionary    movie=incomplete
    ${response}=    POST On Session    cinema_api    /sessions    json=${body}    headers=${headers}    expected_status=400
    Should Be Error Response    ${response}    400

TC054 - Update Data Session As Admin
    [Documentation]    Atualizar sessão como administrador
    [Tags]    sessions    update    admin
    ${admin_token}=    Get Admin Token
    
    ${movies_response}=    Get All Movies    expected_status=200
    ${theaters_response}=    Get All Theaters    expected_status=200
    
    ${movies_count}=    Get Length    ${movies_response.json()}[data]
    ${theaters_count}=    Get Length    ${theaters_response.json()}[data]
    
    Run Keyword If    ${movies_count} > 0 and ${theaters_count} > 0
    ...    Create And Update Data Session    ${admin_token}    ${movies_response}    ${theaters_response}
    ...    ELSE
    ...    Log    Não há recursos disponíveis para teste de atualização

TC055 - Update Data Session With Partial Data
    [Documentation]    Atualizar apenas alguns campos da sessão
    [Tags]    sessions    update    admin
    ${admin_token}=    Get Admin Token
    
    ${movies_response}=    Get All Movies    expected_status=200
    ${theaters_response}=    Get All Theaters    expected_status=200
    
    ${movies_count}=    Get Length    ${movies_response.json()}[data]
    ${theaters_count}=    Get Length    ${theaters_response.json()}[data]
    
    Run Keyword If    ${movies_count} > 0 and ${theaters_count} > 0
    ...    Create And Update Data Session Partial    ${admin_token}    ${movies_response}    ${theaters_response}
    ...    ELSE
    ...    Log    Não há recursos disponíveis para teste

TC056 - Update Non-Existent Session
    [Documentation]    Tentativa de atualizar sessão que não existe
    [Tags]    sessions    update    admin    error
    ${admin_token}=    Get Admin Token
    ${future_datetime}=    Get Future Datetime    hours=24
    ${response}=    Update Data Session    ${admin_token}    60d0fe4f5311236168a109ce    datetime=${future_datetime}    expected_status=404
    Should Be Error Response    ${response}    404

TC057 - Delete Data Session As Admin
    [Documentation]    Deletar sessão como administrador
    [Tags]    sessions    delete    admin
    ${admin_token}=    Get Admin Token
    
    ${movies_response}=    Get All Movies    expected_status=200
    ${theaters_response}=    Get All Theaters    expected_status=200
    
    ${movies_count}=    Get Length    ${movies_response.json()}[data]
    ${theaters_count}=    Get Length    ${theaters_response.json()}[data]
    
    Run Keyword If    ${movies_count} > 0 and ${theaters_count} > 0
    ...    Create And Delete Data Session    ${admin_token}    ${movies_response}    ${theaters_response}
    ...    ELSE
    ...    Log    Não há recursos disponíveis para teste de deleção

TC058 - Delete Non-Existent Session
    [Documentation]    Tentativa de deletar sessão que não existe
    [Tags]    sessions    delete    admin    error
    ${admin_token}=    Get Admin Token
    ${response}=    Delete Data Session    ${admin_token}    60d0fe4f5311236168a109ce    expected_status=404
    Should Be Error Response    ${response}    404

TC059 - Create Data Session Without Admin Rights
    [Documentation]    Tentativa de criar sessão sem ser admin
    [Tags]    sessions    create    security
    ${user_token}=    Get User Token
    ${future_datetime}=    Get Future Datetime    hours=24
    ${response}=    Create Data Session    ${user_token}    movie_id    theater_id    ${future_datetime}    20    10    expected_status=403
    Should Be Error Response    ${response}    403

TC060 - Update Data Session Without Admin Rights
    [Documentation]    Tentativa de atualizar sessão sem ser admin
    [Tags]    sessions    update    security
    ${user_token}=    Get User Token
    ${response}=    Update Data Session    ${user_token}    60d0fe4f5311236168a109ce    full_price=25    expected_status=403
    Should Be Error Response    ${response}    403

TC061 - Delete Data Session Without Admin Rights
    [Documentation]    Tentativa de deletar sessão sem ser admin
    [Tags]    sessions    delete    security
    ${user_token}=    Get User Token
    ${response}=    Delete Data Session    ${user_token}    60d0fe4f5311236168a109ce    expected_status=403
    Should Be Error Response    ${response}    403

TC062 - Reset Data Session Seats As Admin
    [Documentation]    Resetar assentos de uma sessão como admin
    [Tags]    sessions    update    admin
    ${admin_token}=    Get Admin Token
    ${sessions_response}=    Get All Data Sessions    expected_status=200
    ${sessions_count}=    Get Length    ${sessions_response.json()}[data]
    
    Run Keyword If    ${sessions_count} > 0
    ...    Run Keywords
    ...    ${session_id}=    Set Variable    ${sessions_response.json()}[data][0][_id]
    ...    AND    ${response}=    Reset Data Session Seats    ${admin_token}    ${session_id}    expected_status=200
    ...    AND    Should Be Success Response    ${response}    200
    ...    AND    Should Contain    ${response.json()}[message]    reset
    ...    ELSE
    ...    Log    Não há sessões disponíveis para resetar

TC063 - Reset Seats Without Admin Rights
    [Documentation]    Tentativa de resetar assentos sem ser admin
    [Tags]    sessions    update    security
    ${user_token}=    Get User Token
    ${response}=    Reset Data Session Seats    ${user_token}    60d0fe4f5311236168a109ce    expected_status=403
    Should Be Error Response    ${response}    403

TC064 - Reset Seats Of Non-Existent Session
    [Documentation]    Tentativa de resetar assentos de sessão inexistente
    [Tags]    sessions    update    admin    error
    ${admin_token}=    Get Admin Token
    ${response}=    Reset Data Session Seats    ${admin_token}    60d0fe4f5311236168a109ce    expected_status=404
    Should Be Error Response    ${response}    404

TC065 - Complete Session CRUD Flow
    [Documentation]    Fluxo completo CRUD para sessões
    [Tags]    sessions    crud    admin    smoke
    ${admin_token}=    Get Admin Token
    
    ${movies_response}=    Get All Movies    expected_status=200
    ${theaters_response}=    Get All Theaters    expected_status=200
    
    ${movies_count}=    Get Length    ${movies_response.json()}[data]
    ${theaters_count}=    Get Length    ${theaters_response.json()}[data]
    
    Run Keyword If    ${movies_count} > 0 and ${theaters_count} > 0
    ...    Execute Complete CRUD Flow    ${admin_token}    ${movies_response}    ${theaters_response}
    ...    ELSE
    ...    Log    Não há recursos disponíveis para teste de CRUD completo

*** Keywords ***
Get Future Datetime
    [Arguments]    ${hours}=24
    [Documentation]    Gera uma datetime futura para testes
    ${current_date}=    Get Current Date
    ${future_date}=    Add Time To Date    ${current_date}    ${hours} hours
    ${formatted_date}=    Convert Date    ${future_date}    result_format=%Y-%m-%dT%H:%M:%S.000Z
    [Return]    ${formatted_date}

Create Valid Session
    [Arguments]    ${admin_token}    ${movies_response}    ${theaters_response}
    ${movie_id}=    Set Variable    ${movies_response.json()}[data][0][_id]
    ${theater_id}=    Set Variable    ${theaters_response.json()}[data][0][_id]
    ${future_datetime}=    Get Future Datetime    hours=48
    
    ${response}=    Create Data Session    ${admin_token}    ${movie_id}    ${theater_id}    ${future_datetime}    20    10    expected_status=201
    Should Be Success Response    ${response}    201
    Verify Session Data Structure    ${response.json()}[data]
    Should Be Equal As Strings    ${response.json()}[data][movie]    ${movie_id}
    Should Be Equal As Strings    ${response.json()}[data][theater]    ${theater_id}

Create And Update Data Session
    [Arguments]    ${admin_token}    ${movies_response}    ${theaters_response}
    ${movie_id}=    Set Variable    ${movies_response.json()}[data][0][_id]
    ${theater_id}=    Set Variable    ${theaters_response.json()}[data][0][_id]
    ${future_datetime}=    Get Future Datetime    hours=48
    
    ${create_response}=    Create Data Session    ${admin_token}    ${movie_id}    ${theater_id}    ${future_datetime}    20    10    expected_status=201
    ${session_id}=    Extract Session ID From Response    ${create_response}
    
    ${new_datetime}=    Get Future Datetime    hours=72
    ${response}=    Update Data Session    ${admin_token}    ${session_id}    datetime=${new_datetime}    full_price=25    half_price=12    expected_status=200
    Should Be Success Response    ${response}    200
    Should Be Equal As Numbers    ${response.json()}[data][fullPrice]    25
    Should Be Equal As Numbers    ${response.json()}[data][halfPrice]    12

Create And Update Data Session Partial
    [Arguments]    ${admin_token}    ${movies_response}    ${theaters_response}
    ${movie_id}=    Set Variable    ${movies_response.json()}[data][0][_id]
    ${theater_id}=    Set Variable    ${theaters_response.json()}[data][0][_id]
    ${future_datetime}=    Get Future Datetime    hours=48
    
    ${create_response}=    Create Data Session    ${admin_token}    ${movie_id}    ${theater_id}    ${future_datetime}    20    10    expected_status=201
    ${session_id}=    Extract Session ID From Response    ${create_response}
    
    ${response}=    Update Data Session    ${admin_token}    ${session_id}    full_price=30    expected_status=200
    Should Be Success Response    ${response}    200
    Should Be Equal As Numbers    ${response.json()}[data][fullPrice]    30

Create And Delete Data Session
    [Arguments]    ${admin_token}    ${movies_response}    ${theaters_response}
    ${movie_id}=    Set Variable    ${movies_response.json()}[data][0][_id]
    ${theater_id}=    Set Variable    ${theaters_response.json()}[data][0][_id]
    ${future_datetime}=    Get Future Datetime    hours=48
    
    ${create_response}=    Create Data Session    ${admin_token}    ${movie_id}    ${theater_id}    ${future_datetime}    20    10    expected_status=201
    ${session_id}=    Extract Session ID From Response    ${create_response}
    
    ${response}=    Delete Data Session    ${admin_token}    ${session_id}    expected_status=200
    Should Be Success Response    ${response}    200
    Should Contain    ${response.json()}[message]    deleted
    
    ${verify_response}=    Get Session By ID    ${session_id}    expected_status=404
    Should Be Error Response    ${verify_response}    404

Execute Complete CRUD Flow
    [Arguments]    ${admin_token}    ${movies_response}    ${theaters_response}
    ${movie_id}=    Set Variable    ${movies_response.json()}[data][0][_id]
    ${theater_id}=    Set Variable    ${theaters_response.json()}[data][0][_id]
    ${future_datetime}=    Get Future Datetime    hours=48
    
    # Create
    ${create_response}=    Create Data Session    ${admin_token}    ${movie_id}    ${theater_id}    ${future_datetime}    20    10    expected_status=201
    Should Be Success Response    ${create_response}    201
    ${session_id}=    Extract Session ID From Response    ${create_response}
    
    # Read
    ${get_response}=    Get Session By ID    ${session_id}    expected_status=200
    Should Be Success Response    ${get_response}    200
    
    # Update
    ${update_response}=    Update Data Session    ${admin_token}    ${session_id}    full_price=25    expected_status=200
    Should Be Success Response    ${update_response}    200
    
    # Delete
    ${delete_response}=    Delete Data Session    ${admin_token}    ${session_id}    expected_status=200
    Should Be Success Response    ${delete_response}    200
    
    # Verify deletion
    ${verify_response}=    Get Session By ID    ${session_id}    expected_status=404
    Should Be Error Response    ${verify_response}    404