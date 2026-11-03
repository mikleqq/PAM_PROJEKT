// lib/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/masters_model.dart';
import '../widgets/master_card.dart';
import '../widgets/error_view.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      final favoriteMasters = model.favorites;

      bodyContent = favoriteMasters.isEmpty
          ? const Center(
              child: Text('У вас пока нет избранных мастеров'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteMasters.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final master = favoriteMasters[index];
                return MasterCard(
                  key: ValueKey(master.id),
                  master: master,
                  onTap: () {
                    context.push('/masters/${master.id}');
                  },
                );
              },
            );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Избранные мастера (${model.favoritesCount})'),
      ),
      body: bodyContent,
    );
  }
}
