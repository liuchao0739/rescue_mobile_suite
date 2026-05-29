import 'package:flutter/material.dart';
import 'package:rescue_mobile_core/rescue_mobile_core.dart';
import 'package:rescue_mobile_map/rescue_mobile_map.dart';
import 'package:rescue_mobile_ui/rescue_mobile_ui.dart';

void main() {
  runApp(const RescueWorkerApp());
}

class RescueWorkerApp extends StatelessWidget {
  const RescueWorkerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rescue Worker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WorkerHomePage(),
    );
  }
}

class WorkerHomePage extends StatelessWidget {
  const WorkerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const config = AppConfig.worker;
    return Scaffold(
      appBar: AppBar(title: const Text('Available Orders')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Rescue Worker', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('Accept orders and update dispatch status'),
          const SizedBox(height: 16),
          RescuePrimaryButton(
            label: 'Go Online',
            icon: Icons.online_prediction,
            onPressed: () {},
          ),
          const SizedBox(height: 24),
          const RescueMapPlaceholder(config: config),
        ],
      ),
    );
  }
}
