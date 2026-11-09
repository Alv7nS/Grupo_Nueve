-- ============================================================
-- Nuevereware - create.sql
-- Base de dados relacional (MySQL 8+)
-- Alinhada com API_CONTRATO.md (nomes de campos e estados)
-- ============================================================

DROP DATABASE IF EXISTS nuevereware;
CREATE DATABASE nuevereware CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE nuevereware;

-- ------------------------------------------------------------
-- TABELAS
-- ------------------------------------------------------------

-- AppUser
CREATE TABLE utilizador (
    id                 INT AUTO_INCREMENT PRIMARY KEY,
    nome               VARCHAR(100) NOT NULL,
    email              VARCHAR(150) NOT NULL UNIQUE,
    password_hash      VARCHAR(255) NOT NULL,
    tipo               ENUM('doador', 'gestor') NOT NULL DEFAULT 'doador',
    pontos             INT NOT NULL DEFAULT 0 CHECK (pontos >= 0),
    consentimento_rgpd BOOLEAN NOT NULL DEFAULT FALSE,
    criado_em          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CollectionPoint
CREATE TABLE ponto_recolha (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    nome          VARCHAR(100) NOT NULL,
    morada        VARCHAR(200) NOT NULL,
    codigo_postal VARCHAR(20)  NOT NULL,
    horario       VARCHAR(100),
    latitude      DECIMAL(9,6) NOT NULL,
    longitude     DECIMAL(9,6) NOT NULL,
    como_chegar   VARCHAR(255),
    contacto      VARCHAR(30)
);

-- Donation (utilizador 1 --- 0..* doacao; doacao 0..* --- 0..1 ponto_recolha)
-- nome_peca e calculado ("Camisa" + "Algodão" -> "Camisa de algodão"),
-- a app nao o envia no POST /doacoes.
CREATE TABLE doacao (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    utilizador_id    INT NOT NULL,
    ponto_recolha_id INT NULL,
    categoria        VARCHAR(50)  NOT NULL,
    estado_peca      VARCHAR(100) NOT NULL,
    tecido           VARCHAR(50)  NOT NULL,
    composicao       VARCHAR(100),
    observacoes      TEXT,
    peso_kg          DECIMAL(5,2) NOT NULL DEFAULT 0.50 CHECK (peso_kg > 0),
    estado           ENUM('em_avaliacao', 'aprovada', 'recusada', 'entregue')
                     NOT NULL DEFAULT 'em_avaliacao',
    mensagem_estado  VARCHAR(255),
    data_submissao   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    nome_peca        VARCHAR(150)
                     GENERATED ALWAYS AS (CONCAT(categoria, ' de ', LOWER(tecido))) STORED,
    CONSTRAINT fk_doacao_utilizador FOREIGN KEY (utilizador_id)
        REFERENCES utilizador (id) ON DELETE CASCADE,
    CONSTRAINT fk_doacao_ponto FOREIGN KEY (ponto_recolha_id)
        REFERENCES ponto_recolha (id) ON DELETE SET NULL
);

-- Donation.photos (List<String>)
CREATE TABLE fotografia (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    doacao_id  INT NOT NULL,
    url        VARCHAR(255) NOT NULL,
    CONSTRAINT fk_foto_doacao FOREIGN KEY (doacao_id)
        REFERENCES doacao (id) ON DELETE CASCADE
);

-- ShippingResult (doacao 1 --- 0..1 envio_correio)
CREATE TABLE envio_correio (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    doacao_id       INT NOT NULL UNIQUE,
    morada          VARCHAR(200) NOT NULL,
    codigo_postal   VARCHAR(20)  NOT NULL,
    valor_orcamento DECIMAL(8,2) NOT NULL CHECK (valor_orcamento >= 0),
    CONSTRAINT fk_envio_doacao FOREIGN KEY (doacao_id)
        REFERENCES doacao (id) ON DELETE CASCADE
);

-- PointsEntry (utilizador 1 --- 0..* entrada_pontos)
CREATE TABLE entrada_pontos (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    utilizador_id  INT NOT NULL,
    doacao_id      INT NULL,
    descricao      VARCHAR(200) NOT NULL,
    quantidade     INT NOT NULL,
    criado_em      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pontos_utilizador FOREIGN KEY (utilizador_id)
        REFERENCES utilizador (id) ON DELETE CASCADE,
    CONSTRAINT fk_pontos_doacao FOREIGN KEY (doacao_id)
        REFERENCES doacao (id) ON DELETE SET NULL
);

-- Lote de producao (o campo "historia" do catalogo vem das etapas)
CREATE TABLE lote (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    nome       VARCHAR(100) NOT NULL,
    criado_em  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE lote_etapa (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    lote_id    INT NOT NULL,
    ordem      INT NOT NULL,
    descricao  VARCHAR(200) NOT NULL,
    UNIQUE (lote_id, ordem),
    CONSTRAINT fk_etapa_lote FOREIGN KEY (lote_id)
        REFERENCES lote (id) ON DELETE CASCADE
);

-- Product
CREATE TABLE produto (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    lote_id     INT NOT NULL,
    nome        VARCHAR(100) NOT NULL,
    genero      VARCHAR(20)  NOT NULL,
    categoria   VARCHAR(50)  NOT NULL,
    tecido      VARCHAR(50)  NOT NULL,
    tamanho     VARCHAR(10)  NOT NULL,
    preco       DECIMAL(8,2) NOT NULL CHECK (preco >= 0),
    descricao   TEXT,
    composicao  VARCHAR(100),
    imagem      VARCHAR(255),
    CONSTRAINT fk_produto_lote FOREIGN KEY (lote_id)
        REFERENCES lote (id)
);

-- "feita com tecido de" (produto 0..* --- 0..* doacao)
CREATE TABLE produto_doacao (
    produto_id INT NOT NULL,
    doacao_id  INT NOT NULL,
    PRIMARY KEY (produto_id, doacao_id),
    CONSTRAINT fk_pd_produto FOREIGN KEY (produto_id)
        REFERENCES produto (id) ON DELETE CASCADE,
    CONSTRAINT fk_pd_doacao FOREIGN KEY (doacao_id)
        REFERENCES doacao (id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
-- INDICES
-- ------------------------------------------------------------
CREATE INDEX idx_doacao_estado      ON doacao (estado);
CREATE INDEX idx_doacao_utilizador  ON doacao (utilizador_id, data_submissao);
CREATE INDEX idx_pontos_utilizador  ON entrada_pontos (utilizador_id);

-- ------------------------------------------------------------
-- VIEWS
-- ------------------------------------------------------------

-- Resposta de login / criar conta: total_doacoes e kg_recuperados
-- (kg das doacoes ja entregues)
CREATE VIEW vw_utilizador_resumo AS
SELECT u.id,
       u.nome,
       u.email,
       u.tipo,
       u.pontos,
       COUNT(d.id) AS total_doacoes,
       COALESCE(SUM(CASE WHEN d.estado = 'entregue' THEN d.peso_kg END), 0)
           AS kg_recuperados
FROM utilizador u
LEFT JOIN doacao d ON d.utilizador_id = u.id
GROUP BY u.id, u.nome, u.email, u.tipo, u.pontos;

-- Doacoes com dados do doador (GET /doacoes)
-- As fotografias vao numa query a parte (ou GROUP_CONCAT).
CREATE VIEW vw_doacoes_detalhe AS
SELECT d.id,
       d.utilizador_id,
       d.nome_peca,
       d.categoria,
       d.estado_peca,
       d.tecido,
       d.composicao,
       d.observacoes,
       d.estado,
       d.mensagem_estado,
       d.data_submissao,
       u.nome  AS doador_nome,
       u.email AS doador_email,
       pr.nome AS ponto_recolha,
       (e.id IS NOT NULL) AS por_correio
FROM doacao d
JOIN utilizador u          ON u.id = d.utilizador_id
LEFT JOIN ponto_recolha pr ON pr.id = d.ponto_recolha_id
LEFT JOIN envio_correio e  ON e.doacao_id = d.id;

-- Ranking de doadores por pontos
-- (sem RANK() OVER, para funcionar tambem em MySQL 5.7)
CREATE VIEW vw_ranking_pontos AS
SELECT r.id, r.nome, r.pontos, r.total_doacoes, r.kg_recuperados,
       (SELECT COUNT(*) + 1
          FROM vw_utilizador_resumo r2
         WHERE r2.tipo = 'doador' AND r2.pontos > r.pontos) AS posicao
FROM vw_utilizador_resumo r
WHERE r.tipo = 'doador';

-- ------------------------------------------------------------
-- STORED PROCEDURES
-- ------------------------------------------------------------
DELIMITER //

-- PATCH /doacoes/:id/estado
-- Altera o estado; ao passar a 'entregue' soma 120 pontos ao doador
-- e regista o movimento (tudo numa transacao).
CREATE PROCEDURE sp_alterar_estado_doacao(
    IN p_doacao_id INT,
    IN p_estado    VARCHAR(20),
    IN p_mensagem  VARCHAR(255)
)
BEGIN
    DECLARE v_user   INT;
    DECLARE v_antigo VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_estado NOT IN ('em_avaliacao', 'aprovada', 'recusada', 'entregue') THEN
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Estado invalido';
    END IF;

    START TRANSACTION;

    SELECT utilizador_id, estado INTO v_user, v_antigo
    FROM doacao WHERE id = p_doacao_id FOR UPDATE;

    IF v_user IS NULL THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'Doacao inexistente';
    END IF;

    UPDATE doacao
       SET estado = p_estado,
           mensagem_estado = p_mensagem
     WHERE id = p_doacao_id;

    IF p_estado = 'entregue' AND v_antigo <> 'entregue' THEN
        INSERT INTO entrada_pontos (utilizador_id, doacao_id, descricao, quantidade)
        VALUES (v_user, p_doacao_id, 'Doação entregue', 120);

        UPDATE utilizador SET pontos = pontos + 120 WHERE id = v_user;
    END IF;

    COMMIT;
END //

DELIMITER ;
