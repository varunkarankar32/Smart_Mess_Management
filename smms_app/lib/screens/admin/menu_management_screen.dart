import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../services/mock_data_service.dart';

class MenuManagementScreen extends StatefulWidget {
  const MenuManagementScreen({super.key});

  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  String _selectedDay = 'Monday';
  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  @override
  Widget build(BuildContext context) {
    final weeklyMenu = MockDataService.weeklyMenu;
    final recipeBank = MockDataService.recipeBank;
    final dayItems = weeklyMenu[_selectedDay] ?? [];
    final fatigueData = MockDataService.ingredientFatigue;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Text('Menu Planner', style: AppTextStyles.headlineLarge),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Drag dishes from the recipe bank to plan the week', style: AppTextStyles.bodySmall),
              ),
              const SizedBox(height: 16),

              // Day Tabs
              SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _days.length,
                  itemBuilder: (context, index) {
                    final isSelected = _days[index] == _selectedDay;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedDay = _days[index]),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: isSelected ? AppColors.accentGradient : null,
                          color: isSelected ? null : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: isSelected ? [
                            BoxShadow(color: AppColors.accent.withValues(alpha: 0.3), blurRadius: 10)
                          ] : null,
                        ),
                        child: Text(
                          _days[index].substring(0, 3),
                          style: AppTextStyles.labelLarge.copyWith(
                            color: isSelected ? Colors.white : AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current Day Menu
                      const SectionHeader(title: 'Planned Menu'),
                      const SizedBox(height: 4),
                      ...dayItems.map((item) => Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                        child: GlassCard(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceLight,
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
                                    Text(item.category.toUpperCase(), style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent, fontSize: 9)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.drag_indicator_rounded, color: AppColors.textMuted, size: 18),
                            ],
                          ),
                        ),
                      )),

                      const SizedBox(height: 16),

                      // Nutritional Balance Widget
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GlassCard(
                          borderColor: AppColors.info.withValues(alpha: 0.2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.balance_rounded, color: AppColors.info, size: 18),
                                  const SizedBox(width: 8),
                                  Text('Weekly Nutritional Balance', style: AppTextStyles.labelLarge.copyWith(color: AppColors.info, fontSize: 13)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _nutritionBar('Protein', 0.7, AppColors.info),
                              const SizedBox(height: 8),
                              _nutritionBar('Carbs', 0.85, AppColors.warning),
                              const SizedBox(height: 8),
                              _nutritionBar('Fats', 0.55, AppColors.accentLight),
                              const SizedBox(height: 8),
                              _nutritionBar('Fiber', 0.35, AppColors.accent),
                              const SizedBox(height: 8),
                              Text('⚠️ Consider adding more fiber-rich items this week',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Ingredient Fatigue Alerts
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GlassCard(
                          borderColor: AppColors.warning.withValues(alpha: 0.2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.repeat_rounded, color: AppColors.warning, size: 18),
                                  const SizedBox(width: 8),
                                  Text('Ingredient Fatigue', style: AppTextStyles.labelLarge.copyWith(color: AppColors.warning, fontSize: 13)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ...fatigueData.map((f) => Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.1)),
                                ),
                                child: Row(
                                  children: [
                                    Text('${f['ingredient']}', style: AppTextStyles.labelLarge.copyWith(fontSize: 12)),
                                    const SizedBox(width: 6),
                                    Text('(${f['usedInDays']}/${f['outOf']} days)', style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning, fontSize: 10)),
                                    const Spacer(),
                                    Flexible(
                                      child: Text('→ ${f['suggestion']}', style: AppTextStyles.bodySmall.copyWith(fontSize: 10), textAlign: TextAlign.right),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Recipe Bank
                      const SectionHeader(title: 'Recipe Bank'),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: recipeBank.length,
                          itemBuilder: (context, index) {
                            final r = recipeBank[index];
                            return Container(
                              width: 110,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              child: GlassCard(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(r.imageEmoji, style: const TextStyle(fontSize: 28)),
                                    const SizedBox(height: 6),
                                    Text(r.name, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textPrimary, fontSize: 10), textAlign: TextAlign.center, maxLines: 2),
                                    const SizedBox(height: 4),
                                    Text('${r.calories} kcal', style: AppTextStyles.bodySmall.copyWith(fontSize: 9)),
                                  ],
                                ),
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

  Widget _nutritionBar(String label, double value, Color color) {
    return Row(
      children: [
        SizedBox(width: 50, child: Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 11))),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: AppColors.surfaceLight,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text('${(value * 100).toInt()}%', style: AppTextStyles.labelSmall.copyWith(color: color, fontSize: 10)),
      ],
    );
  }
}
