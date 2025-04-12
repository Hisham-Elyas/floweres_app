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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HLocalStorage.init("Floweres App");
  setPathUrlStrategy();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => Get.put(AuthRepo()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Set design size based on device type
        final designSize = constraints.maxWidth > 600
            ? const Size(1200, 800) // Desktop/tablet
            : const Size(549, 960); // Mobile   old const Size(549, 960),

        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => GetMaterialApp(
            navigatorObservers: [RouteObservers()],
            debugShowCheckedModeBanner: false,
            title: 'Floweres App',
            themeMode: ThemeMode.light,
            theme: HAppTheme.lightTheme,
            darkTheme: HAppTheme.darkTheme,
            scrollBehavior: MyCustomScrollBehavior(),
            initialBinding: BindingsBuilder(() {
              Get.lazyPut(() => NetworkManager(), fenix: true);
              Get.lazyPut(() => UserRepo(), fenix: true);
            }),
            initialRoute: HRoutes.home,
            getPages: HAppRoutes.pages,
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
