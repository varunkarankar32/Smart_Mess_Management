import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/glass_theme.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'admin/admin_dashboard_screen.dart';
import 'admin/qr_scanner_screen.dart';
import 'admin/menu_management_screen.dart';
import 'admin/analytics_screen.dart';
import 'admin/inventory_screen.dart';
import 'admin/feedback_inbox_screen.dart';
import 'admin/user_management_screen.dart';
import 'admin/kitchen_display_screen.dart';
import 'innovative/simulation_screen.dart';
import 'innovative/surge_management_screen.dart';
import 'innovative/heatmap_screen.dart';

class AdminNavShell extends StatefulWidget {
  const AdminNavShell({super.key});

  @override
  State<AdminNavShell> createState() => _AdminNavShellState();
}

class _AdminNavShellState extends State<AdminNavShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    AdminDashboardScreen(),
    IdCardScannerScreen(),
    MenuManagementScreen(),
    AnalyticsScreen(),
    _AdminMoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(Icons.dashboard_rounded, 'Dashboard', 0),
                _navItem(Icons.badge_rounded, 'ID Scanner', 1),
                _navItem(Icons.menu_book_rounded, 'Menu', 2),
                _navItem(Icons.analytics_rounded, 'Analytics', 3),
                _navItem(Icons.more_horiz_rounded, 'More', 4),
              ],
            ),
          ),
        ),
      ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color:
              isActive
                  ? AppColors.accent.withValues(alpha: 0.12)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.accent : AppColors.textMuted,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isActive ? AppColors.accent : AppColors.textMuted,
                fontSize: 9,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminMoreScreen extends StatelessWidget {
  const _AdminMoreScreen();

  Widget build(BuildContext context) {
    return GlassScaffold(
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Text('More Tools', style: AppTextStyles.headlineLarge),
                ),
                const SizedBox(height: 20),
                _moreItem(
                  context,
                  Icons.inventory_2_rounded,
                  'Inventory',
                  'Stock levels & leftover routing',
                  AppColors.info,
                  const InventoryScreen(),
                ),
                _moreItem(
                  context,
                  Icons.inbox_rounded,
                  'Feedback Inbox',
                  'Top/worst dishes & surveys',
                  AppColors.warning,
                  const FeedbackInboxScreen(),
                ),
                _moreItem(
                  context,
                  Icons.people_alt_rounded,
                  'User Management',
                  'Student records & overrides',
                  AppColors.accentLight,
                  const UserManagementScreen(),
                ),
                _moreItem(
                  context,
                  Icons.kitchen_rounded,
                  'Kitchen Display',
                  'Live serving line status',
                  AppColors.accent,
                  const KitchenDisplayScreen(),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    'Innovative Features',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _moreItem(
                  context,
                  Icons.science_rounded,
                  'Digital Twin',
                  'Simulate next week\'s operations',
                  AppColors.info,
                  const SimulationScreen(),
                ),
                _moreItem(
                  context,
                  Icons.flash_on_rounded,
                  'Surge Manager',
                  'Dynamic incentives & Happy Hour',
                  AppColors.warning,
                  const SurgeManagementScreen(),
                ),
                _moreItem(
                  context,
                  Icons.map_rounded,
                  'Crowd Heatmap',
                  'Live floorplan congestion',
                  AppColors.error,
                  const HeatmapScreen(),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _moreItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    Widget screen,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: GestureDetector(
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => screen),
            ),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
