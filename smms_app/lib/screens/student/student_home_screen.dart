import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/models.dart';
import '../../services/mock_data_service.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen>
    with TickerProviderStateMixin {
  bool _notEatingToday = false;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  static const Color _pageBackground = Color(0xFFF6F1E8);
  static const Color _surface = Colors.white;
  static const Color _surfaceSoft = Color(0xFFFFFBF6);
  static const Color _border = Color(0xFFE8DED0);
  static const Color _textPrimary = Color(0xFF1F2937);
  static const Color _textSecondary = Color(0xFF667085);
  static const Color _accent = Color(0xFFFF7A45);
  static const Color _accentDark = Color(0xFFEA5C2B);
  static const Color _success = Color(0xFF179B67);
  static const Color _warning = Color(0xFFF4A62A);
  static const Color _coolBlue = Color(0xFF5A88F0);

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    final curved = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    );
    _fadeAnimation = curved;
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(curved);
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final user = MockDataService.currentUser;
    final meals = MockDataService.todaysMeals;
    final occupancy = MockDataService.currentOccupancy;
    final weather = MockDataService.currentWeather;

    return Scaffold(
      backgroundColor: _pageBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth =
                constraints.maxWidth > 1200 ? 1120.0 : constraints.maxWidth;
            final menuColumns =
                constraints.maxWidth >= 1120
                    ? 4
                    : constraints.maxWidth >= 820
                    ? 3
                    : 2;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentWidth),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(context, user),
                            const SizedBox(height: 18),
                            _HeroSnapshotCard(
                              occupancy: occupancy,
                              weather: weather,
                              notEatingToday: _notEatingToday,
                              onQrTap:
                                  () => Navigator.pushNamed(
                                    context,
                                    '/student/qr',
                                  ),
                              onToggleChanged:
                                  (value) =>
                                      setState(() => _notEatingToday = value),
                            ),
                            const SizedBox(height: 18),
                            _buildCategoryChips(),
                            const SizedBox(height: 22),
                            _SectionTitle(
                              title: "Today's Menu",
                              subtitle:
                                  'Premium food cards inspired by the delivery-style layout',
                            ),
                            const SizedBox(height: 14),
                            GridView.count(
                              crossAxisCount: menuColumns,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio:
                                  constraints.maxWidth >= 820 ? 0.84 : 0.78,
                              children:
                                  meals
                                      .map((meal) => _MealCard(meal: meal))
                                      .toList(),
                            ),
                            const SizedBox(height: 22),
                            _SectionTitle(
                              title: 'Your Progress',
                              subtitle:
                                  'Student activity and savings at a glance',
                            ),
                            const SizedBox(height: 14),
                            GridView.count(
                              crossAxisCount:
                                  constraints.maxWidth >= 1100 ? 4 : 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio:
                                  constraints.maxWidth >= 820 ? 1.45 : 1.25,
                              children: [
                                _MetricCard(
                                  title: 'Meals Eaten',
                                  value: '${user.totalMeals}',
                                  subtitle: 'This semester',
                                  icon: Icons.restaurant_rounded,
                                  tint: _coolBlue,
                                ),
                                _MetricCard(
                                  title: 'Waste Saved',
                                  value:
                                      '${user.wasteSavedKg.toStringAsFixed(1)} kg',
                                  subtitle: 'Sustainable impact',
                                  icon: Icons.eco_rounded,
                                  tint: _success,
                                ),
                                _MetricCard(
                                  title: 'Reward Points',
                                  value: '${user.rewardPoints}',
                                  subtitle: 'Loyalty balance',
                                  icon: Icons.star_rounded,
                                  tint: _warning,
                                ),
                                _MetricCard(
                                  title: 'Rebate Balance',
                                  value: '₹${user.rebateBalance.toInt()}',
                                  subtitle: 'Available credit',
                                  icon: Icons.account_balance_wallet_rounded,
                                  tint: _accent,
                                ),
                              ],
                            ),
                            const SizedBox(height: 22),
                            _WeatherCard(weather: weather),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserModel user) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                user.name,
                style: GoogleFonts.outfit(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${user.rollNo} • ${user.dietPreferences.join(', ')}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _HeaderActionButton(
          icon: Icons.notifications_none_rounded,
          onTap: () => Navigator.pushNamed(context, '/student/notifications'),
          hasBadge: true,
        ),
        const SizedBox(width: 10),
        _HeaderAvatar(
          label: user.name.isNotEmpty ? user.name.substring(0, 1) : 'U',
          onTap: () => Navigator.pushNamed(context, '/student/profile'),
        ),
      ],
    );
  }

  Widget _buildCategoryChips() {
    final categories = <_CategoryChipData>[
      const _CategoryChipData('Breakfast', Icons.wb_sunny_rounded, false),
      const _CategoryChipData('Lunch', Icons.lunch_dining_rounded, true),
      const _CategoryChipData('Snacks', Icons.cookie_rounded, false),
      const _CategoryChipData('Dinner', Icons.nightlight_round_rounded, false),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children:
            categories
                .map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _CategoryPill(
                      label: category.label,
                      icon: category.icon,
                      active: category.active,
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}

class _HeroSnapshotCard extends StatelessWidget {
  final double occupancy;
  final WeatherData weather;
  final bool notEatingToday;
  final ValueChanged<bool> onToggleChanged;
  final VoidCallback onQrTap;

  const _HeroSnapshotCard({
    required this.occupancy,
    required this.weather,
    required this.notEatingToday,
    required this.onToggleChanged,
    required this.onQrTap,
  });

  static const Color _surface = Colors.white;
  static const Color _surfaceSoft = Color(0xFFFFFBF6);
  static const Color _border = Color(0xFFE8DED0);
  static const Color _textPrimary = Color(0xFF1F2937);
  static const Color _textSecondary = Color(0xFF667085);
  static const Color _accent = Color(0xFFFF7A45);
  static const Color _accentDark = Color(0xFFEA5C2B);
  static const Color _success = Color(0xFF179B67);

  @override
  Widget build(BuildContext context) {
    final percent = (occupancy / 100).clamp(0.0, 1.0);
    final trafficLabel =
        occupancy < 40
            ? 'Easy entry'
            : occupancy < 65
            ? 'Moderate flow'
            : occupancy < 85
            ? 'Busy hour'
            : 'Nearly full';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFFFF7EE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 680;
          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoChip(
                    label: 'Live crowd',
                    value: '${occupancy.toStringAsFixed(0)}%',
                    tint: _accent,
                  ),
                  _InfoChip(
                    label: 'Weather',
                    value: '${weather.temperature.toInt()}°C',
                    tint: _success,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Today\'s dining snapshot',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                weather.suggestion,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                  color: _textSecondary,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _MiniPill(
                    icon: Icons.schedule_rounded,
                    label: 'Best at 1:30 PM',
                    tint: _accentDark,
                  ),
                  _MiniPill(
                    icon: Icons.restaurant_rounded,
                    label: trafficLabel,
                    tint: _success,
                  ),
                  _MiniPill(
                    icon: Icons.eco_rounded,
                    label: notEatingToday ? 'Meal skipped' : 'Meal active',
                    tint: notEatingToday ? const Color(0xFFE74C3C) : _accent,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  _PrimaryActionButton(
                    label: 'Show QR Pass',
                    icon: Icons.qr_code_2_rounded,
                    onTap: onQrTap,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: _surfaceSoft,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: _border),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              notEatingToday
                                  ? 'Not eating today'
                                  : 'Eating today',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _textPrimary,
                              ),
                            ),
                          ),
                          Transform.scale(
                            scale: 0.9,
                            child: Switch.adaptive(
                              value: notEatingToday,
                              onChanged: onToggleChanged,
                              activeColor: _accent,
                              activeTrackColor: _accent.withValues(alpha: 0.28),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );

          return isWide
              ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: details),
                  const SizedBox(width: 24),
                  _CrowdMeterCompact(percent: percent),
                ],
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  details,
                  const SizedBox(height: 20),
                  _CrowdMeterCompact(percent: percent),
                ],
              );
        },
      ),
    );
  }
}

class _CrowdMeterCompact extends StatelessWidget {
  final double percent;

  const _CrowdMeterCompact({required this.percent});

  static const Color _textPrimary = Color(0xFF1F2937);
  static const Color _textSecondary = Color(0xFF667085);
  static const Color _accent = Color(0xFFFF7A45);
  static const Color _success = Color(0xFF179B67);
  static const Color _warning = Color(0xFFF4A62A);
  static const Color _surface = Colors.white;
  static const Color _border = Color(0xFFE8DED0);

  @override
  Widget build(BuildContext context) {
    final intensity =
        percent < 0.4
            ? _success
            : percent < 0.65
            ? _warning
            : _accent;
    final label =
        percent < 0.4
            ? 'Relaxed'
            : percent < 0.65
            ? 'Steady'
            : 'Busy';

    return Container(
      width: 220,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 12,
                  backgroundColor: const Color(0xFFF0E7DC),
                  valueColor: AlwaysStoppedAnimation<Color>(intensity),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(percent * 100).toInt()}%',
                    style: GoogleFonts.outfit(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: _textPrimary,
                    ),
                  ),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: intensity.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: intensity,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Live occupancy',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: intensity,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final MealModel meal;

  const _MealCard({required this.meal});

  static const Color _surface = Colors.white;
  static const Color _border = Color(0xFFE8DED0);
  static const Color _textPrimary = Color(0xFF1F2937);
  static const Color _textSecondary = Color(0xFF667085);
  static const Color _accent = Color(0xFFFF7A45);
  static const Color _success = Color(0xFF179B67);
  static const Color _warning = Color(0xFFF4A62A);
  static const Color _coolBlue = Color(0xFF5A88F0);

  Color _mealTint() {
    switch (meal.mealType.toLowerCase()) {
      case 'breakfast':
        return _warning;
      case 'lunch':
        return _success;
      case 'snacks':
        return _accent;
      case 'dinner':
        return _coolBlue;
      default:
        return _accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final featuredItem = meal.items.first;
    final extraItems = meal.items.skip(1).take(2).toList();
    final tint = _mealTint();

    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    tint.withValues(alpha: 0.12),
                    const Color(0xFFFFFBF7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: tint.withValues(alpha: 0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        featuredItem.imageEmoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: tint.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            meal.mealType,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: tint,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              featuredItem.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.1,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              extraItems.isEmpty
                  ? 'Chef special for today'
                  : extraItems.map((item) => item.name).join(' • '),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 12,
                height: 1.35,
                fontWeight: FontWeight.w500,
                color: _textSecondary,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                _MetaChip(
                  icon: Icons.local_fire_department_rounded,
                  label: '${featuredItem.calories} kcal',
                  tint: tint,
                ),
                const SizedBox(width: 8),
                _MetaChip(
                  icon: Icons.star_rounded,
                  label:
                      featuredItem.averageRating == 0
                          ? 'New'
                          : featuredItem.averageRating.toStringAsFixed(1),
                  tint: _warning,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${meal.items.length} items',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _textSecondary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: tint.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.add_rounded, color: tint, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color tint;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.tint,
  });

  static const Color _surface = Colors.white;
  static const Color _border = Color(0xFFE8DED0);
  static const Color _textPrimary = Color(0xFF1F2937);
  static const Color _textSecondary = Color(0xFF667085);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: tint, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: _textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  final WeatherData weather;

  const _WeatherCard({required this.weather});

  static const Color _surface = Colors.white;
  static const Color _border = Color(0xFFE8DED0);
  static const Color _textPrimary = Color(0xFF1F2937);
  static const Color _textSecondary = Color(0xFF667085);
  static const Color _coolBlue = Color(0xFF5A88F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _coolBlue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(weather.icon, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${weather.temperature.toInt()}°C · ${weather.condition.toUpperCase()}',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  weather.suggestion,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({required this.title, required this.subtitle});

  static const Color _textPrimary = Color(0xFF1F2937);
  static const Color _textSecondary = Color(0xFF667085);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _textSecondary,
          ),
        ),
      ],
    );
  }
}

class _CategoryChipData {
  final String label;
  final IconData icon;
  final bool active;

  const _CategoryChipData(this.label, this.icon, this.active);
}

class _HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hasBadge;

  const _HeaderActionButton({
    required this.icon,
    required this.onTap,
    this.hasBadge = false,
  });

  static const Color _surface = Colors.white;
  static const Color _border = Color(0xFFE8DED0);
  static const Color _textPrimary = Color(0xFF1F2937);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(child: Icon(icon, color: _textPrimary, size: 22)),
              if (hasBadge)
                Positioned(
                  right: 11,
                  top: 11,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE74C3C),
                      shape: BoxShape.circle,
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

class _HeaderAvatar extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _HeaderAvatar({required this.label, required this.onTap});

  static const Color _accent = Color(0xFFFF7A45);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _accent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: _accent.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;

  const _CategoryPill({
    required this.label,
    required this.icon,
    required this.active,
  });

  static const Color _surface = Colors.white;
  static const Color _border = Color(0xFFE8DED0);
  static const Color _textPrimary = Color(0xFF1F2937);
  static const Color _textSecondary = Color(0xFF667085);
  static const Color _accent = Color(0xFFFF7A45);

  @override
  Widget build(BuildContext context) {
    final tint = active ? _accent : _textSecondary;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: active ? _accent.withValues(alpha: 0.12) : _surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: active ? _accent.withValues(alpha: 0.18) : _border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: active ? 0.05 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: tint),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: active ? _textPrimary : _textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color tint;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: tint,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: tint,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color tint;

  const _MiniPill({
    required this.icon,
    required this.label,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: tint),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: tint,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PrimaryActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  static const Color _accent = Color(0xFFFF7A45);
  static const Color _accentDark = Color(0xFFEA5C2B);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_accent, _accentDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: _accent.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color tint;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: tint),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: tint,
            ),
          ),
        ],
      ),
    );
  }
}
