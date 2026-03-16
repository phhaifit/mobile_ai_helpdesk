import 'package:flutter/material.dart';
import 'package:ai_helpdesk/domain/entity/enums.dart';

class AppColors {
  AppColors._();

  // Primary Colors (from UI.md)
  static const Color primaryBlue = Color(0xFF0084FF);      // #0084FF
  static const Color primaryPurple = Color(0xFF5E5CE6);    // #5E5CE6
  static const Color darkBlue = Color(0xFF0D1B3E);         // #0D1B3E

  // Neutral Colors
  static const Color backgroundGrey = Color(0xFFF8F9FD);   // #F8F9FD
  static const Color textPrimary = Color(0xFF1C1E21);      // #1C1E21
  static const Color inputBackground = Color(0xFFF0F2F5);  // #F0F2F5
  static const Color bubbleGrey = Color(0xFFE9E9EB);       // #E9E9EB
  static const Color dividerColor = Color(0xFFE0E0E0);     // #E0E0E0
  static const Color textSecondary = Color(0xFF666666);    // #666666
  static const Color textTertiary = Color(0xFF999999);     // #999999

  // Status Colors
  static const Color successGreen = Color(0xFF31A24C);     // #31A24C
  static const Color warningOrange = Color(0xFFFF9500);    // #FF9500
  static const Color errorRed = Color(0xFFE4163A);         // #E4163A

  // Legacy blue palette (kept for backward compatibility)
  static const Map<int, Color> blue = <int, Color>{
    50: Color(0xFFE3F2FD),
    100: Color(0xFFBBDEFB),
    200: Color(0xFF90CAF9),
    300: Color(0xFF64B5F6),
    400: Color(0xFF42A5F5),
    500: Color(0xFF1A73E8),
    600: Color(0xFF1E88E5),
    700: Color(0xFF1976D2),
    800: Color(0xFF1565C0),
    900: Color(0xFF0D47A1),
  };

  /// Map ticket status to color
  static Color getStatusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return primaryBlue;
      case TicketStatus.inProgress:
        return warningOrange;
      case TicketStatus.resolved:
        return successGreen;
      case TicketStatus.closed:
        return textTertiary;
    }
  }

  /// Map ticket priority to color
  static Color getPriorityColor(TicketPriority priority) {
    switch (priority) {
      case TicketPriority.low:
        return successGreen;
      case TicketPriority.medium:
        return primaryBlue;
      case TicketPriority.high:
        return warningOrange;
      case TicketPriority.urgent:
        return errorRed;
    }
  }
}
