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

  /// Последний поисковый запрос модели, уже показанный в поле ввода.
  String? _syncedSearch;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSortOptions(BuildContext context) {
    final model = context.read<MastersModel>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            Widget sortTile(MasterSort value, IconData icon, String title) {
              final selected = model.sort == value;
              return ListTile(
                leading: Icon(icon, color: selected ? Theme.of(ctx).colorScheme.primary : null),
                title: Text(title),
                trailing: selected ? const Icon(Icons.check) : null,
                onTap: () {
                  model.setSort(value);
                  Navigator.pop(ctx);
                },
              );
            }

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
                  sortTile(MasterSort.rating, Icons.star, 'По рейтингу (сначала высокий)'),
                  const Divider(height: 1),
                  sortTile(MasterSort.priceAsc, Icons.payments_outlined, 'По стоимости (сначала дешевле)'),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.verified_user_outlined),
                    title: const Text('Только проверенные мастера'),
                    value: model.verifiedOnly,
                    onChanged: (val) {
                      model.setVerifiedOnly(val);
                      setSheetState(() {});
                    },
                  ),
                ],
              ),
            );
          },
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
      // Поиск мог прийти из каталога — показать его в поле, не трогая ввод пользователя.
      if (_syncedSearch != model.search) {
        _syncedSearch = model.search;
        _searchController.value = TextEditingValue(
          text: model.search,
          selection: TextSelection.collapsed(offset: model.search.length),
        );
      }

      bodyContent = Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (query) {
                context.read<MastersModel>().load(search: query.trim());
              },
              decoration: InputDecoration(
                hintText: 'Поиск по имени, услуге или навыку...',
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    context.read<MastersModel>().load(search: _searchController.text.trim());
                  },
                ),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _searchController,
                  builder: (context, value, _) => value.text.isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            context.read<MastersModel>().load(search: '');
                          },
                        ),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Horizontal Filter Chips (категории с сервера)
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: model.categories.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = index == 0 ? null : model.categories[index - 1];
                final id = category?.id ?? '';
                final isSelected = model.categoryId == id;
                return FilterChip(
                  label: Text(category?.name ?? 'Все мастера'),
                  selected: isSelected,
                  onSelected: (_) {
                    context.read<MastersModel>().load(categoryId: id);
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
                Expanded(
                  child: Text(
                    'Найдено мастеров: ${masters.length}'
                    '${model.verifiedOnly ? ' (проверенные)' : ''}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showSortOptions(context),
                  icon: const Icon(Icons.swap_vert, size: 18),
                  label: Text(model.sort == MasterSort.rating ? 'По рейтингу' : 'По цене'),
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
