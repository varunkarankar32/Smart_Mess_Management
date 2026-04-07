import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/student_nav_shell.dart';
import 'screens/admin_nav_shell.dart';
import 'screens/student/qr_pass_screen.dart';
import 'screens/student/notifications_screen.dart';
import 'screens/student/profile_screen.dart';

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
        '/student/qr': (context) => const QrPassScreen(),
        '/student/notifications': (context) => const NotificationsScreen(),
        '/student/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
