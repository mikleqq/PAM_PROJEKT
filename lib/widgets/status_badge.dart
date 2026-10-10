// lib/widgets/status_badge.dart
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case 'Завершён':
        backgroundColor = colorScheme.primaryContainer;
        textColor = colorScheme.onPrimaryContainer;
        icon = Icons.check_circle_outline;
        break;
      case 'В процессе':
        backgroundColor = colorScheme.tertiaryContainer;
        textColor = colorScheme.onTertiaryContainer;
        icon = Icons.sync;
        break;
      case 'Ожидает':
        backgroundColor = colorScheme.secondaryContainer;
        textColor = colorScheme.onSecondaryContainer;
        icon = Icons.access_time;
        break;
      case 'Отменён':
        backgroundColor = colorScheme.errorContainer;
        textColor = colorScheme.onErrorContainer;
        icon = Icons.cancel_outlined;
        break;
      default:
        backgroundColor = colorScheme.surfaceContainerHighest;
        textColor = colorScheme.onSurfaceVariant;
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            status,
            style: theme.textTheme.labelMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
