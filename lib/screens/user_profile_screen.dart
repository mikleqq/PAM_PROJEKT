// lib/screens/user_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/auth_api.dart';
import '../data/repositories/http_master_repository.dart';
import '../data/repositories/http_order_repository.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String _name = '';
  String _email = '';
  final List<String> _addresses = ['г. Кишинев, ул. Штефан чел Маре 132'];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final auth = context.read<AuthApi>();
    final name = await auth.tokens.readName() ?? '';
    final email = await auth.tokens.readEmail() ?? '';
    if (!mounted) return;
    setState(() {
      _name = name;
      _email = email;
    });
  }

  String get _initials {
    final trimmed = _name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }

  void _showSettingsSheet(BuildContext context) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Настройки приложения',
                    style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const ListTile(
                leading: Icon(Icons.language_outlined),
                title: Text('Язык приложения'),
                subtitle: Text('Русский (Moldova)'),
              ),
              const Divider(height: 1),
              const ListTile(
                leading: Icon(Icons.dark_mode_outlined),
                title: Text('Тема оформления'),
                subtitle: Text('Светлая Material 3'),
              ),
              const Divider(height: 1),
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Версия приложения'),
                subtitle: Text('ПрофиСервис v1.0.0 (L5 Build 2026)'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final nameCtrl = TextEditingController(text: _name);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Редактировать профиль'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Имя и фамилия',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (val) =>
                (val == null || val.trim().isEmpty) ? 'Введите ваше имя' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final newName = nameCtrl.text.trim();
              final auth = context.read<AuthApi>();
              await auth.tokens.saveUser(newName, _email);
              if (!mounted) return;
              setState(() {
                _name = newName;
              });
              if (dialogCtx.mounted) {
                Navigator.pop(dialogCtx);
              }
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Профиль успешно обновлён!')),
                );
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _showAddressesSheet(BuildContext context) {
    final addressCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Мои адреса',
                        style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_addresses.isEmpty)
                    const Text('У вас пока нет сохранённых адресов')
                  else
                    ..._addresses.map(
                      (addr) => ListTile(
                        leading: const Icon(Icons.location_on, color: Colors.blue),
                        title: Text(addr),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            setModalState(() {
                              _addresses.remove(addr);
                            });
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  const Divider(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: addressCtrl,
                          decoration: const InputDecoration(
                            hintText: 'Новый адрес (ул., дом...)',
                            prefixIcon: Icon(Icons.add_location_alt_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: () {
                          if (addressCtrl.text.trim().isNotEmpty) {
                            setModalState(() {
                              _addresses.add(addressCtrl.text.trim());
                            });
                            setState(() {});
                            addressCtrl.clear();
                          }
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSupportChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.support_agent, color: Colors.blue),
            SizedBox(width: 8),
            Text('Служба поддержки 24/7'),
          ],
        ),
        content: const Text(
          'Оператор поддержки онлайн. Задайте любой вопрос по поводу поиска мастеров, заказов или качества услуг.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Закрыть'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Соединение с оператором установлено (Чат открыт)'),
                ),
              );
            },
            icon: const Icon(Icons.chat),
            label: const Text('Начать чат'),
          ),
        ],
      ),
    );
  }

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
      await context.read<AuthApi>().logout();
      if (!context.mounted) return;

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
    final masterRepo = context.watch<HttpMasterRepository>();
    final orderRepo = context.watch<HttpOrderRepository>();
    final isErrorSimulated = masterRepo.simulateError || orderRepo.simulateError;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мой профиль'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _showSettingsSheet(context),
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
                        _initials,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _name.isNotEmpty ? _name : 'Пользователь',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _email,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => _showEditProfileDialog(context),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Редактировать профиль'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Fault Simulation Section
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
                subtitle: const Text('Переключает режим сбоя (ErrorView с кнопкой "Повторить")'),
                value: isErrorSimulated,
                onChanged: (val) {
                  setState(() {
                    masterRepo.simulateError = val;
                    orderRepo.simulateError = val;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        val ? 'Авария сети включена!' : 'Подключение к сети восстановлено',
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
                    subtitle: Text(
                      _addresses.isNotEmpty ? _addresses.first : 'Адрес не указан',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showAddressesSheet(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.notifications_none_outlined, color: colorScheme.primary),
                    title: const Text('Уведомления'),
                    subtitle: const Text('Пуш-уведомления и SMS'),
                    trailing: Switch(
                      value: true,
                      onChanged: (val) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              val ? 'Уведомления включены' : 'Уведомления отключены',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.support_agent_outlined, color: colorScheme.primary),
                    title: const Text('Служба поддержки'),
                    subtitle: const Text('Чат с оператором 24/7'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showSupportChatDialog(context),
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
