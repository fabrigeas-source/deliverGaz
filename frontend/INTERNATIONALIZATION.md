# DeliverGaz - Internationalization Guide

## Overview
This Flutter application now supports multiple languages through Flutter's built-in internationalization (i18n) framework.

## Supported Languages
- 🇺🇸 **English** (`en`) - Default
- 🇫🇷 **French** (`fr`) 
- 🇪🇸 **Spanish** (`es`)

## Features
- **Automatic language detection** based on device locale
- **Manual language switching** via the language selector in the app
- **Comprehensive translations** covering all major UI elements
- **Parameterized messages** for dynamic content (e.g., order IDs, error messages)
- **Proper number and currency formatting** per locale

## File Structure
```
lib/
├── l10n/
│   ├── app_en.arb          # English translations (template)
│   ├── app_fr.arb          # French translations
│   ├── app_es.arb          # Spanish translations
│   └── app_localizations.dart  # Generated localization classes
├── widgets/
│   └── language_selector.dart  # Language selector widget
└── main.dart               # App configuration with i18n support
```

## Configuration Files
- `l10n.yaml` - Localization generation configuration
- `pubspec.yaml` - Dependencies and generation settings

## Usage in Code

### Accessing Translations
```dart
import 'package:deliver_gaz/l10n/app_localizations.dart';

@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  
  return Text(l10n.welcome); // "Welcome to DeliverGaz"
}
```

### Parameterized Messages
```dart
// For messages with parameters
Text(l10n.testOrderCreated(orderId)) // "Test order 12345 created successfully!"
Text(l10n.failedToCreateOrder(error)) // "Failed to create order: Network error"
```

### Language Selector
The `LanguageSelector` widget provides a dropdown to switch languages:
```dart
LanguageSelector(
  currentLocale: Localizations.localeOf(context),
  onLocaleChanged: (locale) {
    MyApp.setLocale(context, locale);
  },
)
```

## Adding New Translations

### 1. Add to ARB Files
Add new keys to all `.arb` files in `lib/l10n/`:

**app_en.arb**
```json
{
  "newKey": "English text",
  "@newKey": {
    "description": "Description of this text"
  }
}
```

**app_fr.arb**
```json
{
  "newKey": "Texte français"
}
```

**app_es.arb**
```json
{
  "newKey": "Texto español"
}
```

### 2. Regenerate Localizations
```bash
flutter gen-l10n
```

### 3. Use in Code
```dart
Text(l10n.newKey)
```

## Adding New Languages

### 1. Create New ARB File
Create `lib/l10n/app_[language_code].arb` with translations

### 2. Update Supported Locales
In `lib/main.dart`:
```dart
supportedLocales: const [
  Locale('en'), // English
  Locale('fr'), // French  
  Locale('es'), // Spanish
  Locale('de'), // German (new)
],
```

### 3. Update Language Selector
Add new option in `lib/widgets/language_selector.dart`

## Key Translated Sections
- ✅ **App Title & Navigation**
- ✅ **Welcome Messages**
- ✅ **Order Management** (create, view, filter, sort)
- ✅ **Product Names** (gas cylinders, regulators, hoses)
- ✅ **User Interface** (buttons, labels, messages)
- ✅ **Success/Error Messages**
- ✅ **Form Fields** (email, password, profile info)

## Testing Different Languages

### Device Language
The app automatically detects and uses the device language if supported.

### Manual Testing
Use the language selector (🌐) in the app header to switch between languages in real-time.

### Development Testing
```dart
// Force a specific locale during development
locale: const Locale('fr'), // Forces French
```

## Best Practices
1. **Always use keys** instead of hardcoded strings
2. **Provide descriptions** in ARB files for context
3. **Use parameters** for dynamic content
4. **Test all languages** before release
5. **Keep translations consistent** across the app
6. **Consider RTL languages** for future expansion

## Notes
- The app defaults to English if the device language is not supported
- All currency is displayed with proper locale formatting
- Date and time formatting automatically adapts to locale
- The language preference persists during the app session