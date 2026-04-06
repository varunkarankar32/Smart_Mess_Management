import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../services/mock_data_service.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final headcount = MockDataService.liveHeadcount;
    final capacity = MockDataService.totalCapacity;
    final occupancy = (headcount / capacity * 100).clamp(0, 100).toInt();
                      (scan) => Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            scan.isValid ? '/admin/users' : '/admin/scanner',
                          ),
                          child: NeumorphicSection(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: scan.isValid
                                          ? [
                                              AppColors.accent.withValues(alpha: 0.25),
                                              AppColors.surface,
                                            ]
                                          : [
                                              AppColors.error.withValues(alpha: 0.25),
                                              AppColors.surface,
                                            ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    scan.isValid
                                        ? Icons.check_circle_rounded
                                        : Icons.cancel_rounded,
                                    color: scan.isValid
                                        ? AppColors.accentLight
                                        : AppColors.error,
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
                                        scan.isValid
                                            ? 'Validated at serving counter'
                                            : 'Needs review before serving',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: scan.isValid
                                              ? AppColors.accentLight
                                              : AppColors.error,
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
                            color: AppColors.accent,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Waste Prevention Active',
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.accent,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '142 "Not Eating" toggles today → 45 kg food saved → ₹6,750 saved',
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

                // Overview Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Scanned Today',
                          value: '$headcount',
                          icon: Icons.qr_code_scanner_rounded,
                          color: AppColors.info,
                          subtitle: 'LIVE',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          title: 'Occupancy',
                          value: '$occupancy%',
                          icon: Icons.people_alt_rounded,
                          color: occupancy > 80
                              ? AppColors.error
                              : occupancy > 50
                              ? AppColors.warning
                              : AppColors.accent,
                          subtitle: occupancy > 80
                              ? 'HIGH'
                              : occupancy > 50
                              ? 'MODERATE'
                              : 'LOW',
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
                          title: 'Pending Rebates',
                          value: '₹12.4K',
                          icon: Icons.account_balance_wallet_rounded,
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          title: 'Feedback Score',
                          value: '4.2',
                          icon: Icons.star_rounded,
                          color: AppColors.accentLight,
                          subtitle: '↑ 0.3',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                SectionHeader(
                  title: 'Operations Shortcuts',
                  actionLabel: 'Live Board →',
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

                // Footfall Chart
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
                                getTitlesWidget: (value, meta) {
                                  final data = MockDataService.hourlyFootfall;
                                  if (value.toInt() >= data.length)
                                    return const SizedBox();
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      (data[value.toInt()]['hour'] as String)
                                          .replaceAll(' ', '\n'),
                                      style: AppTextStyles.bodySmall.copyWith(
                                        fontSize: 8,
                                      ),
                                      textAlign: TextAlign.center,
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
                                final val = (entry.value['count'] as int)
                                    .toDouble();
                                final isPeak = val > 250;
                                return BarChartGroupData(
                                  x: entry.key,
                                  barRods: [
                                    BarChartRodData(
                                      toY: val,
                                      width: 14,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(6),
                                      ),
                                      gradient: LinearGradient(
                                        colors: isPeak
                                            ? [
                                                AppColors.error,
                                                AppColors.warning,
                                              ]
                                            : [
                                                AppColors.accent,
                                                AppColors.accentLight,
                                              ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                  ],
                                );
                              })
                              .toList(),
                        ),
                        duration: const Duration(milliseconds: 800),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Recent Scans
                const SectionHeader(title: 'Recent Scans'),
                const SizedBox(height: 8),
                ...MockDataService.recentScans
                    .take(3)
                    .map(
                      (scan) => Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                        child: NeumorphicSection(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: scan.isValid
                                        ? [
                                            AppColors.accent.withValues(
                                              alpha: 0.25,
                                            ),
                                            AppColors.surface,
                                          ]
                                        : [
                                            AppColors.error.withValues(
                                              alpha: 0.25,
                                            ),
                                            AppColors.surface,
                                          ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  scan.isValid
                                      ? Icons.check_circle_rounded
                                      : Icons.cancel_rounded,
                                  color: scan.isValid
                                      ? AppColors.accentLight
                                      : AppColors.error,
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
                                      scan.isValid
                                          ? 'Validated at serving counter'
                                          : 'Needs review before serving',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: scan.isValid
                                            ? AppColors.accentLight
                                            : AppColors.error,
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
        child: Row(
          children: [
            NeuIconTile(
              icon: icon,
              iconColor: color,
              padding: const EdgeInsets.all(8),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLarge.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 9),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
