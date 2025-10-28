*** Settings ***
Documentation    Recursos relacionados à autenticação de usuários via interface web

Library          Browser
Library          Collections

Resource  ../../resources/variables.resource
Resource  ../../resources/base.resource
Resource  ../../resources/components/auth/login_form.resource
Resource  ../../resources/pages/register_page.resource
Resource  ../../resources/components/auth/register_form.resource
Resource    ../../resources/components/auth/logout_buton.resource

*** Test Cases ***
TC001 - Verificar Elementos da Página de Login
    [Documentation]    Deve verificar se todos os elementos da página de login estão presentes
    Configurar Teste
    Abrir Página de Login
    Verificar Elementos da Página de Login
    Tirar Print
    Finalizar Teste

TC002 - Login Bem Sucedido com Credenciais Válidas
    [Documentation]    Deve realizar login com sucesso usando credenciais válidas
    Configurar Teste
    Abrir Página de Login
    Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
    Verificar Login Bem Sucedido
    Tirar Print
    Finalizar Teste

TC003 - Login com Email Inválido
    [Documentation]    Deve exibir mensagem de erro ao tentar login com email inválido
    Configurar Teste
    Abrir Página de Login
    ${email_invalido}=    Gerar Email Aleatório
    Preencher Formulário de Login    ${email_invalido}    qualquerSenha123
    
    Verificar Erro Login
    Tirar Print
    Finalizar Teste

TC004 - Login com Senha Inválida
    [Documentation]    Deve exibir mensagem de erro ao tentar login com senha inválida
    Configurar Teste
    Abrir Página de Login
    Preencher Formulário de Login    user@example.com    senhaErrada123
    
    Verificar Erro Login
    Tirar Print
    Finalizar Teste

TC005 - Login com Campos Vazios
    [Documentation]    Deve validar campos obrigatórios ao tentar login com campos vazios
    Configurar Teste
    Abrir Página de Login
    
    Verificar Validação Campos Obrigatórios
    Tirar Print
    Finalizar Teste

TC006 - Navegar para Página de Registro
    [Documentation]    Deve navegar para página de registro ao clicar no link
    Configurar Teste
    Abrir Página de Login
    Clicar Link Registrar
    Verificar Página Registro Carregou
    Tirar Print
    Finalizar Teste

TC007 - Login com Email Mal Formatado
    [Documentation]    Deve validar formato de email incorreto
    Configurar Teste
    Abrir Página de Login
    Preencher Formulário de Login    email-invalido    senha123

    Verificar Erro Login
    Tirar Print
    Finalizar Teste

TC008 - Login com Múltiplas Tentativas
    [Documentation]    Teste de tentativas consecutivas de login
    Configurar Teste
    Abrir Página de Login

    Preencher Formulário de Login    user@example.com    senhaErrada1
    
    Verificar Erro Login
    Preencher Formulário de Login    emailerrado@teste.com    password123

    Verificar Erro Login
    Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
    
    Verificar Login Bem Sucedido
    
    Tirar Print
    Finalizar Teste

TC009 - Verificar Elementos da Página de Registro
    [Documentation]    Deve verificar se todos os elementos da página de registro estão presentes
    Abrir Página de Registro
    Verificar Elementos Formulário Registro
    Tirar Print Registro

TC010 - Registro Bem Sucedido com Novo Usuário
    [Documentation]    Deve realizar registro com sucesso com novo usuário
    Abrir Página de Registro
    ${nome}=    Gerar Nome Aleatório
    ${email}=    Gerar Email Aleatório
    ${senha}=    Gerar Senha Aleatória
    
    Preencher Formulário Registro    ${nome}    ${email}    ${senha}    ${senha}
    Sleep    1s
    Clicar Botão Cadastrar
    Sleep    1s

    Verificar Registro Bem Sucedido
    Tirar Print Registro

TC011 - Registro com Email Já Existente
    [Documentation]    Deve exibir erro ao tentar registrar com email existente
    Abrir Página de Registro
    Preencher Formulário Registro    João Silva    user@example.com    password123    password123
    Clicar Botão Cadastrar
    Verificar Mensagem Erro Registro    User already exists
    Tirar Print Registro

TC012 - Registro com Senhas Diferentes
    [Documentation]    Deve validar quando senhas não conferem
    Abrir Página de Registro
    ${nome}=    Gerar Nome Aleatório
    ${email}=    Gerar Email Aleatório
    
    Preencher Formulário Registro    ${nome}    ${email}    senha123    senhaDiferente123
    Clicar Botão Cadastrar
    Sleep    1s
    Verificar Senhas Não Conferem
    Tirar Print Registro

TC0013 - Registro com Campos Vazios
    [Documentation]    Deve validar campos obrigatórios
    Abrir Página de Registro
    Clicar Botão Cadastrar
    Tirar Print Registro

TC014 - Navegar para Página de Login
    [Documentation]    Deve navegar para página de login ao clicar no link
    Abrir Página de Registro
    Clicar Link Login
    Wait For Elements State    css=.login-form    visible    timeout=10s
    Get Url    contains    /login
    Tirar Print Registro

TC0015 - Registro com Email Inválido
    [Documentation]    Deve validar formato de email incorreto, permanecendo na página de registro
    Abrir Página de Registro
    Preencher Formulário Registro    Maria Silva    email-invalido    senha123    senha123
    Clicar Botão Cadastrar
    ${current_url}=    Get Url
    Log To Console    URL atual após tentativa de registro: ${current_url}
    Should Be Equal As Strings    ${current_url}    ${URL_FRONT}/register
    Tirar Print Registro


TC0016 - Registro com Senha Fraca
    [Documentation]    Deve validar senha muito curta
    Abrir Página de Registro
    ${nome}=    Gerar Nome Aleatório
    ${email}=    Gerar Email Aleatório
    
    Preencher Formulário Registro    ${nome}    ${email}    123    123
    Clicar Botão Cadastrar
    Verificar Mensagem Erro Registro    Validation failed 
    Tirar Print Registro

TC0017 - Registro com Nome Muito Curto
    [Documentation]    Deve validar nome muito curto
    Abrir Página de Registro
    Preencher Formulário Registro    A    email@teste.com    senha123    senha123
    Clicar Botão Cadastrar
    Verificar Mensagem Erro Registro    User already exists
    Tirar Print Registro

TC018 - Logout após o Login
    [Documentation]    Deve realizar logout com sucesso
    Abrir Página de Login
    Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
    Verificar Login Bem Sucedido
    Sleep    1s
    Clicar Botão Logout
    Verificar Logout Bem Sucedido
    Tirar Print

TC019 - Logout após o Register
    [Documentation]    Deve realizar logout com sucesso
    Configurar Teste
    Abrir Página de Login

    Verificar Erro Login
    Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
    Verificar Login Bem Sucedido
    Clicar Botão Logout
    Verificar Logout Bem Sucedido
    Tirar Print
    Finalizar Teste