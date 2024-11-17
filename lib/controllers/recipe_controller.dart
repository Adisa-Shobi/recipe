import 'package:food_app/controllers/main_controller.dart';
import 'package:food_app/models/recipe.dart';
import 'package:food_app/utils/remote.dart';
import 'package:get/get.dart';

class CRecipeController extends GetxController {
  final _currentRecipe = Rxn<Recipe>();
  final _lodedRecipeIds = <int>{}.obs;

  Recipe? get currentRecipe => _currentRecipe.value;

  bool hasLoadedRecipe(int recipeId) => _lodedRecipeIds.contains(recipeId);

  // Initialize the API client
  MainController mainController = Get.find();

  void getRecipe(recipeId) async {
    if (hasLoadedRecipe(recipeId)) return;

    _currentRecipe.value = null;

    final response = await mainController.apiClient.get(
      '/recipes/$recipeId/information',
      fromJson: Recipe.fromJson,
    );

    if (response.success) {
      _currentRecipe.value = response.data;
      _lodedRecipeIds.add(recipeId);
    } else {
      print('Error: ${response.message}');
    }
  }

  @override
  void onClose() {
    _lodedRecipeIds.clear();
    super.onClose();
  }
}
