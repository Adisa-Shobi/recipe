import 'package:flutter/material.dart';
import 'package:food_app/components/view.dart';
import 'package:food_app/controllers/search_controller.dart';
import 'package:food_app/models/dtos/search_dto.dart';
import 'package:food_app/routes/route_names.dart';
import 'package:food_app/utils/colors.dart';
import 'package:food_app/utils/spacing.dart';
import 'package:food_app/utils/typography.dart';
import 'package:get/get.dart';

class SearchView extends GetView<CSearchController> {
  @override
  Widget build(BuildContext context) {
    return CustomView(
      topPadding: 0,
      appBar: AppBar(
        toolbarHeight: 40,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.grey,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
      child: Column(
        children: [
          Obx(
            () => TextField(
              focusNode: controller.focusNode.value,
              style: AppTypography.bodyMedium,
              controller: controller.searchController.value,
              decoration: InputDecoration(
                hintText: 'Search for recipes',
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.text.withOpacity(0.5),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColors.text.withOpacity(0.5),
                    width: 0.7,
                    style: BorderStyle.solid,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColors.primary.withOpacity(0.5),
                    width: 1.5,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
          ),
          Spacing.vertical(Spacing.m),
          Expanded(
            child: Obx(
              () => controller.isSearching.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : controller.searchResultRecipes.isEmpty
                      ? SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/search.png',
                              ),
                              Spacing.vertical(Spacing.xs),
                              Text(
                                'Search for recipes',
                                style: AppTypography.h3.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                              Spacing.vertical(Spacing.xl),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            final SearchRecipeDto recipe =
                                controller.searchResultRecipes[index];
                            return _buildSearchItem(context, recipe);
                          },
                          itemCount: controller.searchResultRecipes.length,
                        ),
            ),
          )
        ],
      ),
    );
  }
}

_buildSearchItem(BuildContext context, SearchRecipeDto recipe) {
  return GestureDetector(
    onTap: () => {
      Get.toNamed(
        RouteNames.recipeInfo,
        arguments: {
          'recipeId': recipe.id,
        },
      ),
    },
    child: Padding(
      padding: const EdgeInsets.only(
        bottom: Spacing.xs,
      ),
      child: Container(
        decoration: BoxDecoration(
          // color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        height: 60,
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.s,
          vertical: Spacing.s,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: 2,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            Spacing.horizontal(Spacing.s),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                recipe.image,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
            Spacing.horizontal(
              Spacing.s,
            ),
            Expanded(
              child: Text(
                recipe.title,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.text.withOpacity(0.8),
                  fontWeight: FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
