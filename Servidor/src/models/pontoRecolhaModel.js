const db = require('../db');

async function listar() {
  const [rows] = await db.query('SELECT * FROM ponto_recolha ORDER BY id');
  return rows.map((p) => ({
    id: p.id,
    nome: p.nome,
    morada: p.morada,
    codigo_postal: p.codigo_postal,
    horario: p.horario,
    latitude: Number(p.latitude),
    longitude: Number(p.longitude),
    como_chegar: p.como_chegar,
    contacto: p.contacto,
  }));
}

module.exports = { listar };