*** Settings ***
Documentation        Verifica o header

Library              Browser

Resource             ../base.resource
Resource             ../variables.resource

*** Keywords ***
Verify Complete Header Structure
    [Documentation]    Verifica a estrutura completa do header
    Wait For Elements State    ${HEADER_CONTAINER}    visible
    Wait For Elements State    ${HEADER_LOGO}         visible
    Wait For Elements State    ${HEADER_NAV}          visible
    Wait For Elements State    ${NAV_MENU}            visible
    
    # Verifica se existem itens no menu
    ${count}=    Get Element Count    ${NAV_MENU_ITEMS}
    Should Be True    ${count} > 0    msg=Menu não contém itens

    Sleep    0.5

Verify Header Is Visible
    [Documentation]    Verifica se o header está visível
    Wait For Elements State    ${HEADER_CONTAINER}    visible
    Browser.Take Screenshot            filename=header_visible.png

    Sleep    0.5

Verify Logo Is Visible AndClickable
    [Documentation]    Verifica se o logo está visível e clicável
    Wait For Elements State    ${HEADER_LOGO}    visible
    Wait For Elements State    ${HEADER_LOGO}    enabled
    Sleep    0.5


Navigate To Login Page
    [Documentation]    Navega para a página de login via header
    Click    ${MENU_LOGIN}
    Wait For Condition    url    contains    /login

Navigate To Register Page
    [Documentation]    Navega para a página de cadastro via header
    Click    ${MENU_REGISTER}
    Wait For Condition    url    contains    /register
    Sleep    0.5

Navigate To Home Via Logo
    [Documentation]    Navega para a home page clicando no logo
    Click    ${HEADER_LOGO}
    Wait For Condition    url    contains    /
    Sleep    0.5
