import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../services/mock_data_service.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wasteData = MockDataService.weeklyWaste;
    final events = MockDataService.academicEvents;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0E1A), Color(0xFF0F172A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
                      Text('Analytics', style: AppTextStyles.headlineLarge),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.download_rounded, color: AppColors.accent, size: 14),
                            const SizedBox(width: 4),
                            Text('Export', style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Predicted vs Actual Line Chart
                const SectionHeader(title: 'Predicted vs Actual Turnout'),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassCard(
                    padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
                    child: SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 100,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.white.withValues(alpha: 0.04),
                              strokeWidth: 1,
                            ),
                          ),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                  if (value.toInt() >= days.length || value.toInt() < 0) return const SizedBox();
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(days[value.toInt()], style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                                  );
                                },
                                interval: 1,
                              ),
                            ),
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          minX: 0, maxX: 6, minY: 0, maxY: 500,
                          lineBarsData: [
                            // Predicted
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 340), FlSpot(1, 380), FlSpot(2, 320),
                                FlSpot(3, 400), FlSpot(4, 280), FlSpot(5, 200), FlSpot(6, 250),
                              ],
                              isCurved: true,
                              color: AppColors.info,
                              barWidth: 2,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(show: true, color: AppColors.info.withValues(alpha: 0.08)),
                            ),
                            // Actual
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 320), FlSpot(1, 390), FlSpot(2, 310),
                                FlSpot(3, 380), FlSpot(4, 300), FlSpot(5, 180), FlSpot(6, 260),
                              ],
                              isCurved: true,
                              color: AppColors.accent,
                              barWidth: 3,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(show: true, color: AppColors.accent.withValues(alpha: 0.08)),
                            ),
                          ],
                        ),
                        duration: const Duration(milliseconds: 800),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Row(
                    children: [
                      Container(width: 12, height: 3, decoration: BoxDecoration(color: AppColors.info, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 6),
                      Text('Predicted', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                      const SizedBox(width: 16),
                      Container(width: 12, height: 3, decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 6),
                      Text('Actual', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Food Waste Trend
                const SectionHeader(title: 'Food Waste vs Saved (This Week)'),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassCard(
                    padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
                    child: SizedBox(
                      height: 180,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 60,
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() < 0 || value.toInt() >= wasteData.length) return const SizedBox();
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(wasteData[value.toInt()]['day'] as String, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                                  );
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          barGroups: wasteData.asMap().entries.map((entry) {
                            return BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY: (entry.value['wasteKg'] as int).toDouble(),
                                  color: AppColors.error.withValues(alpha: 0.7),
                                  width: 8,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                ),
                                BarChartRodData(
                                  toY: (entry.value['savedKg'] as int).toDouble(),
                                  color: AppColors.accent.withValues(alpha: 0.7),
                                  width: 8,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        duration: const Duration(milliseconds: 800),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Row(
                    children: [
                      Container(width: 12, height: 8, decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 6),
                      Text('Wasted (kg)', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                      const SizedBox(width: 16),
                      Container(width: 12, height: 8, decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 6),
                      Text('Saved (kg)', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Academic Calendar Overlay
                const SectionHeader(title: 'Academic Calendar Impact'),
                const SizedBox(height: 8),
                ...events.map((e) {
                  final date = e['date'] as DateTime;
                  final modifier = e['modifier'] as double;
                  final color = modifier > 1.0 ? AppColors.error : modifier < 0.5 ? AppColors.info : AppColors.warning;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    child: GlassCard(
                      padding: const EdgeInsets.all(12),
                      borderColor: color.withValues(alpha: 0.15),
                      child: Row(
                        children: [
                          Text(e['icon'] as String, style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e['event'] as String, style: AppTextStyles.labelLarge.copyWith(fontSize: 13)),
                                Text('${date.day}/${date.month} • Modifier: ${modifier}x', style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              modifier > 1.0 ? '↑ HIGH' : modifier < 0.5 ? '↓ LOW' : '~ AVG',
                              style: AppTextStyles.labelSmall.copyWith(color: color, fontWeight: FontWeight.w700, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
