*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource   ../variables.resource

*** Keywords ***
Create API Session
    [Documentation]    Cria a sessão de RequestsLibrary.
    Create Session    cinema_api    ${URL_API}    verify=True

Set Admin Token
    [Arguments]    ${token}
    Set Suite Variable    ${ADMIN_TOKEN}    ${token}

Set User Token
    [Arguments]    ${token}
    Set Suite Variable    ${USER_TOKEN}    ${token}

Perform Valid Login
    [Arguments]    ${email}    ${password}
    [Documentation]    Realiza login e retorna o token JWT.
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${body}=    Create Dictionary    email=${email}    password=${password}
    ${response}=    POST On Session    cinema_api    /auth/login    json=${body}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Equal As Strings    ${response.json()}[success]    True
    ${token}=    Set Variable    ${response.json()}[data][token]
    [Return]    ${token}

# NOVA PALAVRA-CHAVE DE SETUP
Register And Perform Login
    [Arguments]    ${email}    ${password}    ${name}=New Test User    ${role}=user  # <-- ADICIONE O ARGUMENTO ${role}
    [Documentation]    Registra um novo usuário e faz login imediatamente.
    
    # 1. Registro (Endpoint POST /auth/register)
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${body}=    Create Dictionary    email=${email}    password=${password}    name=${name}    role=${role} # <-- INCLUA ROLE NO BODY
    ${response}=    POST On Session    cinema_api    /auth/register    json=${body}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    201
    
    # 2. Login (Endpoint POST /auth/login)
    ${token}=    Perform Valid Login    ${email}    ${password}
    [Return]    ${token}

Setup Authentication Tokens
    [Documentation]    Registra/loga novos usuários Admin e User para garantir tokens válidos.
    
    # GERA E-MAIL ÚNICO PARA O NOVO USUÁRIO ADMIN E COMUM
    ${timestamp}=    Get Time    epoch
    ${admin_email}=    Catenate    SEPARATOR=    robot_admin_${timestamp}@example.com
    ${user_email}=    Catenate    SEPARATOR=    robot_user_${timestamp}@example.com

    # 1. REGISTRA E LOGA NOVO ADMIN (SENHA: ADMIN123, ROLE: ADMIN)
    # Role deve ser enviada como "admin" para o endpoint de registro, ou o back-end deve ter uma rota específica para isso.
    # Assumindo que o Admin precisa de role="admin" no corpo, mas usando o registro que já funciona.
    
    # ATENÇÃO: Se o registro ADMIN não for por role=admin, isso precisa ser ajustado.
    # Vamos criar o Admin usando as credenciais e torcer para o Back-end aceitar a role.
    ${admin_token}=    Register And Perform Login    ${admin_email}    ${ADMIN_PASSWORD}    Robot Admin    admin
    Set Suite Variable    ${ADMIN_TOKEN}    ${admin_token}
    Log To Console    Admin Token obtido.

    # 2. REGISTRA E LOGA NOVO USUÁRIO (USER_TOKEN)
    ${user_token}=    Register And Perform Login    ${user_email}    ${NEW_USER_PASSWORD}    Robot User
    Set Suite Variable    ${USER_TOKEN}    ${user_token}
    Log To Console    User Token obtido.

*** Keywords ***
Verify User Profile Access
    [Arguments]    ${token}    ${expected_email}
    [Documentation]    Verifica se o acesso ao perfil retorna dados corretos
    ${headers}=    Create Dictionary    
    ...    Content-Type=application/json    
    ...    Authorization=Bearer ${token}
    
    ${response}=    GET On Session    cinema_api    /auth/me    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Equal As Strings    ${response.json()}[data][email]    ${expected_email}
    [Return]    ${response}

Attempt Login With Invalid Credentials
    [Arguments]    ${email}    ${password}
    [Documentation]    Tenta login e verifica que falha
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${body}=    Create Dictionary    email=${email}    password=${password}
    ${response}=    POST On Session    cinema_api    /auth/login    json=${body}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    400
    Should Be Equal As Strings    ${response.json()}[success]    False
    [Return]    ${response}

Update User Name
    [Arguments]    ${token}    ${new_name}
    [Documentation]    Atualiza o nome do usuário
    ${headers}=    Create Dictionary    
    ...    Content-Type=application/json    
    ...    Authorization=Bearer ${token}
    
    ${body}=    Create Dictionary    name=${new_name}
    ${response}=    PUT On Session    cinema_api    /auth/profile    json=${body}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    [Return]    ${response}