// lib/screens/master_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:home_services/data/models.dart';
import 'package:home_services/models/masters_model.dart';
import 'package:home_services/widgets/info_row.dart';

class MasterDetailScreen extends StatelessWidget {
  final String masterId;

  const MasterDetailScreen({super.key, required this.masterId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final model = context.watch<MastersModel>();
    final master = model.byId(masterId);

    if (master == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Профиль мастера')),
        body: Center(
          child: model.isLoading
              ? const CircularProgressIndicator()
              : const Text('Мастер не найден'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль мастера'),
        actions: [
          IconButton(
            icon: Icon(
              master.isFavorite ? Icons.bookmark : Icons.bookmark_border,
              color: master.isFavorite ? colorScheme.primary : null,
            ),
            onPressed: () async {
              final err = await context.read<MastersModel>().toggleFavorite(master.id);
              if (err != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(err)),
                );
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      master.isFavorite
                          ? 'Удалено из избранного'
                          : 'Добавлено в избранное',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Master Header Card
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundColor: colorScheme.primaryContainer,
                          child: Text(
                            _getInitials(master.name),
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (master.isAvailable)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorScheme.surface,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          master.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (master.isVerified) ...[
                          const SizedBox(width: 6),
                          Icon(
                            Icons.verified,
                            color: colorScheme.primary,
                            size: 22,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      master.specialty,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Quick Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(
                          context,
                          icon: Icons.star_rounded,
                          iconColor: Colors.amber.shade700,
                          value: master.rating.toStringAsFixed(1),
                          label: '${master.reviewsCount} отзывов',
                        ),
                        Container(
                          height: 36,
                          width: 1,
                          color: colorScheme.outlineVariant,
                        ),
                        _buildStatItem(
                          context,
                          icon: Icons.work_history_outlined,
                          iconColor: colorScheme.primary,
                          value: '${master.experienceYears} лет',
                          label: 'Опыт работы',
                        ),
                        Container(
                          height: 36,
                          width: 1,
                          color: colorScheme.outlineVariant,
                        ),
                        _buildStatItem(
                          context,
                          icon: Icons.payments_outlined,
                          iconColor: colorScheme.tertiary,
                          value: '${master.hourlyRate.toStringAsFixed(0)} MDL',
                          label: 'За час',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Bio / Description
            Text(
              'О мастере',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              master.bio,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Skills Chips
            Text(
              'Навыки и специализация',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: master.skills.map((skill) {
                return Chip(
                  label: Text(skill),
                  backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  side: BorderSide.none,
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Details Group Box
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    InfoRow(
                      icon: Icons.phone_outlined,
                      label: 'Телефон',
                      value: master.phone,
                    ),
                    const Divider(height: 12),
                    InfoRow(
                      icon: Icons.schedule_outlined,
                      label: 'Статус',
                      value: master.isAvailable ? 'Свободен для заказов' : 'Занят на выезде',
                      valueColor: master.isAvailable ? Colors.green.shade700 : Colors.orange.shade700,
                    ),
                    const Divider(height: 12),
                    InfoRow(
                      icon: Icons.verified_user_outlined,
                      label: 'Проверка',
                      value: master.isVerified ? 'Паспорт и диплом подтверждены' : 'На проверке',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Reviews Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Отзывы клиентов (${mockReviews.length})',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Все отзывы'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Reviews Preview List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mockReviews.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final review = mockReviews[index];
                return Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              review.userName,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  size: 16,
                                  color: Colors.amber.shade700,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  review.rating.toStringAsFixed(1),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          review.comment,
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          review.date,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 28),

            // Bottom CTA Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: () {
                  context.push('/create-order?masterId=${master.id}');
                },
                icon: const Icon(Icons.add_task),
                label: const Text(
                  'Заказать услугу у мастера',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0];
    }
    return '?';
  }
}
