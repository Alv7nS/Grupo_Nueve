-- ============================================================
-- Nuevereware - populate.sql
-- Dados FICTICIOS para testes (nao reais)
-- Palavra-passe de todos os utilizadores: password123
-- (os hashes sao gerados por seed_passwords.js, ver README)
-- ============================================================

USE nuevereware;

INSERT INTO utilizador (nome, email, password_hash, tipo, consentimento_rgpd) VALUES
('Hélio José',           'helio.jose@exemplo.pt',     'POR_GERAR', 'doador', TRUE),
('Maria Silva',          'maria@exemplo.pt',          'POR_GERAR', 'doador', TRUE),
('Rui Santos',           'rui.santos@exemplo.pt',     'POR_GERAR', 'doador', TRUE),
('Inês Carvalho',        'ines.carvalho@exemplo.pt',  'POR_GERAR', 'doador', TRUE),
('Equipa Nuevereware',   'gestor@exemplo.pt',         'POR_GERAR', 'gestor', TRUE);

INSERT INTO ponto_recolha
    (nome, morada, codigo_postal, horario, latitude, longitude, como_chegar, contacto) VALUES
('Ponto de recolha · Alcântara', 'Rua de Exemplo, 10',  '1300-001 Lisboa',
 'Segunda a sexta, 10:00–18:00', 38.704600, -9.177200,
 'Comboio: estação de Alcântara-Mar (5 min a pé).', '210 000 001'),
('Ponto de recolha · Queluz',    'Avenida Exemplo, 25', '2745-001 Queluz',
 'Segunda a sábado, 09:00–19:00', 38.756600, -9.254500,
 'Comboio: estação de Queluz-Belas (8 min a pé).', '210 000 002'),
('Ponto de recolha · Sintra',    'Largo de Exemplo, 3', '2710-001 Sintra',
 'Terça a sábado, 10:00–17:00', 38.797400, -9.387900,
 'Comboio: estação de Sintra (10 min a pé).', '210 000 003'),
('Ponto de recolha · Oeiras',    'Rua de Teste, 7',     '2780-001 Oeiras',
 'Segunda a sexta, 09:00–17:00', 38.692100, -9.312200,
 'Autocarro 171, paragem Oeiras Centro.', '210 000 004');

INSERT INTO doacao
    (id, utilizador_id, ponto_recolha_id, categoria, estado_peca, tecido, composicao,
     observacoes, peso_kg, estado, mensagem_estado, data_submissao) VALUES
(1, 1, NULL, 'Camisa',   'Danificada, com tecido aproveitável', 'Algodão', '100% algodão',
 'Rasgo na manga direita.', 0.40, 'em_avaliacao',
 'A equipa está a analisar as fotografias.', '2026-09-12 14:20:00'),
(2, 1, 1,    'Calças',   'Usadas, em bom estado',               'Ganga',   '98% algodão, 2% elastano',
 'Desgaste nos joelhos.',   1.40, 'entregue',
 'Doação recebida. Obrigado!', '2026-07-03 10:05:00'),
(3, 1, 2,    'Vestido',  'Manchado, com tecido aproveitável',   'Linho',   '100% linho',
 NULL,                      1.20, 'entregue',
 'Doação recebida. Obrigado!', '2026-08-01 16:40:00'),
(4, 1, 1,    'Camisola', 'Bom estado',                          'Lã',      '100% lã',
 'Tamanho M.',              0.60, 'aprovada',
 'Consulte as instruções de entrega.', '2026-10-05 09:15:00'),
(5, 2, NULL, 'Casaco',   'Bom estado',                          'Lã',      '80% lã, 20% poliéster',
 'Casaco de inverno.',      1.10, 'em_avaliacao',
 'A equipa está a analisar as fotografias.', '2026-10-20 18:30:00'),
(6, 2, NULL, 'T-shirt',  'Muito desgastada',                    'Algodão', '100% algodão',
 'Rasgões em várias zonas.', 0.25, 'recusada',
 'Tecido sem condições de aproveitamento.', '2026-09-28 11:00:00'),
(7, 3, NULL, 'Camisa',   'Bom estado',                          'Algodão', '100% algodão',
 'Enviada por correio.',    0.35, 'entregue',
 'Doação recebida. Obrigado!', '2026-09-02 13:10:00'),
(8, 3, 3,    'Calças',   'Danificadas, com tecido aproveitável','Ganga',   '100% algodão',
 NULL,                      0.80, 'aprovada',
 'Consulte as instruções de entrega.', '2026-10-30 12:00:00'),
(9, 4, NULL, 'Vestido',  'Bom estado',                          'Linho',   '100% linho',
 NULL,                      0.50, 'em_avaliacao',
 'A equipa está a analisar as fotografias.', '2026-11-02 08:45:00'),
(10, 4, 4,   'Camisola', 'Usada, pequena mancha',               'Algodão', '100% algodão',
 'Pequena mancha na gola.', 0.45, 'entregue',
 'Doação recebida. Obrigado!', '2026-10-10 15:25:00');

INSERT INTO fotografia (doacao_id, url) VALUES
(1, 'assets/images/donations/camisa_rasgo.jpg'),
(1, 'assets/images/donations/etiqueta.jpg'),
(2, 'assets/images/donations/calcas_ganga.jpg'),
(3, 'assets/images/donations/vestido_linho.jpg'),
(3, 'assets/images/donations/etiqueta.jpg'),
(4, 'assets/images/donations/camisola_la.jpg'),
(5, 'assets/images/donations/casaco_la.jpg'),
(5, 'assets/images/donations/etiqueta.jpg'),
(6, 'assets/images/donations/tshirt_rasgada.jpg'),
(7, 'assets/images/donations/camisa_algodao.jpg'),
(8, 'assets/images/donations/calcas_danificadas.jpg'),
(9, 'assets/images/donations/vestido_linho2.jpg'),
(10, 'assets/images/donations/camisola_algodao.jpg');

INSERT INTO envio_correio (doacao_id, morada, codigo_postal, valor_orcamento) VALUES
(7, 'Rua Fictícia, 15, Almada', '2800-001', 3.95);

INSERT INTO entrada_pontos (utilizador_id, doacao_id, descricao, quantidade) VALUES
(1, NULL, 'Bónus de boas-vindas', 20),
(1, 2,    'Doação entregue',     120),
(1, 3,    'Doação entregue',     120),
(1, NULL, 'Desafio mensal',       60),
(2, NULL, 'Bónus de boas-vindas', 20),
(3, NULL, 'Bónus de boas-vindas', 20),
(3, 7,    'Doação entregue',     120),
(4, NULL, 'Bónus de boas-vindas', 20),
(4, 10,   'Doação entregue',     120);

-- Mantem utilizador.pontos coerente com o historico de movimentos
UPDATE utilizador u
   SET pontos = COALESCE((SELECT SUM(quantidade)
                            FROM entrada_pontos e
                           WHERE e.utilizador_id = u.id), 0);

INSERT INTO lote (id, nome) VALUES
(1, 'Lote Camisas'),
(2, 'Lote Ganga'),
(3, 'Lote Linho'),
(4, 'Lote Lã');

INSERT INTO lote_etapa (lote_id, ordem, descricao) VALUES
(1, 1, 'Doação de uma camisa de algodão'),
(1, 2, 'Desconstrução e higienização'),
(1, 3, 'Nova peça criada pelos artesãos'),
(2, 1, 'Doação de peças de ganga'),
(2, 2, 'Corte e seleção do tecido aproveitável'),
(2, 3, 'Costura de novas peças pelos artesãos'),
(3, 1, 'Doação de peças de linho'),
(3, 2, 'Lavagem e passagem a ferro'),
(3, 3, 'Confeção de acessórios em linho'),
(4, 1, 'Doação de peças de lã'),
(4, 2, 'Desfiar e higienizar a lã'),
(4, 3, 'Tricô e patchwork pelos artesãos');

INSERT INTO produto
    (id, lote_id, nome, genero, categoria, tecido, tamanho, preco, descricao, composicao, imagem) VALUES
(1, 1, 'Camisa reconstruída',     'Feminino',  'Camisas',     'Algodão', 'M', 42.00,
 'Camisa de corte descontraído feita a partir de camisas doadas.',
 '100% algodão recuperado', 'assets/images/products/camisa_reconstruida.jpg'),
(2, 2, 'Tote bag de ganga',       'Unissexo',  'Acessórios',  'Ganga',   'U', 18.50,
 'Saco de ombro resistente feito com retalhos de ganga.',
 '100% algodão recuperado', 'assets/images/products/tote_ganga.jpg'),
(3, 3, 'Bolsa de linho',          'Unissexo',  'Acessórios',  'Linho',   'U', 22.00,
 'Bolsa leve em linho, forrada e com fecho.',
 '100% linho recuperado',   'assets/images/products/bolsa_linho.jpg'),
(4, 4, 'Camisola patchwork',      'Feminino',  'Camisolas',   'Lã',      'M', 55.00,
 'Camisola em retalhos de lã de várias cores.',
 '100% lã recuperada',      'assets/images/products/camisola_patchwork.jpg'),
(5, 4, 'Gorro de lã',             'Unissexo',  'Acessórios',  'Lã',      'U', 14.90,
 'Gorro quente em lã reaproveitada.',
 '100% lã recuperada',      'assets/images/products/gorro_la.jpg'),
(6, 2, 'Casaco de ganga remendado','Masculino','Casacos',     'Ganga',   'L', 79.00,
 'Casaco de ganga com remendos feitos à mão.',
 '100% algodão recuperado', 'assets/images/products/casaco_ganga.jpg');

-- "feita com tecido de" (so doacoes ja entregues)
INSERT INTO produto_doacao (produto_id, doacao_id) VALUES
(1, 7), (2, 2), (6, 2), (3, 3), (4, 10);
