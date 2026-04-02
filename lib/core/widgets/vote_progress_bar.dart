import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:campus_clash/core/constants/app_colors.dart';
import 'package:campus_clash/core/constants/app_text_styles.dart';

class VoteProgressBar extends StatelessWidget {
  final int homeVotes;
  final int awayVotes;

  const VoteProgressBar({
    super.key,
    required this.homeVotes,
    required this.awayVotes,
  });

  @override
  Widget build(BuildContext context) {
    final total = homeVotes + awayVotes;
    final homePercent = total == 0 ? 0.5 : homeVotes / total;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$homeVotes VOTES (${(homePercent * 100).toInt()}%)',
              style: AppTextStyles.bold10NoSpacing.copyWith(
                color: AppColors.primary,
              ),
            ),
            Text(
              '$awayVotes VOTES (${((1 - homePercent) * 100).toInt()}%)',
              style: AppTextStyles.bold10NoSpacing,
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Stack(
          children: [
            Container(
              height: 8.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: 8.h,
                  width: constraints.maxWidth * homePercent,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
