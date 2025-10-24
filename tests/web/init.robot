# *** Settings ***
# Documentation    Testes relacionados ao componente de header do site

# Library   Browser
# Library          Collections

# Resource   ../../resources/base.resource
# Resource   ../../resources/variables.resource

# Resource   ../../resources/components/header.resource
# Resource   ../../resources/components/home_list_conteiner.resource
# Resource   ../../resources/components/footer.resource
# Resource   ../../resources/components/movie_card.resource

# Resource   ../../resources/pages/movies_search.resource

# Suite Setup      Setup Browser
# Suite Teardown   Close Browser

# *** Test Cases ***
# # Verificar Header Na Pagina Inicial
# #     [Documentation]    Teste completo do header na página inicial
# #     Open Page    /
# #     Verify Complete Header Structure
    
# #     Verify Text In Element    .nav ul li:nth-child(2) a    Início
# #     Verify Text In Element    .nav ul li:nth-child(3) a    Login
# #     Verify Text In Element    .nav ul li:nth-child(4) a    Cadastrar

# # Verificar Navegacao Via Header
# #     [Documentation]    Teste de navegação usando o header
# #     Open Page    /

# #     Navigate To Login Page
# #     Verify Page Onlline    Cinema App
    
# #     Navigate To Home Via Logo
# #     Verify Page Onlline    Cinema App
    
# #     Navigate To Register Page
# #     Verify Page Onlline    Cinema App

# # Verificar Header Em Diferentes Paginas
# #     [Documentation]  
# #     @{pages}=    Create List    /    /login    /register    /movies
    
# #     FOR    ${page}    IN    @{pages}
# #         Open Page    ${page}
# #         Verify Header Is Visible
# #         Verify Logo Is Visible AndClickable
# #         Browser.Take Screenshot    filename=header_${page.replace('/', '')}.png
# #     END

# # Verificar Seção De Features Na Pagina Inicial
# #     [Documentation]    Testa a seção de features na página inicial
# #     Open Page    /
    
# #     Verify Features Section Is Visible
# #     Verify Features Title Is Correct
# #     Verify Features List Is Correct
# #     Verify CTA Button Is Working

# #     Go to    ${URL_FRONT}/
# #     Click    ${FEATURES_CTA_BUTTON}
# #     Wait For Condition    url    contains    /movies
# #     Get URL    ==    ${URL_FRONT}/movies


# # Verificar Footer Na Pagina Inicial
# #     [Documentation]    Testa o footer completo na página inicial
# #     Open Page    /
    
# #     Verify Footer Is Visible
# #     Verify Footer Structure
# #     Verify Footer App Section
# #     Verify Footer Links Section
# #     Verify Footer Contact Section
# #     Verify Footer Social Section
# #     Verify Footer Copyright

# # Verificar Footer Em Diferentes Paginas
# #     [Documentation]    Verifica se o footer está presente em todas as páginas
# #     @{pages}=    Create List    /    /login    /register   
    
# #     FOR    ${page}    IN    @{pages}
# #         Open Page    ${page}
# #         Verify Footer Is Visible
# #         Verify Footer Copyright
# #         ${page_name}=    Evaluate    "${page}".replace('/', '') or 'home'
# #         Browser.Take Screenshot    filename=footer_${page_name}.png
# #     END

# Teste Completo Seção de Filmes
#     [Documentation]    Teste completo da seção de filmes e cartões
#     Open Page    /
    
#     Verificar Seção de Filmes Existe
#     Validar Grid de Filmes
#     Verificar Múltiplos Cartões de Filme
    
#     Verificar Cartão Filme Interstellar Renderiza Corretamente
#     Validar Conteúdo do Cartão Interstellar
#     Verificar Gêneros do Filme
#     Validar Poster Placeholder
#     Clicar Botão Ver Detalhes
#     Go Back   
    
#     Testar Layout Responsivo do Cartão
#     Verificar Acessibilidade

# Teste Navegação Entre Filmes
#     [Documentation]    Testa navegação entre diferentes filmes
#     Open Page    /
#     Navegar Para Detalhes do Primeiro Filme
#     Get Url    contains    /movies/


# # Teste Componentes Da Pagina De Busca
# #     [Documentation]    Verifica se todos os componentes da página estão presentes
# #     Navigate To Search Movies Page
# #     Verify Search Movies Page Loaded

# # Teste Busca Por Filme Existente
# #     [Documentation]    Testa busca por um filme existente
# #     Navigate To Search Movies Page
# #     Search And Filter Movies    Interstellar
# #     Verify Search Results    1

# # Teste Filtro Por Genero
# #     [Documentation]    Testa filtro por gênero
# #     Navigate To Search Movies Page
# #     Search And Filter Movies    ${EMPTY}    Adventure
# #     Verify Search Results    1

# # Teste Busca E Filtro Combinados
# #     [Documentation]    Testa combinação de busca e filtro
# #     Navigate To Search Movies Page
# #     Search And Filter Movies    Avengers    Action
# #     Verify Search Results    1

# # Teste Navegacao Para Detalhes Do Filme
# #     [Documentation]    Testa navegação para detalhes a partir dos resultados
# #     Navigate To Search Movies Page
# #     Search And Filter Movies    Interstellar
# #     Click Movie Details Button In Search
# #     Get Url    contains    /movies/

# # Teste Limpeza De Filtros
# #     [Documentation]    Testa limpeza dos filtros de busca
# #     Navigate To Search Movies Page
# #     Search And Filter Movies    Teste    Adventure
# #     Clear All Filters
# #     ${count}    Get Search Movie Cards Count
# #     Should Be True    ${count} > 1