import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nihongo/app/theme.dart';
import 'package:nihongo/core/l10n.dart';

/// Home · Learn · Tests · Pass · Class. The active tab sits in a sky bubble.
class AppShell extends StatelessWidget {
  const new({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      (Icons.home_rounded, l10n.navHome),
      (Icons.menu_book_rounded, l10n.navLearn),
      (Icons.assignment_turned_in_rounded, l10n.navTests),
      (Icons.confirmation_number_rounded, l10n.navPass),
      (Icons.groups_rounded, l10n.navClass),
    ];
    return Scaffold(
      body: shell,
      bottomNavigationBar: Semantics(
        container: true,
        label: l10n.mainMenu,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.card,
            boxShadow: [
              BoxShadow(
                color: Color(0x0F0F1222),
                blurRadius: 20,
                offset: Offset(0, -6),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  for (final (i, (icon, label)) in items.indexed)
                    Expanded(
                      child: _NavItem(
                        icon: icon,
                        label: label,
                        selected: shell.currentIndex == i,
                        onTap: () => shell.goBranch(
                          i,
                          initialLocation: i == shell.currentIndex,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const new({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.sky : AppColors.faint;
    return Semantics(
      selected: selected,
      button: true,
      child: InkResponse(
        onTap: onTap,
        child: SizedBox(
          height: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: selected ? AppColors.skyTint : Colors.transparent,
                  borderRadius: AppRadii.button,
                ),
                child: Icon(icon, size: 26, color: color),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.body(11, weight: FontWeight.w800, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
