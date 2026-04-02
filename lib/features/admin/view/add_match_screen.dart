import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:campus_clash/core/constants/app_colors.dart';
import 'package:campus_clash/core/constants/app_text_styles.dart';
import 'package:campus_clash/core/models/match_model.dart';
import 'package:campus_clash/core/providers/matches_provider.dart';

class AddMatchScreen extends StatefulWidget {
  const AddMatchScreen({super.key});

  @override
  State<AddMatchScreen> createState() => _AddMatchScreenState();
}

class _AddMatchScreenState extends State<AddMatchScreen> {
  final _teamAController = TextEditingController();
  final _teamBController = TextEditingController();
  final _venueController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  MatchStatus _status = MatchStatus.upcoming;
  bool _isLoading = false;

  void _createMatch() async {
    if (_teamAController.text.isEmpty ||
        _teamBController.text.isEmpty ||
        _venueController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? dateStr;
      if (_selectedDate != null) {
        dateStr = DateFormat(
          'MMM dd yyyy',
        ).format(_selectedDate!).toUpperCase();
      }

      String? timeStr;
      if (_selectedTime != null) {
        timeStr = _selectedTime!.format(context);
      }
      
      String matchId = '${_teamAController.text.replaceAll(' ', '')}_${_teamBController.text.replaceAll(' ', '')}';
      if (dateStr != null) {
        matchId += '-${dateStr.replaceAll(' ', '')}';
      }
      if (timeStr != null) {
        matchId += '-${timeStr.replaceAll(' ', '').replaceAll(':', '')}';
      }

      final newMatch = MatchModel(
        id: matchId,
        homeTeam: _teamAController.text,
        awayTeam: _teamBController.text,
        homeGoals: 0,
        awayGoals: 0,
        status: _status,
        homeVotes: 0,
        awayVotes: 0,
        arena: _venueController.text,
        date: dateStr,
        time: timeStr,
      );

      await context.read<MatchesProvider>().addMatch(newMatch);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Match for ${newMatch.homeTeam} vs ${newMatch.awayTeam} created successfully!',
              style: AppTextStyles.bold12.copyWith(color: Colors.black),
            ),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error creating match: $e',
              style: AppTextStyles.bold12.copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _teamAController.dispose();
    _teamBController.dispose();
    _venueController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              const AddMatchHeader(),
              SizedBox(height: 32.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AddMatchTeamField(
                        label: 'TEAM A NAME',
                        controller: _teamAController,
                      ),
                      SizedBox(height: 24.h),
                      AddMatchTeamField(
                        label: 'TEAM B NAME',
                        controller: _teamBController,
                      ),
                      SizedBox(height: 24.h),
                      AddMatchVenueField(controller: _venueController),
                      SizedBox(height: 24.h),
                      AddMatchScheduleField(
                        selectedDate: _selectedDate,
                        selectedTime: _selectedTime,
                        onPickDate: _pickDate,
                        onPickTime: _pickTime,
                      ),
                      SizedBox(height: 40.h),
                      AddMatchStatusToggle(
                        status: _status,
                        onStatusChanged: (status) =>
                            setState(() => _status = status),
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
              AddMatchCreateButton(
                onPressed: _isLoading ? () {} : _createMatch,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class AddMatchHeader extends StatelessWidget {
  const AddMatchHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: Colors.white, size: 20.sp),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'NEW MATCH',
          style: AppTextStyles.black48.copyWith(fontSize: 32.sp),
        ),
        Text(
          'Initialize the next legendary showdown',
          style: AppTextStyles.regular16.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}

class AddMatchTeamField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const AddMatchTeamField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bold10.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: AppTextStyles.bold12,
                  decoration: InputDecoration(
                    hintText: 'Enter Department Name',
                    hintStyle: AppTextStyles.regular16.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                  ),
                ),
              ),
              Icon(
                Icons.shield_outlined,
                color: AppColors.primary,
                size: 20.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AddMatchVenueField extends StatelessWidget {
  final TextEditingController controller;

  const AddMatchVenueField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'VENUE / ARENA',
          style: AppTextStyles.bold10.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: TextField(
            controller: controller,
            style: AppTextStyles.bold12,
            decoration: InputDecoration(
              hintText: 'Enter Arena Name',
              hintStyle: AppTextStyles.regular16.copyWith(
                color: AppColors.textTertiary,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 16.h),
            ),
          ),
        ),
      ],
    );
  }
}

class AddMatchScheduleField extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;

  const AddMatchScheduleField({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.onPickDate,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = selectedDate != null
        ? DateFormat('MM/dd/yyyy').format(selectedDate!)
        : 'mm/dd/yyyy';
    final timeStr = selectedTime != null
        ? selectedTime!.format(context)
        : '--:--';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MATCH SCHEDULE',
                style: AppTextStyles.bold10.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onPickDate,
                      child: _ScheduleChip(
                        label: 'DATE',
                        value: dateStr,
                        isSelected: selectedDate != null,
                        icon: Icons.calendar_today,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: onPickTime,
                      child: _ScheduleChip(
                        label: 'TIME',
                        value: timeStr,
                        isSelected: selectedTime != null,
                        icon: Icons.access_time,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScheduleChip extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final IconData icon;

  const _ScheduleChip({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isSelected
              ? AppColors.primary.withOpacity(0.5)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : AppColors.textTertiary,
            size: 14.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bold10.copyWith(
                    fontSize: 8.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: AppTextStyles.bold12.copyWith(
                    fontSize: 10.sp,
                    color: isSelected ? Colors.white : AppColors.textTertiary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddMatchStatusToggle extends StatelessWidget {
  final MatchStatus status;
  final Function(MatchStatus) onStatusChanged;

  const AddMatchStatusToggle({
    super.key,
    required this.status,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MATCH INTENSITY STATUS',
          style: AppTextStyles.bold10.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _StatusCard(
                label: 'UPCOMING',
                icon: Icons.calendar_today_outlined,
                isActive: status == MatchStatus.upcoming,
                onTap: () => onStatusChanged(MatchStatus.upcoming),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _StatusCard(
                label: 'LIVE',
                icon: Icons.sensors_outlined,
                isActive: status == MatchStatus.live,
                onTap: () => onStatusChanged(MatchStatus.live),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AddMatchCreateButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddMatchCreateButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(vertical: 20.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CREATE MATCH',
              style: AppTextStyles.black12Spacing.copyWith(
                color: Colors.black,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Transform.rotate(
              angle: 0.8,
              child: Icon(
                Icons.rocket_launch_outlined,
                color: Colors.black,
                size: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _StatusCard({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        decoration: BoxDecoration(
          color: isActive ? Colors.transparent : AppColors.surface,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              size: 24.sp,
            ),
            SizedBox(height: 12.h),
            Text(
              label,
              style: AppTextStyles.bold10.copyWith(
                color: isActive ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
