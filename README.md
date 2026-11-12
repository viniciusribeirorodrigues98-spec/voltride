# VoltRide

Base inicial de uma loja online de trotinetes elétricas. O projeto usa HTML, CSS e JavaScript no frontend, Node.js/Express no backend e MySQL para os dados.

## Requisitos

- Node.js 20 ou superior e npm
- MySQL 8.0 ou superior

## Arranque local

1. Instala as dependências:

   ```sh
   npm install
   ```

2. Inicia o servidor:

   ```sh
   npm start
   ```

3. Abre `http://localhost:3000`. O servidor e as páginas podem ser consultados sem configurar MySQL.

### Configuração futura do MySQL

Para utilizar os endpoints que consultam o catálogo ou verificar a ligação em `/api/health`, instala MySQL e importa o esquema vazio:

```sh
mysql -u root -p < database/schema.sql
```

Depois copia `.env.example` para `.env` e preenche as credenciais da tua instalação. Não adiciones `.env` ao Git. O seed não insere produtos nem componentes: serão necessários dados aprovados antes de o catálogo poder apresentar artigos.

Para desenvolvimento com reinício automático, usa `npm run dev`.

## Estrutura

```text
frontend/                 HTML, estilos, JavaScript e recursos visuais
  index.html              Página principal
  pages/                  Páginas HTML adicionais
      checkout.html         Estrutura da finalização de encomenda
      orders.html            Estrutura do histórico de encomendas
  css/                    Folhas de estilo
  js/                     Código do navegador
  assets/                 Imagens e ícones
backend/                  Aplicação Express
  config/                 Configuração da ligação MySQL
  controllers/            Controladores HTTP
  routes/                 Rotas da API
  models/                 Consultas e acesso a dados
  middleware/             Tratamento de erros
  services/               Regras de negócio futuras
  server.js               Entrada do servidor
 database/                Esquema inicial e seed vazio
 docs/                    Decisões e documentação técnica
```

O `index.html` que já existia na raiz foi preservado; o servidor serve como página inicial a versão estruturada em `frontend/index.html`.

## API inicial

- `GET /api/health`: estado do servidor e ligação MySQL.
- `GET /api/scooters`: lista os modelos ativos; sem registos aprovados, a lista está vazia.
- `GET /api/scooters?search=...`: pesquisa por nome, marca ou descrição.
- `GET /api/scooters?minPrice=...&maxPrice=...`: filtra por preço.
- `POST /api/auth/register`, `POST /api/auth/login`, `POST /api/auth/logout` e `GET /api/auth/me`: rotas reservadas; respondem HTTP 501 enquanto a autenticação não estiver implementada.

## Estado do projeto

Esta etapa prepara a estrutura, a API do catálogo e as tabelas relacionais. O seed está intencionalmente vazio: não foram inventados produtos, preços, componentes ou características técnicas. A autenticação, autorização administrativa, regras de compatibilidade, pagamentos, checkout e gestão de encomendas ainda não estão implementados.

A autenticação futura deverá usar hashes de palavra-passe e verificação de permissões no servidor. As credenciais de produção devem ser fornecidas por variáveis de ambiente e nunca adicionadas ao Git.
