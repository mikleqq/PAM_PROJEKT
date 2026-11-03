// lib/screens/services_catalog_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/masters_model.dart';
import '../widgets/service_category_card.dart';
import '../widgets/master_card.dart';
import '../widgets/error_view.dart';

class ServicesCatalogScreen extends StatelessWidget {
  const ServicesCatalogScreen({super.key});

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
      final categories = model.categories;
      final topMasters = model.masters.take(3).toList();

      bodyContent = SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Поиск услуги или мастера...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () {},
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Categories Section Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Категории услуг',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.go('/masters');
                  },
                  child: Text('Все (${categories.length})'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Category Grid (2 columns)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                return ServiceCategoryCard(
                  category: categories[index],
                  onTap: () {
                    context.go('/masters');
                  },
                );
              },
            ),
            const SizedBox(height: 28),

            // Top Rated Masters Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Рекомендуемые мастера',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.go('/masters');
                  },
                  child: const Text('Показать всех'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ListView of top masters
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: topMasters.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final master = topMasters[index];
                return MasterCard(
                  master: master,
                  onTap: () {
                    context.push('/masters/${master.id}');
                  },
                );
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог услуг'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: bodyContent,
    );
  }
}
