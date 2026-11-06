# Contrato da API — o que a app Flutter espera do servidor

Combinado entre a app (Flutter) e o servidor (Node.js + Express + MySQL).
**Se mudarem um nome de campo ou de rota, avisem a pessoa da app** — os nomes abaixo
estão escritos no código (`lib/models/*.dart` → `fromJson`, `lib/services/*.dart`).

- Base: `http://localhost:3000` (emulador Android usa `http://10.0.2.2:3000`)
- Tudo em JSON, UTF-8. Campos em `snake_case` português.
- Erros: código HTTP adequado + `{ "erro": "mensagem para o utilizador" }`
- O servidor tem de ter **CORS ativo** (`app.use(cors())`) para a versão web funcionar.

---

## 1. Iniciar sessão
`POST /auth/login`

Pedido:
```json
{ "email": "helio.jose@exemplo.pt", "password": "password123" }
```
Resposta `200`:
```json
{
  "utilizador": {
    "id": 1,
    "nome": "Hélio José",
    "email": "helio.jose@exemplo.pt",
    "tipo": "doador",
    "pontos": 320,
    "total_doacoes": 4,
    "kg_recuperados": 2.6
  }
}
```
Erros: `401` e-mail/palavra-passe errados · `400` campos em falta.
`tipo` é `"doador"` ou `"gestor"`. Nunca devolver a password nem o hash.

## 2. Criar conta
`POST /utilizadores`

Pedido:
```json
{ "nome": "Maria Silva", "email": "maria@exemplo.pt", "password": "password123", "consentimento_rgpd": true }
```
Resposta `201`: igual à do login (`{ "utilizador": { ... } }`, com `pontos: 0`).
Erros: `409` e-mail já registado · `400` dados inválidos.

## 3. Doações do utilizador
`GET /doacoes?utilizador=1`

Resposta `200`:
```json
{
  "doacoes": [
    {
      "id": 24,
      "nome_peca": "Camisa de algodão",
      "categoria": "Camisa",
      "estado_peca": "Danificada, com tecido aproveitável",
      "tecido": "Algodão",
      "composicao": "100% algodão",
      "observacoes": "Rasgo na manga direita.",
      "estado": "em_avaliacao",
      "mensagem_estado": "A equipa está a analisar as fotografias.",
      "data_submissao": "2026-09-12T14:20:00.000Z",
      "doador_nome": "Hélio José",
      "doador_email": "helio.jose@exemplo.pt",
      "fotografias": [
        "assets/images/donations/camisa_rasgo.jpg",
        "assets/images/donations/etiqueta.jpg"
      ]
    }
  ]
}
```
- `estado`: `em_avaliacao` | `aprovada` | `recusada` | `entregue`
- `fotografias`: lista de caminhos/URLs (JOIN com a tabela `Fotografia`). Nesta fase podem ser
  os caminhos `assets/images/...` que já existem na app.
- Ordenar da mais recente para a mais antiga.

## 4. Submeter doação
`POST /doacoes`

Pedido:
```json
{
  "utilizador_id": 1,
  "categoria": "Camisa",
  "estado_peca": "Danificada, com tecido aproveitável",
  "tecido": "Algodão",
  "composicao": "100% algodão",
  "observacoes": "Rasgo na manga esquerda.",
  "fotografias": ["assets/images/donations/camisa_rasgo.jpg"]
}
```
Resposta `201`: `{ "doacao": { ...mesmo formato do ponto 3... } }` com o `id` novo e
`estado: "em_avaliacao"`.

## 5. Alterar estado de uma doação (gestor / demonstração)
`PATCH /doacoes/:id/estado`

Pedido:
```json
{ "estado": "aprovada", "mensagem_estado": "Consulte as instruções de entrega." }
```
Resposta `200`: `{ "doacao": { ... } }` · `404` se não existir · `400` estado inválido.
Quando o estado passa a `entregue`, o servidor deve somar **120 pontos** ao doador e
registar o movimento na tabela de pontos.

## 6. Catálogo
`GET /produtos`

Resposta `200`:
```json
{
  "produtos": [
    {
      "id": 8,
      "nome": "Camisa reconstruída",
      "genero": "Feminino",
      "categoria": "Camisas",
      "tecido": "Algodão",
      "tamanho": "M",
      "preco": 42.00,
      "descricao": "Camisa de corte descontraído...",
      "composicao": "100% algodão recuperado",
      "lote_id": 8,
      "imagem": "assets/images/products/camisa_reconstruida.jpg",
      "historia": ["Doação de uma camisa de algodão", "Desconstrução e higienização", "Nova peça criada pelos artesãos"]
    }
  ]
}
```
- `preco` pode vir como número ou texto (o MySQL devolve DECIMAL como texto — a app aceita os dois).
- `imagem` pode ser um caminho `assets/...` ou um URL `http...`.
- `historia` é opcional (lista de etapas do lote).

## 7. Pontos de recolha
`GET /pontos-recolha`

Resposta `200`:
```json
{
  "pontos_recolha": [
    {
      "id": 1,
      "nome": "Ponto de recolha · Alcântara",
      "morada": "Rua de Exemplo, 10",
      "codigo_postal": "1300-001 Lisboa",
      "horario": "Segunda a sexta, 10:00–18:00",
      "latitude": 38.7046,
      "longitude": -9.1772,
      "como_chegar": "Comboio: estação de Alcântara-Mar (5 min a pé).",
      "contacto": "210 000 001"
    }
  ]
}
```

---

### Teste rápido (antes de ligar a app)
```bash
curl -X POST http://localhost:3000/auth/login -H "Content-Type: application/json" \
     -d '{"email":"helio.jose@exemplo.pt","password":"password123"}'
curl "http://localhost:3000/doacoes?utilizador=1"
curl http://localhost:3000/produtos
```
