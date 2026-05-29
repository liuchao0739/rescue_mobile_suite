library rescue_mobile_map;

import 'package:flutter/material.dart';
import 'package:rescue_mobile_core/rescue_mobile_core.dart';

/// Placeholder map shell — integrate Mapbox / Google Maps in Phase 2.
class RescueMapPlaceholder extends StatelessWidget {
  const RescueMapPlaceholder({super.key, required this.config});

  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.map_outlined, size: 48),
            const SizedBox(height: 12),
            Text('Map — ${config.appName}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text('Mapbox / Google Maps integration pending'),
          ],
        ),
      ),
    );
  }
}
