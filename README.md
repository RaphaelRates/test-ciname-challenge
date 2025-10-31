# Test Cinema Challenge

Este é um projeto de automação de testes para um sistema de cinema, desenvolvido utilizando o framework Robot Framework.

## 📁 Estrutura do Projeto

```
test-cinema-challenge/
├── lib/                          # Bibliotecas e recursos do projeto
│   ├── resources/               # Arquivos de recursos do Robot Framework
│   │   ├── api/                 # Recursos para APIs
│   │   │   ├── auth.resource
│   │   │   ├── movies.resource
│   │   │   ├── reservations.resource
│   │   │   ├── sessions.resource
│   │   │   ├── setup.resource
│   │   │   ├── theater.resource
│   │   │   └── users.resource
│   │   ├── components/          # Componentes da interface
│   │   │   ├── auth/
│   │   │   │   ├── login_form.resource
│   │   │   │   ├── logout_button.resource
│   │   │   │   └── register_form.resource
│   │   │   ├── dropdown_filter_movies.resource
│   │   │   ├── footer.resource
│   │   │   ├── header.resource
│   │   │   ├── home_list_container.resource
│   │   │   ├── movie_card.resource
│   │   │   ├── search_movie_card.resource
│   │   │   └── search_movies_input.resource
│   │   ├── fixtures/            # Dados de teste
│   │   │   ├── auth.json
│   │   │   ├── cinema.json
│   │   │   ├── movies.json
│   │   │   ├── reservation.json
│   │   │   ├── sessions.json
│   │   │   └── theaters.json
│   │   ├── pages/               # Definições de páginas
│   │   │   ├── base.resource
│   │   │   └── variables.resource
│   │   └── result/              # Resultados de testes
├── tests/                       # Casos de teste
│   └── server/                  # Testes do servidor/API
│       ├── auth.robot
│       ├── movies.robot
│       ├── reservations.robot
│       └── sessions.robot
│   └── web/                  # Testes do servidor/API
│       ├── auth.robot
│       ├── movies.robot
│       ├── init.robot
│       └── profile.robot
```

## 🚀 Funcionalidades Testadas

### APIs Testadas
- **Autenticação** (`auth.robot`): Testes de login, registro e controle de acesso
- **Filmes** (`movies.robot`): Testes de CRUD para filmes
- **Sessões** (`sessions.robot`): Testes para gerenciamento de sessões de cinema
- **Reservas** (`reservations.robot`): Testes para sistema de reservas

### Componentes de Interface
- Formulários de autenticação (login/registro)
- Componentes de filtro e busca de filmes
- Cards de exibição de filmes
- Header e footer da aplicação
- Container de listagem na página inicial

## 🛠️ Pré-requisitos

- Python 3.7+
- Robot Framework
- Bibliotecas do Robot Framework:
  - RequestsLibrary (para testes de API)
  - SeleniumLibrary (para testes de interface)
  - Collections
  - String

## 📦 Instalação

1. Clone o repositório:
```bash
git clone [url-do-repositorio]
cd test-cinema-challenge
```

2. Instale as dependências:
```bash
pip install robotframework
pip install robotframework-requests
pip install robotframework-faker
pip install robotframework-browser
pip install robotframework-faker
pip install robotframework-jsonloader
```

## 🧪 Executando os Testes

### Executar todos os testes:
```bash
robot tests/
```

### Executar testes específicos:
```bash
# Testes de autenticação
robot tests/server/auth.robot

# Testes de filmes
robot tests/server/movies.robot

# Testes de reservas
robot tests/server/reservations.robot

# Testes de sessões
robot tests/server/sessions.robot
```

## 📊 Estrutura de Testes

### Testes de API
Localizados em `tests/server/`, focam na validação dos endpoints do backend:
- CRUD de entidades
- Validação de respostas
- Testes de autenticação e autorização
- Validação de regras de negócio

### Dados de Teste
Os arquivos JSON em `lib/resources/fixtures/` contêm dados mock para:
- Usuários e autenticação
- Catálogo de filmes
- Sessões de cinema
- Reservas
- Informações do cinema

## 🔧 Configuração

### Variáveis de Ambiente
Configure as variáveis no arquivo `lib/resources/pages/variables.resource`:
- URL base da API
- Credenciais de teste
- Timeouts
- Configurações do ambiente

### Setup de Testes
O arquivo `lib/resources/api/setup.resource` contém configurações iniciais:
- Conexão com APIs
- Headers padrão
- Setup e teardown de suites

## 📈 Relatórios

Os resultados dos testes são gerados automaticamente em:
- `output.xml` - Relatório em XML
- `log.html` - Log detalhado em HTML
- `report.html` - Relatório sumarizado em HTML

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto é destinado para fins de teste e desafio técnico.