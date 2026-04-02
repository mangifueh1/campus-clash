import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:campus_clash/core/models/match_model.dart';
import 'package:campus_clash/core/utils/match_utils.dart';
import 'package:campus_clash/features/matches/view/widgets/team_avatar.dart';
import 'package:campus_clash/core/constants/app_colors.dart';
import 'package:campus_clash/core/constants/app_text_styles.dart';
import 'package:campus_clash/core/widgets/app_button.dart';
import 'package:campus_clash/core/widgets/status_badge.dart';
import 'package:campus_clash/core/providers/matches_provider.dart';
import 'package:campus_clash/core/providers/voting_provider.dart';
import 'package:campus_clash/core/widgets/vote_progress_bar.dart';

class LiveMatchCard extends StatelessWidget {
  final MatchModel match;

  const LiveMatchCard({super.key, required this.match});

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
              Text(
                '${match.arena ?? "STADIUM ARENA"} • ${match.time ?? "Q2"}',
                style: AppTextStyles.bold12,
              ),
            ],
          ),
          SizedBox(height: 32.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _TeamInfo(
                shortName: getTeamShortName(match.homeTeam),
                fullName: match.homeTeam,
                isSelected: hasVoted && votedForHome == true,
              ),
              Text(
                '${match.homeGoals} - ${match.awayGoals}',
                style: AppTextStyles.black48,
              ),
              _TeamInfo(
                shortName: getTeamShortName(match.awayTeam),
                fullName: match.awayTeam,
                isSelected: hasVoted && votedForHome == false,
              ),
            ],
          ),
          SizedBox(height: 40.h),
          if (hasVoted)
            VoteProgressBar(
              homeVotes: match.homeVotes,
              awayVotes: match.awayVotes,
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton(
                  text: 'VOTE ${getTeamShortName(match.homeTeam)}',
                  onPressed: () {
                    context.read<MatchesProvider>().voteForTeam(match.id, true);
                    context.read<VotingProvider>().registerVoteLocally(match.id, true);
                  },
                  width: 140.w,
                ),
                AppButton(
                  text: 'VOTE ${getTeamShortName(match.awayTeam)}',
                  onPressed: () {
                    context.read<MatchesProvider>().voteForTeam(match.id, false);
                    context.read<VotingProvider>().registerVoteLocally(match.id, false);
                  },
                  isPrimary: false,
                  width: 140.w,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _TeamInfo extends StatelessWidget {
  final String shortName;
  final String fullName;
  final bool isSelected;

  const _TeamInfo({
    required this.shortName,
    required this.fullName,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TeamAvatar(shortName: shortName, isSelected: isSelected),
        SizedBox(height: 12.h),
        Text(fullName, style: AppTextStyles.extraBold10),
      ],
    );
  }
}
