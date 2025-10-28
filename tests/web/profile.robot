# *** Settings ***
# Documentation    Recursos relacionados à autenticação de usuários via interface web

# Library          Browser
# Library          Collections

# Resource  ../../resources/variables.resource
# Resource  ../../resources/base.resource
# Resource  ../../resources/components/auth/login_form.resource
# Resource  ../../resources/pages/register_page.resource
# Resource  ../../resources/components/auth/register_form.resource
# Resource  ../../resources/pages/profile.resource

# *** Test Cases ***
# TC035 - Verificar A Rota De Perfil
#     [Documentation]    Deve verificar se todos os elementos da página de login estão presentes
#     Configurar Teste
#     Abrir Página de Login
#     Verificar Elementos da Página de Login
#     Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
#        Sleep    1s
#     Click    css=#root > header > div > nav > ul > li:nth-child(4) > a

# TC036 - Verificar Carregamento Da Página De Perfil
#     [Documentation]    Verifica se a página de perfil carrega corretamente
#     [Tags]    smoke    profile
#     Configurar Teste
#     Abrir Página de Login
#     Verificar Elementos da Página de Login
#     Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
#     Sleep    1s
#     Click    css=#root > header > div > nav > ul > li:nth-child(4) > a
#     Validar Título Da Página    Meu Perfil
#     Validar Descrição Da Página    Gerencie suas informações pessoais e credenciais de acesso
#     Validar Abas Visíveis
# TC037 - Verificar Informações Do Usuário Carregadas
#     [Documentation]    Verifica se as informações do usuário estão preenchidas corretamente
#     [Tags]    profile    user-info
#     Configurar Teste
#     Abrir Página de Login
#     Verificar Elementos da Página de Login
#     Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
#     Sleep    1s
#     Click    css=#root > header > div > nav > ul > li:nth-child(4) > a
#     Validar Campo Nome    Raphael Susa Silva
#     Validar Campo Email    raphaelrates.dev@gmail.com
#     Validar Email Desabilitado

# TC038 - Validar Campo Email Não Editável
#     [Documentation]    Verifica se o campo de e-mail não pode ser editado
#     [Tags]    profile    validation
#     Configurar Teste
#     Abrir Página de Login
#     Verificar Elementos da Página de Login
#     Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
#     Sleep    1s
#     Click    css=#root > header > div > nav > ul > li:nth-child(4) > a
#     Validar Email Desabilitado
#     Validar Mensagem Email Não Editável    O e-mail não pode ser alterado

# TC039 - Alterar Nome Do Usuário
#     [Documentation]    Testa a funcionalidade de alteração do nome do usuário
#     [Tags]    profile    edit
#     Configurar Teste
#     Abrir Página de Login
#     Verificar Elementos da Página de Login
#     Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
#        Sleep    1s
#     Click    css=#root > header > div > nav > ul > li:nth-child(4) > a
#     ${novo_nome}=    Set Variable    Raphael Susa 
#     Preencher Campo Nome    ${novo_nome}
#     ${novo_nome}=    Set Variable    Raphael Susa Silva
#     Preencher Campo Nome    ${novo_nome}
#     Validar Botão Salvar Habilitado
#     Clicar Botão Salvar
#     Validar Mensagem Sucesso
#     Validar Campo Nome    ${novo_nome}

# TC040 - Verificar Seção De Alteração De Senha
#     [Documentation]    Verifica a presença e estado da seção de alteração de senha
#     [Tags]    profile    password
#     Configurar Teste
#     Abrir Página de Login
#     Verificar Elementos da Página de Login
#     Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
#        Sleep    1s
#     Click    css=#root > header > div > nav > ul > li:nth-child(4) > a
#     Validar Seção Alterar Senha Visível
#     Validar Campos De Senha Presentes
#     Validar Aviso Senha Indisponível

# TC041 - Verificar Botão Salvar Desabilitado Sem Alterações
#     [Documentation]    Verifica que o botão salvar fica desabilitado quando não há alterações
#     [Tags]    profile    validation
#     Configurar Teste
#     Abrir Página de Login
#     Verificar Elementos da Página de Login
#     Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
#        Sleep    1s
#     Click    css=#root > header > div > nav > ul > li:nth-child(4) > a
#     Validar Botão Salvar Desabilitado
#     Validar Tooltip Botão Salvar    Não há alterações a salvar

# TC042 - Validar Campos De Senha Vazios
#     [Documentation]    Verifica que os campos de senha estão inicialmente vazios
#     [Tags]    profile    password
#     Configurar Teste
#     Abrir Página de Login
#     Verificar Elementos da Página de Login
#     Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
#        Sleep    1s
#     Click    css=#root > header > div > nav > ul > li:nth-child(4) > a
#     Validar Campo Senha Atual Vazio
#     Validar Campo Nova Senha Vazio
#     Validar Campo Confirmar Senha Vazio

# TC043 - Verificar Lista De Reservas
#     [Documentation]    Valida a exibição da lista de reservas do usuário
#     [Tags]    profile    reservations
#     Configurar Teste
#     Abrir Página de Login
#     Verificar Elementos da Página de Login
#     Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
#        Sleep    1s
#     Click    css=#root > header > div > nav > ul > li:nth-child(4) > a
#     Validar Seção Minhas Reservas Visível
#     Validar Quantidade De Reservas    1

# TC044 - Verificar Detalhes Da Reserva
#     [Documentation]    Valida os detalhes de uma reserva específica
#     [Tags]    profile    reservations    details
#     Configurar Teste
#     Abrir Página de Login
#     Verificar Elementos da Página de Login
#     Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
#        Sleep    1s
#     Click    css=#root > header > div > nav > ul > li:nth-child(4) > a
#     ${reserva}=    Obter Primeira Reserva
#     Validar Filme Da Reserva    ${reserva}    The Avengers
#     Validar Data Da Reserva    ${reserva}    21/10/2025
#     Validar Horário Da Reserva    ${reserva}    12:00
#     Validar Teatro Da Reserva    ${reserva}    Theater 1
#     Validar Assento Da Reserva    ${reserva}    C8 (Inteira)
#     Validar Status Da Reserva    ${reserva}    CONFIRMADA
#     Validar Preço Da Reserva    ${reserva}    R$ 15.00

# TC045 - Verificar Poster Do Filme Na Reserva
#     [Documentation]    Valida a exibição do poster do filme
#     [Tags]    profile    reservations    image
#     Configurar Teste
#     Abrir Página de Login
#     Verificar Elementos da Página de Login
#     Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
#        Sleep    1s
#     Click    css=#root > header > div > nav > ul > li:nth-child(4) > a
#     ${reserva}=    Obter Primeira Reserva
#     Validar Poster Do Filme    ${reserva}    avengers.jpg

# TC046 - Alternar Entre Abas
#     [Documentation]    Testa a funcionalidade de alternância entre as abas
#     [Tags]    profile    navigation
#     Configurar Teste
#     Abrir Página de Login
#     Verificar Elementos da Página de Login
#     Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
#        Sleep    1s
#     Click    css=#root > header > div > nav > ul > li:nth-child(4) > a
#     Clicar Aba Minhas Reservas
#     Validar Aba Ativa    Minhas Reservas
#     Clicar Aba Meu Perfil
#     Validar Aba Ativa    Meu Perfil

# TC047 - Tentar Salvar Sem Alterações
#     [Documentation]    Verifica comportamento ao tentar salvar sem fazer alterações
#     [Tags]    profile    validation    negative
#     Configurar Teste
#     Abrir Página de Login
#     Verificar Elementos da Página de Login
#     Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
#        Sleep    1s
#     Click    css=#root > header > div > nav > ul > li:nth-child(4) > a
#     Validar Botão Salvar Desabilitado
#     Tentar Clicar Botão Salvar Desabilitado
#     Validar Nenhuma Ação Executada

# TC048 - Limpar Campo Nome E Validar
#     [Documentation]    Verifica validação ao limpar o campo nome
#     [Tags]    profile    validation    negative
#     Configurar Teste
#     Abrir Página de Login
#     Verificar Elementos da Página de Login
#     Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
#        Sleep    1s
#     Click    css=#root > header > div > nav > ul > li:nth-child(4) > a
#     Limpar Campo Nome
#     Validar Campo Nome Vazio
#     Validar Botão Salvar Habilitado

# TC049 - Validar Formulário Completo
#     [Documentation]    Valida todos os campos do formulário de perfil
#     [Tags]    profile    full-validation
#     Configurar Teste
#     Abrir Página de Login
#     Verificar Elementos da Página de Login
#     Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
#        Sleep    1s
#     Click    css=#root > header > div > nav > ul > li:nth-child(4) > a
#     Validar Estrutura Do Formulário
#     Validar Labels Dos Campos
#     Validar Placeholders Dos Campos
#     Validar Tipos De Input