*** Settings ***
Documentation    Arquivo responsável por funcionalidades gerais de todos os testes

Resource         variables.resource

Library    Browser
Library    Screenshot
Library    OperatingSystem
Library    Collections
Library    String
Library    Faker
Library    JSONLibrary

*** Keywords ***

Open Page
    [Arguments]    ${root}=/
    ${url}=    Set Variable    ${URL_FRONT}${root}
    ${status}    ${message}=    Run Keyword And Ignore Error    Get URL
    IF    '${status}' == 'PASS'
        Go To    ${url}
        Log    Página redirecionada para: ${url}
    ELSE
        New Browser    chromium    headless=False
        New Context
        New Page       ${url}
        Log    Nova página aberta: ${url}
    END
    Wait For Elements State    body    visible    timeout=5s

Verify Page Online
    [Arguments]    ${title_expected}
    ${page_title}=    Get Title
    Should Be Equal As Strings    ${page_title}    ${title_expected}

Verify Text In Element
    [Arguments]    ${selector}    ${expected_text}  
    [Documentation]    Verifica se o texto dentro de um elemento CSS corresponde ao esperado
    Wait For Elements State    css=${selector}    visible    timeout=5s
    ${actual_text}=    Get Text    css=${selector}
    Should Be Equal As Strings    ${actual_text.strip()}    ${expected_text.strip()}
    ...    msg=Texto não corresponde no elemento '${selector}'\nEsperado: '${expected_text}'\nEncontrado: '${actual_text}'



Load JSON Fixture
    [Documentation]    Carrega um fixture JSON do arquivo
    [Arguments]    ${fixture_file}    ${fixture_name}=None
    ${file_path}=    Set Variable    ${EXECDIR}${/}resources${/}fixtures${/}${fixture_file}
    ${json_data}=    Get File    ${file_path}    encoding=UTF-8
    ${all_fixtures}=    Evaluate    json.loads('''${json_data}''')    json
    IF    '${fixture_name}' != 'None'
        ${fixture}=    Get From Dictionary    ${all_fixtures}    ${fixture_name}
        RETURN    ${fixture}
    ELSE
        RETURN    ${all_fixtures}
    END

Get Movie Fixture
    [Arguments]    ${fixture_name}
    ${fixture}=    Load JSON Fixture    movies.json    ${fixture_name}
    RETURN    ${fixture}

Get Theater Fixture
    [Arguments]    ${fixture_name}
    ${fixture}=    Load JSON Fixture    theaters.json    ${fixture_name}
    RETURN    ${fixture}

Get Session Fixture
    [Arguments]    ${fixture_name}
    ${fixture}=    Load JSON Fixture    sessions.json    ${fixture_name}
    RETURN    ${fixture}

Get Reservation Fixture
    [Arguments]    ${fixture_name}
    ${fixture}=    Load JSON Fixture    reservation.json    ${fixture_name}
    RETURN    ${fixture}

Get Auth Fixture
    [Arguments]    ${fixture_name}
    ${fixture}=    Load JSON Fixture    auth.json    ${fixture_name}
    RETURN    ${fixture}


Generate Update Profile Fixture
    [Documentation]    Gera dados aleatórios para atualização de perfil
    ${timestamp}=    Get Time    epoch
    ${random_name}=    Catenate    SEPARATOR=_    UpdatedUser    ${timestamp}
    ${random_email}=    Catenate    SEPARATOR=    updated${timestamp}@example.com
    &{update_data}=    Create Dictionary
    ...    name=${random_name}
    ...    email=${random_email}
    RETURN    ${update_data}
 Generate User with Faker
    [Documentation]    Gera dados aleatórios para registro de usuário
    ${random_name}=    Faker Name
    ${random_email}=    Faker Email
    ${random_password}=    Faker Password    length=12    special_chars=True    digits=True    upper_case=True    lower_case=True
    &{user_data}=    Create Dictionary
    ...    name=${random_name}
    ...    email=${random_email}
    ...    password=${random_password}
    RETURN    ${user_data}

Suite Setup
    [Documentation]    Configuração inicial da suite de testes
    New Browser    ${BROWSER}    headless=${HEADLESS}
    New Context    viewport={'width': 1920, 'height': 1080}

Setup Browser
    New Browser    chromium    headless=False
    New Context
    New Page    ${URL_FRONT}/

Teardown Browser
    Close Page
    Close Context
    Close Browser

Suite Teardown
    [Documentation]    Finalização da suite de testes
    Close Browser

Test Setup
    [Documentation]    Configuração inicial de cada teste
    New Page    about:blank

Test Teardown
    [Documentation]    Finalização de cada teste
    Run Keyword If Test Failed    Take Screenshot    fullPage=True
    Close Page

Gerar Senha Aleatória
    ${random_senha}=    Generate Random String    12    [LETTERS][NUMBERS]
    [Return]    ${random_senha}

Verificar Página Registro Carregou
    Get Url    contains    /register
    Get Element States    css=.register-form    contains    visible