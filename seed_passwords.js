// seed_passwords.js
// Corre DEPOIS de create.sql e populate.sql.
// Define a password "password123" (com bcrypt) em todos os utilizadores de teste.
//
// Uso (na pasta do servidor):
//   npm install bcrypt mysql2
//   DB_USER=root DB_PASSWORD=a_tua_password node seed_passwords.js

const bcrypt = require('bcrypt');
const mysql = require('mysql2/promise');

(async () => {
  const conn = await mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'nuevereware',
  });

  const hash = await bcrypt.hash('password123', 10);
  const [res] = await conn.execute(
    "UPDATE utilizador SET password_hash = ? WHERE password_hash = 'POR_GERAR'",
    [hash]
  );
  console.log(`Passwords definidas em ${res.affectedRows} utilizadores.`);
  await conn.end();
})().catch((err) => {
  console.error(err);
  process.exit(1);
});
