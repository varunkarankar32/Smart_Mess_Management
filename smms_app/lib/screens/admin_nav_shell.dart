import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/common_widgets.dart';
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
    QrScannerScreen(),
    MenuManagementScreen(),
    AnalyticsScreen(),
    _AdminMoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F1724), Color(0xFF111B2D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: IndexedStack(index: _currentIndex, children: _pages),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 18,
              offset: const Offset(-6, -6),
              spreadRadius: -4,
            ),
            BoxShadow(
              color: AppColors.shadowDark,
              blurRadius: 18,
              offset: const Offset(6, 6),
              spreadRadius: -4,
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.dashboard_rounded, 'Dashboard', 0),
              _navItem(Icons.qr_code_scanner_rounded, 'Scanner', 1),
              _navItem(Icons.menu_book_rounded, 'Menu', 2),
              _navItem(Icons.analytics_rounded, 'Analytics', 3),
              _navItem(Icons.more_horiz_rounded, 'More', 4),
            ],
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.surfaceRaised : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 10,
                    offset: const Offset(-4, -4),
                    spreadRadius: -3,
                  ),
                  BoxShadow(
                    color: AppColors.shadowDark,
                    blurRadius: 10,
                    offset: const Offset(4, 4),
                    spreadRadius: -3,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.accentLight : AppColors.textMuted,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isActive ? Colors.white : AppColors.textMuted,
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

  @override
  Widget build(BuildContext context) {
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
                        child: Text(
                          'More Tools',
                          style: AppTextStyles.headlineLarge,
                        ),
                      ),
                      const NeuPill(label: 'Ops Hub'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _moreItem(
                  context,
                  Icons.inventory_2_rounded,
                  'Inventory',
                  'Stock levels & leftover routing',
                  AppColors.info,
                  '/admin/inventory',
                ),
                _moreItem(
                  context,
                  Icons.inbox_rounded,
                  'Feedback Inbox',
                  'Top/worst dishes & surveys',
                  AppColors.warning,
                  '/admin/feedback',
                ),
                _moreItem(
                  context,
                  Icons.people_alt_rounded,
                  'User Management',
                  'Student records & overrides',
                  AppColors.accentLight,
                  '/admin/users',
                ),
                _moreItem(
                  context,
                  Icons.event_busy_rounded,
                  'Leave Review',
                  'Approve or reject meal leave requests',
                  AppColors.warning,
                  '/admin/leaves',
                ),
                _moreItem(
                  context,
                  Icons.kitchen_rounded,
                  'Kitchen Display',
                  'Live serving line status',
                  AppColors.accent,
                  '/admin/kitchen',
                ),
                const SectionHeader(
                  title: 'Innovative Features',
                  actionLabel: 'AI Lab',
                ),
                _moreItem(
                  context,
                  Icons.science_rounded,
                  'Digital Twin',
                  'Simulate next week\'s operations',
                  AppColors.info,
                  '/admin/simulation',
                ),
                _moreItem(
                  context,
                  Icons.flash_on_rounded,
                  'Surge Manager',
                  'Dynamic incentives & Happy Hour',
                  AppColors.warning,
                  '/admin/surge',
                ),
                _moreItem(
                  context,
                  Icons.map_rounded,
                  'Crowd Heatmap',
                  'Live floorplan congestion',
                  AppColors.error,
                  '/admin/heatmap',
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
    String route,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, route),
        child: NeumorphicSection(
          borderColor: color.withValues(alpha: 0.15),
          child: Row(
            children: [
              NeuIconTile(
                icon: icon,
                iconColor: color,
                padding: const EdgeInsets.all(10),
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
