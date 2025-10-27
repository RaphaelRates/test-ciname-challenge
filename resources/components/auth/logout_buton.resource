*** Settings ***
Documentation    Recursos relacionados ao botão de logout via interface web

Library          Browser
Library          Collections

Resource  ../../variables.resource
Resource  ../../base.resource

*** Keywords ***

Clicar Botão Logout
    [Documentation]    Clica no botão de logout
    Click    ${LOGOUT_BUTTON}

Verificar Logout Bem Sucedido
    [Documentation]    Verifica se o logout foi bem-sucedido (mudança de URL e presença do botão de login)
    ${current_url}=    Get Url
    Should Be Equal As Strings    ${current_url}    ${URL_FRONT}/login
    Wait For Elements State    ${MENU_LOGIN}    visible    timeout=5s
