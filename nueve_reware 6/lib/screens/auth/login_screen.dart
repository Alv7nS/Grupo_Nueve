import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../utils/feedback.dart';
import '../../widgets/app_button.dart';
import '../../widgets/form_fields.dart';
import '../../widgets/notice_box.dart';
import '../../widgets/segmented_tabs.dart';

/// Ecrã de entrada: iniciar sessão / criar conta (autenticação simulada).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _tab = 0; // 0 = iniciar sessão, 1 = criar conta
  bool _acceptedTerms = false;

  final _loginEmail = TextEditingController();
  final _registerName = TextEditingController();
  final _registerEmail = TextEditingController();

  @override
  void dispose() {
    _loginEmail.dispose();
    _registerName.dispose();
    _registerEmail.dispose();
    super.dispose();
  }

  void _enterApp() {
    Navigator.pushReplacementNamed(context, AppRoutes.shell, arguments: 0);
  }

  void _login() {
    MockData.login(_loginEmail.text);
    _enterApp();
  }

  void _createAccount() {
    if (!_acceptedTerms) {
      showInfo(context, 'Aceite os termos e a política de privacidade para continuar.');
      return;
    }
    MockData.register(_registerName.text, _registerEmail.text);
    showInfo(
      context,
      'Conta criada (simulado). Bem-vindo, ${MockData.currentUser.firstName}!',
    );
    _enterApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          children: [
            const Text('Nuevé ReWare', style: AppText.brand),
            const SizedBox(height: 32),
            const Text('Uma nova vida para o seu tecido!', style: AppText.section),
            const SizedBox(height: 8),
            const Text(
              'Doe roupa sem uso ou danificada. Descubra peças exclusivas '
              'criadas a partir de tecidos recuperados.',
              style: AppText.bodyMuted,
            ),
            const SizedBox(height: 24),
            UnderlineTabs(
              options: const ['Iniciar sessão', 'Criar conta'],
              selectedIndex: _tab,
              onChanged: (i) => setState(() => _tab = i),
            ),
            const SizedBox(height: 20),
            if (_tab == 0) ..._loginFields() else ..._registerFields(),
            const SizedBox(height: 16),
            Center(
              child: AppButton.text(
                label: 'Explorar catálogo sem iniciar sessão',
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.shell,
                  arguments: 2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const NoticeBox(
              icon: Icons.shield_outlined,
              title: 'Os seus dados, protegidos',
              message: 'Só recolhemos os dados necessários ao serviço (RGPD). '
                  'Pode consultar, corrigir ou pedir a eliminação dos seus dados.',
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.admin),
                icon: const Icon(Icons.admin_panel_settings_outlined, size: 18),
                label: const Text('Entrar como gestor (demo)'),
                style: TextButton.styleFrom(foregroundColor: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text('Privacidade · Termos de utilização · Ajuda', style: AppText.small),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _loginFields() => [
        AppTextField(
          key: const ValueKey('login-email'),
          label: 'E-mail',
          hint: 'O seu endereço de e-mail',
          keyboardType: TextInputType.emailAddress,
          controller: _loginEmail,
        ),
        const SizedBox(height: 16),
        const AppTextField(
          key: ValueKey('login-password'),
          label: 'Palavra-passe',
          hint: 'Introduza a palavra-passe',
          obscure: true,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: AppButton.text(
            label: 'Esqueceu-se da palavra-passe?',
            onPressed: () => showSimulated(context, 'Recuperação de palavra-passe'),
          ),
        ),
        const SizedBox(height: 8),
        AppButton(label: 'Iniciar sessão', onPressed: _login),
        const SizedBox(height: 12),
        AppButton.secondary(
          label: 'Criar uma conta',
          onPressed: () => setState(() => _tab = 1),
        ),
      ];

  List<Widget> _registerFields() => [
        AppTextField(
          key: const ValueKey('register-name'),
          label: 'Nome',
          hint: 'O seu nome',
          controller: _registerName,
        ),
        const SizedBox(height: 16),
        AppTextField(
          key: const ValueKey('register-email'),
          label: 'E-mail',
          hint: 'O seu endereço de e-mail',
          keyboardType: TextInputType.emailAddress,
          controller: _registerEmail,
        ),
        const SizedBox(height: 16),
        const AppTextField(
          key: ValueKey('register-password'),
          label: 'Palavra-passe',
          hint: 'Mínimo 8 caracteres',
          obscure: true,
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          value: _acceptedTerms,
          onChanged: (v) => setState(() => _acceptedTerms = v ?? false),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          activeColor: AppColors.green,
          title: const Text(
            'Li e aceito os termos de utilização e a política de privacidade.',
            style: AppText.small,
          ),
        ),
        const SizedBox(height: 8),
        AppButton(label: 'Criar conta', onPressed: _createAccount),
      ];
}
