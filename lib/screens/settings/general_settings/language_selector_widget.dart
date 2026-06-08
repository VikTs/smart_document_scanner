import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    super.key,
    required this.currentLocale,
  });

  final Locale currentLocale;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "settings.language".tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            DropdownButton<Locale>(
              value: currentLocale,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: Locale('uk'),
                  child: Text('Українська'),
                ),
              ],
              onChanged: (locale) {
                if (locale != null) {
                  context.setLocale(locale);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}