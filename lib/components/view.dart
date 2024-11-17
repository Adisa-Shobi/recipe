import 'package:flutter/material.dart';
import 'package:food_app/utils/spacing.dart';

class CustomView extends StatelessWidget {
  const CustomView({
    required this.child,
    this.appBar,
    this.topPadding = Spacing.xl,
    super.key,
  });
  final Widget child;
  final AppBar? appBar;
  final double topPadding;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: Spacing.m,
            right: Spacing.m,
            top: topPadding,
          ),
          child: child,
        ),
      ),
    );
  }
}
