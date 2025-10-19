import 'package:flutter/material.dart';
import 'package:deliver_gaz/l10n/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  const LanguageSelector({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      tooltip: i10n.selectLanguage,
      onSelected: onLocaleChanged,
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<Locale>(
          value: const Locale('en'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🇺🇸', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              const Text('English'),
              if (currentLocale.languageCode == 'en')
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.check, size: 16),
                ),
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('fr'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🇫🇷', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              const Text('Français'),
              if (currentLocale.languageCode == 'fr')
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.check, size: 16),
                ),
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('es'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🇪🇸', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              const Text('Español'),
              if (currentLocale.languageCode == 'es')
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.check, size: 16),
                ),
            ],
          ),
        ),
      ],
    );
  }
}