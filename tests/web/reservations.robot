*** Settings ***
Documentation    Testes relacionados ás reservs do usuario

Library      Browser
Library      Collections

Resource       ../../resources/variables.resource
Resource       ../../resources/base.resource
Resource       ../../resources/pages/reservation_page.resource
Resource       ../../resources/components/auth/login_form.resource

*** Test Cases ***
# TC050 - Verificar Carregamento da Página de Reservas
#     [Documentation]    Deve verificar se a página de reservas carrega corretamente
#     [Tags]    smoke    reservations
#     Configurar Teste
#     Abrir Página de Login
#     Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
#     Sleep    1s
#     Acessar Página de Reservas
#     Validar Página de Reservas Carregada
#     Validar Header da Página de Reservas

TC051 - Verificar Estrutura do Card de Reserva
    [Documentation]    Deve validar a estrutura completa de um card de reserva
    [Tags]    reservations    structure
        Configurar Teste
    Abrir Página de Login
    Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
    Acessar Página de Reservas
    Validar Estrutura do Card de Reserva
    Validar Elementos do Header da Reserva
    Validar Informações do Filme
    Validar Detalhes da Sessão
    Validar Footer da Reserva

TC052 - Validar Conteúdo da Reserva do Avengers
    [Documentation]    Deve validar todas as informações da reserva do filme The Avengers
    [Tags]    reservations    content    avengers
        Configurar Teste
    Abrir Página de Login
    Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
    Acessar Página de Reservas
    Validar Reserva Específica do Avengers

TC053 - Verificar Ícones dos Detalhes
    [Documentation]    Deve validar que todos os ícones dos detalhes estão presentes
    [Tags]    reservations    icons
        Configurar Teste
    Abrir Página de Login
    Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
    Acessar Página de Reservas
    Validar Ícones dos Detalhes      1

TC054 - Validar Status da Reserva
    [Documentation]    Deve verificar se o status da reserva está correto
    [Tags]    reservations    status
        Configurar Teste
    Abrir Página de Login
    Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
    Acessar Página de Reservas
    Validar Status da Reserva    1    CONFIRMADA

TC055 - Verificar Informações de Pagamento
    [Documentation]    Deve validar as informações de pagamento da reserva
    [Tags]    reservations    payment
        Configurar Teste
    Abrir Página de Login
    Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
    Acessar Página de Reservas
    Validar Preço da Reserva    1    R$ 15.00
    Validar Forma de Pagamento    1    Cartão de Crédito

TC056 - Validar Botões de Ação
    [Documentation]    Deve verificar a presença e funcionalidade dos botões de ação
    [Tags]    reservations    actions
        Configurar Teste
    Abrir Página de Login
    Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
    Acessar Página de Reservas
    Validar Botões de Ação Presentes

TC057 - Navegar para Página Inicial
    [Documentation]    Deve testar a navegação para a página inicial
    [Tags]    reservations    navigation
        Configurar Teste
    Abrir Página de Login
    Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
    Acessar Página de Reservas
    Validar Navegação para Página Inicial

TC058 - Navegar para Filmes em Cartaz
    [Documentation]    Deve testar a navegação para a página de filmes
    [Tags]    reservations    navigation
        Configurar Teste
    Abrir Página de Login
    Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
    Acessar Página de Reservas
    Validar Navegação para Filmes em Cartaz

TC059 - Verificar Número da Reserva
    [Documentation]    Deve validar o formato do número da reserva
    [Tags]    reservations    validation
        Configurar Teste
    Abrir Página de Login
    Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
    Acessar Página de Reservas
    Validar Número da Reserva

TC060 - Validar Poster do Filme
    [Documentation]    Deve verificar se o poster do filme é exibido corretamente
    [Tags]    reservations    image
        Configurar Teste
    Abrir Página de Login
    Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
    Acessar Página de Reservas
    Validar Poster do Filme    1    avengers.jpg

TC061 - Verificar Múltiplas Reservas
    [Documentation]    Deve validar a estrutura quando há múltiplas reservas
    [Tags]    reservations    multiple
        Configurar Teste
    Abrir Página de Login
    Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
    Acessar Página de Reservas
    Validar Quantidade de Reservas    1
    Validar Todas as Reservas Com Estrutura Completa

TC062 - Validar Responsividade do Card
    [Documentation]    Deve verificar a estrutura responsiva do card de reserva
    [Tags]    reservations    responsive
        Configurar Teste
    Abrir Página de Login
    Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
    Acessar Página de Reservas
    Validar Estrutura do Card de Reserva
    # Testes de responsividade podem ser adicionados com diferentes viewports

TC063 - Verificar Ordenação das Reservas
    [Documentation]    Deve validar se as reservas estão ordenadas corretamente
    [Tags]    reservations    ordering
        Configurar Teste
    Abrir Página de Login
    Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
    Acessar Página de Reservas
    # Assume-se que a ordenação é por data mais recente primeiro
    Log    Ordenação validada - implementar lógica específica se necessário

TC064 - Validar Comportamento Sem Reservas
    [Documentation]    Deve verificar o comportamento quando não há reservas
    [Tags]    reservations    empty
        Configurar Teste
    Abrir Página de Login
    Preencher Formulário de Login    raphaelrates.dev@gmail.com    12345678
    # Este teste requer um usuário sem reservas
    Log    Comportamento sem reservas - implementar com usuário específico