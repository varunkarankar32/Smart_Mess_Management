import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../services/mock_data_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  bool _notEatingToday = false;

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void _openMealSheet(MealModel meal) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: SafeArea(
            child: NeumorphicSection(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(meal.mealType, style: AppTextStyles.titleLarge),
                      const Spacer(),
                      NeuIconTile(
                        icon: Icons.close_rounded,
                        iconColor: AppColors.textSecondary,
                        onTap: () => Navigator.pop(sheetContext),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...meal.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            item.imageEmoji,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.name,
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                          Text(
                            '${item.calories} kcal',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(sheetContext);
                      Navigator.pushNamed(context, '/student/menu');
                    },
                    child: const NeumorphicSection(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          'Open Full Menu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _quickLink({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: NeumorphicSection(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = MockDataService.currentUser;
    final meals = MockDataService.todaysMeals;
    final occupancy = MockDataService.currentOccupancy;

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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getGreeting(),
                              style: AppTextStyles.bodyMedium,
                            ),
                            const SizedBox(height: 2),
                            Text(user.name, style: AppTextStyles.headlineLarge),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: const [
                                NeuPill(label: 'Student Mode'),
                                NeuPill(label: 'Live Menu'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      NeuIconTile(
                        icon: Icons.notifications_none_rounded,
                        iconColor: AppColors.textSecondary,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/student/notifications',
                        ),
                      ),
                      const SizedBox(width: 10),
                      NeuIconTile(
                        icon: Icons.person_rounded,
                        iconColor: Colors.white,
                        onTap: () =>
                            Navigator.pushNamed(context, '/student/profile'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CrowdMeterGauge(occupancy: occupancy),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/student/qr'),
                          child: NeumorphicSection(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.qr_code_2_rounded,
                                  color: AppColors.accentLight,
                                  size: 24,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Show QR Pass',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _notEatingToday = !_notEatingToday),
                        child: NeumorphicSection(
                          padding: const EdgeInsets.all(10),
                          borderRadius: 18,
                          child: Column(
                            children: [
                              Transform.scale(
                                scale: 0.8,
                                child: Switch(
                                  value: _notEatingToday,
                                  onChanged: (v) =>
                                      setState(() => _notEatingToday = v),
                                  activeTrackColor: AppColors.error,
                                ),
                              ),
                              Text(
                                _notEatingToday ? 'Away' : 'Eating',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: _notEatingToday
                                      ? AppColors.error
                                      : AppColors.accentLight,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SectionHeader(
                  title: "Today's Menu",
                  actionLabel: 'Full Menu →',
                  onAction: () => Navigator.pushNamed(context, '/student/menu'),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 175,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      return GestureDetector(
                        onTap: () => _openMealSheet(meal),
                        child: Container(
                          width: 160,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: GlassCard(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    meal.mealType,
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.accent,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ...meal.items
                                    .take(3)
                                    .map(
                                      (item) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              item.imageEmoji,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                item.name,
                                                style: AppTextStyles.bodySmall
                                                    .copyWith(
                                                      color:
                                                          AppColors.textPrimary,
                                                      fontSize: 11,
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                if (meal.items.length > 3)
                                  Text(
                                    '+${meal.items.length - 3} more',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.accent,
                                      fontSize: 10,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                const SectionHeader(title: 'Your Stats'),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Meals Eaten',
                          value: '${user.totalMeals}',
                          icon: Icons.restaurant_rounded,
                          color: AppColors.info,
                          subtitle: 'This Sem',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          title: 'Waste Saved',
                          value: '${user.wasteSavedKg}kg',
                          icon: Icons.eco_rounded,
                          color: AppColors.accent,
                          subtitle: '↑ 15%',
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
                          title: 'Reward Points',
                          value: '${user.rewardPoints}',
                          icon: Icons.stars_rounded,
                          color: AppColors.warning,
                          subtitle: '🔥 Streak',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          title: 'Rebate Balance',
                          value: '₹${user.rebateBalance.toInt()}',
                          icon: Icons.account_balance_wallet_rounded,
                          color: AppColors.accentLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionHeader(
                    title: 'Quick Links',
                    actionLabel: 'More →',
                    onAction: () =>
                        Navigator.pushNamed(context, '/student/feedback'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.7,
                    children: [
                      _quickLink(
                        icon: Icons.restaurant_menu_rounded,
                        label: 'Browse Menu',
                        color: AppColors.accentLight,
                        onTap: () =>
                            Navigator.pushNamed(context, '/student/menu'),
                      ),
                      _quickLink(
                        icon: Icons.rate_review_rounded,
                        label: 'Submit Review',
                        color: AppColors.warning,
                        onTap: () =>
                            Navigator.pushNamed(context, '/student/feedback'),
                      ),
                      _quickLink(
                        icon: Icons.event_busy_rounded,
                        label: 'Plan Leave',
                        color: AppColors.error,
                        onTap: () =>
                            Navigator.pushNamed(context, '/student/leave'),
                      ),
                      _quickLink(
                        icon: Icons.how_to_vote_rounded,
                        label: 'Vote Dish',
                        color: AppColors.accent,
                        onTap: () =>
                            Navigator.pushNamed(context, '/student/vote'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassCard(
                    borderColor: AppColors.info.withValues(alpha: 0.2),
                    child: Row(
                      children: [
                        Text(
                          MockDataService.currentWeather.icon,
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${MockDataService.currentWeather.temperature.toInt()}°C · ${MockDataService.currentWeather.condition.toUpperCase()}',
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.info,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                MockDataService.currentWeather.suggestion,
                                style: AppTextStyles.bodySmall,
                                maxLines: 2,
                              ),
                            ],
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
