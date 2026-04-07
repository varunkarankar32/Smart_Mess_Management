import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';

class _CardScanResult {
  const _CardScanResult({
    required this.isValid,
    required this.name,
    required this.enrollmentNo,
    required this.message,
  });

  final bool isValid;
  final String name;
  final String enrollmentNo;
  final String message;
}

class IdCardScannerScreen extends StatefulWidget {
  const IdCardScannerScreen({super.key});

  @override
  State<IdCardScannerScreen> createState() => _IdCardScannerScreenState();
}

class _IdCardScannerScreenState extends State<IdCardScannerScreen>
    with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  Future<void>? _initializationFuture;
  bool _isCameraAvailable = false;
  bool _isProcessing = false;
  String _scanStatus = 'idle'; // idle, scanning, success, error
  String _scannedName = '';
  String _scannedEnrollmentNo = '';
  String _scanHint = 'Align the college ID card inside the frame';
  String? _errorMessage;
  late AnimationController _flashController;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _flashController.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (!mounted) return;
        setState(() {
          _scanStatus = 'error';
          _errorMessage = 'No camera found on this device.';
          _isCameraAvailable = false;
        });
        return;
      }

      final backCamera =
          cameras
              .where(
                (camera) => camera.lensDirection == CameraLensDirection.back,
              )
              .toList();
      final selectedCamera =
          backCamera.isNotEmpty ? backCamera.first : cameras.first;
      final controller = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      _initializationFuture = controller.initialize();
      await _initializationFuture;

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _cameraController = controller;
        _isCameraAvailable = true;
        _scanStatus = 'idle';
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _scanStatus = 'error';
        _errorMessage = 'Camera unavailable: $error';
        _isCameraAvailable = false;
      });
    }
  }

  Color get _scanColor {
    switch (_scanStatus) {
      case 'success':
        return AppColors.accent;
      case 'error':
        return AppColors.error;
      case 'scanning':
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }

  String get _scanMessage {
    switch (_scanStatus) {
      case 'success':
        return 'ID Card Verified';
      case 'error':
        return _errorMessage ?? 'Unable to verify ID card';
      case 'scanning':
        return 'Scanning ID Card...';
      default:
        return 'Ready to Scan ID Card';
    }
  }

  Future<void> _scanIdCard() async {
    final controller = _cameraController;
    if (controller == null ||
        !controller.value.isInitialized ||
        _isProcessing) {
      return;
    }

    setState(() {
      _isProcessing = true;
      _scanStatus = 'scanning';
      _scanHint = 'Hold the card steady while we read the text';
      _errorMessage = null;
    });

    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final file = await controller.takePicture();
      final inputImage = InputImage.fromFilePath(file.path);
      final recognizedText = await recognizer.processImage(inputImage);
      final result = _parseCardText(recognizedText.text);

      if (!mounted) {
        return;
      }

      setState(() {
        _scanStatus = result.isValid ? 'success' : 'error';
        _scannedName = result.name;
        _scannedEnrollmentNo = result.enrollmentNo;
        _scanHint = result.message;
        _errorMessage = result.isValid ? null : result.message;
      });
      _flashController.forward(from: 0);
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _scanStatus = 'error';
        _errorMessage = 'Scan failed: $error';
        _scanHint = 'Try again with the card fully visible';
      });
      _flashController.forward(from: 0);
    } finally {
      await recognizer.close();
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  _CardScanResult _parseCardText(String rawText) {
    final lines =
        rawText
            .split(RegExp(r'[\r\n]+'))
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty)
            .toList();

    String? name = _extractValueAfterLabel(lines, const [
      'student name',
      'name of student',
      'name',
    ]);
    String? enrollmentNo = _extractValueAfterLabel(lines, const [
      'enrollment number',
      'enrollment no',
      'enrolment number',
      'enrolment no',
      'roll no',
      'roll number',
      'student id',
      'id no',
    ]);

    name ??= _findLikelyName(lines);
    enrollmentNo ??= _findLikelyEnrollment(lines);

    final cleanedName = _cleanValue(name);
    final cleanedEnrollmentNo = _cleanValue(enrollmentNo);

    if (cleanedName.isEmpty || cleanedEnrollmentNo.isEmpty) {
      return _CardScanResult(
        isValid: false,
        name: cleanedName,
        enrollmentNo: cleanedEnrollmentNo,
        message:
            'Could not read both student name and enrollment number. Try better lighting and keep the card straight.',
      );
    }

    return _CardScanResult(
      isValid: true,
      name: cleanedName,
      enrollmentNo: cleanedEnrollmentNo,
      message: 'Student details extracted successfully.',
    );
  }

  String _cleanValue(String? value) {
    return (value ?? '').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String? _extractValueAfterLabel(List<String> lines, List<String> labels) {
    for (var index = 0; index < lines.length; index++) {
      final line = lines[index];
      final lowerLine = line.toLowerCase();

      for (final label in labels) {
        final labelIndex = lowerLine.indexOf(label);
        if (labelIndex == -1) {
          continue;
        }

        final afterLabel =
            line
                .substring(labelIndex + label.length)
                .replaceFirst(RegExp(r'^[\s:\-]+'), '')
                .trim();
        if (afterLabel.isNotEmpty) {
          return afterLabel;
        }

        if (index + 1 < lines.length) {
          final nextLine = lines[index + 1].trim();
          if (nextLine.isNotEmpty) {
            return nextLine;
          }
        }
      }
    }

    return null;
  }

  String? _findLikelyName(List<String> lines) {
    const blockedWords = [
      'college',
      'university',
      'institute',
      'department',
      'student id',
      'id card',
      'enrollment',
      'enrolment',
      'roll no',
      'roll number',
    ];

    for (final line in lines) {
      final lowerLine = line.toLowerCase();
      if (blockedWords.any(lowerLine.contains)) {
        continue;
      }

      final wordCount = line.split(RegExp(r'\s+')).length;
      final alphabeticWords = RegExp(
        r"^[A-Za-z][A-Za-z.'\-]*(\s+[A-Za-z][A-Za-z.'\-]*)+$",
      );
      if (wordCount >= 2 && wordCount <= 4 && alphabeticWords.hasMatch(line)) {
        return line;
      }
    }

    return null;
  }

  String? _findLikelyEnrollment(List<String> lines) {
    const blockedWords = [
      'college',
      'university',
      'institute',
      'department',
      'student',
      'name',
    ];

    for (final line in lines) {
      final lowerLine = line.toLowerCase();
      if (blockedWords.any(lowerLine.contains)) {
        continue;
      }

      final sanitized = line.replaceAll(RegExp(r'[^A-Za-z0-9/-]'), '');
      if (sanitized.length < 5) {
        continue;
      }

      final containsDigits = RegExp(r'\d').hasMatch(sanitized);
      final looksLikeId = RegExp(r'^[A-Za-z0-9/-]{5,}$').hasMatch(sanitized);
      if (containsDigits && looksLikeId) {
        return sanitized;
      }
    }

    return null;
  }

  Widget _buildPreview() {
    if (!_isCameraAvailable || _cameraController == null) {
      return _buildFallbackState();
    }

    final controller = _cameraController!;
    return FutureBuilder<void>(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            !controller.value.isInitialized) {
          return _buildLoadingState();
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(controller),
              Container(color: Colors.black.withValues(alpha: 0.18)),
              Center(
                child: Container(
                  width: 260,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          _scanStatus == 'success'
                              ? AppColors.accent.withValues(alpha: 0.75)
                              : AppColors.accent.withValues(alpha: 0.45),
                      width: 2,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statusChip(
                      icon:
                          _scanStatus == 'scanning'
                              ? Icons.sync_rounded
                              : Icons.badge_rounded,
                      label:
                          _scanStatus == 'scanning' ? 'Scanning' : 'ID Ready',
                    ),
                    _statusChip(
                      icon: Icons.camera_alt_rounded,
                      label:
                          controller.description.name.isNotEmpty
                              ? controller.description.name
                              : 'Back Camera',
                    ),
                  ],
                ),
              ),
              if (_scanStatus == 'success')
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _flashController,
                        curve: Curves.easeOut,
                      ),
                      child: _resultCard(
                        icon: Icons.check_circle_rounded,
                        title: 'Student Found',
                        subtitle: _scanHint,
                        accentColor: AppColors.accent,
                      ),
                    ),
                  ),
                ),
              if (_scanStatus == 'error')
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _flashController,
                        curve: Curves.easeOut,
                      ),
                      child: _resultCard(
                        icon: Icons.cancel_rounded,
                        title: 'Scan Failed',
                        subtitle: _scanMessage,
                        accentColor: AppColors.error,
                      ),
                    ),
                  ),
                ),
              if (_isProcessing)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.25),
                    child: Center(
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Reading ID card text...',
                              style: AppTextStyles.labelLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            const SizedBox(height: 12),
            Text(
              'Starting camera...',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackState() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.no_photography_rounded,
                size: 52,
                color: AppColors.textMuted.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 12),
              Text('Camera unavailable', style: AppTextStyles.titleLarge),
              const SizedBox(height: 6),
              Text(
                _errorMessage ??
                    'Grant camera permission or use a phone with a camera.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _initializeCamera,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    'Retry Camera',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.accent,
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

  Widget _statusChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accentColor,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      borderColor: accentColor.withValues(alpha: 0.2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: accentColor, size: 54),
          const SizedBox(height: 10),
          Text(
            title,
            style: AppTextStyles.titleLarge.copyWith(color: accentColor),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 260,
            child: Text(
              subtitle,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          if (_scanStatus == 'success') ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Column(
                children: [
                  Text(
                    'Student Name',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _scannedName,
                    style: AppTextStyles.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Enrollment Number',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _scannedEnrollmentNo,
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          GestureDetector(
            onTap: _isProcessing ? null : _scanIdCard,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accentColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                _scanStatus == 'success' ? 'Scan Another Card' : 'Try Again',
                style: AppTextStyles.labelLarge.copyWith(color: accentColor),
              ),
            ),
          ),
        ],
      ),
    );
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
                        _buildPreview(),

                        // Scan crosshair overlay
                        if (_isCameraAvailable && _scanStatus == 'idle')
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
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Scan Controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scan Controls',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _isProcessing ? null : _scanIdCard,
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
                                    '✅ Scan ID Card',
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
                              onTap:
                                  _isProcessing
                                      ? null
                                      : () {
                                        setState(() {
                                          _scanStatus = 'idle';
                                          _scanHint =
                                              'Align the college ID card inside the frame';
                                          _errorMessage = null;
                                          _scannedName = '';
                                          _scannedEnrollmentNo = '';
                                        });
                                      },
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
                                    '↺ Clear Result',
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
