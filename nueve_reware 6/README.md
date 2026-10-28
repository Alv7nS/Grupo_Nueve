# Nuevé ReWare — Protótipo da Aplicação Final (Flutter)

**Programação de Dispositivos Móveis · 2026/27 · Grupo G03 (Nuevé)**
Licenciatura em Engenharia Informática — IADE / Universidade Europeia

## Elementos do grupo

| Nome | N.º |
|---|---|
| Alvin Alexandre Sacramento Dias dos Santos | 20251280 |
| Eurica Nelma Brado Costa | 20251534 |
| Cristiane Idalécia Neto Paciência | 20252623 |
| Wesley Tiago Simão Chipango | 20251556 |

Repositório: https://github.com/Alv7nS/Grupo_Nueve

## Tema do projeto

A **Nuevé ReWare** é uma aplicação de economia circular para o setor têxtil. O utilizador
**doa** roupa sem uso (com fotografias e detalhes do tecido), a equipa **avalia** o potencial
de reaproveitamento, a entrega é **validada por QR Code** num ponto de recolha e o tecido é
**transformado** em peças novas e exclusivas, vendidas no **catálogo** da própria aplicação.
Cada doação validada dá **pontos/descontos** ao doador, que pode acompanhar o percurso do
tecido até à nova peça.

O protótipo segue os mockups do Figma do grupo e as cores do Style Guide
(verde `#1F4D3A`, terracota `#A8441F`, creme `#F6F3EC`).

## Como executar

Requisitos: Flutter 3.22 ou superior (Dart 3), Android Studio ou VS Code com emulador/dispositivo.

```bash
cd nueve_reware
flutter create . --project-name nueve_reware   # só na 1.ª vez: gera android/, ios/, web/...
flutter pub get
flutter run
```

> O ZIP não inclui as pastas de plataforma (`android/`, `ios/`, `web/`…) nem pastas geradas
> (`build/`, `.dart_tool/`). O comando `flutter create .` cria-as sem alterar o código em `lib/`.
> Packages usados: `flutter_map` e `latlong2` (mapa). As imagens estão em `assets/images/`.
> O mapa precisa de internet. Para gerar a APK de *release* (não é preciso para `flutter run`),
> confirmem que `android/app/src/main/AndroidManifest.xml` tem
> `<uses-permission android:name="android.permission.INTERNET"/>`.

A aplicação começa em `lib/main.dart`, no ecrã de autenticação. Qualquer e-mail/palavra-passe
permite entrar. O nome mostrado («Olá, …») vem do registo (campo Nome) ou do e-mail usado no
login (ex.: `maria.silva@…` → «Olá, Maria!»). Utilizadores de exemplo: `helio.jose@exemplo.pt`,
`aline.barros@exemplo.pt`. A sessão fica só em memória (`MockData.currentUser`).
Doações, pontos, notificações e encomendas pertencem a cada utilizador: uma conta nova começa
sem doações, com 0 pontos e só com a notificação de boas-vindas. Os pontos são somados quando uma
entrega é validada (+120) e descontados quando são usados no carrinho (−250).

## Ecrãs disponíveis (22 + folhas/diálogos)

**Autenticação**
1. Iniciar sessão / Criar conta (separadores, RGPD, acesso ao catálogo sem conta)

**Utilizador — navegação inferior (Início · Doações · Catálogo · Perfil)**
2. Início — atalhos «Doar roupa» e «Comprar», indicadores, última doação, novidades
3. Minhas doações — lista com filtro Todas / Em curso / Concluídas
4. Catálogo — pesquisa, filtro por género, filtros de tamanho/categoria/preço, grelha de peças
5. Perfil — dados, indicadores, menu da conta e definições

**Fluxo de doação (caso de utilização core, 6 passos)**
6. Nova doação — fotografias (câmara simulada com fotos de roupa danificada), categoria, estado, tecido, composição, observações
7. Rever e submeter — resumo, aceitação dos termos, confirmação
8. Acompanhar doação — linha temporal do pedido (ou motivo de recusa)
9. Doação aprovada — escolha entre ponto de recolha (lista) e envio por correio (o doador escreve a sua morada → cálculo do frete até ao armazém)
10. QR Code de entrega — código único do pedido
10a. Instruções de entrega — **mapa (OpenStreetMap)** e localização escrita do ponto de recolha/armazém, como chegar, passo a passo
11. Entrega confirmada — pontos atribuídos e «próxima vida do tecido»

**Fluxo de compra**
12. Detalhe da peça — informação, compra, história do tecido (lote), cuidados
13. Carrinho / checkout — morada de entrega escrita pelo utilizador → cálculo dos portes por código postal, levantamento em loja, pagamento, uso de pontos, resumo
14. Encomenda confirmada

**Perfil**
15. Pontos e descontos — saldo, progresso, recompensas, histórico
16. Notificações — abre o pedido associado
17. Privacidade e dados (RGPD) — consentimentos e direitos

**Área do gestor (navegação inferior própria: Triagem · Ler QR · Tecidos)**
18. Triagem — pedidos pendentes de avaliação
19. Avaliar pedido — fotografias, especificações, checklist, instruções, aprovar/recusar
20. Ler QR / Entregas — leitura simulada e confirmação da receção
21. Tecidos — lotes recebidos e progresso da transformação

Folhas e diálogos: motivo de recusa (gestor), detalhe do lote, confirmação de terminar sessão.

Acesso à área do gestor: botão **«Entrar como gestor (demo)»** no ecrã inicial ou
**Perfil → Área do gestor (demo)**.

## Percorrer o fluxo completo de doação

Início → *Começar uma doação* → *Continuar para revisão* → aceitar termos → *Confirmar submissão*
→ *Ver acompanhamento* → *Simular aprovação pela equipa (demo)* → *Apresentar QR Code de entrega*
→ *Simular leitura pelo operador (demo)* → Entrega confirmada.

Os pedidos de exemplo em «Minhas doações» abrem diretamente cada estado
(Em avaliação, Aprovada, Entregue, Não aprovada).

## Organização do código

```
lib/
├── main.dart              # arranque (MaterialApp + rotas)
├── routes/app_routes.dart # rotas nomeadas e onGenerateRoute (com argumentos)
├── theme/                 # cores, tipografia e tema (Style Guide)
├── models/                # Donation, Product, AppUser, notificações, lotes...
├── data/mock_data.dart    # dados de exemplo (listas de objetos Dart)
├── utils/feedback.dart    # SnackBars para ações simuladas
├── widgets/               # componentes reutilizáveis
└── screens/               # auth, shell, home, donations, catalog, profile, admin
```

**Widgets reutilizáveis:** `AppButton` (primário/secundário/destaque/texto), `AppCard`,
`StatusBadge`, `DonationCard`, `ProductCard`, `SectionHeader`, `InfoRow`, `TimelineStep` /
`TimelineList`, `AddressShippingForm` (morada + cálculo de portes, usado no carrinho e na doação), `AppTextField`, `AppDropdown`, `SegmentedTabs`, `UnderlineTabs`, `NoticeBox`,
`PageAppBar`, `GarmentPlaceholder`, `StatTile`, `SelectableCard`, `MenuTile`, `ChecklistItem`,
`FlowStepLabel`, `FakeQrCode`.

**Coleções dinâmicas:** `ListView.builder/separated` (doações, notificações, pontos de recolha,
carrinho, recompensas, histórico, triagem, lotes), `ListView` horizontal (novidades) e
`GridView.builder` (catálogo, fotografias da doação).

**Navegação:** rotas nomeadas com `Navigator.pushNamed / pushReplacementNamed /
pushNamedAndRemoveUntil / pop`, `NavigationBar` com `IndexedStack` (utilizador e gestor).

## Funcionalidades simuladas nesta fase

- **Autenticação e registo** — sem validação nem contas reais; o utilizador da sessão é guardado só em memória (`MockData.login` / `MockData.register`).
- **Dados** — todos fictícios, em `lib/data/mock_data.dart`; alterações (nova doação, carrinho,
  aprovação) ficam só em memória e perdem-se ao fechar a app. Sem API REST nem MySQL.
- **Câmara / fotografias** — o botão abre uma «galeria» de fotografias ilustrativas de roupa danificada (rasgos, manchas, desgaste, borboto, etiqueta); a primeira fotografia pré-preenche o formulário, simulando o reconhecimento de imagem.
- **Avaliação pela equipa e leitura do operador** — botões «(demo)» simulam a aprovação e a
  leitura do QR Code para se poder percorrer o fluxo.
- **QR Code** — desenho ilustrativo (não legível); a leitura no gestor é simulada.
- **Portes** — calculados por tabela fictícia a partir do código postal (Lisboa 2,90 €, Continente 4,90 €, Ilhas 7,90 €).
- **Localização do utilizador (GPS)** e **navegação no Google Maps**, **guia de envio**, **pagamento**, **troca de pontos**,
  **contacto com a equipa**, **edição de perfil**, **exportação/eliminação de dados (RGPD)**,
  **notificações push**, **publicação de produtos** — mostram uma SnackBar informativa.
- **Imagens** — ilustrações criadas para o protótipo (não são fotografias reais); na versão final virão da API.
- **Moradas, pontos de recolha e contactos** — fictícios.
