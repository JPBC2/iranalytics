import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iranalytics/app/res/responsive.res.dart';
import 'package:iranalytics/app/view_models/theme_mode.vm.dart';
import 'package:iranalytics/main.dart';                    // contains routerDelegate
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopNav extends ConsumerWidget implements PreferredSizeWidget {
  const TopNav({super.key,}); /*

   Top navigation bar that plugs directly into `Scaffold(appBar: …)`.
   Implements [PreferredSizeWidget] so Flutter knows its height.*/

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); /*

  PreferredSizeWidget */

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final bool isWide = MediaQuery.of(context).size.width > ScreenSizes.md; /*
    Show the button row only on wider screens (≥ ScreenSizes.md px).*/
    final ThemeModeVM themeModeVM = ref.watch(themeModeProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color buttonTextColor = isDark ? Colors.white : Colors.black; /*

    Determine the correct button text colour for the current theme.
    Light theme  → black text for contrast.
    Dark theme   → white text for contrast.*/
    final Color appBarColor = isDark ? Colors.grey.shade900 : Colors.white;

    return AppBar(
      backgroundColor: appBarColor,

      title: GestureDetector(
          onTap: () => routerDelegate.go('/'),
          child: Text(
            'IR Analytics',
            style: TextStyle(
              fontFamily: 'ContrailOne',
              color: buttonTextColor,
            ),
          )),

      elevation: kIsWeb ? 0 : null,
      centerTitle: kIsWeb ? false : null,

      actions: isWide
          ? [
        _navButton(label: 'Content',   path: '/content', color: buttonTextColor),

        /*...popoverConfigurations.map((config) {
          return ReusablePopoverButton(
            label: config['label'] as String,
            popoverItemsPlaceholders: config['items'] as List<String>,
            textColor: buttonTextColor,
            backgroundColor: isDark ? Colors.black : Colors.white,
          );
        }),*/

        /* Buttons without an icon
        _navButton(label: 'Home',    path: '/',        color: buttonTextColor),
        _navButton(label: 'Cursos',  path: '/courses', color: buttonTextColor), */

        /*_navButton(
          label: 'Cursos',
          path: '/cursos',
          color: buttonTextColor,
          icon: Icons.shopping_cart,
        ),*/

        /* _navButton(
          label: 'Accede',
          path: '/accede',
          color: buttonTextColor,
          icon: Icons.person,
        ),*/

        IconButton(
          tooltip: 'Cambiar tema (claro/oscuro)', // 'Activar o desactivar modo oscuro', 'Toggle dark / light theme',
          onPressed: themeModeVM.toggleThemeMode,
          icon: Icon(
            themeModeVM.themeMode == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode,
            color: buttonTextColor,
          ),
        ),
      ]
          : null, /*

          Small screens: AppBar shows only the hamburger icon.*/

    );
  }

  Widget _navButton({
    required String label,
    required String path,
    required Color color,
    IconData? icon,
  }) {
    return TextButton(
      style: TextButton.styleFrom(foregroundColor: color),
      onPressed: () => routerDelegate.go(path),
      child: icon == null
          ? Text(label)
          : Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}