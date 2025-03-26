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
  // Ensure that widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetX Local Storage
  await HLocalStorage.init("Floweres App");

  // Remove # sign from url
  setPathUrlStrategy();

  // Initialize Firebase & Authentication Repository
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => Get.put(AuthRepo()));
  await ScreenUtil.ensureScreenSize();
  // Main App Starts here...

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(549, 960),
      builder: (context, child) => GetMaterialApp(
        navigatorObservers: [
          RouteObservers(),
        ],
        debugShowCheckedModeBanner: false,
        title: 'Floweres App',
        themeMode: ThemeMode.light,
        theme: HAppTheme.lightTheme,
        darkTheme: HAppTheme.darkTheme,
        scrollBehavior: MyCustomScrollBehavior(),
        initialBinding: BindingsBuilder(
          () {
            Get.lazyPut(() => NetworkManager(), fenix: true);
            Get.lazyPut(() => UserRepo(), fenix: true);
          },
        ),
        initialRoute: HRoutes.home,
        getPages: HAppRoutes.pages,
        unknownRoute: GetPage(
            name: "/page-not-found",
            page: () =>
                const Scaffold(body: Center(child: Text("Page Not Found")))),
      ),
    );
  }
}
