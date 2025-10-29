# *** Settings ***

# Library     RequestsLibrary
# Library     Collections
# Library     String

# Resource    ../../resources/api/setup.resource
# Resource    ../../resources/variables.resource
# Resource    ../../resources/base.resource

# Suite Setup    Create Session    cinema_api    ${URL_API}

# *** Test Cases ***
# Create Admin User Successfully
#     [Documentation]    Test POST /setup/admin creates admin user successfully
#     ${unique_email}=    Generate Unique Email
#     ${admin_data}=    Create Valid Admin Data    email=${unique_email}
#     ${response}=    Create Admin User    ${admin_data}
#     Verify Admin User Response Structure    ${response}
#     Admin User Should Have Correct Structure    ${response.json()}[data]

# Create Admin User With Duplicate Email
#     [Documentation]    Test POST /setup/admin with existing email returns error
#     ${admin_data}=    Create Valid Admin Data    email=admin@example.com
#     ${response}=    Create Admin User    ${admin_data}
#     Verify Error Response Structure    ${response}   


# Create Admin User With Invalid Data
#     [Documentation]    Test POST /setup/admin with missing required fields
#     ${invalid_data}=    Create Dictionary    name=Invalid Admin
#     ${response}=    Create Admin User    ${invalid_data}
#     Verify Error Response Structure    ${response}    

# Create Admin User With Weak Password
#     [Documentation]    Test POST /setup/admin with weak password
#     ${admin_data}=    Create Valid Admin Data    password=123
#     ${response}=    Create Admin User    ${admin_data}
#     Verify Error Response Structure    ${response}    

# Create Test Users Successfully
#     [Documentation]    Test POST /setup/test-users creates default test users
#     ${response}=    Create Test Users
    
#     Run Keyword If    ${True}
#     ...    Run Keywords
#     ...    Verify Test Users Response Structure    ${response}
#     ...    AND
#     ...    Run Keyword If    ${response.status_code} == 201
#     ...    Test Users Data Should Have Correct Structure    ${response.json()}[data]
#     ...    ELSE IF    ${response.status_code} == 200
#     ...    Should Be Equal    ${response.json()}[message]    Test users already exist
#     ...    ELSE
#     ...    Verify Production Environment Error    ${response}

# Create Test Users Multiple Times
#     [Documentation]    Test POST /setup/test-users when users already exist
#     ${response1}=    Create Test Users
#     ${response2}=    Create Test Users
#     Verify Test Users Response Structure    ${response1}
#     Verify Test Users Response Structure    ${response2}

# Test Users Should Include Admin And Regular User
#     [Documentation]    Verify test users include both admin and regular user
#     ${response}=    Create Test Users
    
#     Run Keyword If   ${response.status_code} == 201
#     ...    Run Keywords
#     ...    ${users}=    Set Variable    ${response.json()}[data][users]
#     ...    AND
#     ...    Should Be True    len(${users}) >= 2
#     ...    AND
#     ...    ${has_admin}=    Evaluate    any(user['role'] == 'admin' for user in ${users})
#     ...    AND
#     ...    ${has_user}=    Evaluate    any(user['role'] == 'user' for user in ${users})
#     ...    AND
#     ...    Should Be True    ${has_admin}
#     ...    AND
#     ...    Should Be True    ${has_user}

# *** Test Cases ***
# Complete Setup Flow
#     [Documentation]    Complete setup flow for test environment
#     [Tags]    setup-flow
    
#     ${test_users_response}=    Create Test Users
#     Verify Test Users Response Structure    ${test_users_response}

#     ${unique_email}=    Generate Unique Email
#     ${admin_data}=    Create Valid Admin Data
#     ...    name=Test Suite Admin
#     ...    email=${unique_email}
#     ...    password=securepassword123
    
#     ${admin_response}=    Create Admin User    ${admin_data}
#     Verify Admin User Response Structure    ${admin_response}

# Setup Endpoints Response Time
#     [Documentation]    Test setup endpoints response time
#     [Tags]    performance
    
#     ${start_time}=    Get Time    epoch
#     ${response}=    Create Test Users
#     ${end_time}=    Get Time    epoch
#     ${response_time}=    Evaluate    ${end_time} - ${start_time}
    
#     Should Be True    ${response_time} < 5