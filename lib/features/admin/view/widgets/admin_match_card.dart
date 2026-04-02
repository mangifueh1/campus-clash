import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:campus_clash/core/models/match_model.dart';
import 'package:campus_clash/core/utils/match_utils.dart';
import 'package:campus_clash/features/matches/view/widgets/team_avatar.dart';
import 'package:campus_clash/core/constants/app_colors.dart';
import 'package:campus_clash/core/constants/app_text_styles.dart';
import 'package:campus_clash/core/providers/matches_provider.dart';

class AdminMatchCard extends StatelessWidget {
  final MatchModel match;

  const AdminMatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  TeamAvatar(
                    shortName: getTeamShortName(match.homeTeam),
                    size: 48.w,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 32.w),
                    child: TeamAvatar(
                      shortName: getTeamShortName(match.awayTeam),
                      size: 48.w,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 24.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          getTeamShortName(match.homeTeam),
                          style: AppTextStyles.black24.copyWith(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text('VS', style: AppTextStyles.bold10),
                        SizedBox(width: 8.w),
                        Text(
                          getTeamShortName(match.awayTeam),
                          style: AppTextStyles.black24.copyWith(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${match.homeTeam} vs ${match.awayTeam}',
                      style: AppTextStyles.bold10.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),
          _ScoreSection(match: match),
          SizedBox(height: 32.h),
          _ActionButtons(match: match),
        ],
      ),
    );
  }
}

class _ScoreSection extends StatelessWidget {
  final MatchModel match;
  const _ScoreSection({required this.match});

  @override
  Widget build(BuildContext context) {
    final bool isLive = match.status == MatchStatus.live;
    final bool isUpcoming = match.status == MatchStatus.upcoming;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isLive ? 'SCORE' : (isUpcoming ? 'SCHEDULED' : 'FINAL'),
                style: AppTextStyles.bold10,
              ),
              Text(
                isUpcoming ? '0' : '${match.homeGoals}',
                style: AppTextStyles.black24.copyWith(
                  color: isLive ? Colors.white : AppColors.primary,
                ),
              ),
            ],
          ),
          Text(
            ':',
            style: AppTextStyles.black24.copyWith(color: AppColors.primary),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isLive ? 'LIVE' : (isUpcoming ? '20:00' : 'FINISHED'),
                style: AppTextStyles.bold10.copyWith(
                  color: isLive ? AppColors.live : AppColors.textSecondary,
                ),
              ),
              Text(
                isUpcoming ? '0' : '${match.awayGoals}',
                style: AppTextStyles.black24.copyWith(
                  color: isLive ? Colors.white : AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final MatchModel match;
  const _ActionButtons({required this.match});

  @override
  Widget build(BuildContext context) {
    if (match.status == MatchStatus.live) {
      return Row(
        children: [
          Expanded(
            child: _AdminButton(
              text: 'EDIT SCORE',
              icon: Icons.edit,
              onPressed: () => _showEditScoreDialog(context),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _AdminButton(
              text: 'END MATCH',
              icon: Icons.stop,
              onPressed: () => _showEndMatchConfirmation(context),
            ),
          ),
        ],
      );
    } else if (match.status == MatchStatus.upcoming) {
      return Row(
        children: [
          Expanded(
            child: _AdminButton(
              text: 'START MATCH',
              icon: Icons.play_arrow,
              onPressed: () {
                context.read<MatchesProvider>().startMatch(match.id);
              },
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: _AdminButton(
              text: 'LOGS',
              icon: Icons.history,
              onPressed: () {},
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _AdminButton(
              text: 'REVERT',
              icon: Icons.refresh,
              onPressed: () {},
            ),
          ),
        ],
      );
    }
  }

  void _showEditScoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _EditScoreDialog(match: match),
    );
  }

  void _showEndMatchConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(32.r),
            border: Border.all(
              color: AppColors.textTertiary.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.live.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.stop_circle,
                  color: AppColors.live,
                  size: 32.sp,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'END MATCH?',
                style: AppTextStyles.black24.copyWith(
                  color: Colors.white,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Are you sure you want to end this match? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: AppTextStyles.regular16.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        'CANCEL',
                        style: AppTextStyles.bold12.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<MatchesProvider>().endMatch(match.id);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.live,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        'END MATCH',
                        style: AppTextStyles.bold12.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditScoreDialog extends StatefulWidget {
  final MatchModel match;
  const _EditScoreDialog({required this.match});

  @override
  State<_EditScoreDialog> createState() => _EditScoreDialogState();
}

class _EditScoreDialogState extends State<_EditScoreDialog> {
  late int homeGoals;
  late int awayGoals;

  @override
  void initState() {
    super.initState();
    homeGoals = widget.match.homeGoals;
    awayGoals = widget.match.awayGoals;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(32.r),
          border: Border.all(
            color: AppColors.textTertiary.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'EDIT SCORE',
              style: AppTextStyles.black24.copyWith(
                color: Colors.white,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 32.h),
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ScoreCounter(
                    teamName: getTeamShortName(widget.match.homeTeam),
                    goals: homeGoals,
                    onIncrement: () => setState(() => homeGoals++),
                    onDecrement: () {
                      if (homeGoals > 0) setState(() => homeGoals--);
                    },
                  ),
                  SizedBox(width: 10.w),
                  _ScoreCounter(
                    teamName: getTeamShortName(widget.match.awayTeam),
                    goals: awayGoals,
                    onIncrement: () => setState(() => awayGoals++),
                    onDecrement: () {
                      if (awayGoals > 0) setState(() => awayGoals--);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                    child: Text(
                      'CANCEL',
                      style: AppTextStyles.bold12.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showPublishConfirmation(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      'PUBLISH',
                      style: AppTextStyles.bold12.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPublishConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (confirmContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(32.r),
            border: Border.all(
              color: AppColors.textTertiary.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'PUBLISH UPDATE?',
                style: AppTextStyles.black24.copyWith(
                  color: Colors.white,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Are you sure you want to update the score to $homeGoals - $awayGoals?',
                textAlign: TextAlign.center,
                style: AppTextStyles.regular16.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(confirmContext),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                      ),
                      child: Text(
                        'NO, WAIT',
                        style: AppTextStyles.bold12.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await context.read<MatchesProvider>().updateScore(
                              widget.match.id,
                              homeGoals,
                              awayGoals,
                            );
                        if (confirmContext.mounted) {
                          Navigator.pop(confirmContext);
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        'YES, PUBLISH',
                        style: AppTextStyles.bold12.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreCounter extends StatelessWidget {
  final String teamName;
  final int goals;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _ScoreCounter({
    required this.teamName,
    required this.goals,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          teamName,
          style: AppTextStyles.bold12.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CounterButton(icon: Icons.remove, onPressed: onDecrement),
            SizedBox(width: 16.w),
            SizedBox(
              width: 40.w,
              child: Text(
                '$goals',
                textAlign: TextAlign.center,
                style: AppTextStyles.black48NoSpacing.copyWith(fontSize: 40.sp),
              ),
            ),
            SizedBox(width: 16.w),
            _CounterButton(icon: Icons.add, onPressed: onIncrement),
          ],
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CounterButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.textTertiary.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Icon(icon, size: 20.sp, color: Colors.white),
      ),
    );
  }
}

class _AdminButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const _AdminButton({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: AppColors.textTertiary.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16.sp, color: Colors.white),
            SizedBox(width: 8.w),
            Text(
              text,
              style: AppTextStyles.bold10.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
