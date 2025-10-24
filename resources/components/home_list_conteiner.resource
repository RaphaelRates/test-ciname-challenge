*** Settings ***
Documentation    Testes relacionados ao componente de header do site

Library    Browser

Resource   ../../resources/base.resource
Resource   ../../resources/variables.resource

*** Keywords ***
Verify Features List Is Correct
    [Documentation]    Verifica se a lista de features na página inicial está correta
    ${feature_elements}=    Get Elements    ${FEATURES_LIST_ITEMS}
    
    FOR    ${index}    ${expected_feature}    IN ENUMERATE    @{EXPECTED_FEATURES_LIST}
        ${actual_text}=    Get Text    ${FEATURES_LIST_ITEMS}:nth-child(${index + 1})
        Should Be Equal    ${actual_text}    ${expected_feature}
    END
    Sleep    0.5

Verify Features Section Is Visible
    [Documentation]    Verifica se a seção de features está visível
    Wait For Elements State    ${FEATURES_SECTION}        visible
    Wait For Elements State    ${FEATURES_TITLE}          visible
    Wait For Elements State    ${FEATURES_LIST}           visible
    Wait For Elements State    ${FEATURES_CTA_CONTAINER}  visible
    Sleep    0.5

Verify Features Title Is Correct
    [Documentation]    Verifica se o título da seção está correto
    Get Text    ${FEATURES_TITLE}    ==    ${EXPECTED_FEATURES_TITLE}
    Sleep    0.5

Verify CTA Button Is Working
    [Documentation]    Verifica se o botão CTA está funcionando
    Wait For Elements State    ${FEATURES_CTA_BUTTON}    visible
    Wait For Elements State    ${FEATURES_CTA_BUTTON}    enabled

    Get Text    ${FEATURES_CTA_BUTTON}    ==    ${EXPECTED_CTA_BUTTON_TEXT}
    Get Attribute    ${FEATURES_CTA_BUTTON}    href    ==    ${EXPECTED_CTA_BUTTON_HREF}
    
    Click    ${FEATURES_CTA_BUTTON}
    Wait For Condition    url    contains    ${EXPECTED_CTA_BUTTON_HREF}
    Sleep    0.5