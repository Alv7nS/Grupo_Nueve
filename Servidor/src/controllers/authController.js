
const bcrypt = require('bcrypt');
const utilizadorModel = require('../models/utilizadorModel');

const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

// POST /auth/login
async function login(req, res) {
  const email = String(req.body.email || '').trim().toLowerCase();
  const password = String(req.body.password || '');

  if (!email || !password) {
    return res
      .status(400)
      .json({ erro: 'Preencha o e-mail e a palavra-passe.' });
  }

  const user = await utilizadorModel.procurarPorEmail(email);
  const ok = user && (await bcrypt.compare(password, user.password_hash));
  if (!ok) {
    return res
      .status(401)
      .json({ erro: 'E-mail ou palavra-passe incorretos.' });
  }

  const utilizador = await utilizadorModel.obterResumo(user.id);
  res.json({ utilizador });
}

// POST /utilizadores
async function criarConta(req, res) {
  const nome = String(req.body.nome || '').trim();
  const email = String(req.body.email || '').trim().toLowerCase();
  const password = String(req.body.password || '');
  const consentimento = req.body.consentimento_rgpd === true;

  if (!nome || !EMAIL_RE.test(email) || password.length < 6) {
    return res.status(400).json({
      erro: 'Dados inválidos. Indique nome, e-mail válido e palavra-passe com pelo menos 6 caracteres.',
    });
  }
  if (!consentimento) {
    return res
      .status(400)
      .json({ erro: 'É necessário aceitar o tratamento de dados (RGPD).' });
  }

  if (await utilizadorModel.procurarPorEmail(email)) {
    return res.status(409).json({ erro: 'Este e-mail já está registado.' });
  }

  const passwordHash = await bcrypt.hash(password, 10);
  let id;
  try {
    id = await utilizadorModel.criar({ nome, email, passwordHash });
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({ erro: 'Este e-mail já está registado.' });
    }
    throw err;
  }

  const utilizador = await utilizadorModel.obterResumo(id);
  res.status(201).json({ utilizador });
}

module.exports = { login, criarConta };