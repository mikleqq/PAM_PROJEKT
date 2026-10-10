// lib/screens/create_order_screen.dart
import 'package:flutter/material.dart';
import '../data/mock_data.dart';

class CreateOrderScreen extends StatefulWidget {
  final Master? selectedMaster;

  const CreateOrderScreen({super.key, this.selectedMaster});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  String _selectedPaymentMethod = 'cash';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Оформление заказа'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected Master Header
            if (widget.selectedMaster != null) ...[
              Card(
                color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: colorScheme.primary,
                        child: Text(
                          widget.selectedMaster!.name[0],
                          style: TextStyle(color: colorScheme.onPrimary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Выбранный мастер: ${widget.selectedMaster!.name}',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${widget.selectedMaster!.specialty} • ${widget.selectedMaster!.hourlyRate.toStringAsFixed(0)} MDL/ч',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            Text(
              'Детали заказа',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Service Type Dropdown Form Layout
            DropdownButtonFormField<String>(
              initialValue: mockCategories.first.name,
              decoration: InputDecoration(
                labelText: 'Категория услуги',
                prefixIcon: const Icon(Icons.category_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: mockCategories.map((cat) {
                return DropdownMenuItem<String>(
                  value: cat.name,
                  child: Text(cat.name),
                );
              }).toList(),
              onChanged: (val) {},
            ),
            const SizedBox(height: 16),

            // Service Problem Description TextField
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Описание проблемы или задачи',
                hintText: 'Опишите детально, что необходимо сделать...',
                prefixIcon: const Icon(Icons.description_outlined),
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Address TextField
            TextField(
              decoration: InputDecoration(
                labelText: 'Адрес выполнения работ',
                hintText: 'г. Кишинев, ул. ...',
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Date & Time Picker Layout
            Text(
              'Дата и время визита',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: const Text('15 Октября 2026'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.access_time_outlined),
                    label: const Text('14:00 - 16:00'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Payment Method Selector
            Text(
              'Способ оплаты',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Radio<String>(
                      value: 'cash',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedPaymentMethod = val;
                          });
                        }
                      },
                    ),
                    title: const Text('Наличными мастеру'),
                    subtitle: const Text('Оплата на месте по факту выполнения'),
                    onTap: () {
                      setState(() {
                        _selectedPaymentMethod = 'cash';
                      });
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Radio<String>(
                      value: 'card',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedPaymentMethod = val;
                          });
                        }
                      },
                    ),
                    title: const Text('Картой через терминал мастера'),
                    subtitle: const Text('Оплата на месте по факту выполнения'),
                    onTap: () {
                      setState(() {
                        _selectedPaymentMethod = 'card';
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Cost Summary Card
            Card(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Ориентировочная стоимость:', style: theme.textTheme.bodyMedium),
                        Text(
                          '${widget.selectedMaster?.hourlyRate.toStringAsFixed(0) ?? "350"} MDL',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '* Окончательная стоимость согласовывается с мастером на месте.',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Заказ успешно создан! (Статический макет)'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Подтвердить заказ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
