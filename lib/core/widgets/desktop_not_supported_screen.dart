import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:campus_clash/core/constants/app_colors.dart';
import 'package:campus_clash/core/constants/app_text_styles.dart';

class DesktopNotSupportedScreen extends StatelessWidget {
  const DesktopNotSupportedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SizedBox(
          width: 600.w,
          height: 600.h,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: EdgeInsets.all(40.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100.w,
                    height: 100.w,
                    padding: EdgeInsets.all(100.r),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Icon(
                        Icons.mobile_off_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Text(
                    'MOBILE EXPERIENCE ONLY',
                    style: AppTextStyles.black24.copyWith(
                      color: Colors.white,
                      letterSpacing: 2.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: 400.w,
                    child: Text(
                      'Campus Clash is optimized for mobile and tablet devices. Please view on a smaller screen or resize your browser window for a proper experience.',
                      style: AppTextStyles.regular16.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
