import 'package:flutter/material.dart';

/// Chip styling for prompt library + editor.
///
/// **Light theme:** Selected chips use [ColorScheme.primary] (`#1A73E8`) with
/// [ColorScheme.onPrimary] label text so they stand out on near-white surfaces.
/// Unselected use [ColorScheme.secondary] (light gray) for clear idle state.
///
/// **Dark theme:** [Chip] background uses theme defaults; label weight bumps when selected.
class PromptSelectionChips {
  PromptSelectionChips._();

  static bool _isLight(ColorScheme scheme) =>
      scheme.brightness == Brightness.light;

  /// [ChoiceChip] / [FilterChip] `color` (Material 3 state layer).
  static WidgetStateProperty<Color?> background(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return WidgetStateProperty.resolveWith((states) {
      final selected = states.contains(WidgetState.selected);
      if (_isLight(scheme)) {
        if (selected) {
          return scheme.primary;
        }
        return scheme.secondary;
      }
      return null;
    });
  }

  /// Apply to the chip `label` [Text] so contrast matches [background].
  static TextStyle? labelTextStyle(
    BuildContext context, {
    required bool selected,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final base = Theme.of(context).textTheme.labelLarge;
    if (_isLight(scheme)) {
      if (selected) {
        return base?.copyWith(
          color: scheme.onPrimary,
          fontWeight: FontWeight.w600,
        );
      }
      return base?.copyWith(color: scheme.onSurface);
    }
    if (selected) {
      return base?.copyWith(fontWeight: FontWeight.w600);
    }
    return base;
  }

  static Color avatarIconColor(
    BuildContext context, {
    required bool selected,
  }) {
    final scheme = Theme.of(context).colorScheme;
    if (_isLight(scheme) && selected) {
      return scheme.onPrimary;
    }
    if (selected) {
      return scheme.primary;
    }
    return scheme.onSurfaceVariant;
  }
}
