import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../routes/app_routes.dart';
import '../../services/api_client.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../utils/feedback.dart';
import '../../widgets/app_button.dart';
import '../../widgets/form_fields.dart';
import '../../widgets/notice_box.dart';
import '../../widgets/segmented_tabs.dart';

/// Ecrã de entrada: iniciar sessão / criar conta (via API REST, com modo
/// de demonstração quando o servidor não está disponível).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _tab = 0; // 0 = iniciar sessão, 1 = criar conta
  bool _acceptedTerms = false;

  bool _loading = false;

  final _loginEmail = TextEditingController();
  final _loginPassword = TextEditingController();
  final _registerName = TextEditingController();
  final _registerEmail = TextEditingController();
  final _registerPassword = TextEditingController();

  @override
  void dispose() {
    _loginEmail.dispose();
    _loginPassword.dispose();
    _registerName.dispose();
    _registerEmail.dispose();
    _registerPassword.dispose();
    super.dispose();
  }

  void _enterApp() {
    Navigator.pushReplacementNamed(context, AppRoutes.shell, arguments: 0);
  }

  /// Login na API. Se o servidor não estiver acessível, entra em modo de
  /// demonstração com dados de exemplo (para a app nunca ficar bloqueada).
  Future<void> _login() async {
    if (_loginEmail.text.trim().isEmpty || _loginPassword.text.isEmpty) {
      showInfo(context, 'Preencha o e-mail e a palavra-passe.');
      return;
    }
    setState(() => _loading = true);
    try {
      await AuthService.login(_loginEmail.text, _loginPassword.text);
      if (!mounted) return;
      _enterApp();
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.isConnectionError) {
        MockData.login(_loginEmail.text);
        showInfo(context, '${e.message} A entrar em modo de demonstração.');
        _enterApp();
      } else {
        showInfo(context, e.statusCode == 401 ? 'E-mail ou palavra-passe incorretos.' : e.message);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _createAccount() async {
    if (!_acceptedTerms) {
      showInfo(context, 'Aceite os termos e a política de privacidade para continuar.');
      return;
    }
    if (_registerName.text.trim().isEmpty ||
        !_registerEmail.text.contains('@') ||
        _registerPassword.text.length < 8) {
      showInfo(context, 'Indique nome, e-mail válido e palavra-passe com 8+ caracteres.');
      return;
    }
    setState(() => _loading = true);
    try {
      await AuthService.register(
        _registerName.text,
        _registerEmail.text,
        _registerPassword.text,
      );
      if (!mounted) return;
      showInfo(context, 'Conta criada. Bem-vindo, ${MockData.currentUser.firstName}!');
      _enterApp();
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.isConnectionError) {
        MockData.register(_registerName.text, _registerEmail.text);
        showInfo(context, '${e.message} Conta criada só neste dispositivo (demonstração).');
        _enterApp();
      } else {
        showInfo(context, e.statusCode == 409 ? 'Já existe uma conta com este e-mail.' : e.message);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
        AppTextField(
          key: const ValueKey('login-password'),
          controller: _loginPassword,
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
        AppButton(
          label: _loading ? 'A entrar…' : 'Iniciar sessão',
          onPressed: _loading ? null : _login,
        ),
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
        AppTextField(
          key: const ValueKey('register-password'),
          controller: _registerPassword,
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
        AppButton(
          label: _loading ? 'A criar conta…' : 'Criar conta',
          onPressed: _loading ? null : _createAccount,
        ),
      ];
}
