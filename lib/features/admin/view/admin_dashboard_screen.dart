import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:campus_clash/core/constants/app_colors.dart';
import 'package:campus_clash/core/constants/app_text_styles.dart';
import 'package:campus_clash/core/providers/matches_provider.dart';
import 'package:campus_clash/features/admin/view/widgets/admin_match_card.dart';
import 'package:campus_clash/features/admin/view/widgets/admin_action_button.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Image.asset('assets/logo.png', height: 24.h),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Text(
                'CONTROL CENTER',
                style: AppTextStyles.bold10.copyWith(color: AppColors.primary),
              ),
              SizedBox(height: 4.h),
              Text(
                'ADMIN\nDASHBOARD',
                style: AppTextStyles.black48.copyWith(height: 1.1),
              ),
              SizedBox(height: 24.h),
              AdminActionButton(
                text: 'ADD MATCH',
                icon: Icons.add,
                onPressed: () {
                  context.push('/admin/add-match');
                },
              ),
              SizedBox(height: 40.h),
              TabBar(
                dividerColor: Colors.transparent,
                indicatorColor: AppColors.primary,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: AppTextStyles.bold12,
                unselectedLabelStyle: AppTextStyles.bold12,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(text: 'LIVE'),
                  Tab(text: 'UPCOMING'),
                ],
              ),
              SizedBox(height: 24.h),
              const Expanded(
                child: TabBarView(
                  children: [
                    _MatchTabContent(isLive: true),
                    _MatchTabContent(isLive: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MatchTabContent extends StatelessWidget {
  final bool isLive;
  const _MatchTabContent({required this.isLive});

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchesProvider>(
      builder: (context, provider, child) {
        final matches = isLive
            ? provider.liveMatches
            : provider.upcomingMatches;

        if (matches.isEmpty) {
          return Center(
            child: Text(
              'No matches found',
              style: AppTextStyles.bold12.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.only(bottom: 24.h),
          itemCount: matches.length,
          itemBuilder: (context, index) {
            return AdminMatchCard(match: matches[index]);
          },
        );
      },
    );
  }
}
