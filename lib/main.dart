import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';

import 'data/repositories/auth/auth_repo.dart';
import 'data/repositories/auth/user_repo.dart';
import 'firebase_options.dart';
import 'routes/app_routes.dart';
import 'routes/routes.dart';
import 'routes/routes_observers.dart';
import 'utils/device/web_material_scroll.dart';
import 'utils/helpers/network_manager.dart';
import 'utils/local_storage/storage_utility.dart';
import 'utils/theme/theme.dart';

/// Main entry point of the application
/// Initializes all required services before starting the app
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage with app name
  await HLocalStorage.init("Floweres App");

  // Remove the hash (#) from the URL in web platforms
  setPathUrlStrategy();

  // Initialize Firebase with platform-specific options
  // After initialization, initialize the AuthRepo and make it available via GetX
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => Get.put(AuthRepo()));

  // Start the application
  runApp(const MyApp());
}

/// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to determine the screen size and adjust accordingly
    return LayoutBuilder(
      builder: (context, constraints) {
        // Set design size based on device type (responsive design)
        final designSize = constraints.maxWidth > 600
            ? const Size(1200, 800) // Desktop/tablet design size
            : const Size(549, 960); // Mobile design size

        // Initialize ScreenUtil for responsive sizing across different devices
        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => GetMaterialApp(
            // Register navigation observer for route tracking
            navigatorObservers: [RouteObservers()],

            // Remove the debug banner from the app
            debugShowCheckedModeBanner: false,

            // App title shown in task managers
            title: 'Floweres App',

            // Theme configuration
            themeMode: ThemeMode.light,
            theme: HAppTheme.lightTheme,
            darkTheme: HAppTheme.darkTheme,

            // Custom scroll behavior for better web scrolling
            scrollBehavior: MyCustomScrollBehavior(),

            // Register global services with GetX dependency injection
            initialBinding: BindingsBuilder(() {
              // Network manager for handling connectivity
              Get.lazyPut(() => NetworkManager(), fenix: true);

              // User repository for user-related operations
              Get.lazyPut(() => UserRepo(), fenix: true);
            }),

            // Set initial route when app starts
            initialRoute: HRoutes.home,

            // Register all application routes
            getPages: HAppRoutes.pages,

            // Fallback page for unknown routes (404 equivalent)
            unknownRoute: GetPage(
              name: "/page-not-found",
              page: () => const Scaffold(
                body: Center(child: Text("Page Not Found")),
              ),
            ),
          ),
        );
      },
    );
  }
}
