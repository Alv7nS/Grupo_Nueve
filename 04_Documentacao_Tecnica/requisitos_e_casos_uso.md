# Especificação Técnica e Casos de Utilização — NuevéReware

## 1. Requisitos Funcionais (RF)

| ID | Nome | Descrição | Ator Principal |
| :--- | :--- | :--- | :--- |
| **RF01** | Registo e Autenticação | O utilizador pode criar conta e autenticar-se na aplicação. | Todos |
| **RF02** | Submeter Doação de Roupa | O cedente envia fotografias, tipo de tecido e estado da peça em desuso. | Cedente / Doador |
| **RF03** | Avaliar Doação / Triagem | A equipa técnica avalia a viabilidade dos tecidos e aprova/rejeita a doação. | Gestor / Artesão |
| **RF04** | Gerir Inventário de Materiais | Registar e catalogar os tecidos recolhidos para novos projetos de upcycling. | Gestor / Artesão |
| **RF05** | Publicar Produto Upcycled | Disponibilizar a nova peça de vestuário redesenhada no catálogo da loja. | Gestor / Artesão |
| **RF06** | Registo do Diário de Roupa | O comprador envia fotos e notas sobre a utilização, conforto e lavagem da peça. | Comprador Sustentável |
| **RF07** | Painel de Impacto Ambiental | Visualizar estatísticas de peças salvas do descarte e estimativa de recursos poupados. | Todos |

---

## 2. Requisitos Não Funcionais (RNF)

* **RNF01 (Desempenho):** O tempo de carregamento do catálogo e submissão de imagens não deve exceder 3 segundos em ligações 4G/5G.
* **RNF02 (Usabilidade):** Interface intuitiva e adaptada a dispositivos móveis (Android e iOS) seguindo diretrizes de acessibilidade.
* **RNF03 (Segurança):** Comunicação encriptada via HTTPS/TLS e proteção de dados pessoais (RGPD).
* **RNF04 (Portabilidade):** Aplicação desenvolvida com tecnologia multiplataforma (React Native ou Flutter).

---

## 3. Especificação dos Casos de Utilização (UC)

### Caso de Utilização 1: Submeter Doação de Roupa (UC01)
* **Ator Principal:** Cedente / Doador de Roupa.
* **Pré-condições:** Utilizador com sessão iniciada na aplicação.
* **Fluxo Principal:**
  1. O utilizador acede ao menu "Doar Roupa".
  2. O utilizador captura ou carrega fotos da peça de vestuário.
  3. Preenche a descrição, tipo de tecido e estado de conservação.
  4. O sistema valida os dados e guarda a submissão com o estado "Pendente de Avaliação".
  5. O sistema envia uma notificação de confirmação ao utilizador.

### Caso de Utilização 2: Registo no Diário de Utilização (UC02)
* **Ator Principal:** Comprador / Consumidor de Moda Sustentável.
* **Pré-condições:** Utilizador autenticado e associado a uma peça da linha NuevéReware.
* **Fluxo Principal:**
  1. O utilizador acede à secção "Os Meus Diários".
  2. Seleciona a peça de vestuário que está a utilizar.
  3. Insere uma nota de texto ou foto referente à utilização, conforto ou lavagem da peça.
  4. O sistema regista o diário e atualiza o histórico do utilizador.
