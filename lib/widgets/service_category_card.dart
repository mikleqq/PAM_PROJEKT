// lib/widgets/service_category_card.dart
import 'package:flutter/material.dart';
import '../data/models.dart';

class ServiceCategoryCard extends StatelessWidget {
  final ServiceCategory category;
  final VoidCallback? onTap;

  const ServiceCategoryCard({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getCategoryIcon(category.iconName),
                  color: colorScheme.onPrimaryContainer,
                  size: 26,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                category.name,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                'от ${category.startingPrice.toStringAsFixed(0)} MDL',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'water_drop':
        return Icons.water_drop;
      case 'bolt':
        return Icons.bolt;
      case 'cleaning_services':
        return Icons.cleaning_services;
      case 'home_repair_service':
        return Icons.home_repair_service;
      case 'chair':
        return Icons.chair;
      case 'lock':
        return Icons.lock;
      case 'format_paint':
        return Icons.format_paint;
      case 'build':
        return Icons.build;
      default:
        return Icons.miscellaneous_services;
    }
  }
}
