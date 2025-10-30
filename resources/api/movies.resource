*** Settings ***
Documentation     keywords por usar nos testes das rotas dos filmes

Library     RequestsLibrary
Library     Collections
Library     String

Resource    ../variables.resource
Resource    ../base.resource

*** Keywords ***
Get All Movies
    [Arguments]    ${token}=${None}    ${title}=${None}    ${genre}=${None}    ${sort}=${None}    ${limit}=10    ${page}=1
    ${headers}=    Run Keyword If    $token is not None    Create Auth Headers    ${token}
    ...    ELSE    Create Dictionary    Content-Type=application/json
    
    ${params}=    Create Dictionary
    Run Keyword If    $title is not None    Set To Dictionary    ${params}    title=${title}
    Run Keyword If    $genre is not None    Set To Dictionary    ${params}    genre=${genre}
    Run Keyword If    $sort is not None    Set To Dictionary    ${params}    sort=${sort}
    Run Keyword If    $limit is not None    Set To Dictionary    ${params}    limit=${limit}
    Run Keyword If    $page is not None    Set To Dictionary    ${params}    page=${page}
    
    ${response}=    GET On Session    cinema_api    /movies    headers=${headers}    params=${params}    expected_status=any
    [Return]    ${response}

Get Movie By ID
    [Arguments]    ${movie_id}    ${token}=${None}    ${expected_status}=any
    ${headers}=    Run Keyword If    $token is not None    Create Auth Headers    ${token}
    ...    ELSE    Create Dictionary    Content-Type=application/json
    ${response}=    GET On Session    cinema_api    /movies/${movie_id}    headers=${headers}    expected_status=${expected_status}
    [Return]    ${response}

Create Movie
    [Arguments]    ${token}    ${title}    ${synopsis}    ${director}    ${genres}    ${duration}    ${classification}    ${poster}=${None}    ${release_date}=${None}    ${expected_status}=any
    ${headers}=    Create Auth Headers    ${token}
    ${body}=    Create Dictionary
    ...    title=${title}
    ...    synopsis=${synopsis}
    ...    director=${director}
    ...    genres=${genres}
    ...    duration=${duration}
    ...    classification=${classification}
    
    Run Keyword If    $poster is not None    Set To Dictionary    ${body}    poster=${poster}
    Run Keyword If    $release_date is not None    Set To Dictionary    ${body}    releaseDate=${release_date}
    
    ${response}=    POST On Session    cinema_api    /movies    json=${body}    headers=${headers}    expected_status=${expected_status}
    [Return]    ${response}

Update Movie
    [Arguments]    ${token}    ${movie_id}    ${title}=${None}    ${synopsis}=${None}    ${director}=${None}    ${genres}=${None}    ${duration}=${None}    ${classification}=${None}    ${poster}=${None}    ${release_date}=${None}    ${expected_status}=any
    ${headers}=    Create Auth Headers    ${token}
    ${body}=    Create Dictionary
    
    Run Keyword If    $title is not None    Set To Dictionary    ${body}    title=${title}
    Run Keyword If    $synopsis is not None    Set To Dictionary    ${body}    synopsis=${synopsis}
    Run Keyword If    $director is not None    Set To Dictionary    ${body}    director=${director}
    Run Keyword If    $genres is not None    Set To Dictionary    ${body}    genres=${genres}
    Run Keyword If    $duration is not None    Set To Dictionary    ${body}    duration=${duration}
    Run Keyword If    $classification is not None    Set To Dictionary    ${body}    classification=${classification}
    Run Keyword If    $poster is not None    Set To Dictionary    ${body}    poster=${poster}
    Run Keyword If    $release_date is not None    Set To Dictionary    ${body}    releaseDate=${release_date}
    
    ${response}=    PUT On Session    cinema_api    /movies/${movie_id}    json=${body}    headers=${headers}    expected_status=${expected_status}
    [Return]    ${response}

Delete Movie
    [Arguments]    ${token}    ${movie_id}    ${expected_status}=any
    ${headers}=    Create Auth Headers    ${token}
    ${response}=    DELETE On Session    cinema_api    /movies/${movie_id}    headers=${headers}    expected_status=${expected_status}
    [Return]    ${response}

Extract Movie ID From Response
    [Arguments]    ${response}
    ${movie_id}=    Set Variable    ${response.json()}[data][_id]
    [Return]    ${movie_id}

Verify Movie Data Structure
    [Arguments]    ${movie_data}
    Dictionary Should Contain Key    ${movie_data}    _id
    Dictionary Should Contain Key    ${movie_data}    title
    Dictionary Should Contain Key    ${movie_data}    synopsis
    Dictionary Should Contain Key    ${movie_data}    director
    Dictionary Should Contain Key    ${movie_data}    genres
    Dictionary Should Contain Key    ${movie_data}    duration
    Dictionary Should Contain Key    ${movie_data}    classification
    Dictionary Should Contain Key    ${movie_data}    poster
    Dictionary Should Contain Key    ${movie_data}    releaseDate
    Dictionary Should Contain Key    ${movie_data}    createdAt

Create Sample Movie Data
    [Arguments]    ${movie_number}=1
    ${movie_data}=    Create Dictionary
    ...    title=Movie Title ${movie_number}
    ...    synopsis=This is a sample movie synopsis for testing purposes ${movie_number}
    ...    director=Director Name ${movie_number}
    ...    genres=${{["Drama", "Action"]}}
    ...    duration=${{120 + ${movie_number}}}
    ...    classification=PG-13
    ...    poster=movie${movie_number}.jpg
    ...    releaseDate=2023-01-01
    [Return]    ${movie_data}