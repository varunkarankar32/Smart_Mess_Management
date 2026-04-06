import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../services/mock_data_service.dart';

class LeaveManagementScreen extends StatefulWidget {
  const LeaveManagementScreen({super.key});

  @override
  State<LeaveManagementScreen> createState() => _LeaveManagementScreenState();
}

class _LeaveManagementScreenState extends State<LeaveManagementScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final Map<DateTime, List<String>> _markedLeaves = {};
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _toggleMeal(DateTime day, String meal) {
    final key = DateTime(day.year, day.month, day.day);
    setState(() {
      _markedLeaves[key] ??= [];
      if (_markedLeaves[key]!.contains(meal)) {
        _markedLeaves[key]!.remove(meal);
        if (_markedLeaves[key]!.isEmpty) _markedLeaves.remove(key);
      } else {
        _markedLeaves[key]!.add(meal);
      }
    });
  }

  void _submitLeaveRequest() {
    if (_selectedDay == null) return;

    final key = DateTime(
      _selectedDay!.year,
      _selectedDay!.month,
      _selectedDay!.day,
    );
    final meals = _markedLeaves[key];
    if (meals == null || meals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select at least one meal before submitting.'),
        ),
      );
      return;
    }

    final reason = _reasonController.text.trim();
    for (final meal in meals) {
      MockDataService.submitLeave(
        userId: MockDataService.currentUser.id,
        date: key,
        mealType: meal,
        reason: reason,
      );
    }

    setState(() {
      _markedLeaves.remove(key);
      _reasonController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Leave request submitted for ${meals.length} meal(s).'),
        backgroundColor: AppColors.accent,
      ),
    );
  }

  int get _totalLeaveMeals =>
      _markedLeaves.values.fold(0, (sum, meals) => sum + meals.length);
  double get _estimatedSavings =>
      _totalLeaveMeals * 0.3; // 0.3 kg per meal saved

  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
        return AppColors.accent;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F1724), Color(0xFF111B2D), Color(0xFF0F1724)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Text('Leave Planner', style: AppTextStyles.headlineLarge),
                    const Spacer(),
                    NeumorphicSection(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      borderRadius: 12,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.eco_rounded,
                            color: AppColors.accentLight,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_estimatedSavings.toStringAsFixed(1)} kg saved',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Mark meals you\'ll skip to reduce food waste',
                  style: AppTextStyles.bodyMedium,
                ),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Calendar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GlassCard(
                          padding: const EdgeInsets.all(8),
                          child: TableCalendar(
                            firstDay: DateTime.now().subtract(
                              const Duration(days: 30),
                            ),
                            lastDay: DateTime.now().add(
                              const Duration(days: 60),
                            ),
                            focusedDay: _focusedDay,
                            calendarFormat: _calendarFormat,
                            onFormatChanged: (format) =>
                                setState(() => _calendarFormat = format),
                            selectedDayPredicate: (day) =>
                                isSameDay(_selectedDay, day),
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            },
                            calendarStyle: CalendarStyle(
                              defaultTextStyle: AppTextStyles.bodyMedium
                                  .copyWith(color: AppColors.textPrimary),
                              weekendTextStyle: AppTextStyles.bodyMedium
                                  .copyWith(color: AppColors.textMuted),
                              outsideTextStyle: AppTextStyles.bodyMedium
                                  .copyWith(
                                    color: AppColors.textMuted.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                              todayDecoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              todayTextStyle: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.accent,
                              ),
                              selectedDecoration: const BoxDecoration(
                                gradient: AppColors.accentGradient,
                                shape: BoxShape.circle,
                              ),
                              selectedTextStyle: AppTextStyles.bodyMedium
                                  .copyWith(color: Colors.white),
                              markerDecoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                              markersMaxCount: 3,
                              markerSize: 5,
                            ),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              titleTextStyle: AppTextStyles.titleMedium,
                              leftChevronIcon: const Icon(
                                Icons.chevron_left_rounded,
                                color: AppColors.textSecondary,
                              ),
                              rightChevronIcon: const Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.textMuted,
                              ),
                              weekendStyle: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                            eventLoader: (day) {
                              final key = DateTime(
                                day.year,
                                day.month,
                                day.day,
                              );
                              return _markedLeaves[key] ?? [];
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Meal toggles for selected day
                      if (_selectedDay != null &&
                          !_selectedDay!.isBefore(
                            DateTime.now().subtract(const Duration(days: 1)),
                          )) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: NeumorphicSection(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Skip meals on ${_selectedDay!.day}/${_selectedDay!.month}',
                                  style: AppTextStyles.titleMedium,
                                ),
                                const SizedBox(height: 12),
                                ...[
                                  'Breakfast',
                                  'Lunch',
                                  'Snacks',
                                  'Dinner',
                                ].map((meal) {
                                  final key = DateTime(
                                    _selectedDay!.year,
                                    _selectedDay!.month,
                                    _selectedDay!.day,
                                  );
                                  final isMarked =
                                      _markedLeaves[key]?.contains(meal) ??
                                      false;
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: GestureDetector(
                                      onTap: () =>
                                          _toggleMeal(_selectedDay!, meal),
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: isMarked
                                              ? LinearGradient(
                                                  colors: [
                                                    AppColors.error.withValues(
                                                      alpha: 0.08,
                                                    ),
                                                    AppColors.surface,
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                )
                                              : const LinearGradient(
                                                  colors: [
                                                    AppColors.surfaceRaised,
                                                    AppColors.surface,
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: isMarked
                                                ? AppColors.error.withValues(
                                                    alpha: 0.3,
                                                  )
                                                : Colors.white.withValues(
                                                    alpha: 0.05,
                                                  ),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              isMarked
                                                  ? Icons.cancel_rounded
                                                  : Icons.circle_outlined,
                                              color: isMarked
                                                  ? AppColors.error
                                                  : AppColors.textMuted,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              meal,
                                              style: AppTextStyles.titleMedium
                                                  .copyWith(
                                                    color: isMarked
                                                        ? AppColors.error
                                                        : AppColors.textPrimary,
                                                    decoration: isMarked
                                                        ? TextDecoration
                                                              .lineThrough
                                                        : null,
                                                  ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              isMarked ? 'Skipping' : 'Eating',
                                              style: AppTextStyles.bodySmall
                                                  .copyWith(
                                                    color: isMarked
                                                        ? AppColors.error
                                                        : AppColors.accent,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _reasonController,
                                  minLines: 1,
                                  maxLines: 3,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Optional reason for leave',
                                    hintStyle: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textMuted,
                                    ),
                                    filled: true,
                                    fillColor: AppColors.surface,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: Colors.white.withValues(
                                          alpha: 0.05,
                                        ),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: Colors.white.withValues(
                                          alpha: 0.05,
                                        ),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: const BorderSide(
                                        color: AppColors.accent,
                                        width: 1.2,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                GestureDetector(
                                  onTap: _submitLeaveRequest,
                                  child: const NeumorphicSection(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    borderRadius: 12,
                                    child: Center(
                                      child: Text(
                                        'Submit Leave Request',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Summary Card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: NeumorphicSection(
                          borderColor: AppColors.accent.withValues(alpha: 0.15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '$_totalLeaveMeals',
                                      style: AppTextStyles.statNumber.copyWith(
                                        fontSize: 28,
                                      ),
                                    ),
                                    Text(
                                      'Meals Skipped',
                                      style: AppTextStyles.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.white.withValues(alpha: 0.05),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '${_estimatedSavings.toStringAsFixed(1)} kg',
                                      style: AppTextStyles.statNumber.copyWith(
                                        fontSize: 28,
                                        color: AppColors.accent,
                                      ),
                                    ),
                                    Text(
                                      'Food Saved',
                                      style: AppTextStyles.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Builder(
                          builder: (context) {
                            final recentRequests = MockDataService.leaveRequests
                                .where(
                                  (request) =>
                                      request.userId ==
                                      MockDataService.currentUser.id,
                                )
                                .take(4)
                                .toList();

                            return NeumorphicSection(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Submitted Requests',
                                    style: AppTextStyles.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  if (recentRequests.isEmpty)
                                    Text(
                                      'No leave requests submitted yet.',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                    )
                                  else
                                    ...recentRequests.map(
                                      (request) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.event_busy_rounded,
                                              color: AppColors.error,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                '${request.mealType} - ${request.date.day}/${request.date.month}',
                                                style: AppTextStyles.bodySmall,
                                              ),
                                            ),
                                            Text(
                                              MockDataService.leaveRequestStatus(
                                                request.id,
                                              ).toUpperCase(),
                                              style: AppTextStyles.labelSmall
                                                  .copyWith(
                                                    color: _statusColor(
                                                      MockDataService.leaveRequestStatus(
                                                        request.id,
                                                      ),
                                                    ),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
