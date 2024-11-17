import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_app/utils/remote.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  late final ApiClient apiClient = ApiClient(
    baseUrl: 'https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com',
    defaultHeaders: {
      "x-rapidapi-host": dotenv.env['RAPIDAPI_HOST'] ?? '',
      "x-rapidapi-key": dotenv.env['RAPIDAPI_KEY'] ?? '',
    },
  );
}
