import 'package:food_app/models/recipe.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:food_app/components/view.dart';
import 'package:food_app/controllers/recipe_controller.dart';
import 'package:food_app/utils/colors.dart';
import 'package:food_app/utils/spacing.dart';
import 'package:food_app/utils/typography.dart';
import 'package:get/get.dart';

class RecipeView extends GetView<CRecipeController> {
  final int recipeId;
  const RecipeView({
    super.key,
    required this.recipeId,
  });

  @override
  Widget build(BuildContext context) {
    // controller.getRecipe(recipeId);
    return Obx(() {
      if (!controller.hasLoadedRecipe(recipeId)) {
        controller.getRecipe(recipeId);
        return const CustomView(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      final recipe = controller.currentRecipe;

      if (recipe == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Failed to load recipe'),
              ElevatedButton(
                onPressed: () => controller.getRecipe(recipeId),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(
              left: Spacing.m,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () => Get.back(),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  recipe.image, // Replace with your image URLs
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, size: 100),
                  ),
                ),
              ),

              // Recipe details
              Container(
                transform: Matrix4.translationValues(0, -32, 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: Spacing.m,
                    right: Spacing.m,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacing.vertical(Spacing.s),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 4,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                      Spacing.vertical(Spacing.m),
                      Text(
                        recipe.title,
                        style: AppTypography.h2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacing.vertical(Spacing.s),
                      Text(
                        'From ${recipe.sourceName}',
                        style: AppTypography.caption,
                      ),
                      Spacing.vertical(Spacing.s),
                      Row(
                        children: [
                          _buildInfoChip(
                            Icons.timer,
                            '${recipe.readyInMinutes} min (s)',
                          ),
                          Spacing.horizontal(Spacing.s),
                          _buildInfoChip(
                            Icons.thumb_up,
                            '${recipe.aggregateLikes} like (s)',
                          ),
                          Spacing.horizontal(Spacing.s),
                          _buildInfoChip(
                            Icons.restaurant_menu,
                            '${recipe.servings} serving (s)',
                          ),
                          Spacing.horizontal(Spacing.s),
                          _buildInfoChip(
                            Icons.attach_money,
                            '\$${recipe.pricePerServing}',
                          ),
                        ],
                      ),
                      Spacing.vertical(Spacing.s),
                      Text(
                        'Summary',
                        style: AppTypography.h3,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Bidi.stripHtmlIfNeeded(recipe.summary),
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Spacing.vertical(Spacing.s),
                      Text(
                        'Steps',
                        style: AppTypography.h3,
                      ),
                      Spacing.vertical(Spacing.s),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: recipe.analyzedInstructions.length,
                        itemBuilder: (context, index) => _buildStepItem(
                          index + 1,
                          recipe.analyzedInstructions[index],
                          recipe.analyzedInstructions.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      height: 65,
      width: 65,
      padding: const EdgeInsets.all(Spacing.s),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 26,
            color: AppColors.primary.withOpacity(0.8),
          ),
          Spacing.vertical(Spacing.xs),
          Expanded(
            child: Text(
              text,
              style: AppTypography.caption.copyWith(
                color: AppColors.primary.withOpacity(0.8),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(
    int number,
    RecipeStep step,
    int lenght,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 24,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number circle with connector line
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    number.toString(),
                    style: AppTypography.bodyLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (number != lenght)
                Container(
                  width: 2,
                  height: 40,
                  color: AppColors.primary.withOpacity(0.3),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: Text(
                step.step,
                style: AppTypography.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
