*** Settings ***
Documentation        Keywords para as reservas dos filmes 

Library        RequestsLibrary
Library        Collections
Library        String

Resource        ../variables.resource
Resource        ../base.resource

*** Keywords ***
Get My Reservations
    [Arguments]    ${token}    ${expected_status}=any
    [Documentation]    GET /reservations/me - Get all reservations for current user
    ${headers}=    Create Auth Headers    ${token}
    ${response}=    GET On Session    cinema_api    /reservations/me    headers=${headers}    expected_status=${expected_status}
    [Return]    ${response}

Get All Reservations
    [Arguments]    ${token}    ${page}=1    ${limit}=10    ${expected_status}=any
    [Documentation]    GET /reservations - Get all reservations (admin only)
    ${headers}=    Create Auth Headers    ${token}
    ${params}=    Create Dictionary    page=${page}    limit=${limit}
    ${response}=    GET On Session    cinema_api    /reservations    headers=${headers}    params=${params}    expected_status=${expected_status}
    [Return]    ${response}

Get Reservation By ID
    [Arguments]    ${token}    ${reservation_id}    ${expected_status}=any
    [Documentation]    GET /reservations/{id} - Get reservation by ID
    ${headers}=    Create Auth Headers    ${token}
    ${response}=    GET On Session    cinema_api    /reservations/${reservation_id}    headers=${headers}    expected_status=${expected_status}
    [Return]    ${response}

Create Reservation
    [Arguments]    ${token}    ${session_id}    ${seats}    ${payment_method}=credit_card    ${expected_status}=any
    [Documentation]    POST /reservations - Create new reservation
    ${headers}=    Create Auth Headers    ${token}
    ${body}=    Create Dictionary
    ...    session=${session_id}
    ...    seats=${seats}
    ...    paymentMethod=${payment_method}
    ${response}=    POST On Session    cinema_api    /reservations    json=${body}    headers=${headers}    expected_status=${expected_status}
    [Return]    ${response}

Update Reservation
    [Arguments]    ${token}    ${reservation_id}    ${status}=${None}    ${payment_status}=${None}    ${expected_status}=any
    [Documentation]    PUT /reservations/{id} - Update reservation status (admin only)
    ${headers}=    Create Auth Headers    ${token}
    ${body}=    Create Dictionary
    Run Keyword If    $status is not None    Set To Dictionary    ${body}    status=${status}
    Run Keyword If    $payment_status is not None    Set To Dictionary    ${body}    paymentStatus=${payment_status}
    ${response}=    PUT On Session    cinema_api    /reservations/${reservation_id}    json=${body}    headers=${headers}    expected_status=${expected_status}
    [Return]    ${response}

Delete Reservation
    [Arguments]    ${token}    ${reservation_id}    ${expected_status}=any
    [Documentation]    DELETE /reservations/{id} - Delete reservation (admin only)
    ${headers}=    Create Auth Headers    ${token}
    ${response}=    DELETE On Session    cinema_api    /reservations/${reservation_id}    headers=${headers}    expected_status=${expected_status}
    [Return]    ${response}

Create Sample Seat
    [Arguments]    ${row}=C    ${number}=5    ${type}=full
    [Documentation]    Create a sample seat object
    ${seat}=    Create Dictionary
    ...    row=${row}
    ...    number=${number}
    ...    type=${type}
    [Return]    ${seat}

Create Sample Seats
    [Arguments]    ${count}=2
    [Documentation]    Create a list of sample seats
    ${seats}=    Create List
    FOR    ${index}    IN RANGE    ${count}
        ${seat_number}=    Evaluate    ${index} + 1
        ${seat}=    Create Sample Seat    number=${seat_number}
        Append To List    ${seats}    ${seat}
    END
    [Return]    ${seats}

Extract Reservation ID From Response
    [Arguments]    ${response}
    [Documentation]    Extract reservation ID from API response
    ${reservation_id}=    Set Variable    ${response.json()}[data][_id]
    [Return]    ${reservation_id}

Verify Reservation Data Structure
    [Arguments]    ${reservation_data}
    [Documentation]    Verify that reservation data has all required fields
    Dictionary Should Contain Key    ${reservation_data}    _id
    Dictionary Should Contain Key    ${reservation_data}    user
    Dictionary Should Contain Key    ${reservation_data}    session
    Dictionary Should Contain Key    ${reservation_data}    seats
    Dictionary Should Contain Key    ${reservation_data}    totalPrice
    Dictionary Should Contain Key    ${reservation_data}    status
    Dictionary Should Contain Key    ${reservation_data}    paymentStatus
    Dictionary Should Contain Key    ${reservation_data}    paymentMethod
    Dictionary Should Contain Key    ${reservation_data}    paymentDate
    Dictionary Should Contain Key    ${reservation_data}    createdAt

Create And Verify Reservation
    [Arguments]    ${user_token}    ${session_id}    ${seats_count}=2    ${payment_method}=credit_card    ${expected_status}=201
    [Documentation]    Create a reservation and verify it was created successfully
    ${seats}=    Create Sample Seats    ${seats_count}
    ${response}=    Create Reservation    ${user_token}    ${session_id}    ${seats}    ${payment_method}    ${expected_status}
    
    Run Keyword If    ${expected_status} == 201
    ...    Run Keywords
    ...    Should Be Success Response    ${response}    201
    ...    AND    Verify Reservation Data Structure    ${response.json()}[data]
    ...    AND    Should Be Equal As Strings    ${response.json()}[data][session]    ${session_id}
    
    [Return]    ${response}

Create And Get Reservation By ID
    [Arguments]    ${user_token}    ${session_id}
    [Documentation]    Create a reservation and then get it by ID
    ${create_response}=    Create And Verify Reservation    ${user_token}    ${session_id}
    ${reservation_id}=    Extract Reservation ID From Response    ${create_response}
    
    ${get_response}=    Get Reservation By ID    ${user_token}    ${reservation_id}    expected_status=200
    Should Be Success Response    ${get_response}    200
    Should Be Equal As Strings    ${get_response.json()}[data][_id]    ${reservation_id}
    
    [Return]    ${reservation_id}

Create And Update Reservation Status
    [Arguments]    ${admin_token}    ${user_token}    ${session_id}    ${new_status}=confirmed
    [Documentation]    Create a reservation and update its status
    ${create_response}=    Create And Verify Reservation    ${user_token}    ${session_id}
    ${reservation_id}=    Extract Reservation ID From Response    ${create_response}
    
    ${update_response}=    Update Reservation    ${admin_token}    ${reservation_id}    status=${new_status}    expected_status=200
    Should Be Success Response    ${update_response}    200
    Should Be Equal As Strings    ${update_response.json()}[data][status]    ${new_status}
    
    [Return]    ${reservation_id}

Create And Update Payment Status
    [Arguments]    ${admin_token}    ${user_token}    ${session_id}    ${new_payment_status}=paid
    [Documentation]    Create a reservation and update its payment status
    ${create_response}=    Create And Verify Reservation    ${user_token}    ${session_id}
    ${reservation_id}=    Extract Reservation ID From Response    ${create_response}
    
    ${update_response}=    Update Reservation    ${admin_token}    ${reservation_id}    payment_status=${new_payment_status}    expected_status=200
    Should Be Success Response    ${update_response}    200
    Should Be Equal As Strings    ${update_response.json()}[data][paymentStatus]    ${new_payment_status}
    
    [Return]    ${reservation_id}

Create And Delete Reservation
    [Arguments]    ${admin_token}    ${user_token}    ${session_id}
    [Documentation]    Create a reservation and then delete it
    ${create_response}=    Create And Verify Reservation    ${user_token}    ${session_id}
    ${reservation_id}=    Extract Reservation ID From Response    ${create_response}
    
    ${delete_response}=    Delete Reservation    ${admin_token}    ${reservation_id}    expected_status=200
    Should Be Success Response    ${delete_response}    200
    Should Contain    ${delete_response.json()}[message]    deleted
    
    # Verify reservation is deleted
    ${verify_response}=    Get Reservation By ID    ${user_token}    ${reservation_id}    expected_status=404
    Should Be Error Response    ${verify_response}    404
    
    [Return]    ${reservation_id}

Get Available Session For Reservation
    [Arguments]    ${token}=${None}
    [Documentation]    Get an available session for reservation tests
    ${sessions_response}=    Get All Sessions    token=${token}    expected_status=200
    Should Be Success Response    ${sessions_response}    200
    ${sessions_count}=    Get Length    ${sessions_response.json()}[data]
    
    Should Be True    ${sessions_count} > 0    Não há sessões disponíveis para teste de reserva
    ${session_id}=    Set Variable    ${sessions_response.json()}[data][0][_id]
    
    [Return]    ${session_id}