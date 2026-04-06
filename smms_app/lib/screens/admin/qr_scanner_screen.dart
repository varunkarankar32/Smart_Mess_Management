import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../services/mock_data_service.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with SingleTickerProviderStateMixin {
  String _scanStatus = 'idle'; // idle, valid, invalid, duplicate
  String _scannedName = '';
  String _scannedRoll = '';
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
      _scannedRoll = scan.rollNo;
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
        return Icons.qr_code_scanner_rounded;
    }
  }

  String get _scanMessage {
    switch (_scanStatus) {
      case 'valid':
        return 'Entry Approved';
      case 'invalid':
        return 'Invalid / Already Scanned';
      case 'duplicate':
        return 'Guest Pass';
      default:
        return 'Ready to Scan';
    }
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
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'QR Scanner',
                        style: AppTextStyles.headlineLarge,
                      ),
                    ),
                    const Spacer(),
                    const NeuPill(label: 'Camera'),
                    const SizedBox(width: 8),
                    const PulsingDot(color: AppColors.accentLight, size: 6),
                    const SizedBox(width: 6),
                    Text(
                      'Camera Active',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.accentLight,
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
                  child: NeumorphicSection(
                    padding: const EdgeInsets.all(4),
                    borderRadius: 26,
                    borderColor: _scanStatus == 'idle'
                        ? Colors.white.withValues(alpha: 0.04)
                        : _scanColor.withValues(alpha: 0.35),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Camera placeholder
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_rounded,
                              size: 48,
                              color: AppColors.textMuted.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Camera Preview',
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
                                      _scannedName,
                                      style: AppTextStyles.headlineMedium,
                                    ),
                                    Text(
                                      _scannedRoll,
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
                child: NeumorphicSection(
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
                              child: NeumorphicSection(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                borderRadius: 12,
                                borderColor: AppColors.accent.withValues(
                                  alpha: 0.18,
                                ),
                                child: Center(
                                  child: Text(
                                    '✅ Valid Scan',
                                    style: AppTextStyles.labelLarge.copyWith(
                                      color: AppColors.accentLight,
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
                              child: NeumorphicSection(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                borderRadius: 12,
                                borderColor: AppColors.error.withValues(
                                  alpha: 0.18,
                                ),
                                child: Center(
                                  child: Text(
                                    '❌ Invalid Scan',
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
