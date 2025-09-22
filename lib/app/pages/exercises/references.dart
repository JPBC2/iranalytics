import 'package:flutter/material.dart';
import 'package:iranalytics/app/res/responsive.res.dart';
import 'package:iranalytics/app/widgets/drawer_nav.widget.dart';
import 'package:iranalytics/app/widgets/top_nav.widget.dart';
// **New import for YouTube player:**
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:iranalytics/app/widgets/google_sheet_embed.widget.dart';

class ReferencesPage extends StatefulWidget {
  const ReferencesPage({super.key});

  @override
  State createState() => _ReferencesPageState();
}

class _ReferencesPageState extends State {
  late final YoutubePlayerController _ytController;

  @override
  void initState() {
    super.initState();
    // Initialize the YouTube player controller with the video ID
    _ytController = YoutubePlayerController.fromVideoId(
      videoId: 'iknH-T8brqY',   // YouTube video ID for https://youtu.be/iknH-T8brqY
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        strictRelatedVideos: true,  // Only show videos from the same channel at end
        showVideoAnnotations: false, // Hide pop-up annotations/end cards
      ),
    );
  }

  @override
  void dispose() {
    _ytController.pauseVideo();
    _ytController.close();  // not .dispose()
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          TopNav(),
          // Constrain content width and enable scrolling
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1140),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 30.0),

                    // Title
                    Text(
                      'Relative, absolute, and mixed references',
                      textAlign: TextAlign.center,
                      style: (Theme.of(context).textTheme.displaySmall ??
                          const TextStyle(fontSize: 36.0, fontWeight: FontWeight.w400))
                          .copyWith(
                            fontFamily: 'ContrailOne',
                            color: Theme.of(context).textTheme.bodyLarge?.color ??
                                (Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey.shade300 : Colors.black87),),
                    ),

                    const SizedBox(height: 40.0),  // spacing between title and video

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          style: (Theme.of(context).textTheme.bodyLarge ??
                              const TextStyle(fontSize: 16.0))
                              .copyWith(
                            height: 1.5,
                            color: Theme.of(context).textTheme.bodyLarge?.color ??
                                (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade300
                                    : Colors.black87),
                          ),
                          children: const [
                            TextSpan(
                              text:
                              'In this lesson we are going to learn how to reference cells in formulas.',
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40.0),  // bottom spacing

                    // **YouTube inline player widget:**
                    YoutubePlayer(
                      controller: _ytController,
                      aspectRatio: 16 / 9, // maintains 16:9 aspect ratio for the player
                    ),
                    const SizedBox(height: 40.0), // spacing between video and text

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          style: (Theme.of(context).textTheme.bodyLarge ??
                              const TextStyle(fontSize: 16.0))
                              .copyWith(
                            height: 1.5,
                            color: Theme.of(context).textTheme.bodyLarge?.color
                                ?? (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade300 : Colors.black87),
                          ),
                          children: const <TextSpan>[
                            TextSpan(text: 'Exercise\n\n', style: TextStyle(fontSize: 20.0, fontFamily: 'ContrailOne')),
                            TextSpan(text: 'Write a formula in cell C3 that calculates the 2% of Albania\'s GDP. Use mixed references and copy this formula to all the cells in the range C3:S35.'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40.0),  // bottom spacing

                    // Embedded Google Sheet for interactive practice.
                    GoogleSheetEmbed(
                      sheetUrl:
                      'https://docs.google.com/spreadsheets/d/17Wf_PII8NzRaaFCkGGyUg_cIrlpwIr0WA1JtmYt3lIE/edit?usp=sharing&widget=true',
                      height: 500.0,
                    ),

                    const SizedBox(height: 40.0), // spacing after the embedded sheet

                  ],
                ),
              ),
            ),
          ),
          // drawer navigation etc. (unchanged)
        ],
      ),
      drawer: MediaQuery.of(context).size.width > ScreenSizes.md ? null : DrawerNav(),
    );
  }
}
