import 'package:flutter/material.dart';
import 'package:food_app/routes/app_pages.dart';
import 'package:food_app/routes/route_names.dart';
import 'package:food_app/utils/theme.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food App',
      theme: AppTheme.lightTheme,
      initialRoute: RouteNames.home,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {}),
    );
  }
}