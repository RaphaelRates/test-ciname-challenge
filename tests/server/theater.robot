*** Settings ***
Library    Collections
Library    RequestsLibrary
Library    String

Resource    ../../resources/api/theater.resource
Resource    ../../resources/api/setup.resource
Resource    ../../resources/variables.resource

Suite Setup    Run Keywords
...    Create Session    cinema_api    ${URL_API}
...    AND
...    Setup Test Environment

*** Test Cases ***
TC075 - Get All Theaters Successfully
    [Documentation]    Test GET /theaters returns theaters list
    ${response}=    Get All Theaters
    Verify Theater List Structure    ${response}

TC076 - Get Theaters With Type Filter
    [Documentation]    Test filtering theaters by type
    ${params}=    Create Dictionary    type=IMAX
    ${response}=    Get All Theaters    params=${params}
    Verify Theater List Structure    ${response}

TC077 - Get Theaters With Pagination
    [Documentation]    Test pagination parameters
    ${params}=    Create Dictionary    limit=5    page=1
    ${response}=    Get All Theaters    params=${params}
    Verify Theater List Structure    ${response}

TC078 - Get Theater By Valid ID
    [Documentation]    Test GET /theaters/{id} with valid theater ID
    ${theater_id}=    Set Variable    68f7ec484bc189e5600e8f8c
    ${response}=    Get Theater By ID    ${theater_id}
    Verify Theater Response Structure    ${response}

TC079 - Get Theater By Invalid ID
    [Documentation]    Test GET /theaters/{id} with non-existent theater ID
    ${response}=    Get Theater By ID    invalid_theater_id
    Verify Error Response    ${response}    404

TC080 - Create Theater As Admin Successfully
    [Documentation]    Test POST /theaters with valid admin token
    ${theater_data}=    Generate Fake Theater Data
    ${response}=    Create Theater    ${theater_data}
    Verify Theater Created Successfully    ${response}

TC081 - Create Theater Without Authentication
    [Documentation]    Test POST /theaters without admin token
    ${theater_data}=    Generate Fake Theater Data
    ${response}=    Create Theater    ${theater_data}    ${None}
    Verify Error Response    ${response}    401

TC082 - Create Theater With Invalid Data
    [Documentation]    Test POST /theaters with missing required fields
    ${invalid_data}=    Create Dictionary    name=Invalid Theater
    # Missing capacity and type
    ${response}=    Create Theater    ${invalid_data}
    Verify Error Response    ${response}    400

TC083 - Create Theater With Duplicate Name
    [Documentation]    Test POST /theaters with existing theater name
    ${theater_data}=    Generate Fake Theater Data    name=Duplicate Theater
    ${response1}=    Create Theater    ${theater_data}
    ${response2}=    Create Theater    ${theater_data}
    Verify Error Response    ${response2}    409

TC084 - Update Theater Successfully
    [Documentation]    Test PUT /theaters/{id} with valid data
    ${theater_id}=    Create Theater And Get ID
    ${update_data}=    Create Dictionary    capacity=200    type=VIP
    ${response}=    Update Theater    ${theater_id}    ${update_data}
    Verify Theater Response Structure    ${response}

TC085 - Update Theater Without Authentication
    [Documentation]    Test PUT /theaters/{id} without admin token
    ${theater_id}=    Create Theater And Get ID
    ${update_data}=    Create Dictionary    capacity=200
    ${response}=    Update Theater    ${theater_id}    ${update_data}    ${None}
    Verify Error Response    ${response}    401

TC086 - Update Non-Existent Theater
    [Documentation]    Test PUT /theaters/{id} with invalid theater ID
    ${update_data}=    Create Dictionary    capacity=200
    ${response}=    Update Theater    invalid_theater_id    ${update_data}
    Verify Error Response    ${response}    404

TC087 - Delete Theater Successfully
    [Documentation]    Test DELETE /theaters/{id} with valid theater ID
    ${theater_id}=    Create Theater And Get ID
    ${response}=    Delete Theater    ${theater_id}
    Should Be Equal As Strings    ${response.status_code}    200

TC088 - Delete Theater Without Authentication
    [Documentation]    Test DELETE /theaters/{id} without admin token
    ${theater_id}=    Create Theater And Get ID
    ${response}=    Delete Theater    ${theater_id}    ${None}
    Verify Error Response    ${response}    401

TC089 - Delete Non-Existent Theater
    [Documentation]    Test DELETE /theaters/{id} with invalid theater ID
    ${response}=    Delete Theater    invalid_theater_id
    Verify Error Response    ${response}    404

TC090 - Theater CRUD Flow
    [Documentation]    Complete CRUD flow for theaters
    # Create
    ${theater_data}=    Generate Fake Theater Data
    ${create_response}=    Create Theater    ${theater_data}
    Verify Theater Created Successfully    ${create_response}
    ${theater_id}=    Set Variable    ${create_response.json()}[_id]
    
    # Read
    ${get_response}=    Get Theater By ID    ${theater_id}
    Verify Theater Response Structure    ${get_response}
    
    # Update
    ${update_data}=    Create Dictionary    capacity=250    type=3D
    ${update_response}=    Update Theater    ${theater_id}    ${update_data}
    Verify Theater Response Structure    ${update_response}
    
    # Delete
    ${delete_response}=    Delete Theater    ${theater_id}
    Should Be Equal As Strings    ${delete_response.status_code}    200

TC091 - Create Multiple Theaters With Different Types
    [Documentation]    Test creating theaters with all available types
    FOR    ${type}    IN    @{THEATER_TYPES}
        ${theater_data}=    Generate Fake Theater Data    type=${type}
        ${response}=    Create Theater    ${theater_data}
        Verify Theater Created Successfully    ${response}
        Should Be Equal    ${response.json()}[type]    ${type}
    END

TC092 - Theater Capacity Validation
    [Documentation]    Test theater capacity validation
    ${theater_data}=    Generate Fake Theater Data    capacity=10
    ${response}=    Create Theater    ${theater_data}
    Verify Theater Created Successfully    ${response}
    Should Be Equal As Numbers    ${response.json()}[capacity]    10