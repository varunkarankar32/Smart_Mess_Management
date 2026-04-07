import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../services/mock_data_service.dart';

class MenuNutritionScreen extends StatefulWidget {
  const MenuNutritionScreen({super.key});

  @override
  State<MenuNutritionScreen> createState() => _MenuNutritionScreenState();
}

class _MenuNutritionScreenState extends State<MenuNutritionScreen> with SingleTickerProviderStateMixin {
  int _selectedMealIndex = 1; // default to Lunch
  bool _showVegOnly = false;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meals = MockDataService.todaysMeals;
    final selectedMeal = meals[_selectedMealIndex];

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
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Text("Today's Menu", style: AppTextStyles.headlineLarge),
                    const Spacer(),
                    // Veg filter
                    GestureDetector(
                      onTap: () => setState(() => _showVegOnly = !_showVegOnly),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _showVegOnly ? AppColors.accent.withValues(alpha: 0.2) : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _showVegOnly ? AppColors.accent.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.eco_rounded,
                              size: 14,
                              color: _showVegOnly ? AppColors.accent : AppColors.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Veg',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: _showVegOnly ? AppColors.accent : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Meal Type Tabs
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedMealIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedMealIndex = index);
                        _animController.reset();
                        _animController.forward();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: isSelected ? AppColors.accentGradient : null,
                          color: isSelected ? null : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: isSelected ? [
                            BoxShadow(color: AppColors.accent.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4)),
                          ] : null,
                        ),
                        child: Text(
                          meals[index].mealType,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: isSelected ? Colors.white : AppColors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Menu Items
              Expanded(
                child: FadeTransition(
                  opacity: CurvedAnimation(parent: _animController, curve: Curves.easeOut),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: selectedMeal.items.length,
                    itemBuilder: (context, index) {
                      final item = selectedMeal.items[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: GlassCard(
                          child: Column(
                            children: [
                              // Item Header
                              Row(
                                children: [
                                  Container(
                                    width: 48, height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceLight,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Center(child: Text(item.imageEmoji, style: const TextStyle(fontSize: 26))),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.name, style: AppTextStyles.titleMedium),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(Icons.star_rounded, color: AppColors.warning, size: 14),
                                            const SizedBox(width: 2),
                                            Text(
                                              '${item.averageRating} (${item.totalRatings})',
                                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning, fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Allergen badges
                                  if (item.allergens.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.error.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 12),
                                          const SizedBox(width: 3),
                                          Text(item.allergens.join(', '), style: AppTextStyles.bodySmall.copyWith(color: AppColors.error, fontSize: 9)),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Macros Row
                              Row(
                                children: [
                                  _macroChip('🔥', '${item.calories}', 'kcal', AppColors.error),
                                  const SizedBox(width: 8),
                                  _macroChip('💪', '${item.proteinG.toInt()}g', 'Protein', AppColors.info),
                                  const SizedBox(width: 8),
                                  _macroChip('🌾', '${item.carbsG.toInt()}g', 'Carbs', AppColors.warning),
                                  const SizedBox(width: 8),
                                  _macroChip('🫒', '${item.fatG.toInt()}g', 'Fat', AppColors.accentLight),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _macroChip(String emoji, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text('$emoji $value', style: AppTextStyles.labelSmall.copyWith(color: color, fontWeight: FontWeight.w700, fontSize: 11)),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 9, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
