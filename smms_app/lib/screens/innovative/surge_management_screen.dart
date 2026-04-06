import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../services/mock_data_service.dart';

class SurgeManagementScreen extends StatelessWidget {
  const SurgeManagementScreen({super.key});

  Color _slotColor(String color) {
    switch (color) {
      case 'red':
        return AppColors.error;
      case 'orange':
        return AppColors.crowdHigh;
      case 'yellow':
        return AppColors.warning;
      case 'green':
        return AppColors.accent;
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final slots = MockDataService.surgeSlots;

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
                      const NeuIconTile(
                        icon: Icons.flash_on_rounded,
                        iconColor: AppColors.warning,
                        padding: EdgeInsets.all(8),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Surge Manager',
                          style: AppTextStyles.headlineLarge,
                        ),
                      ),
                      const NeuPill(label: 'Off-Peak'),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Manage crowd surges with dynamic incentives',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
                const SizedBox(height: 20),

                // Surge slots
                const SectionHeader(title: 'Lunch Time Slots (Predicted)'),
                const SizedBox(height: 4),
                ...slots.map((slot) {
                  final color = _slotColor(slot['color'] as String);
                  final hasIncentive = slot['incentive'] != null;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: NeumorphicSection(
                      padding: const EdgeInsets.all(14),
                      borderColor: color.withValues(alpha: 0.2),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  slot['time'] as String,
                                  style: AppTextStyles.titleMedium,
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: color.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        slot['predicted'] as String,
                                        style: AppTextStyles.labelSmall
                                            .copyWith(
                                              color: color,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 10,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (hasIncentive)
                            NeumorphicSection(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              borderRadius: 12,
                              borderColor: AppColors.accent.withValues(
                                alpha: 0.18,
                              ),
                              child: Text(
                                slot['incentive'] as String,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          else
                            NeumorphicSection(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              borderRadius: 12,
                              child: Text(
                                'No incentive',
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // Push Notification
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: NeumorphicSection(
                    borderColor: AppColors.accent.withValues(alpha: 0.2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.notifications_active_rounded,
                              color: AppColors.accent,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Push Happy Hour Alert',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.accent,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        NeumorphicSection(
                          padding: const EdgeInsets.all(12),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.accent.withValues(alpha: 0.06),
                              AppColors.surfaceLight,
                            ],
                          ),
                          child: Row(
                            children: [
                              const Text('🎉', style: TextStyle(fontSize: 24)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '"Skip the rush! Eat after 2:00 PM for +15 bonus reward points!"',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: NeumorphicSection(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            borderRadius: 12,
                            borderColor: AppColors.accent.withValues(
                              alpha: 0.18,
                            ),
                            child: Text(
                              'Send to All Students',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
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
}
