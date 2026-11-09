require('dotenv').config();
const express = require('express');
const cors = require('cors');
const routes = require('./src/routes');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => res.json({ok: true, servico: 'NueveRewear API'}));
app.use(routes);

app.use((req, res) => {
  res.status(404).json({ok: false, error: 'Rota não encontrada'});
});

app.use((err, req, res, next) => {
    if (err.type === 'entity.parse.failed') {
        return res.status(400).json({ erro: 'JSON inválido' });
    }
    console.error(err);
    res.status(500).json({ erro: 'Erro interno do servidor. Tente Novamente' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`API a correr em http://localhost:${PORT}`);
});