import 'package:flutter/material.dart';
import 'package:iranalytics/app/res/responsive.res.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CallToAction extends ConsumerWidget {
  const CallToAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    // final Color callToActionBackgroundColor = isDark ? Colors.blue.shade800 : Colors.cyanAccent.shade700;

    /*  cyanAccent.shade700
    lightBlue.shade300
    blue.shade400
    blue.shade800
    pink.shade700
    indigo.shade700
    blueAccent.shade400

    Determine the correct button text colour for the current theme.
    Light theme  → black text for contrast.
    Dark theme   → white text for contrast.*/

    final Color callToActionTextColor = isDark ? Colors.white : Colors.white;
    final Color buttonTextColor = isDark ? Colors.white : Colors.black;

    return Container(
      margin: const EdgeInsets.only(top: 40.0),
      // color: callToActionBackgroundColor,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, //topLeft
          end: Alignment.bottomCenter, //bottomRight
          colors: isDark
              ? [Colors.blue.shade900, Colors.blue.shade700] // shades of pink
              : [Colors.lightBlue.shade900, Colors.cyanAccent.shade700], // shades of amber

          // ? [Colors.pink.shade900, Colors.pink.shade600] // shades of pink
          // : [Colors.amber.shade900, Colors.amber.shade400],

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
                // Lead with evidence: data science for IR

                // Make policy measurable—master data science for IR.

                // Own the data side of global affairs.
                // Master the analytics that power foreign policy
                // Turn IR questions into data-driven answers
                // Own the numbers behind international decisions
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: callToActionTextColor,
                  fontFamily: 'ContrailOne', // Added ContrailOne font
                ),
                // style: Theme.of(context).textTheme.displayMedium?.copyWith(color: callToActionTextColor, fontSize: 41.0,),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // const SizedBox(height: 60.0),

          Flexible(
            flex: 2,
            child: Container(),
          ),

          Flexible(
            flex: 1,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: MediaQuery.of(context).size.width > ScreenSizes.md
                    ? Size(180, 50)
                    : Size(180, 70),
              ),
              onPressed: () {
                print(
                  "This feature is not ready yet",
                ); // This line is a temporary placeholder. Replace with the action you want the button to perform
              },
              child: Text(
                "Start",
                style: TextStyle(color: buttonTextColor, fontSize: 16.5, fontFamily: 'ContrailOne'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
