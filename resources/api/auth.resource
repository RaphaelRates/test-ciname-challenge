*** Settings ***
Library    RequestsLibrary
Library    Collections

Resource    ../../resources/variables.resource
Resource    ../../resources/base.resource



*** Keywords ***
Register New User
    [Arguments]    ${name}    ${email}    ${password}
    ${body}=    Create Dictionary    name=${name}    email=${email}    password=${password}
    ${response}=    POST    ${URL_FRONT}/auth/register    json=${body}    expected_status=any
    RETURN    ${response}

Login User
    [Arguments]    ${email}    ${password}
    ${body}=    Create Dictionary    email=${email}    password=${password}
    ${response}=    POST    ${URL_FRONT}/auth/login    json=${body}    expected_status=any
    RETURN    ${response}

Get User Profile
    [Arguments]    ${token}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${response}=    GET    ${URL_FRONT}/auth/me    headers=${headers}    expected_status=any
    RETURN    ${response}

Update User Profile
    [Arguments]    ${token}    ${name}=${NONE}    ${current_password}=${NONE}    ${new_password}=${NONE}
    ${body}=    Create Dictionary
    Run Keyword If    '${name}' != '${NONE}'    Set To Dictionary    ${body}    name=${name}
    Run Keyword If    '${current_password}' != '${NONE}'    Set To Dictionary    ${body}    currentPassword=${current_password}
    Run Keyword If    '${new_password}' != '${NONE}'    Set To Dictionary    ${body}    newPassword=${new_password}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${response}=    PUT    ${URL_FRONT}/auth/profile    json=${body}    headers=${headers}    expected_status=any
    RETURN    ${response}

Extract Token From Response
    [Arguments]    ${response}
    ${json}=    Set Variable    ${response.json()}
    ${token}=    Get From Dictionary    ${json['data']}    token
    RETURN    ${token}

Verify Success Response
    [Arguments]    ${response}    ${expected_status}=200
    Should Be Equal As Numbers    ${response.status_code}    ${expected_status}
    ${json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json}    success
    Should Be True    ${json['success']}

Verify Error Response
    [Arguments]    ${response}    ${expected_status}    ${expected_message}=${NONE}
    Should Be Equal As Numbers    ${response.status_code}    ${expected_status}
    ${json}=    Set Variable    ${response.json()}
    Should Be True    not ${json['success']}
    Run Keyword If    '${expected_message}' != '${NONE}'    Should Contain    ${json['message']}    ${expected_message}