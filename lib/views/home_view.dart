import 'package:flutter/material.dart';
import 'package:food_app/components/button.dart';
import 'package:food_app/components/tag.dart';
import 'package:food_app/components/view.dart';
import 'package:food_app/controllers/home_controller.dart';
import 'package:food_app/models/recipe.dart';
import 'package:food_app/routes/route_names.dart';
import 'package:food_app/utils/colors.dart';
import 'package:food_app/utils/spacing.dart';
import 'package:food_app/utils/typography.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hey There 👋',
            style: AppTypography.h1.copyWith(color: AppColors.primary),
          ),
          Spacing.vertical(Spacing.s),
          Text(
            'Here is today\'s lucky recipe!',
            style: AppTypography.h3.copyWith(
                color: AppColors.primary, fontWeight: FontWeight.normal),
          ),
          Spacing.vertical(Spacing.m),
          Obx(() => _buildRecipeCard(
                context,
                recipe: controller.currentRecipe.value,
                isLoading: controller.currentRecipe.value == null,
              )),
          Spacing.vertical(Spacing.m),
          CustomButton(
            text: "Search Recipes",
            textStyle: AppTypography.button.copyWith(
              color: Colors.white,
            ),
            onPressed: () {
              Get.toNamed(
                RouteNames.search,
              );
            },
            borderRadius: 100,
            // Fully rouynded
          ),
        ],
      ),
    );
  }
}

_buildRecipeCard(
  BuildContext context, {
  required Recipe? recipe,
  bool isLoading = true,
}) {
  if (isLoading || recipe == null) {
    return const RecipeCardSkeleton();
  }

  return GestureDetector(
    onTap: () {
      Get.toNamed(
        RouteNames.recipeInfo,
        arguments: {
          'recipeId': recipe.id,
        },
      );
    },
    child: Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              height: double.infinity,
              width: double.infinity,
              recipe.image,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Spacing.m),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Tag(text: '${recipe.readyInMinutes} mins'),
                  ],
                ),
                const Spacer(),
                Flex(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  direction: Axis.vertical,
                  children: [
                    Text(
                      recipe.title,
                      style: AppTypography.h1.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Spacing.vertical(Spacing.s),
                    Text(
                      Bidi.stripHtmlIfNeeded(recipe.summary),
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 4,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class RecipeCardSkeleton extends StatelessWidget {
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const RecipeCardSkeleton({
    super.key,
    this.height,
    this.padding,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: baseColor ?? Colors.grey[300]!,
        highlightColor: highlightColor ?? Colors.grey[100]!,
        child: Stack(
          children: [
            // Background skeleton
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: borderRadius ?? BorderRadius.circular(16),
              ),
            ),

            // Content skeleton
            Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag skeleton
                  _buildShimmerContainer(
                    width: 80,
                    height: 24,
                    borderRadius: 12,
                  ),

                  const Spacer(),

                  // Title and description skeletons
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title skeleton
                      _buildShimmerContainer(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 28,
                        borderRadius: 4,
                      ),

                      const SizedBox(height: 8),

                      // Description skeleton lines
                      _buildDescriptionLines(context),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerContainer({
    required double width,
    required double height,
    double borderRadius = 4,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  Widget _buildDescriptionLines(BuildContext context) {
    return Column(
      children: List.generate(
        2,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: index < 1 ? 6 : 0),
          child: _buildShimmerContainer(
            width: MediaQuery.of(context).size.width * (index == 0 ? 0.9 : 0.7),
            height: 16,
            borderRadius: 4,
          ),
        ),
      ),
    );
  }
}
