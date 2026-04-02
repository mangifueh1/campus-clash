import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:campus_clash/core/constants/app_colors.dart';
import 'package:campus_clash/core/constants/app_text_styles.dart';

class TeamAvatar extends StatelessWidget {
  final String shortName;
  final double? size;
  final bool isSelected;

  const TeamAvatar({
    super.key,
    required this.shortName,
    this.size,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final avatarSize = size ?? 80.w;
    
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.3),
          width: isSelected ? 3.w : 1.w,
        ),
      ),
      child: Center(
        child: Text(
          shortName,
          style: AppTextStyles.black10.copyWith(
            color: Colors.white,
            fontSize: (avatarSize * 0.25).sp,
          ),
        ),
      ),
    );
  }
}
