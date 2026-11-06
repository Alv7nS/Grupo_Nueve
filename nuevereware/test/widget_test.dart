import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nueve_reware/main.dart';
import 'package:nueve_reware/services/api_config.dart';

void main() {
  testWidgets('Abre no ecrã de autenticação e entra (modo offline)', (tester) async {
    ApiConfig.offlineMode = true; // os testes não dependem do servidor

    await tester.pumpWidget(const NueveReWareApp());
    expect(find.text('Nuevé ReWare'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'maria.silva@exemplo.pt');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Iniciar sessão'));
    await tester.pumpAndSettle();

    expect(find.text('Olá, Maria!'), findsOneWidget);
    expect(find.text('Catálogo'), findsWidgets);
  });
}
