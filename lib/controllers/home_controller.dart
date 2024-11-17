import 'package:food_app/controllers/main_controller.dart';
import 'package:food_app/models/recipe.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final Rxn<Recipe> currentRecipe = Rxn<Recipe>();

  final MainController mainController = Get.find();

  @override
  void onInit() {
    super.onInit();
    getRandomRecipe();
  }

  Future<void> getRandomRecipe() async {
    try {
      final response = await mainController.apiClient.get(
        '/recipes/random',
        queryParameters: {
          'number': '1',
        },
        fromJson: Recipe.getListParser('recipes'),
      );

      if (response.success) {
        List<Recipe> recipes = response.data;
        currentRecipe.value = recipes.first;
      } else {
        print('Error: ${response.message}');
      }
    } catch (e) {
      print('Errorr: $e');
    }
  }
}
