# *** Settings ***
# Resource    ../../resources/api/sessions.resource
# Suite Setup    Create Session    api_session    ${BASE_URL}

# *** Test Cases ***
# Get All Sessions Successfully
#     [Documentation]    Test GET /sessions endpoint returns sessions list
#     ${response}=    Get All Sessions
#     Verify Session List Structure    ${response}

# Get Sessions With Movie Filter
#     [Documentation]    Test filtering sessions by movie ID
#     ${params}=    Create Dictionary    movie=60d0fe4f5311236168a109cb
#     ${response}=    Get All Sessions    params=${params}
#     Verify Session List Structure    ${response}

# Get Sessions With Theater Filter
#     [Documentation]    Test filtering sessions by theater ID
#     ${params}=    Create Dictionary    theater=60d0fe4f5311236168a109cc
#     ${response}=    Get All Sessions    params=${params}
#     Verify Session List Structure    ${response}

# Get Sessions With Date Filter
#     [Documentation]    Test filtering sessions by date
#     ${params}=    Create Dictionary    date=2025-06-20
#     ${response}=    Get All Sessions    params=${params}
#     Verify Session List Structure    ${response}

# Get Sessions With Pagination
#     [Documentation]    Test pagination parameters
#     ${params}=    Create Dictionary    limit=5    page=1
#     ${response}=    Get All Sessions    params=${params}
#     Verify Session List Structure    ${response}

# Get Session By Valid ID
#     [Documentation]    Test GET /sessions/{id} with valid session ID
#     ${response}=    Get Session By ID    60d0fe4f5311236168a109cd
#     Verify Session Response Structure    ${response}

# Get Session By Invalid ID
#     [Documentation]    Test GET /sessions/{id} with non-existent session ID
#     ${response}=    Get Session By ID    invalid_session_id
#     Verify Error Response    ${response}    404

# Create Session As Admin Successfully
#     [Documentation]    Test POST /sessions with valid admin token
#     ${session_data}=    Create Valid Session Data
#     ${response}=    Create Session    ${session_data}
#     Verify Session Response Structure    ${response}
#     Should Be Equal As Strings    ${response.status_code}    201

# Create Session Without Authentication
#     [Documentation]    Test POST /sessions without admin token
#     ${session_data}=    Create Valid Session Data
#     ${response}=    Create Session    ${session_data}    ${None}
#     Verify Error Response    ${response}    401

# Create Session With Invalid Data
#     [Documentation]    Test POST /sessions with missing required fields
#     ${invalid_data}=    Create Dictionary    movie=invalid_movie_id
#     ${response}=    Create Session    ${invalid_data}
#     Verify Error Response    ${response}    400

# Create Session With Time Conflict
#     [Documentation]    Test POST /sessions with overlapping time
#     ${session_data}=    Create Valid Session Data
#     ${response}=    Create Session    ${session_data}
#     ${response}=    Create Session    ${session_data}    # Try to create duplicate
#     Verify Error Response    ${response}    409

# Update Session Successfully
#     [Documentation]    Test PUT /sessions/{id} with valid data
#     ${update_data}=    Create Dictionary    fullPrice=25    halfPrice=12
#     ${response}=    Update Session    60d0fe4f5311236168a109cd    ${update_data}
#     Verify Session Response Structure    ${response}

# Update Session Without Authentication
#     [Documentation]    Test PUT /sessions/{id} without admin token
#     ${update_data}=    Create Dictionary    fullPrice=25
#     ${response}=    Update Session    60d0fe4f5311236168a109cd    ${update_data}    ${None}
#     Verify Error Response    ${response}    401

# Update Non-Existent Session
#     [Documentation]    Test PUT /sessions/{id} with invalid session ID
#     ${update_data}=    Create Dictionary    fullPrice=25
#     ${response}=    Update Session    invalid_session_id    ${update_data}
#     Verify Error Response    ${response}    404

# Delete Session Successfully
#     [Documentation]    Test DELETE /sessions/{id} with valid session ID
#     # First create a session to delete
#     ${session_data}=    Create Valid Session Data
#     ${create_response}=    Create Session    ${session_data}
#     ${session_id}=    Set Variable    ${create_response.json()}[data][_id]
    
#     ${response}=    Delete Session    ${session_id}
#     Should Be Equal As Strings    ${response.status_code}    200

# Delete Session With Reservations
#     [Documentation]    Test DELETE /sessions/{id} with confirmed reservations
#     ${response}=    Delete Session    session_with_reservations_id
#     Verify Error Response    ${response}    409

# Delete Session Without Authentication
#     [Documentation]    Test DELETE /sessions/{id} without admin token
#     ${response}=    Delete Session    60d0fe4f5311236168a109cd    ${None}
#     Verify Error Response    ${response}    401

# Reset Session Seats Successfully
#     [Documentation]    Test PUT /sessions/{id}/reset-seats endpoint
#     ${response}=    Reset Session Seats    60d0fe4f5311236168a109cd
#     Verify Session Response Structure    ${response}
#     Session Should Have Available Seats    ${response}

# Reset Seats Without Authentication
#     [Documentation]    Test reset seats without admin token
#     ${response}=    Reset Session Seats    60d0fe4f5311236168a109cd    ${None}
#     Verify Error Response    ${response}    401

# Reset Seats For Non-Existent Session
#     [Documentation]    Test reset seats with invalid session ID
#     ${response}=    Reset Session Seats    invalid_session_id
#     Verify Error Response    ${response}    404

# Session CRUD Flow
#     [Documentation]    Complete CRUD flow for sessions
#     # Create
#     ${session_data}=    Create Valid Session Data
#     ${create_response}=    Create Session    ${session_data}
#     Verify Session Response Structure    ${create_response}
#     ${session_id}=    Set Variable    ${create_response.json()}[data][_id]
    
#     # Read
#     ${get_response}=    Get Session By ID    ${session_id}
#     Verify Session Response Structure    ${get_response}
    
#     # Update
#     ${update_data}=    Create Dictionary    fullPrice=30    halfPrice=15
#     ${update_response}=    Update Session    ${session_id}    ${update_data}
#     Verify Session Response Structure    ${update_response}
    
#     # Reset Seats
#     ${reset_response}=    Reset Session Seats    ${session_id}
#     Verify Session Response Structure    ${reset_response}
    
#     # Delete
#     ${delete_response}=    Delete Session    ${session_id}
#     Should Be Equal As Strings    ${delete_response.status_code}    200