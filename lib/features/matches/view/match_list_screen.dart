import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:campus_clash/core/constants/app_colors.dart';
import 'package:campus_clash/core/constants/app_text_styles.dart';
import 'package:campus_clash/core/providers/matches_provider.dart';
import 'package:campus_clash/core/models/match_model.dart';
import 'package:campus_clash/features/matches/view/widgets/live_match_card.dart';
import 'package:campus_clash/features/matches/view/widgets/upcoming_match_card.dart';
import 'package:campus_clash/features/matches/view/widgets/finished_match_card.dart';

class MatchListScreen extends StatefulWidget {
  const MatchListScreen({super.key});

  @override
  State<MatchListScreen> createState() => _MatchListScreenState();
}

class _MatchListScreenState extends State<MatchListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _bottomTapCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final matchesProvider = context.watch<MatchesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/logo.png', height: 40.h),
        actions: const [
          // Circular profile icon removed as requested
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16.h),
          _MatchTabBar(tabController: _tabController),
          SizedBox(height: 24.h),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _MatchList(matches: matchesProvider.upcomingMatches),
                _MatchList(matches: matchesProvider.liveMatches),
                _MatchList(matches: matchesProvider.finishedMatches),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          setState(() {
            _bottomTapCount++;
          });
          if (_bottomTapCount >= 10) {
            _bottomTapCount = 0;
            context.push('/admin');
          }
        },
        child: Container(
          height: 70.h,
          // color: AppColors.surfaceVariant,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          margin: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Vote for who you think will win',
                  style: AppTextStyles.bold16.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => context.push('/admin'),
      //   backgroundColor: AppColors.primary,
      //   shape: const CircleBorder(),
      //   child: Icon(Icons.settings, color: Colors.white, size: 32.sp),
      // ),
    );
  }
}

class _MatchTabBar extends StatelessWidget {
  final TabController tabController;

  const _MatchTabBar({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      isScrollable: true,
      dividerColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
      padding: EdgeInsets.only(left: 16.w),
      tabAlignment: TabAlignment.start,
      labelPadding: EdgeInsets.symmetric(horizontal: 7.w),
      indicator: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24.r),
      ),
      labelColor: Colors.white,
      unselectedLabelColor: AppColors.textSecondary,
      labelStyle: AppTextStyles.black12,
      tabs: const [
        _MatchTab(label: 'UPCOMING'),
        _MatchTab(label: 'LIVE'),
        _MatchTab(label: 'FINISHED'),
      ],
    );
  }
}

class _MatchTab extends StatelessWidget {
  final String label;

  const _MatchTab({required this.label});

  @override
  Widget build(BuildContext context) {
    return Tab(
      iconMargin: EdgeInsets.zero,

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Align(alignment: Alignment.center, child: Text(label)),
      ),
    );
  }
}

class _MatchList extends StatelessWidget {
  final List<MatchModel> matches;

  const _MatchList({required this.matches});

  @override
  Widget build(BuildContext context) {
    if (matches.isEmpty) {
      return Center(
        child: Text('No Matches Yet', style: AppTextStyles.regular16),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];
        switch (match.status) {
          case MatchStatus.upcoming:
            return UpcomingMatchCard(match: match);
          case MatchStatus.live:
            return LiveMatchCard(match: match);
          case MatchStatus.finished:
            return FinishedMatchCard(match: match);
        }
      },
    );
  }
}
