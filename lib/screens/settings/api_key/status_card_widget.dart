import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final String? status;

  const StatusCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: status == "settings.connection_success_message".tr()
          ? Colors.green.withOpacity(0.1)
          : Colors.red.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(
              status == "settings.connection_success_message".tr()
                  ? Icons.check_circle
                  : Icons.error_outline,
            ),

            const SizedBox(width: 10),

            Expanded(child: Text(status!)),
          ],
        ),
      ),
    );
  }
}
