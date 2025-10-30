
concerte os de reservatin

Analisando os testes de reservations, identifico vários problemas:

Problemas Encontrados:
Falta de expected_status em várias chamadas - Causará falhas quando houver erros
Estrutura Run Keyword If com Run Keywords - Sintaxe incorreta e complexa demais
Uso incorreto de Sleep e tratamento de erros
TC041 com sintaxe de FOR loop incorreta
Falta do keyword Get All Sessions em auth.resource
Vou corrigir o arquivo:

reservations.robot (Corrigido)
Código 
Agora vou corrigir o arquivo de resources para adicionar expected_status e melhorar a estrutura:

reservations.resource (Corrigido)
Código 







*** Settings ***
Documentation     Testes das Reservas de filmes

Library        RequestsLibrary
Library        Collections
Library        String

Resource        ../../resources/api/reservations.resource
Resource        ../../resources/api/sessions.resource
Resource        ../../resources/api/auth.resource
Resource        ../../resources/variables.resource
Resource        ../../resources/base.resource

Suite Setup    Setup API Session
Suite Teardown    Teardown API Session

Test Setup    Log    Starting test: ${TEST_NAME}
Test Teardown    Log    Finished test: ${TEST_NAME}

*** Test Cases ***
TC029 - Get My Reservations As User
    [Documentation]    Obter reservas do usuário autenticado
    [Tags]    reservations    read    user
    ${token}=    Get User Token
    ${response}=    Get My Reservations    ${token}    expected_status=200
    Should Be Success Response    ${response}    200
    Dictionary Should Contain Key    ${response.json()}    data
    Dictionary Should Contain Key    ${response.json()}    count
    Log    Número de reservas do usuário: ${response.json()}[count]

TC030 - Create Reservation As User
    [Documentation]    Criar nova reserva como usuário
    [Tags]    reservations    create    user
    ${token}=    Get User Token
    
    # Obtém uma sessão válida para criar reserva
    ${sessions_response}=    Get All Sessions    expected_status=200
    ${sessions_count}=    Get Length    ${sessions_response.json()}[data]
    
    Run Keyword If    ${sessions_count} > 0
    ...    Create And Verify Reservation    ${token}    ${sessions_response}
    ...    ELSE
    ...    Log    Não há sessões disponíveis para criar reserva

TC031 - Create Reservation With Invalid Session
    [Documentation]    Tentativa de criar reserva com sessão inválida
    [Tags]    reservations    create    error
    ${token}=    Get User Token
    ${seats}=    Create Sample Seats    1
    ${response}=    Create Reservation    ${token}    invalid_session_id    ${seats}    expected_status=400
    Should Be Error Response    ${response}    400

TC032 - Get Reservation By ID As Owner
    [Documentation]    Buscar reserva por ID sendo o proprietário
    [Tags]    reservations    read    user
    ${token}=    Get User Token
    
    # Primeiro cria uma reserva para testar
    ${sessions_response}=    Get All Sessions    expected_status=200
    ${sessions_count}=    Get Length    ${sessions_response.json()}[data]
    
    Run Keyword If    ${sessions_count} > 0
    ...    Create And Get Reservation By ID    ${token}    ${sessions_response}
    ...    ELSE
    ...    Log    Não foi possível criar reserva para teste

TC033 - Get All Reservations As Admin
    [Documentation]    Listar todas as reservas como administrador
    [Tags]    reservations    read    admin
    ${token}=    Get Admin Token
    ${response}=    Get All Reservations    ${token}    page=1    limit=5    expected_status=200
    Should Be Success Response    ${response}    200
    Dictionary Should Contain Key    ${response.json()}    data
    Dictionary Should Contain Key    ${response.json()}    count
    Log    Total de reservas no sistema: ${response.json()}[count]

TC034 - Get All Reservations With Pagination
    [Documentation]    Listar reservas com paginação
    [Tags]    reservations    read    admin    pagination
    ${token}=    Get Admin Token
    ${response}=    Get All Reservations    ${token}    page=1    limit=3    expected_status=200
    Should Be Success Response    ${response}    200
    
    # Verifica estrutura de paginação se existir
    ${has_pagination}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${response.json()}    pagination
    Run Keyword If    ${has_pagination}    Log    Paginação: ${response.json()}[pagination]

TC035 - Update Reservation Status As Admin
    [Documentation]    Atualizar status da reserva como administrador
    [Tags]    reservations    update    admin
    ${admin_token}=    Get Admin Token
    ${user_token}=    Get User Token
    
    # Cria uma reserva como usuário
    ${sessions_response}=    Get All Sessions    expected_status=200
    ${sessions_count}=    Get Length    ${sessions_response.json()}[data]
    
    Run Keyword If    ${sessions_count} > 0
    ...    Create And Update Reservation Status    ${admin_token}    ${user_token}    ${sessions_response}
    ...    ELSE
    ...    Log    Não foi possível criar reserva para teste de atualização

TC036 - Update Reservation Payment Status As Admin
    [Documentation]    Atualizar status de pagamento como administrador
    [Tags]    reservations    update    admin
    ${admin_token}=    Get Admin Token
    ${user_token}=    Get User Token
    
    ${sessions_response}=    Get All Sessions    expected_status=200
    ${sessions_count}=    Get Length    ${sessions_response.json()}[data]
    
    Run Keyword If    ${sessions_count} > 0
    ...    Create And Update Payment Status    ${admin_token}    ${user_token}    ${sessions_response}
    ...    ELSE
    ...    Log    Não foi possível criar reserva para teste de pagamento

TC037 - Delete Reservation As Admin
    [Documentation]    Deletar reserva como administrador
    [Tags]    reservations    delete    admin
    ${admin_token}=    Get Admin Token
    ${user_token}=    Get User Token
    
    ${sessions_response}=    Get All Sessions    expected_status=200
    ${sessions_count}=    Get Length    ${sessions_response.json()}[data]
    
    Run Keyword If    ${sessions_count} > 0
    ...    Create And Delete Reservation    ${admin_token}    ${user_token}    ${sessions_response}
    ...    ELSE
    ...    Log    Não foi possível criar reserva para teste de deleção

TC038 - Get All Reservations Without Admin Rights
    [Documentation]    Tentativa de listar todas as reservas sem ser admin
    [Tags]    reservations    read    security
    ${token}=    Get User Token
    ${response}=    Get All Reservations    ${token}    expected_status=403
    Should Be Error Response    ${response}    403

TC039 - Update Reservation Without Admin Rights
    [Documentation]    Tentativa de atualizar reserva sem ser admin
    [Tags]    reservations    update    security
    ${user_token}=    Get User Token
    ${response}=    Update Reservation    ${user_token}    60d0fe4f5311236168a109ce    status=cancelled    expected_status=403
    Should Be Error Response    ${response}    403

TC040 - Delete Reservation Without Admin Rights
    [Documentation]    Tentativa de deletar reserva sem ser admin
    [Tags]    reservations    delete    security
    ${user_token}=    Get User Token
    ${response}=    Delete Reservation    ${user_token}    60d0fe4f5311236168a109ce    expected_status=403
    Should Be Error Response    ${response}    403

TC041 - Create Reservation With Different Payment Methods
    [Documentation]    Criar reservas com diferentes métodos de pagamento
    [Tags]    reservations    create    user
    ${token}=    Get User Token
    
    ${sessions_response}=    Get All Sessions    expected_status=200
    ${sessions_count}=    Get Length    ${sessions_response.json()}[data]
    
    Run Keyword If    ${sessions_count} > 0
    ...    Test Different Payment Methods    ${token}    ${sessions_response}
    ...    ELSE
    ...    Log    Não há sessões para testar métodos de pagamento