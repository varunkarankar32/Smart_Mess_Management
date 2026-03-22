import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../services/mock_data_service.dart';

class FeedbackInboxScreen extends StatelessWidget {
  const FeedbackInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final meals = MockDataService.todaysMeals;
    // Flatten all items and sort by rating
    final allItems = meals.expand((m) => m.items).toList()
      ..sort((a, b) => b.averageRating.compareTo(a.averageRating));
    final bestItems = allItems.take(3).toList();
    final worstItems = allItems.reversed.take(3).toList();

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
                  child: Text('Feedback Inbox', style: AppTextStyles.headlineLarge),
                ),
                const SizedBox(height: 16),

                // Best Performers
                const SectionHeader(title: '⭐ Top Rated Dishes'),
                const SizedBox(height: 4),
                ...bestItems.map((item) => Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: GlassCard(
                    padding: const EdgeInsets.all(12),
                    borderColor: AppColors.accent.withValues(alpha: 0.15),
                    child: Row(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text(item.imageEmoji, style: const TextStyle(fontSize: 22))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: AppTextStyles.titleMedium.copyWith(fontSize: 14)),
                              Text('${item.totalRatings} ratings', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, color: AppColors.warning, size: 16),
                            const SizedBox(width: 2),
                            Text(item.averageRating.toStringAsFixed(1), style: AppTextStyles.labelLarge.copyWith(color: AppColors.warning)),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
                const SizedBox(height: 16),

                // Worst Performers
                const SectionHeader(title: '⚠️ Needs Improvement'),
                const SizedBox(height: 4),
                ...worstItems.map((item) => Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: GlassCard(
                    padding: const EdgeInsets.all(12),
                    borderColor: AppColors.error.withValues(alpha: 0.15),
                    child: Row(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text(item.imageEmoji, style: const TextStyle(fontSize: 22))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: AppTextStyles.titleMedium.copyWith(fontSize: 14)),
                              Text('${item.totalRatings} ratings', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star_rounded, color: AppColors.error, size: 16),
                                const SizedBox(width: 2),
                                Text(item.averageRating.toStringAsFixed(1), style: AppTextStyles.labelLarge.copyWith(color: AppColors.error)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text('3 weeks declining', style: AppTextStyles.bodySmall.copyWith(color: AppColors.error, fontSize: 9)),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
                const SizedBox(height: 16),

                // Targeted Feedback Push
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassCard(
                    borderColor: AppColors.info.withValues(alpha: 0.2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.campaign_rounded, color: AppColors.info, size: 20),
                            const SizedBox(width: 8),
                            Text('Push Targeted Survey', style: AppTextStyles.labelLarge.copyWith(color: AppColors.info, fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                          maxLines: 2,
                          decoration: const InputDecoration(
                            hintText: 'e.g., "Mixed Veg was largely uneaten today. What went wrong?"',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Text('Target: Students who scanned during lunch', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: AppColors.accentGradient,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(color: AppColors.accent.withValues(alpha: 0.3), blurRadius: 8)],
                              ),
                              child: Text('Send', style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
                            ),
                          ],
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
