# Arquitetura inicial

## Camadas

- `frontend/`: página HTML, CSS e JavaScript nativos. O browser consome a API através de `fetch`.
- `backend/routes/`: associa métodos e caminhos HTTP aos controladores.
- `backend/controllers/`: valida parâmetros HTTP e transforma resultados em JSON.
- `backend/models/`: executa consultas SQL parametrizadas usando o pool MySQL.
- `backend/services/`: reservado para regras de domínio, como compatibilidade e cálculo de configuração.
- `database/`: esquema relacional e ficheiro de seed vazio, sem produtos inventados.

## Fluxo do catálogo

`frontend/js/app.js` → `GET /api/scooters` → rota → controlador → modelo → MySQL.

## Próximas etapas sugeridas

1. Criar testes automatizados para as rotas e regras do configurador.
2. Implementar autenticação, gestão segura de sessões e autorização por função.
3. Implementar serviços de compatibilidade que consultem as tabelas de relação.
4. Persistir configurações e carrinhos, validar preços no servidor e criar checkout.
5. Implementar administração com autorização aplicada em cada endpoint.

Não confiar em preços, totais ou compatibilidades enviados pelo browser: o servidor deverá recalculá-los a partir dos registos ativos da base de dados.
