// Import your page components and bindings here
import 'package:food_app/bindings/bindings.dart';
import 'package:food_app/routes/route_names.dart';
import 'package:food_app/views/home_view.dart';
import 'package:food_app/views/recipe_view.dart';
import 'package:food_app/views/search_view.dart';
import 'package:get/get.dart';

class AppPages {
  static final List<GetPage<dynamic>> routes = [
    // Sample of how to use GetPage. You can use it for local and global routes
    // GetPage(
    //   name: RouteNames.home,
    //   page: () => const HomePage(),
    //   binding: HomeBindings(),
    // ),
    GetPage(
      name: RouteNames.home,
      page: () => const HomeView(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: RouteNames.search,
      page: () => SearchView(),
      binding: SearchBindings(),
    ),
    GetPage(
      name: RouteNames.recipeInfo,
      page: () => RecipeView(
        recipeId: Get.arguments["recipeId"],
      ),
      binding: RecipeBindings(),
    )
  ];
}
