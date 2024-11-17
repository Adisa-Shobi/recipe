import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_app/controllers/main_controller.dart';
import 'package:food_app/routes/app_pages.dart';
import 'package:food_app/routes/route_names.dart';
import 'package:food_app/utils/theme.dart';
import 'package:get/get.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe App',
      // lock in potrait
      theme: AppTheme.lightTheme,
      initialRoute: RouteNames.home,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        Get.lazyPut(() => MainController());
      }),
    );
  }
}
