
const produtoModel = require('../models/produtoModel');
const pontoRecolhaModel = require('../models/pontoRecolhaModel');

// GET /produtos
async function listarProdutos(req, res) {
  res.json({ produtos: await produtoModel.listar() });
}

// GET /pontos-recolha
async function listarPontosRecolha(req, res) {
  res.json({ pontos_recolha: await pontoRecolhaModel.listar() });
}

module.exports = { listarProdutos, listarPontosRecolha };