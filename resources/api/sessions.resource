*** Settings ***
Documentation        Keywords para as sessões dos filmes 

Library        RequestsLibrary
Library        Collections
Library        String

Resource        ../variables.resource
Resource        ../base.resource

*** Keywords ***
Get All Data Sessions
    [Arguments]    ${token}=${None}    ${movie}=${None}    ${theater}=${None}    ${date}=${None}    ${limit}=10    ${page}=1    ${expected_status}=any
    [Documentation]    GET /sessions - Get all movie sessions
    ${headers}=    Run Keyword If    $token is not None    Create Auth Headers    ${token}
    ...    ELSE    Create Dictionary    Content-Type=application/json
    
    ${params}=    Create Dictionary    limit=${limit}    page=${page}
    Run Keyword If    $movie is not None    Set To Dictionary    ${params}    movie=${movie}
    Run Keyword If    $theater is not None    Set To Dictionary    ${params}    theater=${theater}
    Run Keyword If    $date is not None    Set To Dictionary    ${params}    date=${date}
    
    ${response}=    GET On Session    cinema_api    /sessions    headers=${headers}    params=${params}    expected_status=${expected_status}
    [Return]    ${response}

Get Session By ID
    [Arguments]    ${session_id}    ${token}=${None}    ${expected_status}=any
    [Documentation]    GET /sessions/{id} - Get session by ID
    ${headers}=    Run Keyword If    $token is not None    Create Auth Headers    ${token}
    ...    ELSE    Create Dictionary    Content-Type=application/json
    ${response}=    GET On Session    cinema_api    /sessions/${session_id}    headers=${headers}    expected_status=${expected_status}
    [Return]    ${response}

Create Data Session
    [Arguments]    ${token}    ${movie}    ${theater}    ${datetime}    ${full_price}    ${half_price}    ${expected_status}=any
    [Documentation]    POST /sessions - Create new session (admin only)
    ${headers}=    Create Auth Headers    ${token}
    ${body}=    Create Dictionary
    ...    movie=${movie}
    ...    theater=${theater}
    ...    datetime=${datetime}
    ...    fullPrice=${full_price}
    ...    halfPrice=${half_price}
    
    ${response}=    POST On Session    cinema_api    /sessions    json=${body}    headers=${headers}    expected_status=${expected_status}
    [Return]    ${response}

Update Data Session
    [Arguments]    ${token}    ${session_id}    ${movie}=${None}    ${theater}=${None}    ${datetime}=${None}    ${full_price}=${None}    ${half_price}=${None}    ${expected_status}=any
    [Documentation]    PUT /sessions/{id} - Update session (admin only)
    ${headers}=    Create Auth Headers    ${token}
    ${body}=    Create Dictionary
    
    Run Keyword If    $movie is not None    Set To Dictionary    ${body}    movie=${movie}
    Run Keyword If    $theater is not None    Set To Dictionary    ${body}    theater=${theater}
    Run Keyword If    $datetime is not None    Set To Dictionary    ${body}    datetime=${datetime}
    Run Keyword If    $full_price is not None    Set To Dictionary    ${body}    fullPrice=${full_price}
    Run Keyword If    $half_price is not None    Set To Dictionary    ${body}    halfPrice=${half_price}
    
    ${response}=    PUT On Session    cinema_api    /sessions/${session_id}    json=${body}    headers=${headers}    expected_status=${expected_status}
    [Return]    ${response}

Delete Data Session
    [Arguments]    ${token}    ${session_id}    ${expected_status}=any
    [Documentation]    DELETE /sessions/{id} - Delete session (admin only)
    ${headers}=    Create Auth Headers    ${token}
    ${response}=    DELETE On Session    cinema_api    /sessions/${session_id}    headers=${headers}    expected_status=${expected_status}
    [Return]    ${response}

Reset Data Session Seats
    [Arguments]    ${token}    ${session_id}    ${expected_status}=any
    [Documentation]    PUT /sessions/{id}/reset-seats - Reset all seats to available
    ${headers}=    Create Auth Headers    ${token}
    ${response}=    PUT On Session    cinema_api    /sessions/${session_id}/reset-seats    headers=${headers}    expected_status=${expected_status}
    [Return]    ${response}

Extract Session ID From Response
    [Arguments]    ${response}
    [Documentation]    Extract session ID from API response
    ${session_id}=    Set Variable    ${response.json()}[data][_id]
    [Return]    ${session_id}

Verify Session Data Structure
    [Arguments]    ${session_data}
    [Documentation]    Verify that session data has all required fields
    Dictionary Should Contain Key    ${session_data}    _id
    Dictionary Should Contain Key    ${session_data}    movie
    Dictionary Should Contain Key    ${session_data}    theater
    Dictionary Should Contain Key    ${session_data}    datetime
    Dictionary Should Contain Key    ${session_data}    fullPrice
    Dictionary Should Contain Key    ${session_data}    halfPrice
    Dictionary Should Contain Key    ${session_data}    seats
    Dictionary Should Contain Key    ${session_data}    createdAt

Get Current Date
    [Documentation]    Retorna a data e hora atual
    ${current_date}=    Get Time    now
    [Return]    ${current_date}

Add Time To Date
    [Arguments]    ${date}    ${time_to_add}
    [Documentation]    Adiciona um intervalo de tempo à data informada (ex: "24 hours")
    ${new_date}=    Add Time To Date    ${date}    ${time_to_add}
    [Return]    ${new_date}

Convert Date
    [Arguments]    ${date}    ${result_format}=%Y-%m-%dT%H:%M:%S.000Z
    [Documentation]    Converte a data para o formato especificado
    ${formatted}=    Convert Date    ${date}    result_format=${result_format}
    [Return]    ${formatted}

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
    
    ${create_response}=    Create Data Session    ${admin_token}    ${movie_id}    ${theater_id}    ${future_datetime}    20    10    expected_status=201
    Should Be Success Response    ${create_response}    201
    ${session_id}=    Extract Session ID From Response    ${create_response}
    
    ${get_response}=    Get Session By ID    ${session_id}    expected_status=200
    Should Be Success Response    ${get_response}    200
    
    ${update_response}=    Update Data Session    ${admin_token}    ${session_id}    full_price=25    expected_status=200
    Should Be Success Response    ${update_response}    200
    
    ${delete_response}=    Delete Data Session    ${admin_token}    ${session_id}    expected_status=200
    Should Be Success Response    ${delete_response}    200

    ${verify_response}=    Get Session By ID    ${session_id}    expected_status=404
    Should Be Error Response    ${verify_response}    404