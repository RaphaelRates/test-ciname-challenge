*** Settings ***
Library    Browser
Library    Collections
Library    String

Resource    ../../resources/variables.resource
Resource    ../../resources/base.resource
Resource    ../../resources/components/auth/register_form.resource

*** Keywords ***
Abrir Página de Registro
    [Documentation]    Abre a página de registro
    New Page    ${URL_FRONT}/register
    Wait For Elements State    ${REGISTER_FORM}    visible    timeout=10s

Verificar Registro Bem Sucedido
    [Documentation]    Verifica se o registro foi bem-sucedido (mudança de URL e presença de link no menu)
    ${current_url}=    Get Url
    Log To Console    URL atual: ${current_url}
    Should Not Be Equal As Strings    ${current_url}    ${URL_FRONT}/register
    Should Be Equal As Strings    ${current_url}    ${URL_FRONT}/
    Wait For Elements State    css=#root > header > div > nav > ul > li:nth-child(4) > a    visible    timeout=5s
    Log To Console    Link do menu visível com sucesso.


Verificar Mensagem Erro Registro
    [Documentation]    Verifica se mensagem de erro é exibida
    [Arguments]    ${mensagem}
    Wait For Elements State    css=.alert-content   visible    timeout=3s
    Get Text    css=.alert-content    contains    ${mensagem}

Verificar Senhas Não Conferem
    [Documentation]    Verifica validação de senhas diferentes
    Wait For Elements State    css=#root > div.alerts-container > div > div.alert-content    visible    timeout=5s



Validar Força Senha
    [Documentation]    Valida se senha atende critérios mínimos
    [Arguments]    ${senha}
    ${tamanho}=    Get Length    ${senha}
    Should Be True    ${tamanho} >= 6    msg=Senha deve ter pelo menos 6 caracteres

Tirar Print Registro
    [Documentation]    Tira screenshot da página de registro
    Take Screenshot    fullPage=True