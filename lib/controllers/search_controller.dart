import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_app/controllers/main_controller.dart';
import 'package:food_app/models/dtos/search_dto.dart';
import 'package:get/get.dart';

class CSearchController extends GetxController {
  final RxList<SearchRecipeDto> searchResultRecipes = <SearchRecipeDto>[].obs;
  final RxBool isSearching = false.obs;
  final Rx<FocusNode> focusNode = FocusNode().obs;
  final Rx<TextEditingController> searchController =
      TextEditingController().obs;
  Timer? _debounceTimer;

  // Initialize the API client
  MainController mainController = Get.find();

  @override
  void onInit() {
    super.onInit();

    searchController.value.addListener(() {
      if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

      _debounceTimer = Timer(const Duration(milliseconds: 500),
          () => searchRecipes(searchController.value.text));
    });
  }

  Future<void> searchRecipes(String query) async {
    if (query.isEmpty) return;
    isSearching.value = true;
    searchResultRecipes.clear();

    try {
      final response = await mainController.apiClient.get(
        '/recipes/complexSearch',
        queryParameters: {
          'query': query,
          // 'number': 10,
        },
        fromJson: SearchRecipeDto.getListParser('results'),
      );

      if (response.success) {
        searchResultRecipes.addAll(response.data!);
      } else {
        print('Error: ${response.message}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isSearching.value = false;
    }
  }
}
