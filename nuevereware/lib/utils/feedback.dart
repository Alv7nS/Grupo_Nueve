import 'package:flutter/material.dart';

/// Mostra uma mensagem informativa para ações ainda simuladas.
void showInfo(BuildContext context, String message, {SnackBarAction? action}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        action: action,
        duration: const Duration(seconds: 3),
      ),
    );
}

/// Mensagem padrão para funcionalidades previstas para fases seguintes.
void showSimulated(BuildContext context, String feature) {
  showInfo(context, '$feature — funcionalidade simulada neste protótipo.');
}
