import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/student_nav_shell.dart';
import 'screens/admin_nav_shell.dart';
import 'screens/student/menu_nutrition_screen.dart';
import 'screens/student/feedback_screen.dart';
import 'screens/student/leave_management_screen.dart';
import 'screens/student/dish_voting_screen.dart';
import 'screens/student/qr_pass_screen.dart';
import 'screens/student/notifications_screen.dart';
import 'screens/student/profile_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/qr_scanner_screen.dart';
import 'screens/admin/menu_management_screen.dart';
import 'screens/admin/analytics_screen.dart';
import 'screens/admin/inventory_screen.dart';
import 'screens/admin/feedback_inbox_screen.dart';
import 'screens/admin/leave_requests_screen.dart';
import 'screens/admin/user_management_screen.dart';
import 'screens/admin/kitchen_display_screen.dart';
import 'screens/innovative/simulation_screen.dart';
import 'screens/innovative/surge_management_screen.dart';
import 'screens/innovative/heatmap_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF121829),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const SMSSApp());
}

class SMSSApp extends StatelessWidget {
  const SMSSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMMS - Smart Mess Management System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/student': (context) => const StudentNavShell(),
        '/admin': (context) => const AdminNavShell(),
        '/student/menu': (context) => const MenuNutritionScreen(),
        '/student/feedback': (context) => const FeedbackScreen(),
        '/student/leave': (context) => const LeaveManagementScreen(),
        '/student/vote': (context) => const DishVotingScreen(),
        '/student/qr': (context) => const QrPassScreen(),
        '/student/notifications': (context) => const NotificationsScreen(),
        '/student/profile': (context) => const ProfileScreen(),
        '/admin/dashboard': (context) => const AdminDashboardScreen(),
        '/admin/scanner': (context) => const QrScannerScreen(),
        '/admin/menu': (context) => const MenuManagementScreen(),
        '/admin/analytics': (context) => const AnalyticsScreen(),
        '/admin/inventory': (context) => const InventoryScreen(),
        '/admin/feedback': (context) => const FeedbackInboxScreen(),
        '/admin/leaves': (context) => const LeaveRequestsScreen(),
        '/admin/users': (context) => const UserManagementScreen(),
        '/admin/kitchen': (context) => const KitchenDisplayScreen(),
        '/admin/simulation': (context) => const SimulationScreen(),
        '/admin/surge': (context) => const SurgeManagementScreen(),
        '/admin/heatmap': (context) => const HeatmapScreen(),
      },
    );
  }
}
