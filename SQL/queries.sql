USE nuevereware;

-- 1. Distribuição das doações por estado (com percentagem)
SELECT estado,
       COUNT(*) AS total,
       ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM doacao), 1) AS percentagem
FROM doacao
GROUP BY estado
ORDER BY total DESC;

-- 2. Doações à espera de avaliação, com o nome do doador
SELECT u.nome AS doador, d.nome_peca, d.estado_peca, d.data_submissao
FROM doacao d
JOIN utilizador u ON u.id = d.utilizador_id
WHERE d.estado = 'em_avaliacao'
ORDER BY d.data_submissao;

-- 3. Ranking de doadores: n.º de doações, kg entregues e pontos
SELECT u.nome,
       COUNT(d.id) AS doacoes,
       COALESCE(SUM(CASE WHEN d.estado = 'entregue' THEN d.peso_kg END), 0) AS kg_entregues,
       u.pontos
FROM utilizador u
LEFT JOIN doacao d ON d.utilizador_id = u.id
WHERE u.tipo = 'doador'
GROUP BY u.id, u.nome, u.pontos
ORDER BY u.pontos DESC;

-- 4. Doadores com pelo menos 2 doações entregues (HAVING)
SELECT u.nome, COUNT(*) AS entregues
FROM utilizador u
JOIN doacao d ON d.utilizador_id = u.id
WHERE d.estado = 'entregue'
GROUP BY u.id, u.nome
HAVING COUNT(*) >= 2;

-- 5. Tecidos mais doados: n.º de peças, kg total e kg médio (sem recusadas)
SELECT tecido,
       COUNT(*) AS pecas,
       ROUND(SUM(peso_kg), 2) AS kg_total,
       ROUND(AVG(peso_kg), 2) AS kg_medio
FROM doacao
WHERE estado <> 'recusada'
GROUP BY tecido
ORDER BY kg_total DESC;

-- 6. Doadores acima da média de pontos (subquery)
SELECT nome, pontos
FROM utilizador
WHERE tipo = 'doador'
  AND pontos > (SELECT AVG(pontos) FROM utilizador WHERE tipo = 'doador');

-- 7. Doadores que nunca tiveram uma doação recusada (NOT EXISTS)
SELECT u.nome
FROM utilizador u
WHERE u.tipo = 'doador'
  AND NOT EXISTS (SELECT 1
                  FROM doacao d
                  WHERE d.utilizador_id = u.id
                    AND d.estado = 'recusada');

-- 8. Última doação de cada doador (subquery correlacionada)
SELECT u.nome, d.nome_peca, d.estado, d.data_submissao
FROM utilizador u
JOIN doacao d ON d.utilizador_id = u.id
WHERE d.data_submissao = (SELECT MAX(d2.data_submissao)
                          FROM doacao d2
                          WHERE d2.utilizador_id = u.id)
ORDER BY d.data_submissao DESC;

-- 9. Origem dos produtos: de que doação e de que doador vem o tecido
SELECT p.nome AS produto, p.preco, d.nome_peca AS feita_com, u.nome AS doador
FROM produto p
JOIN produto_doacao pd ON pd.produto_id = p.id
JOIN doacao d ON d.id = pd.doacao_id
JOIN utilizador u ON u.id = d.utilizador_id
ORDER BY p.nome;

-- 10. Produtos ainda sem doação associada (LEFT JOIN ... IS NULL)
SELECT p.nome, p.categoria
FROM produto p
LEFT JOIN produto_doacao pd ON pd.produto_id = p.id
WHERE pd.doacao_id IS NULL;

-- 11. Catálogo com a história do lote numa só linha (GROUP_CONCAT)
SELECT p.nome,
       p.preco,
       GROUP_CONCAT(e.descricao ORDER BY e.ordem SEPARATOR ' > ') AS historia
FROM produto p
JOIN lote_etapa e ON e.lote_id = p.lote_id
GROUP BY p.id, p.nome, p.preco
ORDER BY p.nome;

-- 12. Pontos de recolha por n.º de doações recebidas
SELECT pr.nome, COUNT(d.id) AS doacoes_recebidas
FROM ponto_recolha pr
LEFT JOIN doacao d ON d.ponto_recolha_id = pr.id
GROUP BY pr.id, pr.nome
ORDER BY doacoes_recebidas DESC, pr.nome;

-- 13. Doações por forma de entrega (CASE)
SELECT CASE
           WHEN d.ponto_recolha_id IS NOT NULL THEN 'Ponto de recolha'
           WHEN e.id IS NOT NULL THEN 'Correio'
           ELSE 'Por definir'
       END AS metodo,
       COUNT(*) AS doacoes
FROM doacao d
LEFT JOIN envio_correio e ON e.doacao_id = d.id
GROUP BY metodo;

-- 14. Evolução mensal: doações e kg submetidos
SELECT DATE_FORMAT(data_submissao, '%Y-%m') AS mes,
       COUNT(*) AS doacoes,
       ROUND(SUM(peso_kg), 2) AS kg
FROM doacao
GROUP BY mes
ORDER BY mes;

-- 15. Linha do tempo do utilizador 1: doações e movimentos de pontos (UNION ALL)
SELECT data_submissao AS quando,
       CONCAT('Doação: ', nome_peca) AS evento
FROM doacao
WHERE utilizador_id = 1
UNION ALL
SELECT criado_em,
       CONCAT('Pontos: ', descricao, ' (+', quantidade, ')')
FROM entrada_pontos
WHERE utilizador_id = 1
ORDER BY quando DESC;

-- 16. Verificação de integridade: pontos guardados vs histórico de movimentos
-- (não deve devolver linhas se estiver tudo coerente)
SELECT u.nome,
       u.pontos AS pontos_guardados,
       COALESCE(SUM(ep.quantidade), 0) AS pontos_historico
FROM utilizador u
LEFT JOIN entrada_pontos ep ON ep.utilizador_id = u.id
GROUP BY u.id, u.nome, u.pontos
HAVING u.pontos <> COALESCE(SUM(ep.quantidade), 0);

-- 17. Estatísticas gerais da plataforma (subqueries escalares)
SELECT (SELECT COUNT(*) FROM utilizador WHERE tipo = 'doador') AS doadores,
       (SELECT COUNT(*) FROM doacao) AS doacoes,
       (SELECT ROUND(SUM(peso_kg), 2) FROM doacao WHERE estado = 'entregue') AS kg_recuperados,
       (SELECT COUNT(*) FROM produto) AS produtos_no_catalogo;

-- 18. Utilização das views
SELECT * FROM vw_utilizador_resumo;
SELECT * FROM vw_ranking_pontos;
SELECT * FROM vw_doacoes_detalhe WHERE estado = 'em_avaliacao';

-- 19. Stored procedure: aprovar uma doação (altera o estado da doação 1)
-- CALL sp_alterar_estado_doacao(1, 'aprovada', 'Consulte as instruções de entrega.');