1.	Identificação do projeto NuevéReware
   
O **NuevéReWare** consiste numa solução móvel e plataforma web orientada à economia circular no setor têxtil. O sistema integra a recolha de vestuário descartado por particulares e a posterior desconstrução e reciclagem desses tecidos para o fabrico de vestuário exclusivo (masculino e feminino), comercializado diretamente no catálogo e loja virtual da aplicação.
________________________________________
2.	Palavras-Chave
   
Upcycling Têxtil, Moda sustentável, Economia circular, Aplicação Móvel, Flutter, REST API, Reconhecimnento de imagem, validação por QR Code.

________________________________________

3.	Descrição Geral e Problema a resolver

  	 ***Descrição da App***
  	A Nuevé ReWare é uma plataforma e aplicação móvel multidisciplinar que operacionaliza um modelo de economia circular no setor da moda. A aplicação permite que os utilizadores se desfaçam de peças de vestuário sem uso, submetendo fotografias e detalhes sobre o estado dos tecidos. A equipa de produção da marca analisa o potencial de reaproveitamento do material e, após a recolha/receção física, desconstrução e higienização, reutiliza as matérias-primas têxteis para criar novas peças de vestuário exclusivas (masculinas e femininas), comercializadas diretamente no catálogo integrado da aplicação.

	***Problema a resolver***
  	
  	**1. Impacto Ambiental da Fast Fashion e Desperdício Têxtil:** Milhares de toneladas de roupa em bom estado ou com tecidos aproveitáveis terminam em aterros sanitários devido à ausência de canais simples para o seu reaproveitamento direto.
  	
  	**2.Custo Elevado de Matérias-Primas Têxteis Sustentáveis:** Marcas de moda ecológica enfrentam custos elevados na aquisição de tecidos reciclados ou orgânicos.
  	
  	**3.Escassez de Peças Exclusivas e Sustentáveis a Preços Acessíveis:** Os consumidores conscientes procuram vestuário com identidade única e pegada ecológica reduzida, mas encontram pouca oferta transparente no mercado.

________________________________________
4.	Objetivos e Motivação
   
    ***Objetivos Principais***
  	
•  Desenvolver uma aplicação móvel multiplataforma (Flutter/Dart) intuitiva e funcional para doação e compra de vestuário sustentável.

•  Implementar um servidor web backend em Node.js suportado pela arquitetura REST para gestão eficiente de utilizadores, submissões de peças e pedidos de compra.

• Projetar e modelar uma Base de Dados relacional em MySQL para assegurar a persistência dos dados de artigos, estados de triagem e histórico de transações.

• Reduzir os custos de produção de matéria-prima têxtil através do reaproveitamento direto de tecidos doados.

• Garantir a conformidade total no tratamento de dados pessoais segundo o RGPD.

***Motivação***

A motivação do grupo assenta na oportunidade de aplicar de forma integrada os conhecimentos adquiridos em Programação de Dispositivos Móveis, Bases de Dados, Redes e Comunicação de Dados, Interfaces e Usabilidade e Matemática Discreta. Pretende-se criar um produto tecnológico real que promova hábitos de consumo sustentáveis e demonstre a viabilidade económica da economia circular na tecnologia móvel.

________________________________________
5.	Público-Alvo
   
•	**Cedentes / Doadores de roupa:** Pessoas de todas as idades que possuem vestuário sem uso em casa e procuram uma solução ecológica e conveniente para lhes dar utilidade, em vez do descarte.

•	Compradores / Consumidores de moda sustentável.

• **Gestores e Artesãos da Marca (Utilizadores Internos/Administração):** Equipa técnica encarregue de avaliar as fotografias enviadas, gerir o inventário de tecidos recebidos e publicar os novos produtos no catálogo da loja.
________________________________________
 6. Pesquisa de Mercado (Análise Comparativa)

| Aplicação / Plataforma | Pontos Fortes | Pontos Fracos | Diferencial do ReFabric |
| :--- | :--- | :--- | :--- |
| **Vinted / OLX** | Grande volume de utilizadores e compra/venda direta . | Não aproveita roupa estragada ou sem valor comercial direto. | Aceita peças danificadas para desconstrução de tecidos e criação de coleções novas. |
| **Too Good To Go** | Modelo eficaz de economia circular e combate ao desperdício. | Focado exclusivamente no setor alimentar. | Aplica a lógica de resgate e valorização de recursos ao vestuário e moda. |
| **Humana / Contentores** | Recolha direta de têxteis em pontos físicos. | Baixa transparência sobre o destino final das peças doadas. | Rastreabilidade total: o doador acompanha as novas peças criadas com o seu tecido. |
   
________________________________________
7.	Casos de utilização e guiões de teste
   
   ***Caso de Utilização 2: Triagem e Validação da Peça (Painel de Gestão***
• **Ator Principal:** Gestor / Administrador.

• **Descrição:** A equipa técnica avalia a viabilidade de reaproveitamento do tecido enviado.

• **Guião de Teste Passo a Passo:**

1. O gestor acede à área administrativa da aplicação e consulta a lista de pedidos em Pendente_Avaliacao.
   
2. Seleciona o registo e analisa as fotografias e especificações submetidas.
   
3. Caso o tecido seja adequado, o gestor clica em "Aprovar Peça", definindo o ponto de recolha mais próximo ou gerando uma guia de envio.
   
4. A aplicação atualiza o estado para Aprovado na base de dados e envia uma notificação push ao doador com as instruções de entrega.
   
**Caso de Utilização 3: Validação da Entrega Física via QR Code**

• Ator Principal: Doador e Operador do Ponto de Recolha

• Descrição: Validação presencial e em tempo real da entrega física da peça no ponto de recolha.

• **Guião de Teste Passo a Passo:**

1. O doador desloca-se ao ponto de recolha parceiro e seleciona o pedido aprovado na app.

2. A aplicação gera um QR Code único de validação no ecrã do doador.
   
3.O operador do ponto de recolha lê o código através do scanner de QR Code da aplicação.

4. A API valida a autenticidade do código, altera o estado para Entregue e atribui pontos de recompensa/desconto ao perfil do doador.

________________________________________
 8. Descrição da Solução a Implementar

### i. Descrição Genérica da Solução
A solução NuevéReWare é composta por uma aplicação móvel para utilizadores finais e gestores, suportada por uma arquitetura em nuvem com API REST intermediária e uma base de dados relacional centralizada.

```text
+-------------------------------------------------------+
|                 APLICAÇÃO MÓVEL                       |
|               (Flutter / Dart / UI)                   |
+---------------------------+---------------------------+
                            |
                 HTTP / REST API (JSON)
                            |
+---------------------------v---------------------------+
|               SERVIDOR BACKEND (REST API)             |
|                 (Node.js / Express)                   |
+---------------------------+---------------------------+
                            |
                     SQL / Driver MySQL
                            |
+---------------------------v---------------------------+
|                 BASE DE DADOS MYSQL                   |
|           (Modelo Relacional Centralizado)            |
+-------------------------------------------------------+
```

---

### ii. Requisitos Técnicos do Projecto

#### Requisitos Funcionais (RF)
* **RF01:** Permitir registo e autenticação segura de utilizadores (Doador, Cliente e Administrador).
* **RF02:** Permitir a captura e envio de imagens através da câmara do dispositivo móvel.
* **RF03:** Disponibilizar um catálogo interativo de peças de vestuário reciclado (masculino/feminino) com filtros por tamanho, categoria e preço.
* **RF04:** Gerar e ler QR Codes para validação de entregas presenciais.
* **RF05:** Calcular e apresentar pontos/descontos acumulados por doações efetuadas.

#### Requisitos Não-Funcionais (RNF)
* **RNF01 (Desempenho):** O tempo de resposta da API REST não deve ultrapassar 2 segundos para operações de leitura.
* **RNF02 (Segurança):** Cumprimento das diretivas do **RGPD**; encriptação de palavras-passe com *hash* seguro.
* **RNF03 (Usabilidade):** Interface responsiva, acessível e desenvolvida segundo os princípios do *Material Design*.
* **RNF04 (Portabilidade):** Compatibilidade com dispositivos Android e iOS através do *framework* Flutter.

---

### iii. Arquitetura da Solução e Tecnologias
* **Design/Prototipagem:** Figma.
* **Frontend Mobile:** Flutter, linguagem Dart.
* **Backend:** Node.js, framework Express.js.
* **Base de Dados:** MySQL (Relacional).
* **Gestão de Versões e Controlo de Projeto:** Git, GitHub, GitHub Projects.

---

________________________________________
9. Planificação e Calendarização Inicial
   
    O projeto desenvolve-se ao longo do semestre com a seguinte distribuição temporal:
   
•	Fase 1 (Atual): Análise de requisitos, definição do problema, mockups e arquitetura inicial.

•	Fase 2: Desenvolvimento do protótipo funcional (frontend e backend), implementação da base de dados e API.

•	Fase 3: Testes de usabilidade, otimizações, elaboração do relatório final, poster e demonstração em vídeo.
________________________________________
10. Conclusão e Objetivos a atingir
    
    A proposta Nuevé ReWare apresenta uma abordagem sólida e inovadora para responder ao problema do desperdício têxtil, aplicando os conceitos técnicos de Engenharia Informática exigidos no 3.º semestre.

Com a conclusão da 1.ª Entrega, o grupo assegura o alinhamento conceptual da equipa, a definição clara dos requisitos técnicos e a calendarização rigorosa do projeto. Os próximos passos focam-se na estruturação da base de dados relacional e no desenvolvimento do servidor REST e do protótipo funcional para a 2.ª Entrega.


