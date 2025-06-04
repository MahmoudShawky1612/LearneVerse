import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutterwidgets/core/providers/theme_provider.dart';

class ThemeToggleButton extends StatefulWidget {
  final double? size;
  final bool showLabel;
  final bool isCompact;

  const ThemeToggleButton({
    super.key,
    this.size,
    this.showLabel = false,
    this.isCompact = false,
  });

  @override
  State<ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<ThemeToggleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    
    if (isDarkMode) {
      _animationController.value = 1.0;
    } else {
      _animationController.value = 0.0;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (isDarkMode) {
            _animationController.reverse();
          } else {
            _animationController.forward();
          }
          themeProvider.toggleTheme();
        },
        borderRadius: BorderRadius.circular(widget.isCompact ? 12 : 20),
        child: Container(
          padding: EdgeInsets.all(widget.isCompact ? 8.0 : 12.0),
          decoration: BoxDecoration(
            color: widget.isCompact
                ? colorScheme.surface.withOpacity(0.8)
                : colorScheme.surface.withOpacity(0.2),
            borderRadius: BorderRadius.circular(widget.isCompact ? 12 : 20),
            boxShadow: widget.isCompact
                ? null
                : [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      
                      Opacity(
                        opacity: 1.0 - _animationController.value,
                        child: Icon(
                          Icons.wb_sunny_rounded,
                          size: widget.size ?? 24,
                          color: colorScheme.primary,
                        ),
                      ),
                      
                      Opacity(
                        opacity: _animationController.value,
                        child: Icon(
                          Icons.nightlight_round,
                          size: widget.size ?? 24,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  );
                },
              ),
              if (widget.showLabel) ...[
                const SizedBox(width: 8),
                Text(
                  isDarkMode ? 'Light Mode' : 'Dark Mode',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
