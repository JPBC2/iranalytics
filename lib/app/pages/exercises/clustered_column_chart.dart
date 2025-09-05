import 'package:flutter/material.dart';
import 'package:iranalytics/app/res/responsive.res.dart';
import 'package:iranalytics/app/widgets/drawer_nav.widget.dart';
import 'package:iranalytics/app/widgets/top_nav.widget.dart';

class ClusteredColumnChartPage extends StatelessWidget {
  const ClusteredColumnChartPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          TopNav(),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1140),
                child: SingleChildScrollView( // or Column/ListView
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // All widgets after TopNav go here

                    ],
                  ),
                ),
              ),
            ),
          ),
          // CallToAction(),
        ],
      ),
      drawer: MediaQuery.of(context).size.width > ScreenSizes.md
          ? null
          : DrawerNav(),
    );
  }
}

/*
          const SizedBox(height: 40.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text("Recent courses",
                style: Theme.of(context).textTheme.displaySmall),
          ),

          const SizedBox(height: 10.0),
          Container(
            height: 420,
            child: CoursesView(),
          ),

          // Featured section
          Center(
            child: FeaturedSection(
              image: Assets.instructor,
              title: "Start teaching today",
              description:
              "Instructors from around the world teach millions of students on Udemy. We provide the tools and skills to teach what you love.",
              buttonLabel: "Become an instructor",
              onActionPressed: () {},
            ),
          ),

          Center(
            child: FeaturedSection(
              imageLeft: false,
              image: Assets.instructor,
              title: "Transform your life through education",
              description:
              "Education changes your life beyond your imagination. Education enables you to achieve your dreams.",
              buttonLabel: "Start learning",
              onActionPressed: () {},
            ),
          ),

          CallToAction(),

          Center(
            child: FeaturedSection(
              imageLeft: false,
              image: Assets.instructor,
              title: "Know your instructors",
              description:
              "Know your instructors. We have chosen the best of them to give you highest quality courses.",
              buttonLabel: "Browse",
              onActionPressed: () {},
            ),
          ),*/
