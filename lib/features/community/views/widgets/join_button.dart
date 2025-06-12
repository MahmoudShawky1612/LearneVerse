import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ModernButtonStyle {
  primary,
  secondary,
  outline,
  success,
  warning,
  danger,
}

enum ModernButtonSize {
  small,
  medium,
  large,
}

class ModernButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ModernButtonStyle style;
  final ModernButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final Color? customColor;
  final String? disabledText;

  const ModernButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = ModernButtonStyle.primary,
    this.size = ModernButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.customColor,
    this.disabledText,
  });

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
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

  ButtonStyle _getButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color foregroundColor;
    Color? borderColor;

    switch (widget.style) {
      case ModernButtonStyle.primary:
        backgroundColor = widget.customColor ?? colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        break;
      case ModernButtonStyle.secondary:
        backgroundColor = colorScheme.secondary;
        foregroundColor = colorScheme.onSecondary;
        break;
      case ModernButtonStyle.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = widget.customColor ?? colorScheme.primary;
        borderColor = widget.customColor ?? colorScheme.primary;
        break;
      case ModernButtonStyle.success:
        backgroundColor = Colors.green.shade600;
        foregroundColor = Colors.white;
        break;
      case ModernButtonStyle.warning:
        backgroundColor = Colors.orange.shade600;
        foregroundColor = Colors.white;
        break;
      case ModernButtonStyle.danger:
        backgroundColor = Colors.red.shade600;
        foregroundColor = Colors.white;
        break;
    }

    if (widget.isDisabled || widget.isLoading) {
      backgroundColor = colorScheme.surfaceContainerHighest;
      foregroundColor = colorScheme.onSurfaceVariant;
      borderColor = null;
    }

    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      side: borderColor != null
          ? BorderSide(color: borderColor, width: 1.5)
          : null,
      elevation: widget.style == ModernButtonStyle.outline ? 0 : 2,
      shadowColor: backgroundColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: _getPadding(),
      minimumSize: Size(widget.width ?? 0, _getHeight()),
    );
  }

  EdgeInsetsGeometry _getPadding() {
    switch (widget.size) {
      case ModernButtonSize.small:
        return EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h);
      case ModernButtonSize.medium:
        return EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h);
      case ModernButtonSize.large:
        return EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h);
    }
  }

  double _getHeight() {
    switch (widget.size) {
      case ModernButtonSize.small:
        return 25.h;
      case ModernButtonSize.medium:
        return 30.h;
      case ModernButtonSize.large:
        return 35.h;
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case ModernButtonSize.small:
        return 12.sp;
      case ModernButtonSize.medium:
        return 14.sp;
      case ModernButtonSize.large:
        return 16.sp;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case ModernButtonSize.small:
        return 16.sp;
      case ModernButtonSize.medium:
        return 18.sp;
      case ModernButtonSize.large:
        return 20.sp;
    }
  }

  Widget _buildButtonContent() {
    if (widget.isLoading) {
      return const Center(child: CupertinoActivityIndicator());
    }

    final displayText = widget.isDisabled && widget.disabledText != null
        ? widget.disabledText!
        : widget.text;

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.icon,
            size: _getIconSize(),
          ),
          SizedBox(width: 8.w),
          Text(
            displayText,
            style: TextStyle(
              fontSize: _getFontSize(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      displayText,
      style: TextStyle(
        fontSize: _getFontSize(),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SizedBox(
            width: widget.width,
            child: ElevatedButton(
              onPressed: (widget.isDisabled || widget.isLoading)
                  ? null
                  : () {
                      _animationController.forward().then((_) {
                        _animationController.reverse();
                      });
                      widget.onPressed?.call();
                    },
              style: _getButtonStyle(context),
              child: _buildButtonContent(),
            ),
          ),
        );
      },
    );
  }
}
