import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // Import for Scheduler Phase
import 'package:iranalytics/app/pages/home.page.dart';
// Ensure this import path is correct and the file defines ClusteredColumnChartPage
import 'package:iranalytics/app/pages/exercises/references.dart';
// If you have an Error404Page, ensure it's imported too, e.g.:
// import 'package:iranalytics/app/pages/error404_page.dart'; 

class AppRouterDelegate extends RouterDelegate<Uri>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Uri> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  Uri _path = Uri.parse('/');

  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  Uri get currentConfiguration => _path;

  @override
  Widget build(BuildContext context) {
    final pages = _getRoutes(_path);
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        // Check if the route being popped corresponds to the last page in our list
        // and ensure there is a path to pop from.
        if (pages.isNotEmpty && pages.last.name == route.settings.name) {
          if (pages.length > 1) { // If it's not the very first page (HomePage)
            _path = _path.replace(
              pathSegments: _path.pathSegments.isNotEmpty 
                  ? _path.pathSegments.sublist(0, _path.pathSegments.length - 1)
                  : [], // Avoid error if pathSegments is already empty somehow
            );
            // If pathSegments became empty, it implies we are back at the root path.
            if (_path.pathSegments.isEmpty) {
              _path = Uri.parse('/');
            }
          } else {
            // Popping the last page (HomePage). Behavior depends on app design.
            // For now, _path remains '/' if it was already, or becomes '/'.
            // This part might need adjustment based on desired behavior for popping the root.
             _path = Uri.parse('/');
          }
        }
        
        _safeNotifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(Uri configuration) async {
    _path = configuration;
    _safeNotifyListeners(); 
  }

  go(String path) {
    if (_path.toString() == path && path != '/') return; 
    _path = Uri.parse(path);
    _safeNotifyListeners();
  }

  List<Page> _getRoutes(Uri path) {
    final pages = <Page>[];
    // Always add HomePage as the base and set its name for onPopPage comparison
    pages.add(MaterialPage(child: HomePage(), key: ValueKey('home'), name: '/'));

    if (path.pathSegments.isNotEmpty) {
      if (path.pathSegments.length == 2 &&
          path.pathSegments[0] == 'exercises' &&
          path.pathSegments[1] == 'clustered-column-chart') {
        pages.add(MaterialPage(
          key: ValueKey('ClusteredColumnChartPage'), 
          name: '/exercises/clustered-column-chart', // Set name for onPopPage comparison
          child: ClusteredColumnChartPage(), // Corrected class name
        ));
      } else if (path.pathSegments.length == 1 && path.pathSegments[0] == 'content') {
        // Example for a hypothetical /content page
        // pages.add(MaterialPage(key: ValueKey('ContentPage'), name: '/content', child: ContentPage()));
        print("Navigating to content page (placeholder) - you might want to add a real page here."); 
      }
      // else {
      //   // Fallback for unrecognized non-empty paths (after HomePage)
      //   if (path.path != '/') {
      //      // pages.add(MaterialPage(child: Error404Page(), key: ValueKey('error'), name: '/error'));
      //   }
      // }
    }
    return pages;
  }

  void _safeNotifyListeners() {
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } else {
      notifyListeners();
    }
  }
}
