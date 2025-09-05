import 'package:flutter/material.dart';
import 'package:iranalytics/app/res/responsive.res.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Assuming routerDelegate is globally accessible from main.dart or a similar setup.
// If not, you'll need to pass it or access it via a Provider.
import 'package:iranalytics/main.dart'; // This line assumes routerDelegate is in main.dart

class CallToAction extends ConsumerWidget {
  const CallToAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color callToActionTextColor = Colors.white; // Simplified as it's always white in your code
    final Color buttonTextColor = isDark ? Colors.white : Colors.black;

    return Container(
      margin: const EdgeInsets.only(top: 40.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [Colors.blue.shade900, Colors.blue.shade700]
              : [Colors.lightBlue.shade900, Colors.cyanAccent.shade700],
        ),
      ),
      height: 400,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Master real-world data science for International Relations",
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: callToActionTextColor,
                      fontFamily: 'ContrailOne',
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Flexible(
            flex: 2,
            child: SizedBox.shrink(), // Using SizedBox.shrink() instead of empty Container
          ),
          Flexible(
            flex: 1, // Consider adjusting flex or using SizedBox for better height control if needed
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: MediaQuery.of(context).size.width > ScreenSizes.md
                    ? const Size(180, 50)
                    : const Size(180, 70),
              ),
              onPressed: () {
                // Use your routerDelegate instance to navigate
                routerDelegate.go('/exercises/clustered-column-chart');
              },
              child: Text(
                "Start",
                style: TextStyle(
                    color: buttonTextColor,
                    fontSize: 16.5,
                    fontFamily: 'ContrailOne'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
