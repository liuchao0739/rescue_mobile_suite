library rescue_mobile_ui;

import 'package:flutter/material.dart';

/// Shared primary action button style for SOS and dispatch flows.
class RescuePrimaryButton extends StatelessWidget {
  const RescuePrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.emergency),
      label: Text(label),
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }
}
