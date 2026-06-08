import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SetupRequired extends StatelessWidget {
  final VoidCallback onPressed;
  const SetupRequired({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.settings_outlined, size: 40),
                const SizedBox(height: 12),
                Text(
                  "chat.setup_required.title".tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onPressed,
                  child: Text("chat.setup_required.open_settings_btn".tr()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
