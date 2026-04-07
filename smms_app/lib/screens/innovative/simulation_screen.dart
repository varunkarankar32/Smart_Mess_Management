import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../services/mock_data_service.dart';

class SimulationScreen extends StatefulWidget {
  const SimulationScreen({super.key});

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> with SingleTickerProviderStateMixin {
  double _modifier = 1.0;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = MockDataService.simulateWeek(_modifier);

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
                      const Icon(Icons.science_rounded, color: AppColors.info, size: 24),
                      const SizedBox(width: 10),
                      Text('Digital Twin', style: AppTextStyles.headlineLarge),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Simulate next week\'s operations', style: AppTextStyles.bodyMedium),
                ),
                const SizedBox(height: 20),

                // Simulation Slider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassCard(
                    borderColor: AppColors.info.withValues(alpha: 0.2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Occupancy Modifier', style: AppTextStyles.labelLarge.copyWith(color: AppColors.info, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text('Adjust to simulate different scenarios', style: AppTextStyles.bodySmall),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text('Low', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: AppColors.accent,
                                  inactiveTrackColor: AppColors.surfaceLight,
                                  thumbColor: AppColors.accent,
                                  overlayColor: AppColors.accent.withValues(alpha: 0.2),
                                  trackHeight: 6,
                                ),
                                child: Slider(
                                  value: _modifier,
                                  min: 0.3,
                                  max: 1.5,
                                  onChanged: (v) {
                                    setState(() => _modifier = v);
                                    _animController.reset();
                                    _animController.forward();
                                  },
                                ),
                              ),
                            ),
                            Text('High', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                          ],
                        ),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${(_modifier * 100).toInt()}% capacity',
                              style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent, fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Simulation Results
                FadeTransition(
                  opacity: CurvedAnimation(parent: _animController, curve: Curves.easeOut),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(child: _resultCard('🍽️', '${data['totalMeals']}', 'Projected Meals', AppColors.info)),
                            const SizedBox(width: 12),
                            Expanded(child: _resultCard('💰', '₹${data['estimatedCost']}', 'Estimated Cost', AppColors.warning)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(child: _resultCard('🗑️', '${data['predictedWaste']}kg', 'Predicted Waste', AppColors.error)),
                            const SizedBox(width: 12),
                            Expanded(child: _resultCard('🌿', '₹${data['savings']}', 'Potential Savings', AppColors.accent)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GlassCard(
                          borderColor: AppColors.accent.withValues(alpha: 0.2),
                          gradient: LinearGradient(
                            colors: [AppColors.accent.withValues(alpha: 0.05), AppColors.surface],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.tips_and_updates_rounded, color: AppColors.accent, size: 18),
                                  const SizedBox(width: 8),
                                  Text('AI Recommendation', style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent, fontSize: 13)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _modifier < 0.6
                                    ? 'Very low expected turnout. Consider reducing raw material order by 40% and adding popular dishes to boost attendance.'
                                    : _modifier < 0.9
                                        ? 'Below average turnout expected. Reduce cooking volume by ~20% and push "Happy Hour" incentives for off-peak slots.'
                                        : _modifier < 1.2
                                            ? 'Normal operations. Current inventory levels are sufficient. Monitor real-time crowd data for adjustments.'
                                            : 'High turnout expected! Increase raw material order by 30%. Schedule additional kitchen staff and prepare overflow seating.',
                                style: AppTextStyles.bodyMedium.copyWith(fontSize: 13, height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

  Widget _resultCard(String emoji, String value, String label, Color color) {
    return GlassCard(
      borderColor: color.withValues(alpha: 0.15),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.titleLarge.copyWith(color: color)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
        ],
      ),
    );
  }
}
