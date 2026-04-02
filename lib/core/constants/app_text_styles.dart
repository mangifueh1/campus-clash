import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:campus_clash/core/constants/app_colors.dart';

class AppTextStyles {
  // Black (w900)
  static TextStyle black48 = TextStyle(
    color: Colors.white,
    fontSize: 48.sp,
    fontWeight: FontWeight.w900,
    letterSpacing: 2.0,
  );

  static TextStyle black48NoSpacing = TextStyle(
    color: Colors.white,
    fontSize: 48.sp,
    fontWeight: FontWeight.w900,
  );

  static TextStyle black24 = TextStyle(
    color: AppColors.primary,
    fontSize: 24.sp,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.2,
  );

  static TextStyle black12 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w900,
  );

  static TextStyle black12Spacing = TextStyle(
    color: Colors.white,
    fontSize: 12.sp,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.2,
  );

  static TextStyle black12NoSpacing = TextStyle(
    color: Colors.white,
    fontSize: 12.sp,
    fontWeight: FontWeight.w900,
  );

  static TextStyle black10 = TextStyle(
    color: AppColors.primary,
    fontSize: 10.sp,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.2,
  );

  // ExtraBold (w800)
  static TextStyle extraBold18 = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 18.sp,
    fontWeight: FontWeight.w800,
  );

  static TextStyle extraBold13Spacing = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.2,
  );

  static TextStyle extraBold10 = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 10.sp,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.2,
  );

  // Bold (w700)
  static TextStyle bold16 = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle bold12 = TextStyle(
    color: Colors.white,
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle bold10 = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
  );

  static TextStyle bold10NoSpacing = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
  );

  // Regular (w400)
  static TextStyle regular16 = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );
}
