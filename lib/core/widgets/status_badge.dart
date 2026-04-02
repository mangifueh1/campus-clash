import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:campus_clash/core/constants/app_colors.dart';
import 'package:campus_clash/core/constants/app_text_styles.dart';
import 'package:campus_clash/core/models/match_model.dart';

class StatusBadge extends StatelessWidget {
  final MatchStatus status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor = Colors.white;
    String text;
    bool hasDot = false;

    switch (status) {
      case MatchStatus.live:
        bgColor = AppColors.live;
        text = 'LIVE';
        hasDot = true;
        break;
      case MatchStatus.upcoming:
        bgColor = AppColors.surfaceVariant;
        text = 'UPCOMING';
        textColor = AppColors.textSecondary;
        break;
      case MatchStatus.finished:
        bgColor = AppColors.surfaceVariant;
        text = 'FINISHED';
        textColor = AppColors.textSecondary;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasDot) ...[
            Container(
              width: 6.w,
              height: 6.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8.w),
          ],
          Text(
            text,
            style: AppTextStyles.black10.copyWith(
              color: textColor,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
