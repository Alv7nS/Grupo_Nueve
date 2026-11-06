import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

InputDecoration _decoration(String? hint, {Widget? suffix}) {
  OutlineInputBorder border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: c),
      );
  return InputDecoration(
    hintText: hint,
    hintStyle: AppText.bodyMuted,
    filled: true,
    fillColor: AppColors.surface,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    suffixIcon: suffix,
    enabledBorder: border(AppColors.border),
    focusedBorder: border(AppColors.green),
    border: border(AppColors.border),
  );
}

/// Rótulo + campo de texto, com o estilo comum dos formulários.
class AppTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscure;
  final int maxLines;
  final TextInputType? keyboardType;
  final IconData? suffixIcon;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscure = false,
    this.maxLines = 1,
    this.keyboardType,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _hidden = widget.obscure;

  /// Correção: quando o Flutter reaproveita este estado para outro campo
  /// (ex.: ao trocar entre «Iniciar sessão» e «Criar conta»), o campo de
  /// e-mail herdava o modo «oculto» da palavra-passe e aparecia em bolinhas.
  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscure != widget.obscure) {
      _hidden = widget.obscure;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? suffix;
    if (widget.obscure) {
      suffix = IconButton(
        tooltip: _hidden ? 'Mostrar' : 'Ocultar',
        icon: Icon(_hidden ? Icons.visibility_off_outlined : Icons.visibility_outlined),
        onPressed: () => setState(() => _hidden = !_hidden),
      );
    } else if (widget.suffixIcon != null) {
      suffix = Icon(widget.suffixIcon, color: AppColors.textMuted);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(widget.label, style: AppText.label),
          const SizedBox(height: 6),
        ],
        TextField(
          controller: widget.controller,
          obscureText: widget.obscure && _hidden,
          maxLines: widget.obscure ? 1 : widget.maxLines,
          keyboardType: widget.obscure
              ? TextInputType.visiblePassword
              : (widget.keyboardType ??
                  (widget.maxLines > 1 ? TextInputType.multiline : TextInputType.text)),
          // Texto livre aceita acentuação, cedilha e @ normalmente.
          autocorrect: !widget.obscure && widget.keyboardType != TextInputType.emailAddress,
          enableSuggestions: !widget.obscure,
          textCapitalization: widget.obscure || widget.keyboardType == TextInputType.emailAddress
              ? TextCapitalization.none
              : TextCapitalization.sentences,
          onChanged: widget.onChanged,
          style: AppText.body,
          decoration: _decoration(widget.hint, suffix: suffix),
        ),
      ],
    );
  }
}

/// Rótulo + lista pendente (dropdown) reutilizável.
class AppDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const AppDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label, style: AppText.label),
          const SizedBox(height: 6),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              style: AppText.body,
              borderRadius: BorderRadius.circular(10),
              dropdownColor: AppColors.surface,
              items: items
                  .map((e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e, overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ),
      ],
    );
  }
}
