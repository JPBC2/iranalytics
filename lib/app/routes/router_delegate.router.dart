import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iranalytics/app/pages/home.page.dart';

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

//    return Consumer(builder: (context, ref, child) {

      final pages = _getRoutes(_path/*, ref.watch(authVM)*/);
      return Navigator(
        key: navigatorKey,
        pages: pages,

        onDidRemovePage: (Page<dynamic> removedPage) {
          if (_path.pathSegments.isNotEmpty) {
            _path = _path.replace(
              pathSegments:
              _path.pathSegments.sublist(0, _path.pathSegments.length - 1),
            );
            _safeNotifyListeners();
          }
        },
      );
//    });
  }

  @override
  Future<void> setNewRoutePath(Uri configuration) async =>
      go(configuration.toString());

  go(String path) {
    _path = Uri.parse(path);
    _safeNotifyListeners();
  }

  List<Page> _getRoutes(Uri path, /*AuthVM authVM*/) {
    final pages = <Page>[];
    pages.add(MaterialPage(child: HomePage(), key: ValueKey('home')));
    if (path.pathSegments.isEmpty) {
      return pages;
    }
    /*switch (path.pathSegments[0]) {
      /*case 'name':
        pages.add(MaterialPage(
          key: ValueKey('name'),
          child: NamePage(),
        ));
        break; */
      /*case 'login':
        if (authVM.isLoggedIn) {
          go('/');
          break;
        }
        pages.add(MaterialPage(
          key: ValueKey('login'),
          child: LoginPage(),
        ));
        break;*/
      default:
        pages.add(MaterialPage(child: Error404Page(), key: ValueKey('error')));
        break; // default: case is a fallback for when the first segment of the path doesn't match any of the defined cases ('name', 'login', etc.). If the user navigates to a path like /banana or /xyz, which is not handled explicitly, Then the default: case gets triggered. It's a good practice in route handling
    }*/

    /* Template for creating two-part paths
    if (path.pathSegments.length == 2) {
      if (path.pathSegments[0] == 'courses') {
        pages.add(
          MaterialPage(
            key: ValueKey('course.${path.pathSegments[1]}'),
            child: CourseDetailsPage(
              courseId: int.parse(
                path.pathSegments[1],
              ),
            ),
          ),
        );
      } else {
        pages.add(MaterialPage(child: Error404Page(), key: ValueKey('error')));
      }
    }*/
    return pages;
  }

  void _safeNotifyListeners() {
    scheduleMicrotask(notifyListeners);
  }
}
