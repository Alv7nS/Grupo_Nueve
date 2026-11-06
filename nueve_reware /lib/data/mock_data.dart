import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../models/donation.dart';
import '../models/misc_models.dart';
import '../models/product.dart';

/// Dados de exemplo (mock data). Na fase seguinte serão substituídos por
/// pedidos à API REST (Node.js + MySQL). Todos os dados são fictícios.
class MockData {
  MockData._();

  /// Sinaliza alterações aos dados em memória (nova doação, carrinho...)
  /// para que os ecrãs abertos se atualizem. Substitui, nesta fase, a
  /// gestão de estado que virá com a integração da API.
  static final ValueNotifier<int> changes = ValueNotifier<int>(0);
  static void notifyChanged() => changes.value++;

  // ---------------------------------------------------------------- Utilizadores
  // ---------------------------------------------------------------- Sessão
  /// Utilizadores "registados" (só em memória, até existir a BD/API).
  static final List<AppUser> users = [
    const AppUser(
      name: 'Hélio José',
      email: 'helio.jose@exemplo.pt',
      role: 'Doador / Cliente',
      points: 320,
      donations: 4,
      kgRecovered: 2.6,
    ),
    const AppUser(
      name: 'Aline Barros',
      email: 'aline.barros@exemplo.pt',
      role: 'Doador / Cliente',
      points: 150,
      donations: 1,
      kgRecovered: 0.8,
    ),
  ];

  /// Utilizador com sessão iniciada (preenchido no login/registo).
  static AppUser currentUser = users.first;

  /// Login simulado: se o e-mail existir na lista usa esse utilizador;
  /// caso contrário cria um a partir do e-mail (maria.silva@... → Maria Silva).
  static void login(String email) {
    final e = email.trim().toLowerCase();
    final match = users.where((u) => u.email.toLowerCase() == e);
    if (match.isNotEmpty) {
      currentUser = match.first;
      return;
    }
    final base = e.contains('@') ? e.split('@').first : e;
    final name = base
        .split(RegExp(r'[._-]'))
        .where((p) => p.isNotEmpty)
        .map((p) => p[0].toUpperCase() + p.substring(1))
        .join(' ');
    currentUser = AppUser(
      name: name.isEmpty ? 'Utilizador' : name,
      email: e.isEmpty ? 'sem-email@exemplo.pt' : e,
      role: 'Doador / Cliente',
      points: 0,
      donations: 0,
      kgRecovered: 0,
    );
    users.add(currentUser);
  }

  /// Registo simulado: guarda o novo utilizador e inicia sessão com ele.
  static void register(String name, String email) {
    final user = AppUser(
      name: name.trim().isEmpty ? 'Utilizador' : name.trim(),
      email: email.trim().isEmpty ? 'sem-email@exemplo.pt' : email.trim(),
      role: 'Doador / Cliente',
      points: 0,
      donations: 0,
      kgRecovered: 0,
    );
    users.add(user);
    currentUser = user;
    _notifications[user.email] = [
      const AppNotification(
        title: 'Bem-vindo à Nuevé ReWare!',
        body: 'Faça a sua primeira doação para começar a ganhar pontos.',
        time: 'Agora',
        icon: Icons.waving_hand_outlined,
        unread: true,
      ),
    ];
  }

  // ---------------------------------------------------------------- Dados do utilizador atual
  /// Doações de quem tem sessão iniciada (uma conta nova começa sem doações).
  static List<Donation> get myDonations =>
      donations.where((d) => d.donorEmail == currentUser.email).toList();

  static List<PointsEntry> get myPointsHistory =>
      _pointsHistory[currentUser.email] ?? const [];

  static List<AppNotification> get myNotifications =>
      _notifications[currentUser.email] ?? const [];

  static int get myOrdersCount => _orders[currentUser.email] ?? 0;

  /// Soma (ou desconta) pontos a um utilizador e regista o movimento.
  static void addPoints(String email, int amount, String description) {
    final i = users.indexWhere((u) => u.email == email);
    if (i >= 0) {
      users[i] = users[i].copyWith(points: users[i].points + amount);
      if (currentUser.email == email) currentUser = users[i];
    } else if (currentUser.email == email) {
      currentUser = currentUser.copyWith(points: currentUser.points + amount);
    }
    (_pointsHistory[email] ??= []).insert(
      0,
      PointsEntry(description: description, date: 'Hoje', amount: amount),
    );
    notifyChanged();
  }

  static int _nextOrder = 118;

  /// Regista uma encomenda do utilizador atual e devolve o número.
  static String addOrder() {
    _orders[currentUser.email] = myOrdersCount + 1;
    notifyChanged();
    return 'E-${_nextOrder++}';
  }

  static const AppUser manager = AppUser(
    name: 'Equipa Nuevé',
    email: 'gestao@nueve-reware.pt',
    role: 'Gestor',
    points: 0,
    donations: 0,
    kgRecovered: 0,
  );

  // ---------------------------------------------------------------- Opções de formulário
  static const List<String> categories = [
    'Camisa',
    'T-shirt',
    'Calças',
    'Casaco',
    'Vestido',
    'Camisola',
    'Outro',
  ];

  static const List<String> conditions = [
    'Como nova',
    'Usada, em bom estado',
    'Danificada, com tecido aproveitável',
    'Muito danificada',
  ];

  static const List<String> fabrics = [
    'Algodão',
    'Ganga',
    'Linho',
    'Lã',
    'Poliéster / sintético',
    'Misto',
    'Não sei',
  ];

  static const List<String> sizes = ['Todos', 'XS', 'S', 'M', 'L', 'XL'];
  static const List<String> productCategories = [
    'Todas',
    'Camisas',
    'Calças',
    'Casacos',
    'Coletes',
  ];
  static const List<String> priceRanges = [
    'Qualquer preço',
    'Até 40 €',
    '40 € — 60 €',
    'Mais de 60 €',
  ];

  // ---------------------------------------------------------------- Doações
  /// Lista mutável para que novas submissões apareçam em «Minhas doações».
  static final List<Donation> donations = [
    const Donation(
      id: 'D-024',
      garment: 'Camisa de algodão',
      category: 'Camisa',
      condition: 'Danificada',
      fabric: 'Algodão',
      composition: '100% algodão',
      notes: 'Rasgo na manga direita; restante tecido em bom estado.',
      submittedAt: '12 set., 14:20',
      donorName: 'Hélio José',
      donorEmail: 'helio.jose@exemplo.pt',
      status: DonationStatus.inReview,
      statusMessage: 'A equipa está a analisar as fotografias.',
      photos: ['assets/images/donations/camisa_rasgo.jpg', 'assets/images/donations/camisa_rasgo_detalhe.jpg', 'assets/images/donations/etiqueta.jpg'],
    ),
    const Donation(
      id: 'D-023',
      garment: 'Calças de ganga',
      category: 'Calças',
      condition: 'Usada, em bom estado',
      fabric: 'Ganga',
      composition: '98% algodão, 2% elastano',
      notes: 'Desgaste nos joelhos.',
      submittedAt: '10 set., 09:05',
      donorName: 'Hélio José',
      donorEmail: 'helio.jose@exemplo.pt',
      status: DonationStatus.approved,
      statusMessage: 'Consulte as instruções de entrega.',
      photos: ['assets/images/donations/calcas_desgaste.jpg'],
    ),
    const Donation(
      id: 'D-019',
      garment: 'Casaco de linho',
      category: 'Casaco',
      condition: 'Usada, em bom estado',
      fabric: 'Linho',
      composition: '100% linho',
      notes: 'Sem danos visíveis.',
      submittedAt: '04 set., 18:40',
      donorName: 'Hélio José',
      donorEmail: 'helio.jose@exemplo.pt',
      status: DonationStatus.delivered,
      statusMessage: 'Tecido recebido. Preparação em curso.',
      photos: ['assets/images/donations/casaco_linho.jpg'],
    ),
    const Donation(
      id: 'D-017',
      garment: 'Camisola sintética',
      category: 'Camisola',
      condition: 'Muito danificada',
      fabric: 'Poliéster / sintético',
      composition: '100% acrílico',
      notes: 'Borboto em toda a peça.',
      submittedAt: '02 set., 11:15',
      donorName: 'Hélio José',
      donorEmail: 'helio.jose@exemplo.pt',
      status: DonationStatus.rejected,
      statusMessage:
          'Fibra sintética com desgaste elevado — não pode ser reaproveitada.',
      photos: ['assets/images/donations/camisola_borboto.jpg'],
    ),
    const Donation(
      id: 'D-025',
      garment: 'Vestido de viscose',
      category: 'Vestido',
      condition: 'Usada, em bom estado',
      fabric: 'Misto',
      composition: '70% viscose, 30% poliéster',
      notes: 'Pequena mancha na bainha.',
      submittedAt: '13 set., 10:02',
      donorName: 'Aline Barros',
      donorEmail: 'aline.barros@exemplo.pt',
      status: DonationStatus.inReview,
      statusMessage: 'Aguarda avaliação.',
      photos: ['assets/images/donations/vestido_mancha.jpg'],
    ),
  ];

  /// Pedidos pendentes vistos pelo gestor (vários doadores).
  static final List<Donation> pendingReview = [
    donations.firstWhere((d) => d.id == 'D-024'),
    donations.firstWhere((d) => d.id == 'D-025'),
    const Donation(
      id: 'D-026',
      garment: 'T-shirt de algodão',
      category: 'T-shirt',
      condition: 'Danificada, com tecido aproveitável',
      fabric: 'Algodão',
      composition: '100% algodão',
      notes: 'Manchas de óleo na frente.',
      submittedAt: '13 set., 16:47',
      donorName: 'Marta Lopes',
      donorEmail: 'marta.lopes@exemplo.pt',
      status: DonationStatus.inReview,
      statusMessage: 'Aguarda avaliação.',
      photos: ['assets/images/donations/tshirt_mancha.jpg'],
    ),
  ];

  /// Atualiza um pedido existente (simula PUT /donations/:id) e devolve-o.
  static Donation updateDonation(Donation updated) {
    final i = donations.indexWhere((d) => d.id == updated.id);
    if (i >= 0) donations[i] = updated;
    notifyChanged();
    return updated;
  }

  static int _nextDonationNumber = 27;
  static String nextDonationId() => 'D-0${_nextDonationNumber++}';

  // ---------------------------------------------------------------- Catálogo
  static const List<Product> products = [
    Product(
      id: 'P-008',
      name: 'Camisa reconstruída',
      gender: 'Feminino',
      category: 'Camisas',
      fabric: 'Algodão',
      size: 'M',
      price: 42.00,
      description:
          'Camisa de corte descontraído, construída a partir de painéis de '
          'algodão recuperado. Cada peça tem uma combinação própria de tecidos.',
      composition: '100% algodão recuperado',
      lot: 'T-008',
      image: 'assets/images/products/camisa_reconstruida.jpg',
      history: [
        'Doação de uma camisa de algodão',
        'Desconstrução e higienização',
        'Nova peça criada pelos artesãos',
      ],
    ),
    Product(
      id: 'P-011',
      name: 'Calças de ganga',
      gender: 'Masculino',
      category: 'Calças',
      fabric: 'Ganga',
      size: 'L',
      price: 58.00,
      description:
          'Calças direitas feitas com ganga de três peças doadas. Costuras '
          'reforçadas e bolsos em tecido contrastante.',
      composition: '98% algodão, 2% elastano',
      lot: 'T-011',
      image: 'assets/images/products/calcas_ganga.jpg',
      history: [
        'Doação de três calças de ganga',
        'Corte das zonas sem desgaste',
        'Montagem e acabamento à mão',
      ],
      icon: Icons.straighten,
    ),
    Product(
      id: 'P-014',
      name: 'Colete de linho',
      gender: 'Feminino',
      category: 'Coletes',
      fabric: 'Linho',
      size: 'S',
      price: 38.00,
      description:
          'Colete leve em linho natural, ideal para sobrepor. Botões '
          'reaproveitados das peças originais.',
      composition: '100% linho',
      lot: 'T-014',
      image: 'assets/images/products/colete_linho.jpg',
      history: [
        'Doação de um casaco de linho',
        'Lavagem e passagem a vapor',
        'Novo colete com botões originais',
      ],
    ),
    Product(
      id: 'P-016',
      name: 'Camisa em patchwork',
      gender: 'Masculino',
      category: 'Camisas',
      fabric: 'Algodão',
      size: 'M',
      price: 49.00,
      description:
          'Camisa em patchwork com cinco tecidos de algodão diferentes. '
          'Peça única e numerada.',
      composition: '100% algodão recuperado',
      lot: 'T-016',
      image: 'assets/images/products/camisa_patchwork.jpg',
      history: [
        'Doação de cinco camisas',
        'Seleção de painéis por cor',
        'Patchwork montado pelos artesãos',
      ],
    ),
    Product(
      id: 'P-019',
      name: 'Casaco acolchoado',
      gender: 'Feminino',
      category: 'Casacos',
      fabric: 'Misto',
      size: 'L',
      price: 74.00,
      description:
          'Casaco curto acolchoado com exterior em ganga e forro de algodão '
          'reaproveitado.',
      composition: 'Ganga e algodão recuperados',
      lot: 'T-019',
      image: 'assets/images/products/casaco_acolchoado.jpg',
      history: [
        'Doação de ganga e lençóis',
        'Corte e acolchoamento',
        'Casaco finalizado e numerado',
      ],
    ),
    Product(
      id: 'P-021',
      name: 'Sobrecamisa de lã',
      gender: 'Masculino',
      category: 'Casacos',
      fabric: 'Lã',
      size: 'XL',
      price: 66.00,
      description:
          'Sobrecamisa quente feita a partir de camisolas de lã feltradas.',
      composition: '80% lã, 20% poliamida',
      lot: 'T-021',
      image: 'assets/images/products/sobrecamisa_la.jpg',
      history: [
        'Doação de camisolas de lã',
        'Feltragem e corte',
        'Sobrecamisa costurada à mão',
      ],
    ),
  ];

  /// Carrinho em memória (sem persistência nesta fase).
  static final List<Product> cart = [];

  // ---------------------------------------------------------------- Entrega
  static const List<CollectionPoint> collectionPoints = [
    CollectionPoint(
      name: 'Ponto de recolha · Alcântara',
      address: 'Rua de Exemplo, 10',
      postalCode: '1300-001 Lisboa',
      hours: 'Segunda a sexta, 10:00–18:00',
      distance: '1,2 km',
      lat: 38.7046,
      lng: -9.1772,
      directions: 'Comboio: estação de Alcântara-Mar (5 min a pé). '
          'Autocarro: paragem Alcântara (Largo do Calvário).',
      contact: '210 000 001 · Exemplo',
    ),
    CollectionPoint(
      name: 'Ponto de recolha · Santos',
      address: 'Avenida Fictícia, 45',
      postalCode: '1200-002 Lisboa',
      hours: 'Terça a sábado, 11:00–19:00',
      distance: '2,8 km',
      lat: 38.7071,
      lng: -9.1565,
      directions: 'Comboio: estação de Santos (3 min a pé). Elétrico 25.',
      contact: '210 000 002 · Exemplo',
    ),
    CollectionPoint(
      name: 'Loja Nuevé · Chiado',
      address: 'Largo Ilustrativo, 3',
      postalCode: '1200-003 Lisboa',
      hours: 'Todos os dias, 10:00–20:00',
      distance: '3,5 km',
      lat: 38.7107,
      lng: -9.1424,
      directions: 'Metro: Baixa-Chiado (linhas azul e verde), saída Chiado.',
      contact: '210 000 003 · Exemplo',
    ),
  ];

  /// Armazém que recebe as peças enviadas por correio.
  static const CollectionPoint warehouse = CollectionPoint(
    name: 'Armazém Nuevé ReWare',
    address: 'Rua Fictícia, 200',
    postalCode: '1950-004 Lisboa',
    hours: 'Receção de encomendas: segunda a sexta, 09:00–17:00',
    distance: '—',
    lat: 38.7480,
    lng: -9.1050,
    directions: 'Envie por correio registado com o QR Code impresso dentro da '
        'embalagem, usando a guia de envio gerada na aplicação.',
    contact: 'gestao@nueve-reware.pt · Exemplo',
  );

  // ---------------------------------------------------------------- Fotografias de exemplo
  /// «Galeria» usada para simular a câmara na nova doação (peças danificadas).
  static const List<SamplePhoto> samplePhotos = [
    SamplePhoto(
      asset: 'assets/images/donations/camisa_rasgo.jpg',
      label: 'Camisa · frente',
      category: 'Camisa',
      condition: 'Danificada, com tecido aproveitável',
      fabric: 'Algodão',
      composition: '100% algodão',
      notes: 'Rasgo na manga esquerda. O restante tecido está em bom estado.',
    ),
    SamplePhoto(asset: 'assets/images/donations/camisa_rasgo_detalhe.jpg', label: 'Rasgo · detalhe'),
    SamplePhoto(asset: 'assets/images/donations/etiqueta.jpg', label: 'Etiqueta', composition: '100% algodão'),
    SamplePhoto(
      asset: 'assets/images/donations/tshirt_mancha.jpg',
      label: 'T-shirt manchada',
      category: 'T-shirt',
      condition: 'Danificada, com tecido aproveitável',
      fabric: 'Algodão',
      composition: '100% algodão',
      notes: 'Manchas de óleo na frente que não saem com lavagem.',
    ),
    SamplePhoto(
      asset: 'assets/images/donations/calcas_desgaste.jpg',
      label: 'Calças gastas',
      category: 'Calças',
      condition: 'Danificada, com tecido aproveitável',
      fabric: 'Ganga',
      composition: '98% algodão, 2% elastano',
      notes: 'Desgaste e furos nos joelhos e na bainha.',
    ),
    SamplePhoto(
      asset: 'assets/images/donations/camisola_borboto.jpg',
      label: 'Camisola com borboto',
      category: 'Camisola',
      condition: 'Muito danificada',
      fabric: 'Poliéster / sintético',
      composition: '100% acrílico',
      notes: 'Borboto em toda a peça e um pequeno furo no peito.',
    ),
    SamplePhoto(
      asset: 'assets/images/donations/casaco_linho.jpg',
      label: 'Casaco de linho',
      category: 'Casaco',
      condition: 'Usada, em bom estado',
      fabric: 'Linho',
      composition: '100% linho',
      notes: 'Pequena mancha junto ao bolso.',
    ),
    SamplePhoto(
      asset: 'assets/images/donations/vestido_mancha.jpg',
      label: 'Vestido manchado',
      category: 'Vestido',
      condition: 'Danificada, com tecido aproveitável',
      fabric: 'Misto',
      composition: '70% viscose, 30% poliéster',
      notes: 'Mancha escura na saia.',
    ),
  ];

  // ---------------------------------------------------------------- Portes (compras)
  /// Cálculo simulado dos portes a partir do código postal (formato 0000-000).
  /// Devolve null se o código postal for inválido.
  static ShippingQuote? shippingFor(String postalCode) {
    final cp = postalCode.trim();
    if (!RegExp(r'^\d{4}-\d{3}$').hasMatch(cp)) return null;
    final prefix = int.parse(cp.substring(0, 4));
    if (prefix >= 9000) {
      return (price: 7.90, zone: 'Regiões Autónomas (Açores / Madeira)', eta: '4 a 6 dias úteis');
    }
    if (prefix < 2000 || (prefix >= 2600 && prefix < 2900)) {
      return (price: 2.90, zone: 'Lisboa e área metropolitana', eta: '1 a 2 dias úteis');
    }
    return (price: 4.90, zone: 'Portugal continental', eta: '2 a 3 dias úteis');
  }

  // ---------------------------------------------------------------- Pontos
  static final Map<String, List<PointsEntry>> _pointsHistory = {
    'helio.jose@exemplo.pt': [
      const PointsEntry(description: 'Entrega validada · D-019', date: '16 set.', amount: 120),
      const PointsEntry(description: 'Desconto usado · Encomenda E-102', date: '08 set.', amount: -100),
      const PointsEntry(description: 'Entrega validada · D-015', date: '28 ago.', amount: 150),
      const PointsEntry(description: 'Bónus de boas-vindas', date: '20 ago.', amount: 150),
    ],
    'aline.barros@exemplo.pt': [
      const PointsEntry(description: 'Campanha de lançamento', date: '01 set.', amount: 150),
    ],
  };

  /// Número de encomendas por utilizador (só para os indicadores do perfil).
  static final Map<String, int> _orders = {'helio.jose@exemplo.pt': 1};

  static const List<Reward> rewards = [
    Reward(title: '5 € de desconto', subtitle: 'Em qualquer peça do catálogo', cost: 250),
    Reward(title: '10 € de desconto', subtitle: 'Em compras acima de 40 €', cost: 450),
    Reward(title: 'Portes grátis', subtitle: 'Na próxima encomenda', cost: 150),
  ];

  // ---------------------------------------------------------------- Notificações
  static final Map<String, List<AppNotification>> _notifications = {
    'helio.jose@exemplo.pt': [
      const AppNotification(
        title: 'Doação aprovada',
        body: 'As suas calças de ganga (D-023) foram aprovadas. Veja as instruções de entrega.',
        time: 'Há 2 h',
        icon: Icons.verified_outlined,
        unread: true,
        donationId: 'D-023',
      ),
      const AppNotification(
        title: 'Pedido em avaliação',
        body: 'Recebemos as fotografias da camisa de algodão (D-024).',
        time: 'Ontem',
        icon: Icons.hourglass_top_outlined,
        unread: true,
        donationId: 'D-024',
      ),
      const AppNotification(
        title: 'Pontos atribuídos',
        body: 'Ganhou 120 pontos pela entrega do casaco de linho.',
        time: '16 set.',
        icon: Icons.stars_outlined,
      ),
      const AppNotification(
        title: 'Nova peça com o seu tecido',
        body: 'O linho que doou deu origem ao «Colete de linho». Veja no catálogo.',
        time: '15 set.',
        icon: Icons.auto_awesome_outlined,
      ),
    ],
    'aline.barros@exemplo.pt': [
      const AppNotification(
        title: 'Pedido em avaliação',
        body: 'Recebemos as fotografias do vestido de viscose (D-025).',
        time: 'Ontem',
        icon: Icons.hourglass_top_outlined,
        unread: true,
        donationId: 'D-025',
      ),
    ],
  };

  // ---------------------------------------------------------------- Gestor
  static const List<FabricLot> fabricLots = [
    FabricLot(id: 'T-021', fabric: 'Lã', origin: '4 camisolas', kg: 1.8, stage: 'Desconstrução', progress: 0.35),
    FabricLot(id: 'T-019', fabric: 'Ganga + algodão', origin: '3 calças, 2 lençóis', kg: 3.1, stage: 'Confeção', progress: 0.7),
    FabricLot(id: 'T-016', fabric: 'Algodão', origin: '5 camisas', kg: 1.2, stage: 'Publicado no catálogo', progress: 1.0),
    FabricLot(id: 'T-014', fabric: 'Linho', origin: '1 casaco (D-019)', kg: 0.6, stage: 'Higienização', progress: 0.2),
  ];

  static const List<String> deliveryMethods = [
    'Ponto de recolha e envio por correio',
    'Apenas ponto de recolha',
    'Apenas envio por correio',
  ];
}
