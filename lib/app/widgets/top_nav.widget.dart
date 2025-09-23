import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iranalytics/app/res/responsive.res.dart';
import 'package:iranalytics/app/view_models/theme_mode.vm.dart';
import 'package:iranalytics/main.dart'; // contains routerDelegate
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopNav extends ConsumerWidget implements PreferredSizeWidget {
  const TopNav({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isWide = MediaQuery.of(context).size.width > ScreenSizes.md;
    final ThemeModeVM themeModeVM = ref.watch(themeModeProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color buttonTextColor = isDark ? Colors.white : Colors.black;
    final Color appBarColor = isDark ? Colors.grey.shade900 : Colors.white70;

    // Language items for the popover
    final List<String> languageItems = ['Español'/*, 'Français', 'Русский', '中文', 'العربية'*/];

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
        ),
      ),
      elevation: kIsWeb ? 0 : null,
      centerTitle: kIsWeb ? false : null,
      actions: isWide
          ? <Widget>[
        // New Content button (matches drawer)
        _navButton(
          icon: Icons.menu_book,
          label: 'Content',
          path: '/content', // Assuming this is the correct general content path
          color: buttonTextColor,
        ),
        // New Access button (matches drawer)
        _navButton(
          icon: Icons.person,
          label: 'Access',
          path: '/access', // Placeholder path, adjust if needed
          color: buttonTextColor,
        ),
        // New English Popover (matches drawer)
        Tooltip(
          message: 'Select Language',


          child: PopupMenuButton<String>(
            offset: const Offset(0, 35.0), // Adjusted offset for tighter spacing
            child: InkWell(
              onTap: null, // PopupMenuButton handles the tap to open.
              hoverColor: Theme.of(context).hoverColor, // Match TextButton hover
              borderRadius: BorderRadius.circular(4.0), // Optional: for rounded corners
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Match _navButton padding
                child: Row(
                  children: <Widget>[
                    Icon(Icons.language_sharp, color: buttonTextColor, size: 20),
                    const SizedBox(width: 6),
                    Text('English', style: TextStyle(color: buttonTextColor)),
                    Icon(Icons.arrow_drop_down, color: buttonTextColor, size: 20),
                  ],


                ),
              ),
            ),


            onSelected: (String language) {
              // Placeholder: Implement language change logic
              print('Selected language: $language');
              // Potentially: ref.read(languageProvider.notifier).setLanguage(language);
            },
            itemBuilder: (BuildContext context) {
              return languageItems.map((String language) {
                return PopupMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList();
            },


          ),
        ),
        // New Theme Toggle (matches drawer)
        Tooltip(
          message: 'Cambiar tema (claro/oscuro)',
          child: TextButton(
            style: TextButton.styleFrom(
                foregroundColor: buttonTextColor,
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0)
            ),
            onPressed: themeModeVM.toggleThemeMode,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  themeModeVM.themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  size: 20,
                  color: buttonTextColor,
                ),
                const SizedBox(width: 6),
                Text('Theme', style: TextStyle(color: buttonTextColor)),
              ],
            ),
          ),
        ),
      ]
          : null,
    );
  }

  // _navButton helper remains the same as it's used for Content and Access
  Widget _navButton({
    required String label,
    required String path,
    required Color color,
    IconData? icon,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0) // Consistent padding
      ),
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