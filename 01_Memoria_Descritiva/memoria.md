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
6.	Pesquisa de Mercado (Análise Comparativa)
   
| Aplicação / Plataforma | Pontos Fortes | Pontos Fracos / Limitações | Diferencial do ReFabric |
| :--- | :--- | :--- | :--- |
| **Vinted / OLX** | Grande volume de utilizadores e facilidade de venda direta.| Não resolve o problema do tecido estragado/sem valor comercial; sem processo de transformação industrial. | O ReFabric aceita peças para desconstrução de tecidos e criação de peças totalmente novas. |
| **Too Good To Go** | Excelente modelo de economia circular e combate ao desperdício. | Focado exclusivamente no setor alimentar. | Aplica a lógica de resgate e valorização ao setor da moda e vestuário. |
| **Humana / Contentores Têxteis** | Recolha direta de vestuário em pontos físicos. | Falta de transparência; o doador não sabe o destino final nem o impacto do seu gesto. | Rastreabilidade total: a app mostra que novas peças foram criadas a partir do tecido doado. |
   
  



________________________________________
6.	Levantamento Inicial de Requisitos
   
Requisitos Funcionais (RF)
•	RF01 (Investigador): Criar e gerir estudos etnográficos e atribuir tarefas diárias.
•	RF02 (Investigador): Acompanhar o progresso dos participantes através de um dashboard.
•	RF03 (Participante): Submeter entradas de diário em formato de texto, imagem, áudio e vídeo.
•	RF04 (Participante): Receber notificações e lembretes para o preenchimento de tarefas.
•	RF05 (Geral): Sistema de autenticação e gestão de perfil de utilizador.

Requisitos Não Funcionais (RNF)
•	RNF01: Interface intuitiva e adaptada a dispositivos móveis (Android e iOS).
•	RNF02: Segurança no armazenamento dos dados multimédia dos participantes.
•	RNF03: Comunicação via REST API com o backend do sistema.
________________________________________
7. Planificação e Calendarização Inicial
   
    O projeto desenvolve-se ao longo do semestre com a seguinte distribuição temporal:
•	Fase 1 (Atual): Análise de requisitos, definição do problema, mockups e arquitetura inicial.
•	Fase 2: Desenvolvimento do protótipo funcional (frontend e backend), implementação da base de dados e API.
•	Fase 3: Testes de usabilidade, otimizações, elaboração do relatório final, poster e demonstração em vídeo.

