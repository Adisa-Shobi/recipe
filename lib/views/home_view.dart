import 'package:flutter/material.dart';
import 'package:food_app/utils/typography.dart';
import 'package:get/get.dart';

class HomeView extends GetWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Home View',
            style: AppTypography.h1,
          ),
        ),
        body: Center(
          child: Text(
            'Home View is working',
            style: AppTypography.bodyLarge,
          ),
        ));
  }
}
