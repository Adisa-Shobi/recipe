import 'package:food_app/controllers/home_controller.dart';
import 'package:food_app/controllers/recipe_controller.dart';
import 'package:food_app/controllers/search_controller.dart';
import 'package:get/get.dart';

class SearchBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CSearchController(),
    );
  }
}

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(),
    );
  }
}

class RecipeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CRecipeController(),
    );
  }
}
