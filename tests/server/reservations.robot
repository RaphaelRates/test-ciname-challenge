# *** Settings ***
# Documentation     Testes das Reservas de filmes

# Library        RequestsLibrary
# Library        Collections
# Library        String

# Resource        ../../resources/api/reservations.resource
# Resource        ../../resources/variables.resource
# Resource        ../../resources/base.resource


# Suite Setup    Setup API Session
# Suite Teardown    Teardown API Session

# Test Setup    Log    Starting test: ${TEST_NAME}
# Test Teardown    Log    Finished test: ${TEST_NAME}

# *** Test Cases ***
# TC029 - Get My Reservations As User
#     [Documentation]    Obter reservas do usuário autenticado
#     [Tags]    reservations    read    user
#     ${token}=    Get User Token
#     Sleep    0.5s
#     ${response}=    Get My Reservations    ${token}
#     Should Be Success Response    ${response}    200
#     Dictionary Should Contain Key    ${response.json()}    data
#     Dictionary Should Contain Key    ${response.json()}    count
#     Log    Número de reservas do usuário: ${response.json()}[count]

# TC030 - Create Reservation As User
#     [Documentation]    Criar nova reserva como usuário
#     [Tags]    reservations    create    user
#     ${token}=    Get User Token
#     Sleep    0.5s
    
#     # Precisamos de uma sessão válida para criar reserva
#     ${sessions_response}=    Get All Sessions    ${token}
#     Sleep    0.5s
#     Run Keyword If    len($sessions_response.json()['data']) > 0
#     ...    Run Keywords
#     ...    ${session_id}=    Set Variable    ${sessions_response.json()}[data][0][_id]
#     ...    AND    ${seats}=    Create Sample Seats    2
#     ...    AND    Sleep    0.5s
#     ...    AND    ${response}=    Create Reservation    ${token}    ${session_id}    ${seats}
#     ...    AND    Should Be Success Response    ${response}    201
#     ...    AND    Verify Reservation Data Structure    ${response.json()}[data]
#     ...    ELSE
#     ...    Log    Não há sessões disponíveis para criar reserva

# TC031 - Create Reservation With Invalid Session
#     [Documentation]    Tentativa de criar reserva com sessão inválida
#     [Tags]    reservations    create    error
#     ${token}=    Get User Token
#     Sleep    0.5s
#     ${seats}=    Create Sample Seats    1
#     Sleep    0.5s
#     ${response}=    Create Reservation    ${token}    invalid_session_id    ${seats}    expected_status=404
#     Should Be Error Response    ${response}    404

# TC032 - Get Reservation By ID As Owner
#     [Documentation]    Buscar reserva por ID sendo o proprietário
#     [Tags]    reservations    read    user
#     ${token}=    Get User Token
#     Sleep    0.5s
    
#     # Primeiro cria uma reserva para testar
#     ${sessions_response}=    Get All Sessions    ${token}
#     Sleep    0.5s
#     Run Keyword If    len($sessions_response.json()['data']) > 0
#     ...    Run Keywords
#     ...    ${session_id}=    Set Variable    ${sessions_response.json()}[data][0][_id]
#     ...    AND    ${seats}=    Create Sample Seats    1
#     ...    AND    Sleep    0.5s
#     ...    AND    ${create_response}=    Create Reservation    ${token}    ${session_id}    ${seats}
#     ...    AND    ${reservation_id}=    Extract Reservation ID From Response    ${create_response}
#     ...    AND    Sleep    0.5s
#     ...    AND    ${response}=    Get Reservation By ID    ${token}    ${reservation_id}
#     ...    AND    Should Be Success Response    ${response}    200
#     ...    AND    Should Be Equal As Strings    ${response.json()}[data][_id]    ${reservation_id}
#     ...    ELSE
#     ...    Log    Não foi possível criar reserva para teste

# TC033 - Get All Reservations As Admin
#     [Documentation]    Listar todas as reservas como administrador
#     [Tags]    reservations    read    admin
#     ${token}=    Get Admin Token
#     Sleep    0.5s
#     ${response}=    Get All Reservations    ${token}    page=1    limit=5
#     Should Be Success Response    ${response}    200
#     Dictionary Should Contain Key    ${response.json()}    data
#     Dictionary Should Contain Key    ${response.json()}    count
#     Log    Total de reservas no sistema: ${response.json()}[count]

# TC034 - Get All Reservations With Pagination
#     [Documentation]    Listar reservas com paginação
#     [Tags]    reservations    read    admin    pagination
#     ${token}=    Get Admin Token
#     Sleep    0.5s
#     ${response}=    Get All Reservations    ${token}    page=1    limit=3
#     Should Be Success Response    ${response}    200
    
#     # Verifica estrutura de paginação se existir
#     Run Keyword And Ignore Error
#     ...    Run Keyword If    'pagination' in $response.json()
#     ...    Log    Paginação: ${response.json()}[pagination]

# TC035 - Update Reservation Status As Admin
#     [Documentation]    Atualizar status da reserva como administrador
#     [Tags]    reservations    update    admin
#     ${admin_token}=    Get Admin Token
#     Sleep    0.5s
#     ${user_token}=    Get User Token
#     Sleep    0.5s
    
#     # Cria uma reserva como usuário
#     ${sessions_response}=    Get All Sessions    ${user_token}
#     Sleep    0.5s
#     Run Keyword If    len($sessions_response.json()['data']) > 0
#     ...    Run Keywords
#     ...    ${session_id}=    Set Variable    ${sessions_response.json()}[data][0][_id]
#     ...    AND    ${seats}=    Create Sample Seats    1
#     ...    AND    Sleep    0.5s
#     ...    AND    ${create_response}=    Create Reservation    ${user_token}    ${session_id}    ${seats}
#     ...    AND    ${reservation_id}=    Extract Reservation ID From Response    ${create_response}
#     ...    AND    Sleep    0.5s
#     ...    AND    ${response}=    Update Reservation    ${admin_token}    ${reservation_id}    status=cancelled
#     ...    AND    Should Be Success Response    ${response}    200
#     ...    AND    Should Be Equal As Strings    ${response.json()}[data][status]    cancelled
#     ...    ELSE
#     ...    Log    Não foi possível criar reserva para teste de atualização

# TC036 - Update Reservation Payment Status As Admin
#     [Documentation]    Atualizar status de pagamento como administrador
#     [Tags]    reservations    update    admin
#     ${admin_token}=    Get Admin Token
#     Sleep    0.5s
#     ${user_token}=    Get User Token
#     Sleep    0.5s
    
#     ${sessions_response}=    Get All Sessions    ${user_token}
#     Sleep    0.5s
#     Run Keyword If    len($sessions_response.json()['data']) > 0
#     ...    Run Keywords
#     ...    ${session_id}=    Set Variable    ${sessions_response.json()}[data][0][_id]
#     ...    AND    ${seats}=    Create Sample Seats    1
#     ...    AND    Sleep    0.5s
#     ...    AND    ${create_response}=    Create Reservation    ${user_token}    ${session_id}    ${seats}
#     ...    AND    ${reservation_id}=    Extract Reservation ID From Response    ${create_response}
#     ...    AND    Sleep    0.5s
#     ...    AND    ${response}=    Update Reservation    ${admin_token}    ${reservation_id}    payment_status=refunded
#     ...    AND    Should Be Success Response    ${response}    200
#     ...    AND    Should Be Equal As Strings    ${response.json()}[data][paymentStatus]    refunded
#     ...    ELSE
#     ...    Log    Não foi possível criar reserva para teste de pagamento

# TC037 - Delete Reservation As Admin
#     [Documentation]    Deletar reserva como administrador
#     [Tags]    reservations    delete    admin
#     ${admin_token}=    Get Admin Token
#     Sleep    0.5s
#     ${user_token}=    Get User Token
#     Sleep    0.5s
    
#     ${sessions_response}=    Get All Sessions    ${user_token}
#     Sleep    0.5s
#     Run Keyword If    len($sessions_response.json()['data']) > 0
#     ...    Run Keywords
#     ...    ${session_id}=    Set Variable    ${sessions_response.json()}[data][0][_id]
#     ...    AND    ${seats}=    Create Sample Seats    1
#     ...    AND    Sleep    0.5s
#     ...    AND    ${create_response}=    Create Reservation    ${user_token}    ${session_id}    ${seats}
#     ...    AND    ${reservation_id}=    Extract Reservation ID From Response    ${create_response}
#     ...    AND    Sleep    0.5s
#     ...    AND    ${response}=    Delete Reservation    ${admin_token}    ${reservation_id}
#     ...    AND    Should Be Success Response    ${response}    200
#     ...    AND    Should Be Equal As Strings    ${response.json()}[message]    Reservation deleted successfully
#     ...    ELSE
#     ...    Log    Não foi possível criar reserva para teste de deleção

# TC038 - Get All Reservations Without Admin Rights
#     [Documentation]    Tentativa de listar todas as reservas sem ser admin
#     [Tags]    reservations    read    security
#     ${token}=    Get User Token
#     Sleep    0.5s
#     ${response}=    Get All Reservations    ${token}    expected_status=403
#     Should Be Error Response    ${response}    403

# TC039 - Update Reservation Without Admin Rights
#     [Documentation]    Tentativa de atualizar reserva sem ser admin
#     [Tags]    reservations    update    security
#     ${user_token}=    Get User Token
#     Sleep    0.5s
    
#     # Tenta atualizar uma reserva que não existe (mas o importante é testar a autorização)
#     ${response}=    Update Reservation    ${user_token}    60d0fe4f5311236168a109ce    status=cancelled    expected_status=403
#     Should Be Error Response    ${response}    403

# TC040 - Delete Reservation Without Admin Rights
#     [Documentation]    Tentativa de deletar reserva sem ser admin
#     [Tags]    reservations    delete    security
#     ${user_token}=    Get User Token
#     Sleep    0.5s
#     ${response}=    Delete Reservation    ${user_token}    60d0fe4f5311236168a109ce    expected_status=403
#     Should Be Error Response    ${response}    403

# TC041 - Create Reservation With Different Payment Methods
#     [Documentation]    Criar reservas com diferentes métodos de pagamento
#     [Tags]    reservations    create    user
#     ${token}=    Get User Token
#     Sleep    0.5s
    
#     ${sessions_response}=    Get All Sessions    ${token}
#     Sleep    0.5s
#     Run Keyword If    len($sessions_response.json()['data']) > 0
#     ...    Run Keywords
#     ...    ${session_id}=    Set Variable    ${sessions_response.json()}[data][0][_id]
#     ...    AND    ${seats}=    Create Sample Seats    1
#     ...    AND    @{payment_methods}=    Create List    credit_card    debit_card    pix    cash
#     ...    AND    FOR    ${method}    IN    @{payment_methods}
#     ...        Sleep    0.5s
#     ...        ${response}=    Create Reservation    ${token}    ${session_id}    ${seats}    payment_method=${method}
#     ...        Run Keyword If    ${response.status_code} == 201
#     ...        Should Be Equal As Strings    ${response.json()}[data][paymentMethod]    ${method}
#     ...        ...    ELSE
#     ...        Log    Método ${method} não suportado: ${response.json()}
#     ...    ELSE
#     ...    Log    Não há sessões para testar métodos de pagamento