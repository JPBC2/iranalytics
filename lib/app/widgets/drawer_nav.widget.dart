import 'package:flutter/material.dart';
// for routerDelegate.go()
import 'package:iranalytics/app/config/menu_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iranalytics/app/view_models/theme_mode.vm.dart';

class DrawerNav extends StatefulWidget {
  const DrawerNav({super.key});

  @override
  State<DrawerNav> createState() => _DrawerNavState();
}

class _DrawerNavState extends State<DrawerNav> {
  int _expandedIndex = -1; // Keep for existing accordion if uncommented
  late List<ExpansibleController> _tileControllers; // Keep for existing accordion

  // Controller for the new language ExpansionTile
  final ExpansionTileController _languageController = ExpansionTileController();

  final List<String> _languageItems = ['Español'/*, 'Français', 'Русский', '中文', 'العربية'*/];

  @override
  void initState() {
    super.initState();
    // Initialize a controller for each menu section to control expansion
    _tileControllers = List.generate(
        popoverConfigurations.length, (_) => ExpansibleController());
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    TextStyle? baseTitleLargeStyle = textTheme.titleLarge;
    TextStyle finalTextStyle = baseTitleLargeStyle?.copyWith(
      color: Colors.white,
      fontFamily: 'ContrailOne',
    ) ??
        const TextStyle(
          color: Colors.white,
          fontFamily: 'ContrailOne',
          fontSize: 22,
        );

    return Drawer(
      child: ListView(
        children: [
          // App name header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [Colors.blue.shade900, Colors.blue.shade700]
                    : [Colors.lightBlue.shade900, Colors.cyanAccent.shade700],
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Text("IR Analytics", style: finalTextStyle),
          ),
          // Static menu item
          ListTile(
            title: const Text("Content"),
            onTap: () {
              Navigator.of(context).pushNamed('/content');
            },
          ),

          // Language Popover
          ExpansionTile(
            controller: _languageController,
            leading: const Icon(Icons.language_sharp),
            title: const Text('English'),
            children: _languageItems.map((String item) {
              return ListTile(
                contentPadding: const EdgeInsets.only(left: 53.0), // Added left padding to ListTile
                title: Text(item),
                onTap: () {
                  // Placeholder: Implement language change logic
                  print('Selected language: $item');
                  _languageController.collapse(); // Collapse after selection
                  Navigator.pop(context); // Close drawer
                  // Potentially: ref.read(languageProvider.notifier).setLanguage(item);
                },
              );
            }).toList(),
          ),

          /*
          // Accordion menu sections (existing commented out code)
          ...popoverConfigurations.asMap().entries.map((entry) {
            final int index = entry.key;
            final String sectionLabel = entry.value['label'] as String;
            final List<String> items = entry.value['items'] as List<String>;
            return ExpansionTile(
              controller: _tileControllers[index], // Uses _tileControllers
              initiallyExpanded: index == _expandedIndex, // Uses _expandedIndex
              title: Text(sectionLabel),
              onExpansionChanged: (expanded) {
                setState(() {
                  if (expanded) {
                    if (_expandedIndex != -1 && _expandedIndex != index) {
                      _tileControllers[_expandedIndex].collapse();
                    }
                    _expandedIndex = index;
                  } else if (_expandedIndex == index) {
                    _expandedIndex = -1;
                  }
                });
              },
              children: items.map((item) {
                final path = '/${sectionLabel.toLowerCase().replaceAll(" ", "-")}'
                    '/${item.toLowerCase().replaceAll(" ", "-")}';
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    Navigator.pop(context);
                    // routerDelegate.go(path); // Ensure routerDelegate is available if uncommented
                  },
                );
              }).toList(),
            );
          }),*/

          // const Divider(),

          // Theme toggle button at the very bottom
          Consumer(
            builder: (context, ref, _) {
              final themeModeVM = ref.watch(themeModeProvider);
              final bool isDarkNow = Theme.of(context).brightness == Brightness.dark;
              final Color buttonColor = isDarkNow ? Colors.white : Colors.black;

              return Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  tooltip: 'Cambiar tema (claro/oscuro)',
                  onPressed: themeModeVM.toggleThemeMode,
                  icon: Icon(
                    themeModeVM.themeMode == ThemeMode.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    color: buttonColor,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
