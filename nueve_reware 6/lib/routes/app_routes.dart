import 'package:flutter/material.dart';

import '../models/donation.dart';
import '../models/misc_models.dart';
import '../models/product.dart';
import '../screens/admin/admin_review_screen.dart';
import '../screens/admin/admin_shell.dart';
import '../screens/auth/login_screen.dart';
import '../screens/catalog/cart_screen.dart';
import '../screens/catalog/order_confirmed_screen.dart';
import '../screens/catalog/product_detail_screen.dart';
import '../screens/donations/delivery_confirmed_screen.dart';
import '../screens/donations/delivery_instructions_screen.dart';
import '../screens/donations/delivery_qr_screen.dart';
import '../screens/donations/donation_approved_screen.dart';
import '../screens/donations/donation_tracking_screen.dart';
import '../screens/donations/new_donation_screen.dart';
import '../screens/donations/review_donation_screen.dart';
import '../screens/profile/notifications_screen.dart';
import '../screens/profile/points_screen.dart';
import '../screens/profile/privacy_screen.dart';
import '../screens/shell/main_shell.dart';

/// Nomes de rotas centralizados + geração de rotas com argumentos.
class AppRoutes {
  AppRoutes._();

  static const String login = '/';
  static const String shell = '/app'; // argumento opcional: índice do separador (int)

  // Fluxo de doação
  static const String newDonation = '/doacao/nova';
  static const String reviewDonation = '/doacao/revisao'; // Donation
  static const String donationTracking = '/doacao/acompanhar'; // Donation
  static const String donationApproved = '/doacao/aprovada'; // Donation
  static const String deliveryQr = '/doacao/qr'; // DeliveryArgs
  static const String deliveryInstructions = '/doacao/instrucoes'; // DeliveryArgs
  static const String deliveryConfirmed = '/doacao/entregue'; // Donation

  // Fluxo de compra
  static const String productDetail = '/catalogo/peca'; // Product
  static const String cart = '/catalogo/carrinho';
  static const String orderConfirmed = '/catalogo/encomenda'; // String (n.º encomenda)

  // Perfil
  static const String notifications = '/notificacoes';
  static const String points = '/perfil/pontos';
  static const String privacy = '/perfil/privacidade';

  // Gestor
  static const String admin = '/gestor';
  static const String adminReview = '/gestor/avaliar'; // Donation

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    Widget page;

    switch (settings.name) {
      case login:
        page = const LoginScreen();
        break;
      case shell:
        page = MainShell(initialIndex: args is int ? args : 0);
        break;
      case newDonation:
        page = const NewDonationScreen();
        break;
      case reviewDonation:
        page = ReviewDonationScreen(donation: args as Donation);
        break;
      case donationTracking:
        page = DonationTrackingScreen(donation: args as Donation);
        break;
      case donationApproved:
        page = DonationApprovedScreen(donation: args as Donation);
        break;
      case deliveryQr:
        page = DeliveryQrScreen(args: args as DeliveryArgs);
        break;
      case deliveryInstructions:
        page = DeliveryInstructionsScreen(args: args as DeliveryArgs);
        break;
      case deliveryConfirmed:
        page = DeliveryConfirmedScreen(donation: args as Donation);
        break;
      case productDetail:
        page = ProductDetailScreen(product: args as Product);
        break;
      case cart:
        page = const CartScreen();
        break;
      case orderConfirmed:
        page = OrderConfirmedScreen(orderId: args is String ? args : 'E-000');
        break;
      case notifications:
        page = const NotificationsScreen();
        break;
      case points:
        page = const PointsScreen();
        break;
      case privacy:
        page = const PrivacyScreen();
        break;
      case admin:
        page = const AdminShell();
        break;
      case adminReview:
        page = AdminReviewScreen(donation: args as Donation);
        break;
      default:
        page = const LoginScreen();
    }

    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }

  /// Volta ao ecrã principal num separador específico, limpando a pilha.
  static void goToTab(BuildContext context, int index) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      shell,
      (route) => false,
      arguments: index,
    );
  }
}
