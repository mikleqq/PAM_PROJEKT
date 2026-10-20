// lib/screens/master_list_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';
import '../widgets/master_card.dart';

class MasterListScreen extends StatelessWidget {
  const MasterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final categoriesFilter = [
      'Все мастера',
      'Сантехника',
      'Электрика',
      'Клининг',
      'Бытовая техника',
      'Сборка мебели',
      'Мастер на час',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск мастеров'),
      ),
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск по имени, услуге или навыку...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Horizontal Filter Chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categoriesFilter.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = index == 0;
                return FilterChip(
                  label: Text(categoriesFilter[index]),
                  selected: isSelected,
                  onSelected: (selected) {},
                  selectedColor: colorScheme.primaryContainer,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Results count header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Найдено мастеров: ${mockMasters.length}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.swap_vert, size: 18),
                  label: const Text('По рейтингу'),
                ),
              ],
            ),
          ),

          // ListView of Masters
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: mockMasters.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final master = mockMasters[index];
                return MasterCard(
                  master: master,
                  onTap: () {
                    context.push('/masters/${master.id}');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
