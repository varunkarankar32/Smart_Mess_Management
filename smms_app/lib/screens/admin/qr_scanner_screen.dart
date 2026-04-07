import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../services/mock_data_service.dart';

class IdCardScannerScreen extends StatefulWidget {
  const IdCardScannerScreen({super.key});

  @override
  State<IdCardScannerScreen> createState() => _IdCardScannerScreenState();
}

class _IdCardScannerScreenState extends State<IdCardScannerScreen>
    with SingleTickerProviderStateMixin {
  String _scanStatus = 'idle'; // idle, valid, invalid, duplicate
  String _scannedName = '';
  String _scannedEnrollmentNo = '';
  late AnimationController _flashController;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

  void _simulateScan(bool isValid) {
    final scans = MockDataService.recentScans;
    final scan = scans[isValid ? 0 : 2];
    setState(() {
      _scanStatus = isValid ? 'valid' : 'invalid';
      _scannedName = scan.userName;
      _scannedEnrollmentNo = scan.rollNo;
    });
    _flashController.forward(from: 0);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _scanStatus = 'idle');
    });
  }

  Color get _scanColor {
    switch (_scanStatus) {
      case 'valid':
        return AppColors.accent;
      case 'invalid':
        return AppColors.error;
      case 'duplicate':
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }

  IconData get _scanIcon {
    switch (_scanStatus) {
      case 'valid':
        return Icons.check_circle_rounded;
      case 'invalid':
        return Icons.cancel_rounded;
      case 'duplicate':
        return Icons.warning_amber_rounded;
      default:
        return Icons.badge_rounded;
    }
  }

  String get _scanMessage {
    switch (_scanStatus) {
      case 'valid':
        return 'ID Card Verified';
      case 'invalid':
        return 'Invalid ID / Already Scanned';
      case 'duplicate':
        return 'Guest Pass';
      default:
        return 'Ready to Scan ID Card';
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Text('ID Card Scanner', style: AppTextStyles.headlineLarge),
                    const Spacer(),
                    const PulsingDot(color: AppColors.accent),
                    const SizedBox(width: 6),
                    Text(
                      'Camera Active',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Camera View Placeholder
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color:
                            _scanStatus == 'idle'
                                ? Colors.white.withValues(alpha: 0.06)
                                : _scanColor.withValues(alpha: 0.5),
                        width: _scanStatus == 'idle' ? 1 : 3,
                      ),
                      boxShadow:
                          _scanStatus != 'idle'
                              ? [
                                BoxShadow(
                                  color: _scanColor.withValues(alpha: 0.2),
                                  blurRadius: 30,
                                ),
                              ]
                              : null,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Camera placeholder
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.badge_rounded,
                              size: 48,
                              color: AppColors.textMuted.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'College ID Card Preview',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '(Requires device camera)',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),

                        // Scan crosshair overlay
                        if (_scanStatus == 'idle')
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.4),
                                width: 2,
                              ),
                            ),
                          ),

                        // Result overlay
                        if (_scanStatus != 'idle')
                          FadeTransition(
                            opacity: CurvedAnimation(
                              parent: _flashController,
                              curve: Curves.easeOut,
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(40),
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: _scanColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _scanColor.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(_scanIcon, color: _scanColor, size: 64),
                                  const SizedBox(height: 12),
                                  Text(
                                    _scanMessage,
                                    style: AppTextStyles.titleLarge.copyWith(
                                      color: _scanColor,
                                    ),
                                  ),
                                  if (_scanStatus == 'valid') ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      'Student Name',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                    Text(
                                      _scannedName,
                                      style: AppTextStyles.headlineMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Enrollment Number',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                    Text(
                                      _scannedEnrollmentNo,
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Simulate Buttons (for demo)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Demo Controls',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _simulateScan(true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.accent.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '✅ Valid ID Card',
                                    style: AppTextStyles.labelLarge.copyWith(
                                      color: AppColors.accent,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _simulateScan(false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.error.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '❌ Invalid ID Card',
                                    style: AppTextStyles.labelLarge.copyWith(
                                      color: AppColors.error,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
