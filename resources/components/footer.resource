*** Settings ***
Documentation    Testes relacionados ao componente de footer do site

Library    Browser

Resource   ../../resources/base.resource
Resource   ../../resources/variables.resource

*** Keywords ***
Verify Footer Is Visible
    [Documentation]    Verifica se o footer está visível na página
    Wait For Elements State    ${FOOTER_CONTAINER}    visible
    Wait For Elements State    ${FOOTER_BOTTOM}       visible
    Sleep    0.5

Verify Footer Structure
    [Documentation]    Verifica a estrutura completa do footer
    ${section_count}=    Get Element Count    ${FOOTER_SECTIONS}
    Should Be Equal As Numbers    ${section_count}    4
    
    Wait For Elements State    ${FOOTER_APP_SECTION}        visible
    Wait For Elements State    ${FOOTER_LINKS_SECTION}      visible
    Wait For Elements State    ${FOOTER_CONTACT_SECTION}    visible
    Wait For Elements State    ${FOOTER_SOCIAL_SECTION}     visible
    Sleep    0.5

Verify Footer App Section
    [Documentation]    Verifica a seção do aplicativo
    Verify Text In Element    ${FOOTER_APP_TITLE}        ${EXPECTED_FOOTER_APP_TITLE}
    Verify Text In Element    ${FOOTER_APP_DESCRIPTION}  ${EXPECTED_FOOTER_APP_DESC}
    Sleep    0.5

Verify Footer Links Section
    [Documentation]    Verifica a seção de links úteis
    Verify Text In Element    ${FOOTER_LINKS_TITLE}    ${EXPECTED_FOOTER_LINKS_TITLE}
    
    # Verifica links
    Verify Text In Element    ${FOOTER_LINK_FILMES}     Filmes em Cartaz
    Get Attribute    ${FOOTER_LINK_FILMES}    href    ==    /
    
    Verify Text In Element    ${FOOTER_LINK_LOGIN}      Login
    Get Attribute    ${FOOTER_LINK_LOGIN}     href    ==    /login
    
    Verify Text In Element    ${FOOTER_LINK_REGISTER}   Cadastre-se
    Get Attribute    ${FOOTER_LINK_REGISTER}  href    ==    /register
    Sleep    0.5

Verify Footer Contact Section
    [Documentation]    Verifica a seção de contato
    Verify Text In Element    ${FOOTER_CONTACT_TITLE}    ${EXPECTED_FOOTER_CONTACT_TITLE}
    
    Wait For Elements State    ${FOOTER_CONTACT_EMAIL}    visible
    ${email_text}=    Get Text    ${FOOTER_CONTACT_EMAIL}
    Should Contain    ${email_text}    ${EXPECTED_FOOTER_EMAIL}
    
    Verify Text In Element    ${FOOTER_CONTACT_PHONE}    ${EXPECTED_FOOTER_PHONE}
    Sleep    0.5

Verify Footer Social Section
    [Documentation]    Verifica a seção de redes sociais
    Verify Text In Element    ${FOOTER_SOCIAL_TITLE}    ${EXPECTED_FOOTER_SOCIAL_TITLE}
    
    # Verifica ícones sociais
    Wait For Elements State    ${FOOTER_SOCIAL_FACEBOOK}    visible
    Wait For Elements State    ${FOOTER_SOCIAL_TWITTER}     visible
    Wait For Elements State    ${FOOTER_SOCIAL_INSTAGRAM}   visible
    
    Get Attribute    ${FOOTER_SOCIAL_FACEBOOK}    href    ==    https://facebook.com
    Get Attribute    ${FOOTER_SOCIAL_TWITTER}     href    ==    https://twitter.com
    Get Attribute    ${FOOTER_SOCIAL_INSTAGRAM}   href    ==    https://instagram.com
    Sleep    0.5

Verify Footer Copyright
    [Documentation]    Verifica o copyright
    Verify Text In Element    ${FOOTER_COPYRIGHT}    ${EXPECTED_FOOTER_COPYRIGHT}
    Sleep    0.5
