

const doacaoModel = require('../models/doacaoModel');

const MENSAGENS_POR_DEFEITO = {
  em_avaliacao: 'A equipa está a analisar as fotografias.',
  aprovada: 'Consulte as instruções de entrega.',
  recusada: 'Tecido sem condições de aproveitamento.',
  entregue: 'Doação recebida. Obrigado!',
};

function textoOuNull(valor) {
  const t = typeof valor === 'string' ? valor.trim() : '';
  return t || null; 
}

// GET /doacoes?utilizador=1
async function listar(req, res) {
  const utilizadorId = Number(req.query.utilizador);
  if (!Number.isInteger(utilizadorId) || utilizadorId <= 0) {
    return res
      .status(400)
      .json({ erro: 'Indique o utilizador (ex.: /doacoes?utilizador=1).' });
  }
  const doacoes = await doacaoModel.listarPorUtilizador(utilizadorId);
  res.json({ doacoes });
}

// POST /doacoes
async function submeter(req, res) {
  const b = req.body;
  const utilizadorId = Number(b.utilizador_id);
  const categoria = textoOuNull(b.categoria);
  const estadoPeca = textoOuNull(b.estado_peca);
  const tecido = textoOuNull(b.tecido);

  if (
    !Number.isInteger(utilizadorId) ||
    utilizadorId <= 0 ||
    !categoria ||
    !estadoPeca ||
    !tecido
  ) {
    return res.status(400).json({
      erro: 'Dados inválidos. Indique utilizador, categoria, estado da peça e tecido.',
    });
  }

  const fotografias = Array.isArray(b.fotografias)
    ? b.fotografias.filter((f) => typeof f === 'string' && f.trim())
    : [];

  let id;
  try {
    id = await doacaoModel.criar({
      utilizador_id: utilizadorId,
      categoria,
      estado_peca: estadoPeca,
      tecido,
      composicao: textoOuNull(b.composicao),
      observacoes: textoOuNull(b.observacoes),
      fotografias,
    });
  } catch (err) {
    if (err.code === 'ER_NO_REFERENCED_ROW_2') {
      return res.status(400).json({ erro: 'Utilizador inexistente.' });
    }
    throw err;
  }

  const doacao = await doacaoModel.obter(id);
  res.status(201).json({ doacao });
}

// PATCH /doacoes/:id/estado
async function alterarEstado(req, res) {
  const id = Number(req.params.id);
  const { estado } = req.body;

  if (!Number.isInteger(id) || id <= 0) {
    return res.status(400).json({ erro: 'Identificador inválido.' });
  }
  if (!doacaoModel.ESTADOS.includes(estado)) {
    return res.status(400).json({
      erro: `Estado inválido. Use: ${doacaoModel.ESTADOS.join(', ')}.`,
    });
  }

  const mensagem =
    textoOuNull(req.body.mensagem_estado) || MENSAGENS_POR_DEFEITO[estado];

  try {
    await doacaoModel.alterarEstado(id, estado, mensagem);
  } catch (err) {
    if (err.sqlState === '45002') {
      return res.status(404).json({ erro: 'Doação não encontrada.' });
    }
    if (err.sqlState === '45001') {
      return res.status(400).json({ erro: 'Estado inválido.' });
    }
    throw err;
  }

  const doacao = await doacaoModel.obter(id);
  res.json({ doacao });
}

module.exports = { listar, submeter, alterarEstado };