import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final Color? borderColor;
  final LinearGradient? gradient;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 20,
    this.borderColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.cardGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? Colors.white.withValues(alpha: 0.06),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color = AppColors.accent,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              if (subtitle != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(subtitle!, style: AppTextStyles.bodySmall.copyWith(color: color, fontSize: 10)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyles.statNumber.copyWith(color: color, fontSize: 26)),
          const SizedBox(height: 4),
          Text(title, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

class CrowdMeterGauge extends StatefulWidget {
  final double occupancy;
  const CrowdMeterGauge({super.key, required this.occupancy});

  @override
  State<CrowdMeterGauge> createState() => _CrowdMeterGaugeState();
}

class _CrowdMeterGaugeState extends State<CrowdMeterGauge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.occupancy / 100)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getColor(double val) {
    if (val < 0.4) return AppColors.crowdLow;
    if (val < 0.65) return AppColors.crowdMedium;
    if (val < 0.85) return AppColors.crowdHigh;
    return AppColors.crowdFull;
  }

  String _getLabel(double val) {
    if (val < 0.4) return 'Low Traffic';
    if (val < 0.65) return 'Moderate';
    if (val < 0.85) return 'High Traffic';
    return 'Full Capacity';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final color = _getColor(_animation.value);
        return GlassCard(
          padding: const EdgeInsets.all(20),
          borderColor: color.withValues(alpha: 0.2),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.people_alt_rounded, color: color, size: 22),
                  const SizedBox(width: 8),
                  Text('Live Crowd Meter', style: AppTextStyles.titleMedium),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6, height: 6,
                          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 4),
                        Text('LIVE', style: AppTextStyles.labelSmall.copyWith(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 140,
                width: 140,
                child: CustomPaint(
                  painter: _GaugePainter(value: _animation.value, color: color),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(_animation.value * 100).toInt()}%',
                          style: AppTextStyles.displayMedium.copyWith(color: color, fontSize: 32),
                        ),
                        Text(_getLabel(_animation.value), style: AppTextStyles.bodySmall.copyWith(color: color)),
                      ],
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
}

class _GaugePainter extends CustomPainter {
  final double value;
  final Color color;

  _GaugePainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const startAngle = 135 * (pi / 180);
    const totalSweep = 270 * (pi / 180);

    // Background arc
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, totalSweep, false, bgPaint);

    // Value arc
    final valuePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, totalSweep * value, false, valuePaint);

    // Glow effect
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, totalSweep * value, false, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MenuCard extends StatelessWidget {
  final String name;
  final String emoji;
  final int calories;
  final double rating;
  final List<String> allergens;
  final VoidCallback? onTap;

  const MenuCard({
    super.key,
    required this.name,
    required this.emoji,
    this.calories = 0,
    this.rating = 0,
    this.allergens = const [],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(name, style: AppTextStyles.labelLarge, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            if (calories > 0)
              Text('$calories kcal', style: AppTextStyles.bodySmall),
            const SizedBox(height: 6),
            if (rating > 0)
              Row(
                children: [
                  Icon(Icons.star_rounded, color: AppColors.warning, size: 14),
                  const SizedBox(width: 2),
                  Text(rating.toStringAsFixed(1), style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning)),
                ],
              ),
            if (allergens.isNotEmpty) ...[
              const SizedBox(height: 6),
              Wrap(
                spacing: 4,
                children: allergens.map((a) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(a, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error, fontSize: 9)),
                )).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AccentButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isLarge;

  const AccentButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isLarge ? 32 : 20,
          vertical: isLarge ? 16 : 12,
        ),
        decoration: BoxDecoration(
          gradient: AppColors.accentGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: isLarge ? 24 : 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                color: Colors.white,
                fontSize: isLarge ? 16 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Text(title, style: AppTextStyles.titleLarge),
          const Spacer(),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Text(actionLabel!, style: AppTextStyles.accentLabel),
            ),
        ],
      ),
    );
  }
}

class PulsingDot extends StatefulWidget {
  final Color color;
  final double size;
  const PulsingDot({super.key, this.color = AppColors.accent, this.size = 8});

  @override
  State<PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Container(
        width: widget.size + _ctrl.value * 4,
        height: widget.size + _ctrl.value * 4,
        decoration: BoxDecoration(
          color: widget.color.withValues(alpha: 0.6 + _ctrl.value * 0.4),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: widget.color.withValues(alpha: 0.4), blurRadius: 8 + _ctrl.value * 4),
          ],
        ),
      ),
    );
  }
}
