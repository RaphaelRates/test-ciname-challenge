*** Settings ***
Library    Collections
Library    RequestsLibrary
Library    String

Resource    ../variables.resource
Resource    ../base.resource

*** Variables ***
${ADMIN_TOKEN}    Bearer your_admin_token_here

*** Keywords ***
Get All Sessions
    [Arguments]    ${params}=${None}
    ${response}=    GET    ${URL_API}/sessions    params=${params}
    RETURN    ${response}

Get Session By ID
    [Arguments]    ${session_id}
    ${response}=    GET    ${URL_API}/sessions/${session_id}
    RETURN    ${response}

Create Session
    [Arguments]    ${session_data}    ${auth_token}=${ADMIN_TOKEN}
    ${headers}=    Create Dictionary    Authorization=${auth_token}    Content-Type=application/json
    ${response}=    POST    ${URL_API}/sessions    json=${session_data}    headers=${headers}
    RETURN    ${response}

Update Session
    [Arguments]    ${session_id}    ${update_data}    ${auth_token}=${ADMIN_TOKEN}
    ${headers}=    Create Dictionary    Authorization=${auth_token}    Content-Type=application/json
    ${response}=    PUT    ${URL_API}/sessions/${session_id}    json=${update_data}    headers=${headers}
    RETURN    ${response}

Delete Session
    [Arguments]    ${session_id}    ${auth_token}=${ADMIN_TOKEN}
    ${headers}=    Create Dictionary    Authorization=${auth_token}
    ${response}=    DELETE    ${URL_API}/sessions/${session_id}    headers=${headers}
    RETURN    ${response}

Reset Session Seats
    [Arguments]    ${session_id}    ${auth_token}=${ADMIN_TOKEN}
    ${headers}=    Create Dictionary    Authorization=${auth_token}
    ${response}=    PUT    ${URL_API}/sessions/${session_id}/reset-seats    headers=${headers}
    RETURN    ${response}

Verify Session Response Structure
    [Arguments]    ${response}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Evaluate    json.loads('''${response.text}''')    json
    Dictionary Should Contain Key    ${json}    success
    Dictionary Should Contain Key    ${json}    data
    Should Be True    ${json}[success]

Verify Session List Structure
    [Arguments]    ${response}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    Evaluate    json.loads('''${response.text}''')    json
    Dictionary Should Contain Key    ${json}    success
    Dictionary Should Contain Key    ${json}    data
    Dictionary Should Contain Key    ${json}    count
    Dictionary Should Contain Key    ${json}    pagination
    Should Be True    ${json}[success]

Create Valid Session Data
    ${movie_id}=    Set Variable    60d0fe4f5311236168a109cb
    ${theater_id}=    Set Variable    60d0fe4f5311236168a109cc
    ${datetime}=    Get Current Date    result_format=%Y-%m-%dT%H:%M:%S.000Z    increment=1 day
    ${session_data}=    Create Dictionary
    ...    movie=${movie_id}
    ...    theater=${theater_id}
    ...    datetime=${datetime}
    ...    fullPrice=20
    ...    halfPrice=10
    RETURN    ${session_data}

Verify Error Response
    [Arguments]    ${response}    ${expected_status}
    Should Be Equal As Strings    ${response.status_code}    ${expected_status}
    ${json}=    Evaluate    json.loads('''${response.text}''')    json
    Dictionary Should Contain Key    ${json}    success
    Should Be Equal    ${json}[success]    ${False}

Session Should Have Available Seats
    [Arguments]    ${session_response}
    ${json}=    Evaluate    json.loads('''${session_response.text}''')    json
    ${seats}=    Set Variable    ${json}[data][seats]
    ${available_seats}=    Evaluate    [seat for seat in ${seats} if seat['status'] == 'available']
    Length Should Be Greater Than    ${available_seats}    0