import 'package:campus_clash/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ScreenWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ScreenWrapper({super.key, required this.child, this.maxWidth = 1024});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
