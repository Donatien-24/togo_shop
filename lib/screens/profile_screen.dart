import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/l10n/locale_provider.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/formatters.dart';
import '../l10n/app_localizations.dart';
import '../models/user_profile.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final themeMode = ref.watch(themeModeProvider);
    final strings = AppLocalizations.of(context);
    final languageCode =
        ref.watch(localeProvider) ??
        Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(strings.profile)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 56,
                  backgroundImage: NetworkImage(profile.avatarUrl),
                  onBackgroundImageError: (_, _) {},
                ),
                IconButton.filledTonal(
                  tooltip: 'Modifier le nom',
                  onPressed: () => _editName(context, ref, profile.name),
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Email'),
                  subtitle: Text(profile.email),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.phone_outlined),
                  title: const Text('Téléphone'),
                  subtitle: Text(profile.phone),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: const Text('Adresse'),
                  subtitle: Text(profile.address),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            strings.language,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(
                value: 'fr',
                label: Text(strings.french),
                icon: const Icon(Icons.translate),
              ),
              ButtonSegment(
                value: 'en',
                label: Text(strings.english),
                icon: const Icon(Icons.translate),
              ),
            ],
            selected: {languageCode == 'fr' ? 'fr' : 'en'},
            onSelectionChanged: (value) {
              ref.read(localeProvider.notifier).setLocale(value.first);
            },
          ),
          const SizedBox(height: 24),
          Text(
            strings.appearance,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(
                value: ThemeMode.system,
                label: Text(strings.system),
                icon: Icon(Icons.brightness_auto),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                label: Text(strings.light),
                icon: Icon(Icons.light_mode),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text(strings.dark),
                icon: Icon(Icons.dark_mode),
              ),
            ],
            selected: {themeMode},
            onSelectionChanged: (value) {
              ref.read(themeModeProvider.notifier).setMode(value.first);
            },
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.orders,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final order in profile.orders) _OrderTile(order: order),
        ],
      ),
    );
  }

  Future<void> _editName(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) async {
    final controller = TextEditingController(text: current);
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nom affiché'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Nom'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (result != null) {
      await ref.read(profileProvider.notifier).updateDisplayName(result);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Préférence enregistrée')));
    }
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order});
  final OrderHistoryItem order;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.receipt_long_outlined),
        title: Text(order.id),
        subtitle: Text(
          '${order.dateLabel} · ${order.itemCount} article(s) · ${order.status}',
        ),
        trailing: Text(formatPrice(order.total)),
      ),
    );
  }
}
