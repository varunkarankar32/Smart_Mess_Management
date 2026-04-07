import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../services/mock_data_service.dart';

class HeatmapScreen extends StatelessWidget {
  const HeatmapScreen({super.key});

  Color _congestionColor(double val) {
    if (val < 0.4) return AppColors.crowdLow;
    if (val < 0.65) return AppColors.crowdMedium;
    if (val < 0.85) return AppColors.crowdHigh;
    return AppColors.crowdFull;
  }

  @override
  Widget build(BuildContext context) {
    final zones = MockDataService.heatmapZones;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
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
                      const Icon(Icons.map_rounded, color: AppColors.info, size: 24),
                      const SizedBox(width: 10),
                      Text('Crowd Heatmap', style: AppTextStyles.headlineLarge),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Live congestion map of the mess hall', style: AppTextStyles.bodySmall),
                ),
                const SizedBox(height: 20),

                // Heatmap visualization
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Mess Hall Floorplan', style: AppTextStyles.titleMedium),
                            const Spacer(),
                            const PulsingDot(color: AppColors.accent, size: 6),
                            const SizedBox(width: 4),
                            Text('LIVE', style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent, fontWeight: FontWeight.w700, fontSize: 9)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        AspectRatio(
                          aspectRatio: 1.2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Stack(
                                  children: [
                                    // Grid lines
                                    ...List.generate(5, (i) {
                                      final y = constraints.maxHeight * (i + 1) / 6;
                                      return Positioned(
                                        top: y, left: 0, right: 0,
                                        child: Container(height: 1, color: Colors.white.withValues(alpha: 0.02)),
                                      );
                                    }),

                                    // Zone Dots
                                    ...zones.map((zone) {
                                      final congestion = zone['congestion'] as double;
                                      final color = _congestionColor(congestion);
                                      final x = (zone['x'] as double) * constraints.maxWidth;
                                      final y = (1.0 - (zone['y'] as double)) * constraints.maxHeight;
                                      final radius = 16.0 + congestion * 18;

                                      return Positioned(
                                        left: x - radius,
                                        top: y - radius,
                                        child: Container(
                                          width: radius * 2,
                                          height: radius * 2,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: color.withValues(alpha: 0.25),
                                            border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
                                            boxShadow: [
                                              BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 12),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${(congestion * 100).toInt()}%',
                                              style: AppTextStyles.labelSmall.copyWith(color: color, fontSize: 9, fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Legend
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _legendDot(AppColors.crowdLow, 'Empty'),
                            const SizedBox(width: 12),
                            _legendDot(AppColors.crowdMedium, 'Moderate'),
                            const SizedBox(width: 12),
                            _legendDot(AppColors.crowdHigh, 'High'),
                            const SizedBox(width: 12),
                            _legendDot(AppColors.crowdFull, 'Full'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Zone Details
                const SectionHeader(title: 'Zone Breakdown'),
                const SizedBox(height: 4),
                ...zones.map((zone) {
                  final congestion = zone['congestion'] as double;
                  final color = _congestionColor(congestion);
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    child: GlassCard(
                      padding: const EdgeInsets.all(10),
                      borderColor: color.withValues(alpha: 0.15),
                      child: Row(
                        children: [
                          Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Container(
                                width: 10, height: 10,
                                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(zone['zone'] as String, style: AppTextStyles.titleMedium.copyWith(fontSize: 13))),
                          SizedBox(
                            width: 60,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: congestion,
                                backgroundColor: AppColors.surfaceLight,
                                valueColor: AlwaysStoppedAnimation(color),
                                minHeight: 4,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(congestion * 100).toInt()}%',
                            style: AppTextStyles.labelSmall.copyWith(color: color, fontWeight: FontWeight.w700),
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

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8, height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 9)),
      ],
    );
  }
}
