import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../services/mock_data_service.dart';

class KitchenDisplayScreen extends StatefulWidget {
  const KitchenDisplayScreen({super.key});

  @override
  State<KitchenDisplayScreen> createState() => _KitchenDisplayScreenState();
}

class _KitchenDisplayScreenState extends State<KitchenDisplayScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'urgent':
        return AppColors.warning;
      case 'critical':
        return AppColors.error;
      default:
        return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = MockDataService.kitchenDisplayItems;
    final headcount = MockDataService.liveHeadcount;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    const NeuIconTile(
                      icon: Icons.kitchen_rounded,
                      iconColor: AppColors.accentLight,
                      padding: EdgeInsets.all(8),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Kitchen Display',
                        style: AppTextStyles.headlineLarge,
                      ),
                    ),
                    const Spacer(),
                    const NeuPill(label: 'LIVE'),
                    const SizedBox(width: 8),
                    const PulsingDot(color: AppColors.accentLight, size: 8),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Scan Rate Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: NeumorphicSection(
                  padding: const EdgeInsets.all(12),
                  borderColor: AppColors.info.withValues(alpha: 0.2),
                  child: Row(
                    children: [
                      const NeuIconTile(
                        icon: Icons.speed_rounded,
                        iconColor: AppColors.info,
                        padding: EdgeInsets.all(8),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current scan rate: 12 students/min',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.info,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '$headcount scanned so far',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const SectionHeader(title: 'Serving Line Status'),
              const SizedBox(height: 4),

              // Kitchen Items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final color = _statusColor(item['status'] as String);
                    final isCritical = item['status'] == 'critical';
                    final refillMin = item['refillIn'] as int;

                    return AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: NeumorphicSection(
                            padding: const EdgeInsets.all(14),
                            borderColor: isCritical
                                ? AppColors.error.withValues(
                                    alpha: 0.2 + _pulseController.value * 0.3,
                                  )
                                : color.withValues(alpha: 0.1),
                            child: Row(
                              children: [
                                // Emoji
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        color.withValues(alpha: 0.18),
                                        AppColors.surface,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      item['emoji'] as String,
                                      style: const TextStyle(fontSize: 26),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                // Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['item'] as String,
                                        style: AppTextStyles.titleMedium,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '~${item['remaining']} servings left',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Refill Timer
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: color.withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${refillMin}m',
                                        style: AppTextStyles.statNumber
                                            .copyWith(
                                              color: color,
                                              fontSize: 20,
                                            ),
                                      ),
                                      Text(
                                        'refill',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          fontSize: 9,
                                          color: color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
