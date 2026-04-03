import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:campus_clash/core/models/match_model.dart';
import 'package:campus_clash/core/utils/match_utils.dart';
import 'package:campus_clash/features/matches/view/widgets/team_avatar.dart';
import 'package:campus_clash/core/constants/app_colors.dart';
import 'package:campus_clash/core/constants/app_text_styles.dart';
import 'package:campus_clash/core/widgets/status_badge.dart';
import 'package:campus_clash/core/widgets/vote_progress_bar.dart';
import 'package:campus_clash/core/providers/matches_provider.dart';
import 'package:campus_clash/core/providers/voting_provider.dart';
import 'package:campus_clash/core/widgets/app_button.dart';

class UpcomingMatchCard extends StatelessWidget {
  final MatchModel match;

  const UpcomingMatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final votingProvider = context.watch<VotingProvider>();
    final hasVoted = votingProvider.hasVoted(match.id);
    final votedForHome = votingProvider.votedForHome(match.id);

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
              if (hasVoted)
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                      size: 14.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'YOU VOTED ${votedForHome == true ? getTeamShortName(match.homeTeam) : getTeamShortName(match.awayTeam)}',
                      style: AppTextStyles.black10,
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 32.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TeamInfoWithSelection(
                shortName: getTeamShortName(match.homeTeam),
                fullName: match.homeTeam,
                isSelected: hasVoted && votedForHome == true,
              ),
              SizedBox(width: 24.w),
              Column(
                children: [
                  Text('VS', style: AppTextStyles.bold16),
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
                  if (match.time != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      match.time!,
                      style: AppTextStyles.extraBold10.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 8.sp,
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(width: 24.w),
              _TeamInfoWithSelection(
                shortName: getTeamShortName(match.awayTeam),
                fullName: match.awayTeam,
                isSelected: hasVoted && votedForHome == false,
              ),
            ],
          ),
          if (hasVoted) ...[
            SizedBox(height: 32.h),
            VoteProgressBar(
              homeVotes: match.homeVotes,
              awayVotes: match.awayVotes,
            ),
          ] else ...[
            SizedBox(height: 32.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton(
                  text: 'VOTE ${getTeamShortName(match.homeTeam)}',
                  onPressed: () {
                    context.read<MatchesProvider>().voteForTeam(match.id, true);
                    context.read<VotingProvider>().registerVoteLocally(
                      match.id,
                      true,
                    );
                  },
                  width: 140.w,
                ),
                AppButton(
                  text: 'VOTE ${getTeamShortName(match.awayTeam)}',
                  onPressed: () {
                    context.read<MatchesProvider>().voteForTeam(
                      match.id,
                      false,
                    );
                    context.read<VotingProvider>().registerVoteLocally(
                      match.id,
                      false,
                    );
                  },
                  isPrimary: false,
                  width: 140.w,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _TeamInfoWithSelection extends StatelessWidget {
  final String shortName;
  final String fullName;
  final bool isSelected;

  const _TeamInfoWithSelection({
    required this.shortName,
    required this.fullName,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TeamAvatar(shortName: shortName, size: 70.w, isSelected: isSelected),
        SizedBox(height: 12.h),
        Text(fullName, style: AppTextStyles.bold10),
      ],
    );
  }
}
