import 'package:flutter/material.dart';
import 'package:rescue_mobile_core/rescue_mobile_core.dart';
import 'package:rescue_mobile_map/rescue_mobile_map.dart';
import 'package:rescue_mobile_ui/rescue_mobile_ui.dart';

void main() {
  runApp(const RescueUserApp());
}

class RescueUserApp extends StatelessWidget {
  const RescueUserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rescue',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const UserHomePage(),
    );
  }
}

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const config = AppConfig.user;
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Emergency SOS', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('Press and hold to trigger SOS (UI scaffold)'),
          const SizedBox(height: 16),
          RescuePrimaryButton(
            label: 'Emergency SOS',
            onPressed: () {},
          ),
          const SizedBox(height: 24),
          const RescueMapPlaceholder(config: config),
        ],
      ),
    );
  }
}
