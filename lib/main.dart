import 'package:flutter/material.dart';
import 'package:iranalytics/app/view_models/theme_mode.vm.dart';
import 'app/routes/app_route_parser.router.dart';
import 'app/routes/router_delegate.router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// Import the splash page
import 'app/pages/auth/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();

  runApp(const ProviderScope(child: MyApp()));
}

final routerDelegate = AppRouterDelegate();

class MyApp extends StatelessWidget {
  final _routeParser = AppRouteInformationParser();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final themeModeVM = ref.watch(themeModeProvider);
      return AnimatedBuilder(
          animation: themeModeVM,
          builder: (context, child) {
            return MaterialApp(
              title: 'IR Analytics',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.blue,
                  brightness: Brightness.light,
                  surface: Colors.white,
                ),
                scaffoldBackgroundColor: Colors.white,
                useMaterial3: true,
              ),
              darkTheme: ThemeData.dark().copyWith(
                primaryColor: Colors.blue,
              ),
              themeMode: themeModeVM.themeMode,

              // Use SplashPage as home instead of router for now
              home: const SplashPage(),

              // Comment out router temporarily
              // routerDelegate: routerDelegate,
              // routeInformationParser: _routeParser,
            );
          });
    });
  }
}
