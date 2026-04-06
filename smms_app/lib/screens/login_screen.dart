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
            colors: [Color(0xFF0F1724), Color(0xFF111B2D), Color(0xFF0F1724)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: -40,
                left: -30,
                child: _GlowBlob(color: AppColors.accent.withValues(alpha: 0.12), size: 180),
              ),
              Positioned(
                bottom: -30,
                right: -20,
                child: _GlowBlob(color: AppColors.info.withValues(alpha: 0.10), size: 160),
              ),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                children: [
                  const Spacer(flex: 2),
                  // Logo & Branding
                  Container(
                    width: 94, height: 94,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.surfaceRaised, AppColors.surface],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: AppColors.accent.withValues(alpha: 0.18)),
                      boxShadow: [
                        BoxShadow(color: AppColors.shadowLight, blurRadius: 18, offset: const Offset(-8, -8), spreadRadius: -4),
                        BoxShadow(color: AppColors.shadowDark, blurRadius: 18, offset: const Offset(8, 8), spreadRadius: -4),
                      ],
                    ),
                    child: const Icon(Icons.restaurant_menu_rounded, size: 44, color: AppColors.accentLight),
                  ),
                  const SizedBox(height: 24),
                  Text('SMMS', style: AppTextStyles.displayLarge.copyWith(letterSpacing: 4)),
                  const SizedBox(height: 6),
                  Text('Smart Mess Management System', style: AppTextStyles.bodyMedium),
                  const Spacer(),

                  // Role Toggle
                  GlassCard(
                    padding: const EdgeInsets.all(4),
                    borderRadius: 24,
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
                    child: _PrimaryNeuButton(
                      label: _isStudent ? 'Login as Student' : 'Login as Admin',
                      icon: Icons.arrow_forward_rounded,
                      onTap: () {
                        if (_isStudent) {
                          Navigator.pushReplacementNamed(context, '/student');
                        } else {
                          Navigator.pushReplacementNamed(context, '/admin');
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // SSO Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: _SecondaryNeuButton(
                      label: 'Sign in with University SSO',
                      icon: Icons.login_rounded,
                      onTap: () {
                        if (_isStudent) {
                          Navigator.pushReplacementNamed(context, '/student');
                        } else {
                          Navigator.pushReplacementNamed(context, '/admin');
                        }
                      },
                    ),
                  ),
                  const Spacer(flex: 2),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? AppColors.surfaceRaised : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isActive
                ? [
                    BoxShadow(color: AppColors.shadowLight, blurRadius: 10, offset: const Offset(-4, -4), spreadRadius: -3),
                    BoxShadow(color: AppColors.shadowDark, blurRadius: 10, offset: const Offset(4, 4), spreadRadius: -3),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isActive ? AppColors.accentLight : AppColors.textMuted),
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

class _PrimaryNeuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PrimaryNeuButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.surfaceRaised, AppColors.surface],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.accent.withValues(alpha: 0.28)),
          boxShadow: [
            BoxShadow(color: AppColors.shadowLight, blurRadius: 16, offset: const Offset(-7, -7), spreadRadius: -3),
            BoxShadow(color: AppColors.shadowDark, blurRadius: 16, offset: const Offset(7, 7), spreadRadius: -3),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
            const SizedBox(width: 8),
            Icon(icon, size: 20, color: AppColors.accentLight),
          ],
        ),
      ),
    );
  }
}

class _SecondaryNeuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SecondaryNeuButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surfacePressed,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(color: AppColors.shadowLight, blurRadius: 12, offset: const Offset(-5, -5), spreadRadius: -3),
            BoxShadow(color: AppColors.shadowDark, blurRadius: 12, offset: const Offset(5, 5), spreadRadius: -3),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.accentLight),
            const SizedBox(width: 8),
            Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
