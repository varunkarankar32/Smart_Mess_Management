import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../services/mock_data_service.dart';

class DishVotingScreen extends StatefulWidget {
  const DishVotingScreen({super.key});

  @override
  State<DishVotingScreen> createState() => _DishVotingScreenState();
}

class _DishVotingScreenState extends State<DishVotingScreen> {
  final Map<String, String?> _votes = {}; // testId -> 'A' or 'B'

  @override
  Widget build(BuildContext context) {
    final tests = MockDataService.abTests;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Text('Vote for Next Menu', style: AppTextStyles.headlineLarge),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Help decide what\'s on the menu!', style: AppTextStyles.bodyMedium),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: tests.length,
                  itemBuilder: (context, index) {
                    final test = tests[index];
                    final totalVotes = test.votesA + test.votesB;
                    final percA = totalVotes > 0 ? test.votesA / totalVotes : 0.5;
                    final percB = totalVotes > 0 ? test.votesB / totalVotes : 0.5;
                    final myVote = _votes[test.id];
                    final hoursLeft = test.deadline.difference(DateTime.now()).inHours;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.info.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(test.mealType, style: AppTextStyles.labelSmall.copyWith(color: AppColors.info, fontWeight: FontWeight.w700)),
                                ),
                                const Spacer(),
                                Icon(Icons.timer_outlined, color: AppColors.textMuted, size: 14),
                                const SizedBox(width: 4),
                                Text('${hoursLeft}h left', style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // VS Cards
                            Row(
                              children: [
                                Expanded(child: _dishOption(test.dishA, 'A', test.id, myVote == 'A', percA)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Container(
                                    width: 36, height: 36,
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceLight,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                                    ),
                                    child: Center(
                                      child: Text('VS', style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w800, color: AppColors.textMuted)),
                                    ),
                                  ),
                                ),
                                Expanded(child: _dishOption(test.dishB, 'B', test.id, myVote == 'B', percB)),
                              ],
                            ),
                            const SizedBox(height: 14),
                            // Vote Count
                            Row(
                              children: [
                                const Icon(Icons.how_to_vote_rounded, color: AppColors.textMuted, size: 14),
                                const SizedBox(width: 4),
                                Text('$totalVotes votes', style: AppTextStyles.bodySmall),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dishOption(dynamic item, String side, String testId, bool isVoted, double percentage) {
    return GestureDetector(
      onTap: isVoted ? null : () => setState(() => _votes[testId] = side),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isVoted ? AppColors.accent.withValues(alpha: 0.1) : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isVoted ? AppColors.accent.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.05),
            width: isVoted ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(item.imageEmoji, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 8),
            Text(item.name, style: AppTextStyles.labelLarge.copyWith(fontSize: 12), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text('${item.calories} kcal', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
            const SizedBox(height: 8),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: AppColors.surfaceLight,
                valueColor: AlwaysStoppedAnimation(isVoted ? AppColors.accent : AppColors.textMuted),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(percentage * 100).toInt()}%',
              style: AppTextStyles.labelSmall.copyWith(
                color: isVoted ? AppColors.accent : AppColors.textMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (isVoted)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Icon(Icons.check_circle_rounded, color: AppColors.accent, size: 16),
              ),
          ],
        ),
      ),
    );
  }
}
