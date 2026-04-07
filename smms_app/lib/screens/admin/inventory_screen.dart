import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';
import '../../services/mock_data_service.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'sufficient': return AppColors.accent;
      case 'low': return AppColors.warning;
      case 'critical': return AppColors.error;
      default: return AppColors.textMuted;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'sufficient': return Icons.check_circle_rounded;
      case 'low': return Icons.warning_amber_rounded;
      case 'critical': return Icons.error_rounded;
      default: return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final inventory = MockDataService.inventory;
    final leftoverData = MockDataService.leftoverData;

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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Text('Inventory', style: AppTextStyles.headlineLarge),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Monitor stock levels and leftover routing', style: AppTextStyles.bodySmall),
                ),
                const SizedBox(height: 16),

                // Stock Summary
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(child: _summaryCard('Sufficient', '${inventory.where((i) => i.status == "sufficient").length}', AppColors.accent)),
                      const SizedBox(width: 8),
                      Expanded(child: _summaryCard('Low Stock', '${inventory.where((i) => i.status == "low").length}', AppColors.warning)),
                      const SizedBox(width: 8),
                      Expanded(child: _summaryCard('Critical', '${inventory.where((i) => i.status == "critical").length}', AppColors.error)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const SectionHeader(title: 'Stock Levels'),
                const SizedBox(height: 4),
                ...inventory.map((item) {
                  final color = _statusColor(item.status);
                  final ratio = (item.currentStockKg / item.requiredKg).clamp(0.0, 1.5);
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    child: GlassCard(
                      padding: const EdgeInsets.all(12),
                      borderColor: item.status == 'critical' ? AppColors.error.withValues(alpha: 0.2) : null,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(_statusIcon(item.status), color: color, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(item.ingredient, style: AppTextStyles.titleMedium.copyWith(fontSize: 14)),
                              ),
                              Text(
                                '${item.currentStockKg.toInt()} / ${item.requiredKg.toInt()} ${item.unit}',
                                style: AppTextStyles.bodySmall.copyWith(color: color, fontSize: 11),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: ratio > 1.0 ? 1.0 : ratio,
                              backgroundColor: AppColors.surfaceLight,
                              valueColor: AlwaysStoppedAnimation(color),
                              minHeight: 5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 20),

                // Leftover Routing
                const SectionHeader(title: 'Leftover Routing Suggestions'),
                const SizedBox(height: 4),
                ...leftoverData.map((item) => Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: GlassCard(
                    padding: const EdgeInsets.all(12),
                    borderColor: AppColors.info.withValues(alpha: 0.15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.recycling_rounded, color: AppColors.info, size: 18),
                            const SizedBox(width: 8),
                            Text('${item['item']}', style: AppTextStyles.labelLarge.copyWith(fontSize: 13)),
                            const Spacer(),
                            Text('${item['surplusKg']} kg surplus', style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('💡 ${item['suggestion']}', style: AppTextStyles.bodyMedium.copyWith(fontSize: 12)),
                        if (item['ngoOption'] == true) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.volunteer_activism_rounded, color: AppColors.accent, size: 14),
                                const SizedBox(width: 6),
                                Text('Notify NGO Partner', style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent)),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                )),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryCard(String label, String count, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      borderColor: color.withValues(alpha: 0.2),
      child: Column(
        children: [
          Text(count, style: AppTextStyles.statNumber.copyWith(color: color, fontSize: 24)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
        ],
      ),
    );
  }
}
