import 'package:flutter/material.dart';
import 'package:iranalytics/app/res/responsive.res.dart';
import 'package:iranalytics/app/widgets/drawer_nav.widget.dart';
import 'package:iranalytics/app/widgets/top_nav.widget.dart';
// **New import for YouTube player:**
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ClusteredColumnChartPage extends StatefulWidget {
  const ClusteredColumnChartPage({super.key});

  @override
  State<ClusteredColumnChartPage> createState() => _ClusteredColumnChartPageState();
}

class _ClusteredColumnChartPageState extends State<ClusteredColumnChartPage> {
  late final YoutubePlayerController _ytController;

  @override
  void initState() {
    super.initState();
    // Initialize the YouTube player controller with the video ID
    _ytController = YoutubePlayerController.fromVideoId(
      videoId: '9vvg9Tuik-M',   // YouTube video ID for https://youtu.be/7EiWhIdL9zs
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
        children: <Widget>[
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
                    // Title with gradient mask
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.lightBlue.shade900, Colors.cyanAccent.shade700],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                      child: Text(
                        'Filtering data',
                        textAlign: TextAlign.center,
                        style: (Theme.of(context).textTheme.displaySmall ??
                            const TextStyle(fontSize: 36.0, fontWeight: FontWeight.w400))
                            .copyWith(fontFamily: 'ContrailOne', color: Colors.white),
                      ),
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
                            color: Theme.of(context).textTheme.bodyLarge?.color
                                ?? (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade300 : Colors.black87),
                          ),
                          children: const <TextSpan>[
                            TextSpan(text: 'In this lesson we are going to learn how filter a dataset using a Pivot Table.'),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40.0),  // bottom spacing

                    // **YouTube inline player widget:**
                    YoutubePlayer(
                      controller: _ytController,
                      aspectRatio: 16 / 9,           // maintains 16:9 aspect ratio for the player
                    ),
                    const SizedBox(height: 24.0),  // spacing between video and text
                    // Instructional text below the video

                    /*Padding(
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
                            TextSpan(text: 'Follow these steps to filter a dataset in Google Sheets:\n\n'
                                '1) Click any cell of your dataset.\n\n2) Go to '),
                            TextSpan(text: 'Data', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ' ▸ '),
                            TextSpan(text: 'Create a filter', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: '\n\n3) Click the '),
                            TextSpan(text: 'filter icon', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ' in the column header ▸ '),
                            TextSpan(text: 'Filter by values', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ' ▸ '),
                            TextSpan(text: 'Clear', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ' ▸ tick the values you want to keep ▸ '),
                            TextSpan(text: 'OK', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40.0),  // bottom spacing
                    */
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
