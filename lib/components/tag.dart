import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:food_app/utils/spacing.dart';
import 'package:food_app/utils/typography.dart';

class Tag extends StatelessWidget {
  const Tag({this.icon, required this.text});
  final Widget? icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Container(
          padding: const EdgeInsets.all(Spacing.s),
          child: Row(
            children: [
              icon ?? Container(),
              icon != null ? Spacing.horizontal(Spacing.xs) : Container(),
              Text(
                text,
                style: AppTypography.caption.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
