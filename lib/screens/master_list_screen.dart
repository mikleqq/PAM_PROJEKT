// lib/screens/master_list_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/masters_model.dart';
import '../widgets/master_card.dart';
import '../widgets/error_view.dart';

class MasterListScreen extends StatefulWidget {
  const MasterListScreen({super.key});

  @override
  State<MasterListScreen> createState() => _MasterListScreenState();
}

class _MasterListScreenState extends State<MasterListScreen> {
  final _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;

  final categoriesFilter = [
    'Все мастера',
    'Сантехника',
    'Электрика',
    'Клининг',
    'Бытовая техника',
    'Сборка мебели',
    'Мастер на час',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Сортировка специалистов',
                style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.star, color: Colors.amber),
                title: const Text('По рейтингу (сначала высокий)'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<MastersModel>().load(search: _searchController.text.trim());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Отсортировано по рейтингу'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.payments_outlined),
                title: const Text('По стоимости за час'),
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<MastersModel>().load(search: _searchController.text.trim());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Отсортировано по стоимости'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final model = context.watch<MastersModel>();

    Widget bodyContent;

    if (model.isLoading) {
      bodyContent = const Center(child: CircularProgressIndicator());
    } else if (model.error != null) {
      bodyContent = ErrorView(
        message: model.error!,
        onRetry: () => context.read<MastersModel>().load(),
      );
    } else {
      final masters = model.masters;

      bodyContent = Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (query) {
                context.read<MastersModel>().load(search: query);
              },
              decoration: InputDecoration(
                hintText: 'Поиск по имени, услуге или навыку...',
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    context.read<MastersModel>().load(search: _searchController.text.trim());
                  },
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<MastersModel>().load(search: '');
                        },
                      )
                    : null,
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
                final isSelected = index == _selectedCategoryIndex;
                final filterText = categoriesFilter[index];
                return FilterChip(
                  label: Text(filterText),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                    final searchParam = index == 0 ? '' : filterText;
                    context.read<MastersModel>().load(search: searchParam);
                  },
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
                  'Найдено мастеров: ${masters.length}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showSortOptions(context),
                  icon: const Icon(Icons.swap_vert, size: 18),
                  label: const Text('По рейтингу'),
                ),
              ],
            ),
          ),

          // ListView of Masters
          Expanded(
            child: masters.isEmpty
                ? const Center(child: Text('Мастера по вашему запросу не найдены'))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: masters.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final master = masters[index];
                      return MasterCard(
                        key: ValueKey(master.id),
                        master: master,
                        onTap: () {
                          context.push('/masters/${master.id}');
                        },
                      );
                    },
                  ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск мастеров'),
      ),
      body: bodyContent,
    );
  }
}
