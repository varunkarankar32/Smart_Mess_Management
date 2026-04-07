import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/common_widgets.dart';

class QrPassScreen extends StatefulWidget {
  const QrPassScreen({super.key});

  @override
  State<QrPassScreen> createState() => _QrPassScreenState();
}

class _QrPassScreenState extends State<QrPassScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Timer _timer;
  int _secondsLeft = 30;
  String _qrData = '';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _rotateController = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
    _refreshQR();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _secondsLeft--;
        if (_secondsLeft <= 0) {
          _refreshQR();
          _secondsLeft = 30;
        }
      });
    });
  }

  void _refreshQR() {
    _qrData = 'SMMS|${MockDataService.currentUser.id}|${DateTime.now().millisecondsSinceEpoch}|${Random().nextInt(99999)}';
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _timer.cancel();
    super.dispose();
  }

  String _getMealType() {
    final hour = DateTime.now().hour;
    if (hour < 10) return 'Breakfast';
    if (hour < 15) return 'Lunch';
    if (hour < 17) return 'Snacks';
    return 'Dinner';
  }

  @override
  Widget build(BuildContext context) {
    final user = MockDataService.currentUser;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.textSecondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text('Entry Pass', style: AppTextStyles.titleLarge),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const PulsingDot(color: AppColors.accent, size: 6),
                          const SizedBox(width: 6),
                          Text('ACTIVE', style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // QR Container with Animated Border
              AnimatedBuilder(
                animation: _rotateController,
                builder: (context, child) {
                  return Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: SweepGradient(
                        center: Alignment.center,
                        startAngle: 0,
                        endAngle: pi * 2,
                        transform: GradientRotation(_rotateController.value * pi * 2),
                        colors: const [
                          AppColors.accent,
                          Colors.transparent,
                          AppColors.info,
                          Colors.transparent,
                          AppColors.accent,
                        ],
                      ),
                    ),
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Profile
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(
                          gradient: AppColors.accentGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(user.name.substring(0, 1), style: AppTextStyles.headlineLarge.copyWith(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(user.name, style: AppTextStyles.titleMedium),
                      Text(user.rollNo, style: AppTextStyles.bodySmall),
                      const SizedBox(height: 16),

                      // QR Code
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: QrImageView(
                          data: _qrData,
                          version: QrVersions.auto,
                          size: 180,
                          backgroundColor: Colors.white,
                          eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Colors.white),
                          dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Meal Type
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(_getMealType(), style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Timer
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, _) {
                  final isUrgent = _secondsLeft <= 5;
                  final color = isUrgent ? AppColors.error : AppColors.accent;
                  return GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    borderColor: color.withValues(alpha: 0.2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh_rounded, color: color, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Refreshes in ${_secondsLeft}s',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: color,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Text('QR auto-refreshes to prevent screenshots', style: AppTextStyles.bodySmall),

              const Spacer(),

              // Security Note
              Padding(
                padding: const EdgeInsets.all(20),
                child: GlassCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.shield_rounded, color: AppColors.info, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'This pass is linked to your identity. Sharing is not allowed.',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.info),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
