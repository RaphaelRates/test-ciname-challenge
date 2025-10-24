*** Settings ***
Documentation    Recursos relacionados à autenticação de usuários via interface web

Library   Browser
Library          Collections

Resource  ../../resources/variables.resource
Resource  ../../resources/base.resource
Resource  ../../resources/components/auth/login_form.resource

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