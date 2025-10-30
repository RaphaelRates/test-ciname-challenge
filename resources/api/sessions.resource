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