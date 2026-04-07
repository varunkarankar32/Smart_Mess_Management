import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../services/mock_data_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockDataService.currentUser;
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
              children: [
                const SizedBox(height: 20),
                // Profile Header
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: AppColors.accent.withValues(alpha: 0.4), blurRadius: 24, offset: const Offset(0, 8)),
                    ],
                  ),
                  child: Center(child: Text(user.name.substring(0, 1), style: AppTextStyles.displayLarge.copyWith(color: Colors.white))),
                ),
                const SizedBox(height: 14),
                Text(user.name, style: AppTextStyles.headlineLarge),
                const SizedBox(height: 4),
                Text('${user.rollNo} • ${user.email}', style: AppTextStyles.bodySmall),
                const SizedBox(height: 20),

                // Diet & Allergy Tags
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Diet & Allergies', style: AppTextStyles.titleMedium),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8, runSpacing: 8,
                          children: [
                            ...user.dietPreferences.map((d) => _tag(d, AppColors.accent, Icons.eco_rounded)),
                            ...user.allergies.map((a) => _tag(a, AppColors.error, Icons.warning_amber_rounded)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Stats Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(child: _statTile('🍽️', '${user.totalMeals}', 'Total Meals')),
                      const SizedBox(width: 12),
                      Expanded(child: _statTile('🌿', '${user.wasteSavedKg}kg', 'Waste Saved')),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(child: _statTile('⭐', '${user.rewardPoints}', 'Points')),
                      const SizedBox(width: 12),
                      Expanded(child: _statTile('💰', '₹${user.rebateBalance.toInt()}', 'Rebate')),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Settings List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children: [
                        _settingsTile(Icons.notifications_none_rounded, 'Notification Preferences', AppColors.info),
                        _divider(),
                        _settingsTile(Icons.history_rounded, 'Rebate History', AppColors.accent),
                        _divider(),
                        _settingsTile(Icons.receipt_long_rounded, 'Meal History', AppColors.warning),
                        _divider(),
                        _settingsTile(Icons.help_outline_rounded, 'Help & Support', AppColors.textSecondary),
                        _divider(),
                        _settingsTile(Icons.logout_rounded, 'Log Out', AppColors.error),
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

  Widget _tag(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.labelSmall.copyWith(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _statTile(String emoji, String value, String label) {
    return GlassCard(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.titleLarge.copyWith(color: AppColors.accent)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _settingsTile(IconData icon, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 14),
          Text(label, style: AppTextStyles.titleMedium.copyWith(fontSize: 14)),
          const Spacer(),
          Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, color: Colors.white.withValues(alpha: 0.04)),
    );
  }
}
