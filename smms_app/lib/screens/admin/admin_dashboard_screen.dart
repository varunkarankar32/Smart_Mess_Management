import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../services/mock_data_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final attendanceCount = MockDataService.todaysAttendanceCount;
    final validAttendanceCount = MockDataService.todaysValidAttendanceCount;
    final duplicateAttendanceCount =
        MockDataService.todaysDuplicateAttendanceCount;
    final pendingLeaves = MockDataService.leaveRequests.length;
    final feedbackEntries = MockDataService.feedbackSubmissions.length;
    final occupancy = (MockDataService.currentOccupancy).clamp(0, 100).toInt();
    final recentScans = MockDataService.recentScans.take(5).toList();

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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Admin Control Room',
                          style: AppTextStyles.headlineLarge,
                        ),
                      ),
                      const NeuPill(label: 'Live'),
                      const SizedBox(width: 8),
                      const PulsingDot(color: AppColors.accentLight, size: 6),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'QR validation, leave requests, feedback, and crowd flow are tracked in one live dashboard.',
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: NeumorphicSection(
                    borderColor: AppColors.accent.withValues(alpha: 0.18),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          color: AppColors.accent,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Attendance workflow active',
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.accent,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$attendanceCount scans today, $duplicateAttendanceCount duplicate attempts blocked, $pendingLeaves leave requests pending.',
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const PulsingDot(color: AppColors.accent),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Scans Today',
                          value: '$attendanceCount',
                          icon: Icons.qr_code_scanner_rounded,
                          color: AppColors.info,
                          subtitle: 'LIVE',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          title: 'Validated',
                          value: '$validAttendanceCount',
                          icon: Icons.check_circle_rounded,
                          color: AppColors.accent,
                          subtitle: 'OK',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Pending Leaves',
                          value: '$pendingLeaves',
                          icon: Icons.event_busy_rounded,
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          title: 'Feedback Entries',
                          value: '$feedbackEntries',
                          icon: Icons.rate_review_rounded,
                          color: AppColors.accentLight,
                          subtitle: 'Student voice',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SectionHeader(
                  title: 'Operations Shortcuts',
                  actionLabel: 'Live Board ->',
                  onAction: () =>
                      Navigator.pushNamed(context, '/admin/kitchen'),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.7,
                    children: [
                      _shortcutCard(
                        context,
                        icon: Icons.qr_code_scanner_rounded,
                        title: 'Scanner',
                        subtitle: 'Validate entry',
                        color: AppColors.info,
                        route: '/admin/scanner',
                      ),
                      _shortcutCard(
                        context,
                        icon: Icons.menu_book_rounded,
                        title: 'Menu Planner',
                        subtitle: 'Plan weekly menu',
                        color: AppColors.accent,
                        route: '/admin/menu',
                      ),
                      _shortcutCard(
                        context,
                        icon: Icons.inventory_2_rounded,
                        title: 'Inventory',
                        subtitle: 'Stock & leftovers',
                        color: AppColors.warning,
                        route: '/admin/inventory',
                      ),
                      _shortcutCard(
                        context,
                        icon: Icons.inbox_rounded,
                        title: 'Feedback',
                        subtitle: 'Top & worst dishes',
                        color: AppColors.error,
                        route: '/admin/feedback',
                      ),
                      _shortcutCard(
                        context,
                        icon: Icons.kitchen_rounded,
                        title: 'Kitchen',
                        subtitle: 'Live serving line',
                        color: AppColors.info,
                        route: '/admin/kitchen',
                      ),
                      _shortcutCard(
                        context,
                        icon: Icons.science_rounded,
                        title: 'Digital Twin',
                        subtitle: 'Scenario sim',
                        color: AppColors.accentLight,
                        route: '/admin/simulation',
                      ),
                      _shortcutCard(
                        context,
                        icon: Icons.flash_on_rounded,
                        title: 'Surge',
                        subtitle: 'Happy hour push',
                        color: AppColors.warning,
                        route: '/admin/surge',
                      ),
                      _shortcutCard(
                        context,
                        icon: Icons.map_rounded,
                        title: 'Heatmap',
                        subtitle: 'Crowd zones',
                        color: AppColors.error,
                        route: '/admin/heatmap',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const SectionHeader(title: 'Hourly Footfall'),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassCard(
                    padding: const EdgeInsets.fromLTRB(8, 20, 16, 8),
                    child: SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 400,
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipColor: (_) => AppColors.surfaceLight,
                              tooltipRoundedRadius: 8,
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                final data = MockDataService.hourlyFootfall;
                                return BarTooltipItem(
                                  '${data[group.x.toInt()]['hour']}\n${rod.toY.toInt()} students',
                                  AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textPrimary,
                                    fontSize: 11,
                                  ),
                                );
                              },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                getTitlesWidget: (value, meta) {
                                  final data = MockDataService.hourlyFootfall;
                                  if (value.toInt() >= data.length) {
                                    return const SizedBox();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      (data[value.toInt()]['hour'] as String)
                                          .replaceAll(' ', '\n'),
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        fontSize: 8,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 100,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.white.withValues(alpha: 0.04),
                              strokeWidth: 1,
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: MockDataService.hourlyFootfall
                              .asMap()
                              .entries
                              .map((entry) {
                                final value = (entry.value['count'] as int)
                                    .toDouble();
                                final isPeak = value > 250;
                                return BarChartGroupData(
                                  x: entry.key,
                                  barRods: [
                                    BarChartRodData(
                                      toY: value,
                                      width: 12,
                                      borderRadius: BorderRadius.circular(6),
                                      color: isPeak
                                          ? AppColors.warning
                                          : AppColors.accent,
                                      backDrawRodData:
                                          BackgroundBarChartRodData(
                                            show: true,
                                            toY: 400,
                                            color: AppColors.surfaceLight,
                                          ),
                                    ),
                                  ],
                                );
                              })
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SectionHeader(
                  title: 'Recent Scans',
                  actionLabel: 'Open Scanner ->',
                  onAction: () =>
                      Navigator.pushNamed(context, '/admin/scanner'),
                ),
                const SizedBox(height: 4),
                ...recentScans.map(
                  (scan) => Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        scan.status == 'valid'
                            ? '/admin/users'
                            : '/admin/scanner',
                      ),
                      child: NeumorphicSection(
                        padding: const EdgeInsets.all(12),
                        borderColor: _scanBorderColor(scan.status),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: _scanGradient(scan.status),
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _scanIcon(scan.status),
                                color: _scanIconColor(scan.status),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    scan.userName,
                                    style: AppTextStyles.labelLarge.copyWith(
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    scan.rollNo,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      fontSize: 10,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _scanMessage(scan.status),
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: _scanTextColor(scan.status),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${scan.scanTime.hour}:${scan.scanTime.minute.toString().padLeft(2, '0')}',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _shortcutCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: NeumorphicSection(
        borderColor: color.withValues(alpha: 0.18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 10),
            Text(title, style: AppTextStyles.labelLarge.copyWith(fontSize: 13)),
            const SizedBox(height: 2),
            Text(subtitle, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }

  List<Color> _scanGradient(String status) {
    switch (status) {
      case 'invalid':
        return [AppColors.error.withValues(alpha: 0.25), AppColors.surface];
      case 'duplicate':
        return [AppColors.warning.withValues(alpha: 0.25), AppColors.surface];
      default:
        return [AppColors.accent.withValues(alpha: 0.25), AppColors.surface];
    }
  }

  Color _scanBorderColor(String status) {
    switch (status) {
      case 'invalid':
        return AppColors.error.withValues(alpha: 0.18);
      case 'duplicate':
        return AppColors.warning.withValues(alpha: 0.18);
      default:
        return AppColors.accent.withValues(alpha: 0.18);
    }
  }

  IconData _scanIcon(String status) {
    switch (status) {
      case 'invalid':
        return Icons.cancel_rounded;
      case 'duplicate':
        return Icons.warning_amber_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }

  Color _scanIconColor(String status) {
    switch (status) {
      case 'invalid':
        return AppColors.error;
      case 'duplicate':
        return AppColors.warning;
      default:
        return AppColors.accentLight;
    }
  }

  Color _scanTextColor(String status) {
    switch (status) {
      case 'invalid':
        return AppColors.error;
      case 'duplicate':
        return AppColors.warning;
      default:
        return AppColors.accentLight;
    }
  }

  String _scanMessage(String status) {
    switch (status) {
      case 'invalid':
        return 'Needs review before serving';
      case 'duplicate':
        return 'Duplicate entry blocked';
      default:
        return 'Validated at serving counter';
    }
  }
}
