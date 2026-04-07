import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double blur;
  final Color? borderColor;
  final LinearGradient? customGradient;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 24.0,
    this.blur = 20.0,
    this.borderColor,
    this.customGradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: Colors.white.withValues(alpha: 0.08),
            gradient: customGradient,
            border: Border.all(
              color: borderColor ?? Colors.white.withValues(alpha: 0.15),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }
    return content;
  }
}

class GlassButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool isPrimary;
  
  const GlassButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.isPrimary = true,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();
  void _onTapUp(TapUpDetails details) => _controller.reverse();
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: widget.isPrimary
                 ? AppColors.glassAccentGradient
                 : LinearGradient(colors: [Colors.white.withValues(alpha: 0.1), Colors.white.withValues(alpha: 0.05)]),
              border: Border.all(
                color: widget.isPrimary 
                    ? Colors.white.withValues(alpha: 0.3) 
                    : (_isHovered ? Colors.white.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.1)),
              ),
              boxShadow: widget.isPrimary ? [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: _isHovered ? 0.3 : 0.2),
                  blurRadius: _isHovered ? 20 : 15,
                  offset: const Offset(0, 5),
                )
              ] : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label,
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GlassTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final bool isPassword;
  final Widget? suffixIcon;
  final TextInputType keyboardType;

  const GlassTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.5)),
              prefixIcon: prefixIcon != null 
                  ? Icon(prefixIcon, color: Colors.white.withValues(alpha: 0.7)) 
                  : null,
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class GlassScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final LinearGradient? backgroundGradient;
  
  const GlassScaffold({
    super.key, 
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.drawer,
    this.backgroundGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Very important
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: appBar,
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: backgroundGradient ?? AppColors.glassBackgroundGradient,
        ),
        child: SafeArea(child: body),
      ),
    );
  }
}

class GlassNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationBarItem> items;

  const GlassNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            items: items,
            backgroundColor: Colors.transparent, // Requires container color
            elevation: 0,
            selectedItemColor: const Color(0xFF818CF8),
            unselectedItemColor: Colors.black.withValues(alpha: 0.4),
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}

