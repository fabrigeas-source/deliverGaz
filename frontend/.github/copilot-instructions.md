# DeliverGaz Flutter App - AI Coding Guidelines

## Project Architecture

This is a **Flutter delivery app for gas services** with a mock API backend. The app follows a **barrel export pattern** for clean imports and includes **comprehensive i18n support**.

### Key Architecture Patterns
- **Path Aliasing**: Use `package:deliver_gaz/models.dart`, `package:deliver_gaz/services.dart`, etc. instead of relative imports
- **Barrel Exports**: Each major directory has an `index.dart` that exports all files (see `lib/models/index.dart`)
- **Mock-First Development**: All APIs are mocked via `MockApiService` in `lib/mock/` for offline development
- **JSON Serialization**: Models use `json_annotation` with generated `.g.dart` files (run `flutter packages pub run build_runner build`)

## Essential Workflows

### Development Commands
```bash
# Run on Windows (primary target)
flutter run -d windows

# Generate JSON serialization code after model changes
flutter packages pub run build_runner build

# Generate localization files after .arb updates
flutter gen-l10n
```

### Testing Mock APIs
- Use "Create Test Order" in Orders page menu to test API endpoints
- All mock APIs simulate 500ms network delay for realistic UX testing
- API routes documented in `API_ROUTES.md`

## Code Organization Patterns

### Import Structure
```dart
// ✅ Correct - Use barrel imports
import 'package:deliver_gaz/models.dart';
import 'package:deliver_gaz/services.dart';
import 'package:deliver_gaz/l10n/app_localizations.dart';

// ❌ Avoid - Relative imports
import '../models/order.model.dart';
import '../../services/orders_api_client.service.dart';
```

### Service Layer Pattern
- **API Clients** (`services/`) provide clean interfaces to mock services
- **Mock Services** (`mock/`) simulate REST APIs with realistic data
- **Base Classes**: `ApiResponse<T>` and `ApiException` for consistent error handling
- Services use singleton pattern: `OrdersApiClient()` returns same instance

### Model Conventions
- All models in `models/` extend JSON serializable classes
- DateTime fields use custom `_dateTimeFromJson`/`_dateTimeToJson` converters
- Export models via `models/index.dart` barrel file

## Internationalization System

### Language Support
- **Supported**: English (default), French, Spanish
- **Files**: `lib/l10n/app_{locale}.arb` for translations
- **Usage**: `AppLocalizations.of(context)!.messageKey`
- **Dynamic Language**: Use `MyApp.setLocale(context, Locale('fr'))` for runtime switching

### Adding New Translations
1. Add entries to all `.arb` files in `lib/l10n/`
2. Run `flutter gen-l10n` to regenerate localization classes
3. Access via `l10n.newMessageKey` in widgets

## Platform-Specific Notes

### Windows Development
- Primary development target is Windows desktop
- Use `flutter run -d windows` task in VS Code
- Windows-specific configurations in `windows/` directory

### Multi-Platform Support
- iOS/Android configurations exist but Windows is primary
- Web build available for testing (`flutter build web`)

## Key Files to Reference
- `lib/main.dart`: App entry point with i18n configuration
- `lib/core/aliases.dart`: Central import aliases
- `API_ROUTES.md`: Complete mock API documentation
- `INTERNATIONALIZATION.md`: Detailed i18n implementation guide
- `PATH_ALIASING.md`: Import system documentation

## Data Flow Patterns
1. **UI Pages** → **API Clients** → **Mock Services** → **Models**
2. All API responses wrapped in `ApiResponse<T>` for consistent error handling
3. State management via `StatefulWidget` - no external state library used
4. Session data stored via `SharedPreferences` in `SessionStorageService`

## Development Best Practices
- Run `flutter analyze` before commits (configured in `analysis_options.yaml`)
- Use provided VS Code task "Run Flutter App" for consistent Windows development
- Mock API responses include realistic gas industry data (cylinders, regulators, etc.)
- Follow Flutter material design patterns for UI consistency