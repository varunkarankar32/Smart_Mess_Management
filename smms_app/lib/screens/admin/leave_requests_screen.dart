import 'package:flutter/material.dart';

import '../../services/mock_data_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common_widgets.dart';

class LeaveRequestsScreen extends StatefulWidget {
  const LeaveRequestsScreen({super.key});

  @override
  State<LeaveRequestsScreen> createState() => _LeaveRequestsScreenState();
}

class _LeaveRequestsScreenState extends State<LeaveRequestsScreen> {
  void _approve(String requestId) {
    setState(() {
      MockDataService.approveLeaveRequest(requestId);
    });
  }

  void _reject(String requestId) {
    setState(() {
      MockDataService.rejectLeaveRequest(requestId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final requests = MockDataService.leaveRequests.toList().reversed.toList();

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Leave Review',
                          style: AppTextStyles.headlineLarge,
                        ),
                      ),
                      const NeuPill(label: 'Admin'),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Approve or reject meal leave requests submitted by students.',
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Pending',
                          value: '${MockDataService.pendingLeaveCount}',
                          icon: Icons.timelapse_rounded,
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          title: 'Approved',
                          value: '${MockDataService.approvedLeaveCount}',
                          icon: Icons.check_circle_rounded,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Rejected',
                          value: '${MockDataService.rejectedLeaveCount}',
                          icon: Icons.cancel_rounded,
                          color: AppColors.error,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          title: 'Total',
                          value: '${requests.length}',
                          icon: Icons.event_rounded,
                          color: AppColors.accentLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ...requests.map((request) {
                  final status = MockDataService.leaveRequestStatus(request.id);
                  final statusColor = _statusColor(status);
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: NeumorphicSection(
                      borderColor: statusColor.withValues(alpha: 0.18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      statusColor.withValues(alpha: 0.2),
                                      AppColors.surface,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.event_busy_rounded,
                                  color: statusColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${request.mealType} - ${request.date.day}/${request.date.month}',
                                      style: AppTextStyles.titleMedium,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      request.reason.isEmpty
                                          ? 'No reason provided'
                                          : request.reason,
                                      style: AppTextStyles.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                status.toUpperCase(),
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  request.userId,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                              if (status == 'pending') ...[
                                GestureDetector(
                                  onTap: () => _reject(request.id),
                                  child: NeumorphicSection(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    borderRadius: 12,
                                    borderColor: AppColors.error.withValues(
                                      alpha: 0.18,
                                    ),
                                    child: Text(
                                      'Reject',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: AppColors.error,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () => _approve(request.id),
                                  child: NeumorphicSection(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    borderRadius: 12,
                                    borderColor: AppColors.accent.withValues(
                                      alpha: 0.18,
                                    ),
                                    child: Text(
                                      'Approve',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: AppColors.accentLight,
                                      ),
                                    ),
                                  ),
                                ),
                              ] else
                                Text(
                                  'Reviewed',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: statusColor,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
        return AppColors.accent;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }
}
