// lib/screens/user_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/repositories/mock_master_repository.dart';
import '../data/repositories/mock_order_repository.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Future<void> _confirmLogout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        content: const Text('Вы действительно хотите выйти из профиля?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Да, выйти'),
          ),
        ],
      ),
    );

    if (ok == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Вы вышли из аккаунта'),
          duration: Duration(seconds: 2),
        ),
      );
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final masterRepo = context.watch<MockMasterRepository>();
    final orderRepo = context.watch<MockOrderRepository>();
    final isErrorSimulated = masterRepo.simulateError || orderRepo.simulateError;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мой профиль'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // User Header Card
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
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(
                        'АК',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Александр Коваленко',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'alex.kovalenko@example.com',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+373 69 987 654',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Редактировать профиль'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Fault Simulation Section (Task 7.2)
            Card(
              elevation: 0,
              color: isErrorSimulated
                  ? colorScheme.errorContainer.withValues(alpha: 0.3)
                  : colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isErrorSimulated
                      ? colorScheme.error
                      : colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: SwitchListTile(
                secondary: Icon(
                  Icons.bug_report_outlined,
                  color: isErrorSimulated ? colorScheme.error : colorScheme.primary,
                ),
                title: const Text(
                  'Симулировать сбой сети',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Принудительно вызывает ошибки сервера для проверки экрана ErrorView'),
                value: isErrorSimulated,
                onChanged: (val) {
                  setState(() {
                    masterRepo.simulateError = val;
                    orderRepo.simulateError = val;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        val ? 'Авария сети включена!' : 'Авария сети отключена',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Profile Sections List
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.location_on_outlined, color: colorScheme.primary),
                    title: const Text('Мои адреса'),
                    subtitle: const Text('г. Кишинев, ул. Штефан чел Маре 132'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.notifications_none_outlined, color: colorScheme.primary),
                    title: const Text('Уведомления'),
                    subtitle: const Text('Пуш-уведомления и SMS'),
                    trailing: Switch(
                      value: true,
                      onChanged: (val) {},
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.support_agent_outlined, color: colorScheme.primary),
                    title: const Text('Служба поддержки'),
                    subtitle: const Text('Чат с оператором 24/7'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Navigation button to Auth Screen
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.go('/login');
                },
                icon: const Icon(Icons.lock_outline),
                label: const Text('Перейти на экран входа'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton.icon(
                onPressed: () => _confirmLogout(context),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Выйти из аккаунта',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
