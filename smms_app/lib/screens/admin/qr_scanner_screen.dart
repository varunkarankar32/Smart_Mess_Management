import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../services/mock_data_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with SingleTickerProviderStateMixin {
  String _scanStatus = 'idle';
  String _scannedName = '';
  String _scannedRoll = '';
  AttendanceModel? _activeScan;
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

  void _simulateValidScan() {
    final scan = MockDataService.recordAttendanceScan(
      userId: MockDataService.demoValidatedUser.id,
      userName: MockDataService.demoValidatedUser.name,
      rollNo: MockDataService.demoValidatedUser.rollNo,
      mealType: 'Lunch',
      isValid: true,
    );
    _applyScan(scan);
  }

  void _simulateDuplicateScan() {
    final scan = MockDataService.recordAttendanceScan(
      userId: MockDataService.demoValidatedUser.id,
      userName: MockDataService.demoValidatedUser.name,
      rollNo: MockDataService.demoValidatedUser.rollNo,
      mealType: 'Lunch',
      isValid: true,
    );
    _applyScan(scan);
  }

  void _simulateInvalidScan() {
    final scan = MockDataService.recordAttendanceScan(
      userId: MockDataService.demoBlockedUser.id,
      userName: MockDataService.demoBlockedUser.name,
      rollNo: MockDataService.demoBlockedUser.rollNo,
      mealType: 'Lunch',
      isValid: false,
    );
    _applyScan(scan);
  }

  void _applyScan(AttendanceModel scan) {
    setState(() {
      _scanStatus = scan.status;
      _scannedName = scan.userName;
      _scannedRoll = scan.rollNo;
      _activeScan = scan;
    });
    _flashController.forward(from: 0);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _scanStatus = 'idle');
      }
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
        return 'Duplicate Blocked';
      default:
        return 'Ready to Scan';
    }
  }

  @override
  Widget build(BuildContext context) {
    final recentLog = MockDataService.recentScans.take(4).toList();

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
              children: [
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
                Padding(
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
                                  if (_scannedName.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      _scannedName,
                                      style: AppTextStyles.headlineMedium,
                                      textAlign: TextAlign.center,
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
                const SizedBox(height: 16),
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
                                onTap: _simulateValidScan,
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
                                      'Valid Scan',
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
                                onTap: _simulateDuplicateScan,
                                child: NeumorphicSection(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  borderRadius: 12,
                                  borderColor: AppColors.warning.withValues(
                                    alpha: 0.18,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Duplicate Scan',
                                      style: AppTextStyles.labelLarge.copyWith(
                                        color: AppColors.warning,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: _simulateInvalidScan,
                          child: NeumorphicSection(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            borderRadius: 12,
                            borderColor: AppColors.error.withValues(
                              alpha: 0.18,
                            ),
                            child: Center(
                              child: Text(
                                'Invalid Scan',
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Tap Valid Scan once, then Duplicate Scan to see blocking.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: NeumorphicSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Live Scan Log',
                              style: AppTextStyles.titleMedium,
                            ),
                            const Spacer(),
                            if (_activeScan != null)
                              Text(
                                _activeScan!.status.toUpperCase(),
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: _scanColor,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...recentLog.map(
                          (scan) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Icon(
                                  _scanIconFor(scan.status),
                                  color: _scanColorFor(scan.status),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    scan.userName,
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ),
                                Text(
                                  _scanMessageFor(scan.status),
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: _scanColorFor(scan.status),
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _scanIconFor(String status) {
    switch (status) {
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

  Color _scanColorFor(String status) {
    switch (status) {
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

  String _scanMessageFor(String status) {
    switch (status) {
      case 'valid':
        return 'Validated';
      case 'invalid':
        return 'Rejected';
      case 'duplicate':
        return 'Duplicate';
      default:
        return 'Pending';
    }
  }
}
