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

class _KitchenDisplayScreenState extends State<KitchenDisplayScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'urgent': return AppColors.warning;
      case 'critical': return AppColors.error;
      default: return AppColors.accent;
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
            colors: [Colors.white, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
                    const Icon(Icons.kitchen_rounded, color: AppColors.accent, size: 24),
                    const SizedBox(width: 10),
                    Text('Kitchen Display', style: AppTextStyles.headlineLarge),
                    const Spacer(),
                    const PulsingDot(color: AppColors.accent, size: 8),
                    const SizedBox(width: 6),
                    Text('LIVE', style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Scan Rate Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassCard(
                  padding: const EdgeInsets.all(12),
                  borderColor: AppColors.info.withValues(alpha: 0.2),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.speed_rounded, color: AppColors.info, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Current scan rate: 12 students/min', style: AppTextStyles.labelLarge.copyWith(color: AppColors.info, fontSize: 12)),
                            Text('$headcount scanned so far', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
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
                          child: GlassCard(
                            padding: const EdgeInsets.all(14),
                            borderColor: isCritical
                                ? AppColors.error.withValues(alpha: 0.2 + _pulseController.value * 0.3)
                                : color.withValues(alpha: 0.1),
                            child: Row(
                              children: [
                                // Emoji
                                Container(
                                  width: 48, height: 48,
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(item['emoji'] as String, style: const TextStyle(fontSize: 26)),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                // Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item['item'] as String, style: AppTextStyles.titleMedium),
                                      const SizedBox(height: 2),
                                      Text(
                                        '~${item['remaining']} servings left',
                                        style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                                // Refill Timer
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: color.withValues(alpha: 0.2)),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${refillMin}m',
                                        style: AppTextStyles.statNumber.copyWith(color: color, fontSize: 20),
                                      ),
                                      Text('refill', style: AppTextStyles.bodySmall.copyWith(fontSize: 9, color: color)),
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
