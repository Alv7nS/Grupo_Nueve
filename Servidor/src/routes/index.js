const express = require('express');
const auth = require('../controllers/authController');
const doacoes = require('../controllers/doacaoController');
const catalogo = require('../controllers/catalogoController');

const router = express.Router();

const ah = (fn) => (req, res, next) =>
  Promise.resolve(fn(req, res, next)).catch(next);

//inciiar sessao e criar conta
router.post('/auth/login', ah(auth.login));
router.post('/utilizadores', ah(auth.criarConta));

// listar e submeter o estado
router.get('/doacoes', ah(doacoes.listar));
router.post('/doacoes', ah(doacoes.submeter));
router.patch('/doacoes/:id/estado', ah(doacoes.alterarEstado));

// catalogo e ponto recolha
router.get('/produtos', ah(catalogo.listarProdutos));
router.get('/pontos-recolha', ah(catalogo.listarPontosRecolha));

module.exports = router;