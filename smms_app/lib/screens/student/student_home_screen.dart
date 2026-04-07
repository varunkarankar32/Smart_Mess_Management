import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../services/mock_data_service.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> with TickerProviderStateMixin {
  bool _notEatingToday = false;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
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
                // ─── Header ───
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_getGreeting(), style: AppTextStyles.bodyMedium),
                            const SizedBox(height: 2),
                            Text(user.name, style: AppTextStyles.headlineLarge),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/student/notifications'),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                          ),
                          child: Stack(
                            children: [
                              const Icon(Icons.notifications_none_rounded, color: AppColors.textSecondary, size: 24),
                              Positioned(
                                right: 0, top: 0,
                                child: Container(
                                  width: 8, height: 8,
                                  decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/student/profile'),
                        child: Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            gradient: AppColors.accentGradient,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              user.name.substring(0, 1),
                              style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ─── Crowd Meter ───
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CrowdMeterGauge(occupancy: occupancy),
                ),
                const SizedBox(height: 16),

                // ─── Quick Actions ───
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/student/qr'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: AppColors.accentGradient,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(color: AppColors.accent.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8)),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 24),
                                const SizedBox(width: 10),
                                Text('Show QR Pass', style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Not Eating Toggle
                      GlassCard(
                        padding: const EdgeInsets.all(8),
                        borderRadius: 16,
                        borderColor: _notEatingToday ? AppColors.error.withValues(alpha: 0.3) : null,
                        child: Column(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: _notEatingToday,
                                onChanged: (v) => setState(() => _notEatingToday = v),
                                activeTrackColor: AppColors.error,
                              ),
                            ),
                            Text(
                              _notEatingToday ? 'Away' : 'Eating',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: _notEatingToday ? AppColors.error : AppColors.accent,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ─── Today's Menu ───
                const SectionHeader(title: "Today's Menu", actionLabel: 'Full Menu →'),
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
                      return Container(
                        width: 160,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: GlassCard(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.accent.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      meal.mealType,
                                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent, fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ...meal.items.take(3).map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    Text(item.imageEmoji, style: const TextStyle(fontSize: 14)),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        item.name,
                                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontSize: 11),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                              if (meal.items.length > 3)
                                Text('+${meal.items.length - 3} more', style: AppTextStyles.bodySmall.copyWith(color: AppColors.accent, fontSize: 10)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // ─── Quick Stats ───
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

                // ─── Weather Advisory ───
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassCard(
                    borderColor: AppColors.info.withValues(alpha: 0.2),
                    child: Row(
                      children: [
                        Text(MockDataService.currentWeather.icon, style: const TextStyle(fontSize: 32)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${MockDataService.currentWeather.temperature.toInt()}°C · ${MockDataService.currentWeather.condition.toUpperCase()}',
                                style: AppTextStyles.labelLarge.copyWith(color: AppColors.info),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Hot soups & chai recommended today!',
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
