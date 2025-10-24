*** Settings ***
Documentation    Exemplo de teste web com Robot Framework Browser
Library    Browser

*** Keywords ***
Exemplo de Teste Web
    New Page    https://example.com
    Get Text    h1    ==    Example Domain
    Browser.Take Screenshot
    Click    text=More information...
    Browser.Take Screenshot

Exemplo com Preenchimento de Formulário
    New Page    https://demo.playwright.dev/todomvc
    Fill Text    input.new-todo    Aprender Robot Framework Browser
    Press Keys    input.new-todo    Enter
    Get Text    css=div.view >> text=Aprender Robot Framework Browser
    Browser.Take Screenshot