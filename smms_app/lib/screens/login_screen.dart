import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool _isStudent = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0E1A), Color(0xFF0F172A), Color(0xFF0A0E1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  // Logo & Branding
                  Container(
                    width: 90, height: 90,
                    decoration: BoxDecoration(
                      gradient: AppColors.accentGradient,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: AppColors.accent.withValues(alpha: 0.4), blurRadius: 30, offset: const Offset(0, 10)),
                      ],
                    ),
                    child: const Icon(Icons.restaurant_menu_rounded, size: 44, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  Text('SMMS', style: AppTextStyles.displayLarge.copyWith(letterSpacing: 4)),
                  const SizedBox(height: 6),
                  Text('Smart Mess Management System', style: AppTextStyles.bodyMedium),
                  const Spacer(),

                  // Role Toggle
                  GlassCard(
                    padding: const EdgeInsets.all(4),
                    borderRadius: 16,
                    child: Row(
                      children: [
                        _roleTab('Student', Icons.school_rounded, _isStudent, () => setState(() => _isStudent = true)),
                        _roleTab('Admin', Icons.admin_panel_settings_rounded, !_isStudent, () => setState(() => _isStudent = false)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Email Field
                  TextField(
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: _isStudent ? 'University Email / Roll No.' : 'Admin ID',
                      prefixIcon: Icon(_isStudent ? Icons.person_outline_rounded : Icons.shield_outlined, color: AppColors.textMuted),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    obscureText: true,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.textMuted),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text('Forgot password?', style: AppTextStyles.bodySmall.copyWith(color: AppColors.accent)),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_isStudent) {
                          Navigator.pushReplacementNamed(context, '/student');
                        } else {
                          Navigator.pushReplacementNamed(context, '/admin');
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_isStudent ? 'Login as Student' : 'Login as Admin'),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // SSO Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        if (_isStudent) {
                          Navigator.pushReplacementNamed(context, '/student');
                        } else {
                          Navigator.pushReplacementNamed(context, '/admin');
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.login_rounded, size: 18, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text('Sign in with University SSO', style: AppTextStyles.bodyMedium),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleTab(String label, IconData icon, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isActive ? Colors.white : AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: isActive ? Colors.white : AppColors.textMuted,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
