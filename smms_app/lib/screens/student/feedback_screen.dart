import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';
import '../../services/mock_data_service.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final Map<String, int> _ratings = {};
  final Map<String, bool> _submitted = {};
  int _reviewsGiven = 3;
  final int _reviewsTarget = 5;

  void _submitFeedbackItem(MenuItemModel item) {
    final rating = _ratings[item.id] ?? 0;
    if (rating == 0 || _submitted[item.id] == true) return;

    MockDataService.submitFeedback(
      userId: MockDataService.currentUser.id,
      itemId: item.id,
      itemName: item.name,
      rating: rating,
    );

    setState(() {
      _submitted[item.id] = true;
      _reviewsGiven++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved feedback for ${item.name}'),
        backgroundColor: AppColors.accent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final meals = MockDataService.todaysMeals;
    final lunchItems = meals[1].items; // Lunch items for feedback

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
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Rate Your Meal',
                        style: AppTextStyles.headlineLarge,
                      ),
                    ),
                    const NeuPill(label: 'Quick Review'),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Help us improve! Your feedback matters.',
                  style: AppTextStyles.bodyMedium,
                ),
              ),
              const SizedBox(height: 16),

              // Gamification Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: NeumorphicSection(
                  borderColor: AppColors.warning.withValues(alpha: 0.3),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.warning.withValues(alpha: 0.08),
                      AppColors.surface,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('🏆', style: TextStyle(fontSize: 24)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Review ${_reviewsTarget - _reviewsGiven} more meals for a canteen rebate!',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: AppColors.warning,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Earn ₹50 off your next month',
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '$_reviewsGiven/$_reviewsTarget',
                            style: AppTextStyles.statNumber.copyWith(
                              color: AppColors.warning,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: _reviewsGiven / _reviewsTarget,
                          backgroundColor: AppColors.surfaceLight,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.warning,
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const SectionHeader(title: "Today's Lunch"),
              const SizedBox(height: 4),

              // Food Items List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ...lunchItems.map((item) {
                      final currentRating = _ratings[item.id] ?? 0;
                      final isSubmitted = _submitted[item.id] ?? false;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: GlassCard(
                          borderColor: isSubmitted
                              ? AppColors.accent.withValues(alpha: 0.2)
                              : null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppColors.surfaceRaised,
                                          AppColors.surface,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        item.imageEmoji,
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: AppTextStyles.titleMedium,
                                        ),
                                        Text(
                                          '${item.calories} kcal',
                                          style: AppTextStyles.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSubmitted)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.accent.withValues(
                                          alpha: 0.15,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.check_circle_rounded,
                                            color: AppColors.accent,
                                            size: 12,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Done',
                                            style: AppTextStyles.bodySmall
                                                .copyWith(
                                                  color: AppColors.accent,
                                                  fontSize: 10,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  ...List.generate(5, (starIndex) {
                                    return GestureDetector(
                                      onTap: isSubmitted
                                          ? null
                                          : () {
                                              setState(
                                                () => _ratings[item.id] =
                                                    starIndex + 1,
                                              );
                                            },
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: Icon(
                                          starIndex < currentRating
                                              ? Icons.star_rounded
                                              : Icons.star_border_rounded,
                                          color: starIndex < currentRating
                                              ? AppColors.warning
                                              : AppColors.textMuted,
                                          size: 28,
                                        ),
                                      ),
                                    );
                                  }),
                                  const Spacer(),
                                  if (currentRating > 0 && !isSubmitted)
                                    GestureDetector(
                                      onTap: () => _submitFeedbackItem(item),
                                      child: NeumorphicSection(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 6,
                                        ),
                                        borderRadius: 12,
                                        child: Text(
                                          'Submit',
                                          style: AppTextStyles.labelSmall
                                              .copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 4),
                    Builder(
                      builder: (context) {
                        final recentSubmissions = MockDataService
                            .feedbackSubmissions
                            .where(
                              (feedback) =>
                                  feedback.userId ==
                                  MockDataService.currentUser.id,
                            )
                            .take(3)
                            .toList();

                        return NeumorphicSection(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recent Submissions',
                                style: AppTextStyles.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              if (recentSubmissions.isEmpty)
                                Text(
                                  'No feedback submitted yet.',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                )
                              else
                                ...recentSubmissions.map(
                                  (feedback) => Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.star_rounded,
                                          color: AppColors.warning,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            feedback.itemName,
                                            style: AppTextStyles.bodySmall,
                                          ),
                                        ),
                                        Text(
                                          '${feedback.rating}/5',
                                          style: AppTextStyles.labelSmall
                                              .copyWith(
                                                color: AppColors.warning,
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
                    const SizedBox(height: 16),
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
