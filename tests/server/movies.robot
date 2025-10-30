*** Settings ***
Documentation       Teste das rotas do filmes

Library    RequestsLibrary
Library    String
Library    Collections

Resource     ../../resources/variables.resource
Resource     ../../resources/base.resource
Resource     ../../resources/api/movies.resource
Resource     ../../resources/api/auth.resource

Suite Setup    Setup API Session
Suite Teardown    Teardown API Session

Test Setup    Log    Starting test: ${TEST_NAME}
Test Teardown    Log    Finished test: ${TEST_NAME}

*** Test Cases ***
TC007 - Get All Movies With Public Access
    [Documentation]    Listar todos os filmes com acesso público
    [Tags]    movies    read    public
    ${response}=    Get All Movies
    Should Be Success Response    ${response}    200
    Dictionary Should Contain Key    ${response.json()}    data
    Should Not Be Empty    ${response.json()}[data]

TC008 - Get Movies With Title Filter
    [Documentation]    Filtrar filmes por título
    [Tags]    movies    read    filter
    ${response}=    Get All Movies
    ${first_movie_title}=    Set Variable    ${response.json()}[data][0][title]
    ${filter_response}=    Get All Movies    title=${first_movie_title}
    Should Be Success Response    ${filter_response}    200

TC010 - Get Movies With Pagination
    [Documentation]    Listar filmes com paginação
    [Tags]    movies    read    pagination
    ${response}=    Get All Movies    limit=5    page=1
    Should Be Success Response    ${response}    200

TC011 - Get Movies With Sorting
    [Documentation]    Listar filmes ordenados
    [Tags]    movies    read    sort
    ${response}=    Get All Movies    sort=title
    Should Be Success Response    ${response}    200

TC012 - Create Movie As Admin
    [Documentation]    Criar novo filme como administrador
    [Tags]    movies    create    admin
    ${token}=    Get Admin Token
    ${movie_data}=    Create Sample Movie Data    1
    ${response}=    Create Movie    ${token}
    ...    title=${movie_data}[title]
    ...    synopsis=${movie_data}[synopsis]
    ...    director=${movie_data}[director]
    ...    genres=${movie_data}[genres]
    ...    duration=${movie_data}[duration]
    ...    classification=${movie_data}[classification]
    ...    poster=${movie_data}[poster]
    ...    release_date=${movie_data}[releaseDate]
    ...    expected_status=201
    Should Be Success Response    ${response}    201
    Verify Movie Data Structure    ${response.json()}[data]
    Should Be Equal As Strings    ${response.json()}[data][title]    ${movie_data}[title]

TC013 - Create Movie With Invalid Data
    [Documentation]    Tentativa de criar filme com dados inválidos
    [Tags]    movies    create    admin    error
    ${token}=    Get Admin Token
    ${body}=    Create Dictionary    title=Incomplete Movie
    ${headers}=    Create Auth Headers    ${token}
    ${response}=    POST On Session    cinema_api    /movies    json=${body}    headers=${headers}    expected_status=400
    Should Be Error Response Message    ${response}    400

TC014 - Get Movie By Valid ID
    [Documentation]    Buscar filme por ID válido
    [Tags]    movies    read
    ${movie_id}=    Set Variable    68f7ec4a377d8700e8da0156
    ${response}=    Get Movie By ID    ${movie_id}    expected_status=200
    Should Be Success Response    ${response}    200
    Should Be Equal As Strings    ${response.json()}[data][_id]    ${movie_id}
    Should Be Equal As Strings    ${response.json()}[data][title]    Interstellar

TC015 - Get Movie By Invalid ID
    [Documentation]    Tentativa de buscar filme com ID inválido
    [Tags]    movies    read    error
    ${response}=    Get Movie By ID    invalid_id_123    expected_status=400
    Should Be Error Response Message    ${response}    400

TC016 - Get Non-Existent Movie
    [Documentation]    Tentativa de buscar filme que não existe
    [Tags]    movies    read    error
    ${response}=    Get Movie By ID    60d0fe4f53112398988a109c    expected_status=404
    Should Be Error Response Message    ${response}    404

TC017 - Update Movie As Admin
    [Documentation]    Atualizar filme como administrador
    [Tags]    movies    update    admin
    ${token}=    Get Admin Token
    ${movie_data}=    Create Sample Movie Data    1
    ${create_response}=    Create Movie    ${token}
    ...    title=${movie_data}[title]
    ...    synopsis=${movie_data}[synopsis]
    ...    director=${movie_data}[director]
    ...    genres=${movie_data}[genres]
    ...    duration=${movie_data}[duration]
    ...    classification=${movie_data}[classification]
    ...    poster=${movie_data}[poster]
    ...    release_date=${movie_data}[releaseDate]
    ...    expected_status=201
    ${movie_id}=    Extract Movie ID From Response    ${create_response}
    ${updated_title}=    Set Variable    Updated Movie Title
    ${response}=    Update Movie    ${token}    ${movie_id}    title=${updated_title}    expected_status=200
    Should Be Success Response    ${response}    200
    Should Be Equal As Strings    ${response.json()}[data][title]    ${updated_title}

TC018 - Update Movie With Partial Data
    [Documentation]    Atualizar apenas alguns campos do filme
    [Tags]    movies    update    admin
    ${token}=    Get Admin Token
    ${movie_data}=    Create Sample Movie Data    1
    ${create_response}=    Create Movie    ${token}
    ...    title=${movie_data}[title]
    ...    synopsis=${movie_data}[synopsis]
    ...    director=${movie_data}[director]
    ...    genres=${movie_data}[genres]
    ...    duration=${movie_data}[duration]
    ...    classification=${movie_data}[classification]
    ...    poster=${movie_data}[poster]
    ...    release_date=${movie_data}[releaseDate]
    ...    expected_status=201
    ${movie_id}=    Extract Movie ID From Response    ${create_response}
    ${new_director}=    Set Variable    New Director Name
    ${response}=    Update Movie    ${token}    ${movie_id}    director=${new_director}    duration=150    expected_status=200
    Should Be Success Response    ${response}    200
    Should Be Equal As Strings    ${response.json()}[data][director]    ${new_director}

TC019 - Update Non-Existent Movie
    [Documentation]    Tentativa de atualizar filme que não existe
    [Tags]    movies    update    admin    error
    ${token}=    Get Admin Token
    ${response}=    Update Movie    ${token}    60d0fe4f5311236168a109cb    title=New Title    expected_status=401
    Should Be Error Response Message    ${response}    401

TC020 - Delete Movie As Admin
    [Documentation]    Deletar filme como administrador
    [Tags]    movies    delete    admin
    ${token}=    Get Admin Token
    ${movie_data}=    Create Sample Movie Data    1
    ${create_response}=    Create Movie    ${token}
    ...    title=${movie_data}[title]
    ...    synopsis=${movie_data}[synopsis]
    ...    director=${movie_data}[director]
    ...    genres=${movie_data}[genres]
    ...    duration=${movie_data}[duration]
    ...    classification=${movie_data}[classification]
    ...    poster=${movie_data}[poster]
    ...    release_date=${movie_data}[releaseDate]
    ...    expected_status=201
    ${movie_id}=    Extract Movie ID From Response    ${create_response}
    ${response}=    Delete Movie    ${token}    ${movie_id}    expected_status=200
    Should Be Success Response    ${response}    200
    Should Be Equal As Strings    ${response.json()}[message]    Movie removed
    ${get_response}=    Get Movie By ID    ${movie_id}    expected_status=404
    Should Be Error Response Message    ${get_response}    404

TC021 - Create Movie Without Admin Rights
    [Documentation]    Tentativa de criar filme sem ser admin
    [Tags]    movies    create    security
    ${token}=    Get User Token
    ${movie_data}=    Create Sample Movie Data    1
    ${response}=    Create Movie    ${token}
    ...    title=${movie_data}[title]
    ...    synopsis=${movie_data}[synopsis]
    ...    director=${movie_data}[director]
    ...    genres=${movie_data}[genres]
    ...    duration=${movie_data}[duration]
    ...    classification=${movie_data}[classification]
    ...    poster=${movie_data}[poster]
    ...    release_date=${movie_data}[releaseDate]
    ...    expected_status=403
    Should Be Error Response Message    ${response}    403

TC022 - Update Movie Without Admin Rights
    [Documentation]    Tentativa de atualizar filme sem ser admin
    [Tags]    movies    update    security
    ${admin_token}=    Get Admin Token
    ${user_token}=    Get User Token
    ${movie_data}=    Create Sample Movie Data    1
    ${create_response}=    Create Movie    ${admin_token}
    ...    title=${movie_data}[title]
    ...    synopsis=${movie_data}[synopsis]
    ...    director=${movie_data}[director]
    ...    genres=${movie_data}[genres]
    ...    duration=${movie_data}[duration]
    ...    classification=${movie_data}[classification]
    ...    poster=${movie_data}[poster]
    ...    release_date=${movie_data}[releaseDate]
    ...    expected_status=201
    ${movie_id}=    Extract Movie ID From Response    ${create_response}
    ${response}=    Update Movie    ${user_token}    ${movie_id}    title=Unauthorized Update    expected_status=403
    Should Be Error Response Message    ${response}    403

TC023 - Delete Movie Without Admin Rights
    [Documentation]    Tentativa de deletar filme sem ser admin
    [Tags]    movies    delete    security
    ${admin_token}=    Get Admin Token
    ${user_token}=    Get User Token
    ${movie_data}=    Create Sample Movie Data    1
    ${create_response}=    Create Movie    ${admin_token}
    ...    title=${movie_data}[title]
    ...    synopsis=${movie_data}[synopsis]
    ...    director=${movie_data}[director]
    ...    genres=${movie_data}[genres]
    ...    duration=${movie_data}[duration]
    ...    classification=${movie_data}[classification]
    ...    poster=${movie_data}[poster]
    ...    release_date=${movie_data}[releaseDate]
    ...    expected_status=201
    ${movie_id}=    Extract Movie ID From Response    ${create_response}
    ${response}=    Delete Movie    ${user_token}    ${movie_id}    expected_status=403
    Should Be Error Response Message    ${response}    403

TC024 - Complete Movie CRUD Flow
    [Documentation]    Fluxo completo CRUD para filmes
    [Tags]    movies    crud    admin    smoke
    ${token}=    Get Admin Token
    ${movie_data}=    Create Sample Movie Data    99
    ${create_response}=    Create Movie    ${token}
    ...    title=${movie_data}[title]
    ...    synopsis=${movie_data}[synopsis]
    ...    director=${movie_data}[director]
    ...    genres=${movie_data}[genres]
    ...    duration=${movie_data}[duration]
    ...    classification=${movie_data}[classification]
    ...    poster=${movie_data}[poster]
    ...    release_date=${movie_data}[releaseDate]
    ...    expected_status=201
    Should Be Success Response    ${create_response}    201
    ${movie_id}=    Extract Movie ID From Response    ${create_response}
    ${get_response}=    Get Movie By ID    ${movie_id}    expected_status=200
    Should Be Success Response    ${get_response}    200
    ${update_response}=    Update Movie    ${token}    ${movie_id}    title=Updated Title    expected_status=200
    Should Be Success Response    ${update_response}    200
    ${delete_response}=    Delete Movie    ${token}    ${movie_id}    expected_status=200
    Should Be Success Response    ${delete_response}    200
    ${verify_response}=    Get Movie By ID    ${movie_id}    expected_status=404
    Should Be Error Response Message    ${verify_response}    404

TC025 - Get Movies Without Authentication
    [Documentation]    Acesso público aos filmes sem autenticação
    [Tags]    movies    read    public
    ${response}=    Get All Movies
    Should Be Success Response    ${response}    200
    Dictionary Should Contain Key    ${response.json()}    data

TC026 - Search Movies By Partial Title
    [Documentation]    Buscar filmes por parte do título
    [Tags]    movies    read    search
    ${response}=    Get All Movies    title=the
    Should Be Success Response    ${response}    200

TC027 - Filter Movies By Multiple Genres
    [Documentation]    Filtrar filmes por diferentes gêneros
    [Tags]    movies    read    filter
    ${genres}=    Create List    Action    Drama    Comedy
    FOR    ${genre}    IN    @{genres}
        ${response}=    Get All Movies    genre=${genre}
        Should Be Success Response    ${response}    200
    END