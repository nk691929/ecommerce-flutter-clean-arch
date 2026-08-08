import 'package:ecommerce_app/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: SwitchListTile(
          title: Text('Dark Mode'),
          value: themeMode == ThemeMode.dark,
          onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
        ),
      ),
    );
  }
}
