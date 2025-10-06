import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

enum TropicalButtonSize { small, medium, large }
enum TropicalButtonVariant { primary, secondary, destructive }

class TropicalButton extends StatefulWidget {
  final String? text;
  final VoidCallback? onPressed;
  final TropicalButtonSize size;
  final TropicalButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final Widget? child;
  final Color? backgroundColor;
  final Color? textColor;

  const TropicalButton({
    super.key,
    this.text,
    this.onPressed,
    this.size = TropicalButtonSize.medium,
    this.variant = TropicalButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.child,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<TropicalButton> createState() => _TropicalButtonState();
}

class _TropicalButtonState extends State<TropicalButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 4.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  EdgeInsets get _padding {
    switch (widget.size) {
      case TropicalButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case TropicalButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case TropicalButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  double get _fontSize {
    switch (widget.size) {
      case TropicalButtonSize.small:
        return 14;
      case TropicalButtonSize.medium:
        return 16;
      case TropicalButtonSize.large:
        return 18;
    }
  }

  List<Color> get _gradientColors {
    if (widget.backgroundColor != null) {
      return [widget.backgroundColor!, widget.backgroundColor!];
    }

    switch (widget.variant) {
      case TropicalButtonVariant.primary:
        return AppColors.tropicalGradient;
      case TropicalButtonVariant.secondary:
        return [Colors.white, Colors.white];
      case TropicalButtonVariant.destructive:
        return [AppColors.error, AppColors.error];
    }
  }

  Color get _textColor {
    if (widget.textColor != null) {
      return widget.textColor!;
    }

    switch (widget.variant) {
      case TropicalButtonVariant.primary:
        return Colors.white;
      case TropicalButtonVariant.secondary:
        return AppColors.primary;
      case TropicalButtonVariant.destructive:
        return Colors.white;
    }
  }

  Color get _shadowColor {
    switch (widget.variant) {
      case TropicalButtonVariant.primary:
        return AppColors.primary.withValues(alpha: 0.3);
      case TropicalButtonVariant.secondary:
        return AppColors.grey400.withValues(alpha: 0.3);
      case TropicalButtonVariant.destructive:
        return AppColors.error.withValues(alpha: 0.3);
    }
  }

  Border? get _border {
    if (widget.variant == TropicalButtonVariant.secondary) {
      return Border.all(
        color: widget.onPressed != null ? AppColors.primary : AppColors.grey300,
        width: 2,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: isEnabled ? (_) => _animationController.forward() : null,
        onTapUp: isEnabled
            ? (_) {
                _animationController.reverse();
                widget.onPressed?.call();
              }
            : null,
        onTapCancel: () => _animationController.reverse(),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return AnimatedScale(
              scale: _isHovered ? 1.05 : _scaleAnimation.value,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: Container(
                padding: _padding,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isEnabled
                        ? _gradientColors
                        : [AppColors.grey300, AppColors.grey400],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  border: _border,
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? _shadowColor.withValues(alpha: 0.6)
                          : _shadowColor.withValues(alpha: 0.3),
                      blurRadius: _isHovered ? 16.0 : 8.0,
                      spreadRadius: _isHovered ? 2.0 : 0.0,
                      offset: Offset(0, _elevationAnimation.value),
                    ),
                  ],
                ),
                child: widget.child ??
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.isLoading) ...[
                            SizedBox(
                              width: _fontSize,
                              height: _fontSize,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(_textColor),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ] else if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: _textColor,
                              size: _fontSize,
                            ),
                            if (widget.text?.isNotEmpty == true)
                              const SizedBox(width: 8),
                          ],
                          if (widget.text?.isNotEmpty == true)
                            Flexible(
                              child: Text(
                                widget.text!,
                                textAlign: TextAlign.center,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _textColor,
                                  fontSize: _fontSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
              ),
            );
          },
        ),
      ),
    );
  }
}
