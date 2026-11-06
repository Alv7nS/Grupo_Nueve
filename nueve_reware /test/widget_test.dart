import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nueve_reware/main.dart';

void main() {
  testWidgets('Abre no ecrã de autenticação e entra na app', (tester) async {
    await tester.pumpWidget(const NueveReWareApp());
    expect(find.text('Nuevé ReWare'), findsOneWidget);

    // Entrar e verificar a navegação inferior.
    await tester.tap(find.widgetWithText(ElevatedButton, 'Iniciar sessão'));
    await tester.pumpAndSettle();
    expect(find.text('Início'), findsOneWidget);
    expect(find.text('Catálogo'), findsWidgets);
  });
}
