

const db = require('../db');

async function listar() {
  const [produtos] = await db.query('SELECT * FROM produto ORDER BY id');
  if (!produtos.length) return [];

  const loteIds = [...new Set(produtos.map((p) => p.lote_id))];
  const [etapas] = await db.query(
    'SELECT lote_id, descricao FROM lote_etapa WHERE lote_id IN (?) ORDER BY lote_id, ordem',
    [loteIds]
  );

  const historiaPorLote = {};
  for (const e of etapas) {
    (historiaPorLote[e.lote_id] ||= []).push(e.descricao);
  }

  return produtos.map((p) => ({
    id: p.id,
    nome: p.nome,
    genero: p.genero,
    categoria: p.categoria,
    tecido: p.tecido,
    tamanho: p.tamanho,
    preco: Number(p.preco),
    descricao: p.descricao,
    composicao: p.composicao,
    lote_id: p.lote_id,
    imagem: p.imagem,
    historia: historiaPorLote[p.lote_id] || [],
  }));
}

module.exports = { listar };