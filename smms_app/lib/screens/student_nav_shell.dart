import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'student/student_home_screen.dart';
import 'student/menu_nutrition_screen.dart';
import 'student/feedback_screen.dart';
import 'student/leave_management_screen.dart';
import 'student/profile_screen.dart';
import 'student/dish_voting_screen.dart';

class StudentNavShell extends StatefulWidget {
  const StudentNavShell({super.key});

  @override
  State<StudentNavShell> createState() => _StudentNavShellState();
}

class _StudentNavShellState extends State<StudentNavShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    StudentHomeScreen(),
    MenuNutritionScreen(),
    FeedbackScreen(),
    LeaveManagementScreen(),
    DishVotingScreen(),
    ProfileScreen(),
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
              _navItem(Icons.home_rounded, 'Home', 0),
              _navItem(Icons.restaurant_menu_rounded, 'Menu', 1),
              _navItem(Icons.star_rounded, 'Review', 2),
              _navItem(Icons.calendar_month_rounded, 'Leave', 3),
              _navItem(Icons.how_to_vote_rounded, 'Vote', 4),
              _navItem(Icons.person_rounded, 'Profile', 5),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
