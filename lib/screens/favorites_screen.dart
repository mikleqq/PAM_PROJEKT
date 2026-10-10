// lib/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/master_card.dart';
import 'master_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Select subset of favorite masters
    final favoriteMasters = [mockMasters[0], mockMasters[1], mockMasters[3], mockMasters[5]];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранные мастера'),
      ),
      body: favoriteMasters.isEmpty
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
                  master: master,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MasterDetailScreen(master: master),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
