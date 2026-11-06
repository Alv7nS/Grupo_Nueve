import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Cabeçalho comum: seta de voltar (se aplicável), título e sino de notificações.
class PageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showNotifications;
  final List<Widget> extraActions;

  const PageAppBar({
    super.key,
    required this.title,
    this.showNotifications = true,
    this.extraActions = const [],
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final unread = MockData.myNotifications.where((n) => n.unread).length;

    return AppBar(
      backgroundColor: AppColors.cream,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 64,
      foregroundColor: AppColors.text,
      titleSpacing: Navigator.of(context).canPop() ? 0 : 20,
      title: Text(
        title,
        style: AppText.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        ...extraActions,
        if (showNotifications)
          IconButton(
            tooltip: 'Notificações',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
            icon: Badge(
              isLabelVisible: unread > 0,
              label: Text('$unread'),
              backgroundColor: AppColors.terracotta,
              child: const Icon(Icons.notifications_none_outlined),
            ),
          ),
        const SizedBox(width: 8),
      ],
    );
  }
}
