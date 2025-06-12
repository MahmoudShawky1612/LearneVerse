import 'package:flutter/material.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color upVote;
  final Color downVote;
  final Gradient buttonGradient;
  final Gradient backgroundGradient;
  final Gradient containerGradient;
  final Gradient circleGradient;

  const AppThemeExtension({
    required this.upVote,
    required this.downVote,
    required this.buttonGradient,
    required this.backgroundGradient,
    required this.containerGradient,
    required this.circleGradient,
  });

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? upVote,
    Color? downVote,
    Gradient? buttonGradient,
    Gradient? backgroundGradient,
    Gradient? containerGradient,
    Gradient? circleGradient,
  }) {
    return AppThemeExtension(
      upVote: upVote ?? this.upVote,
      downVote: downVote ?? this.downVote,
      buttonGradient: buttonGradient ?? this.buttonGradient,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      containerGradient: containerGradient ?? this.containerGradient,
      circleGradient: circleGradient ?? this.circleGradient,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
      covariant ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      upVote: Color.lerp(upVote, other.upVote, t)!,
      downVote: Color.lerp(downVote, other.downVote, t)!,
      buttonGradient: Gradient.lerp(buttonGradient, other.buttonGradient, t)!,
      backgroundGradient:
          Gradient.lerp(backgroundGradient, other.backgroundGradient, t)!,
      containerGradient:
          Gradient.lerp(containerGradient, other.containerGradient, t)!,
      circleGradient: Gradient.lerp(circleGradient, other.circleGradient, t)!,
    );
  }

  static const light = AppThemeExtension(
    upVote: Color(0xFF4CAF50),
    downVote: Color(0xFFB71C1C),
    buttonGradient: LinearGradient(
      colors: [
        Color(0xFF2196F3),
        Color(0xFF1976D2),
        Color(0xFF0D47A1),
      ],
    ),
    backgroundGradient: LinearGradient(
      colors: [
        Color(0xFF1565C0),
        Color(0xFFD81B60),
      ],
      begin: Alignment.topLeft,
      end: Alignment.topRight,
    ),
    containerGradient: LinearGradient(
      colors: [
        Color(0xFFF5F7FA),
        Color(0xFFE8ECEF),
        Color(0xFFDCE2E6),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    circleGradient: LinearGradient(
      colors: [
        Color(0xFF42A5F5),
        Color(0xFFAB47BC),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const dark = AppThemeExtension(
    upVote: Color(0xFF81C784),
    downVote: Color(0xFFEF5350),
    buttonGradient: LinearGradient(
      colors: [
        Color(0xFF0D47A1),
        Color(0xFF0A2E5C),
        Color(0xFF071E3D),
      ],
    ),
    backgroundGradient: LinearGradient(
      colors: [
        Color(0xFF0A2E5C),
        Color(0xFF801A45),
      ],
      begin: Alignment.topLeft,
      end: Alignment.topRight,
    ),
    containerGradient: LinearGradient(
      colors: [
        Color(0xFF121212),
        Color(0xFF1A1A1A),
        Color(0xFF222222),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    circleGradient: LinearGradient(
      colors: [
        Color(0xFF0D47A1),
        Color(0xFF6A1B9A),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}

class AppColors {
  static const Color primary = Color(0xFF1565C0);
  static const Color primaryDark = Color(0xFF0D47A1);

  static const Color secondary = Color(0xFFD81B60);
  static const Color secondaryDark = Color(0xFFAD1457);

  static const Color accent = Color(0xFF8E24AA);
  static const Color accentDark = Color(0xFF6A1B9A);

  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121212);

  static const Color surfaceLight = Color(0xFFF5F5F5);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  static Color lightGrey = Colors.grey.shade100;
  static Color darkGrey = Colors.grey.shade800;
  static Color downVote = Colors.red.shade700;
  static Color upVote = Colors.green.shade700;

  static const Color textPrimary = Color(0xFF212121);
  static const Color textPrimaryDark = Color(0xFFE0E0E0);

  static const Color textSecondary = Color(0xFF757575);
  static const Color textSecondaryDark = Color(0xFFBDBDBD);

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static AppThemeExtension themeOf(BuildContext context) {
    return Theme.of(context).extension<AppThemeExtension>()!;
  }
}
