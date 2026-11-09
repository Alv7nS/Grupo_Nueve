const db = require('../db');

// Formato do objeto "utilizador" do contrato (o MySQL devolve DECIMAL como texto)
function formatarResumo(r) {
  return {
    id: r.id,
    nome: r.nome,
    email: r.email,
    tipo: r.tipo,
    pontos: Number(r.pontos),
    total_doacoes: Number(r.total_doacoes),
    kg_recuperados: Number(r.kg_recuperados),
  };
}

async function obterResumo(id) {
  const [rows] = await db.query(
    'SELECT * FROM vw_utilizador_resumo WHERE id = ?',
    [id]
  );
  return rows.length ? formatarResumo(rows[0]) : null;
}

// Só para o login: traz o hash (nunca sai para a resposta)
async function procurarPorEmail(email) {
  const [rows] = await db.query(
    'SELECT id, password_hash FROM utilizador WHERE email = ?',
    [email]
  );
  return rows[0] || null;
}

async function criar({ nome, email, passwordHash }) {
  const [res] = await db.query(
    `INSERT INTO utilizador (nome, email, password_hash, tipo, consentimento_rgpd)
     VALUES (?, ?, ?, 'doador', TRUE)`,
    [nome, email, passwordHash]
  );
  return res.insertId;
}

module.exports = { obterResumo, procurarPorEmail, criar };