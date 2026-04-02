import 'package:campus_clash/core/models/match_model.dart';
import 'package:campus_clash/core/constants/app_colors.dart';
import 'package:campus_clash/core/constants/app_text_styles.dart';
import 'package:campus_clash/core/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FinishedMatchCard extends StatelessWidget {
  final MatchModel match;

  const FinishedMatchCard({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    final resultText = match.homeGoals == match.awayGoals
        ? 'MATCH ENDED IN A DRAW'
        : '${match.homeGoals > match.awayGoals ? match.homeTeam : match.awayTeam} WON THE MATCH';

    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatusBadge(status: match.status),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'FINAL SCORE',
                    style: AppTextStyles.bold10,
                  ),
                  if (match.date != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      match.date!,
                      style: AppTextStyles.extraBold10.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 8.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          SizedBox(height: 32.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ScoreInfo(
                fullName: match.homeTeam,
                score: match.homeGoals,
                isHome: true,
              ),
              SizedBox(width: 48.w),
              _ScoreInfo(
                fullName: match.awayTeam,
                score: match.awayGoals,
                isHome: false,
              ),
            ],
          ),
          SizedBox(height: 48.h),
          Text(
            resultText.toUpperCase(),
            style: AppTextStyles.extraBold10,
          ),
        ],
      ),
    );
  }
}

class _ScoreInfo extends StatelessWidget {
  final String fullName;
  final int score;
  final bool isHome;

  const _ScoreInfo({
    required this.fullName,
    required this.score,
    required this.isHome,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!isHome) ...[
          Text(
            fullName,
            style: AppTextStyles.extraBold18,
          ),
          SizedBox(width: 16.w),
        ],
        Text(
          '$score',
          style: AppTextStyles.black48NoSpacing,
        ),
        if (isHome) ...[
          SizedBox(width: 16.w),
          Text(
            fullName,
            style: AppTextStyles.extraBold18,
          ),
        ],
      ],
    );
  }
}
