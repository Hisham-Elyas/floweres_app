import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_strategy/url_strategy.dart';

import 'firebase_options.dart';
import 'routes/app_routes.dart';
import 'routes/routes.dart';
import 'routes/routes_observers.dart';
import 'utils/helpers/network_manager.dart';

void main() async {
  // Ensure that widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetX Local Storage
  GetStorage.init();

  // Remove # sign from url
  setPathUrlStrategy();

  // Initialize Firebase & Authentication Repository
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFae614d)),
          useMaterial3: true,
        ),
        initialBinding: BindingsBuilder(
          () => Get.lazyPut(() => NetworkManager(), fenix: true),
        ),
        // home: const HomeScreen(),
        initialRoute: HRoutes.home,
        getPages: HAppRoutes.pages,
        // unknownRoute: GetPage(
        //     name: "/page-not-found",
        //     page: () =>
        //         const Scaffold(body: Center(child: Text("Page Not Found")))),
      ),
    );
  }
}
