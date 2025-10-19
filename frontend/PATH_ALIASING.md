# Path Aliasing Documentation

This document describes the path aliasing system implemented in the Deliver Gaz project for cleaner and more maintainable imports.

## Overview

Path aliasing has been implemented using barrel files (index.dart) to provide clean, organized imports throughout the codebase. This system eliminates relative path imports and creates a more maintainable project structure.

## Directory Structure

```
lib/
├── core/                          # Core utilities and aliases
│   ├── aliases.dart              # Path aliases for clean imports
│   └── paths.dart                # Constants for path management
├── models/                        # Data models
│   └── index.dart                # Models barrel file
├── services/                      # API services and clients
│   └── index.dart                # Services barrel file
├── pages/                         # Page components
│   └── index.dart                # Pages barrel file
├── mock/                          # Mock API implementations
│   └── index.dart                # Mock services barrel file
├── models.dart                    # Models library (clean import)
├── services.dart                  # Services library (clean import)
├── pages.dart                     # Pages library (clean import)
├── mock.dart                      # Mock library (clean import)
└── index.dart                     # Main barrel file
```

## Import Patterns

### Before Path Aliasing (❌ Old)
```dart
import '../models/user.model.dart';
import '../models/address.model.dart';
import '../services/api_base.service.dart';
import '../../mock/user_api_service.mock.dart';
```

### After Path Aliasing (✅ New)
```dart
import 'package:deliver_gaz/models.dart';
import 'package:deliver_gaz/services.dart';
import 'package:deliver_gaz/mock.dart';
```

## Barrel Files

### Models Barrel (`lib/models/index.dart`)
```dart
export 'address.model.dart';
export 'cart_item.model.dart';
export 'order.model.dart';
export 'order_item.model.dart';
export 'product.model.dart';
export 'user.model.dart';
```

### Services Barrel (`lib/services/index.dart`)
```dart
export 'api_base.service.dart';
export 'cart_api_client.service.dart';
export 'orders_api_client.service.dart';
export 'products_api_client.service.dart';
export 'session_storage.service.dart';
export 'user_api_client.service.dart';
```

### Mock Services Barrel (`lib/mock/index.dart`)
```dart
export 'api_service.mock.dart';
export 'cart_api_service.mock.dart';
export 'products_api_service.mock.dart';
export 'user_api_service.mock.dart';
```

## Usage Examples

### In Page Components
```dart
// Clean import for models and services
import 'package:deliver_gaz/models.dart';
import 'package:deliver_gaz/services.dart';

// Usage
final User user = User(...);
final CartApiClient cartApi = CartApiClient();
```

### In Service Files
```dart
// Services can import models and mock services cleanly
import 'package:deliver_gaz/models.dart';
import 'package:deliver_gaz/mock.dart';
```

## Benefits

1. **Cleaner Imports**: No more relative path hell (`../../../`)
2. **Better Organization**: Clear separation of concerns
3. **Maintainability**: Easy to refactor and reorganize
4. **Consistency**: Uniform import patterns across the codebase
5. **Tree Shaking**: Better dead code elimination with explicit exports
6. **IDE Support**: Better autocomplete and refactoring support

## Files Updated

### Page Components (in lib/pages/)
- `create_order.page.dart`
- `shopping_cart.page.dart`
- `payment.page.dart`
- `orders.page.dart`
- `signin.page.dart`
- `registration.page.dart`
- `home.page.dart`
- `profile.page.dart`
- `edit_user_information.page.dart`
- `header_menu_utils.dart`

### Service Files
- `cart_api_client.service.dart`
- `orders_api_client.service.dart`
- `products_api_client.service.dart`
- `user_api_client.service.dart`
- `session_storage.service.dart`
- `services.service.dart`
- `services.dart`

### Mock Files
- `api_service.mock.dart`
- `cart_api_service.mock.dart`
- `products_api_service.mock.dart`
- `user_api_service.mock.dart`

## Best Practices

1. **Use Package Imports**: Always use `package:deliver_gaz/module.dart` for internal imports (without index.dart suffix)
2. **Barrel Files**: Group related exports in barrel files
3. **Avoid Deep Nesting**: Keep import paths short and clean
4. **Consistent Naming**: Follow the established patterns for new files
5. **Documentation**: Update this documentation when adding new modules

## Migration Notes

All relative imports (`../`, `../../`) have been replaced with package-based imports using the barrel file system. The codebase now uses a consistent import pattern that makes it easier to:

- Navigate the codebase
- Refactor file structures
- Add new features
- Maintain code quality

Flutter analyze passes without any compilation errors, confirming that all path aliases are working correctly.