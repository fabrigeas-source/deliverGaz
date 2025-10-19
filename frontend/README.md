# DeliverGaz 🚚⛽

A modern Flutter delivery application for gas services with comprehensive internationalization support and mock API backend.

## 🚀 Quick Start

### Prerequisites
- **Option 1**: Docker Desktop (recommended for consistent development)
- **Option 2**: Flutter SDK (3.9.2+) for native development
- VS Code (recommended IDE)

### 🐳 Fastest Setup (Docker - Recommended)

```bash
# Clone repository
git clone <repository-url>
cd frontend

# Start development with hot reload
docker-compose --profile development up delivergaz-dev

# Open browser to: http://localhost:3002
# Press 'r' in terminal for hot reload 🔥
```

**That's it!** No need to install Flutter SDK, manage dependencies, or configure build tools.

### 📋 Version Information

- **Flutter**: 3.35.6 (Docker image: `ghcr.io/cirruslabs/flutter:3.35.6`)
- **Dart**: 3.9.2+
- **Minimum Flutter**: 3.9.2+
- **Target Platforms**: Windows (primary), Web, Android, iOS

### Option 1: Native Flutter Development

**For developers who prefer local Flutter installation:**

1. **Clone and Setup**
   ```bash
   git clone <repository-url>
   cd frontend
   flutter pub get
   ```

2. **Generate Required Files**
   ```bash
   # Generate JSON serialization code
   flutter packages pub run build_runner build
   
   # Generate localization files
   flutter gen-l10n
   ```

3. **Run the App**
   ```bash
   # Windows (primary target)
   flutter run -d windows
   
   # Web (for testing)
   flutter run -d web-server
   
   # Edge browser (recommended for web testing)
   flutter run -d edge
   
   # Chrome browser (alternative)
   flutter run -d chrome
   
   # Android (see Android setup below)
   flutter run -d android
   
   # iOS (see iOS setup below)
   flutter run -d ios
   
   # Or use VS Code task: "Run Flutter App"
   ```

### Option 2: Docker Development (Recommended for Containerized Workflow)

1. **Development with Hot Reload** ⚡
   ```bash
   # Start development server with live code sync
   docker-compose --profile development up delivergaz-dev
   # Access at http://localhost:3002 with hot reload support
   ```

2. **Quick Production Build**
   ```bash
   docker-compose up -d
   # Access at http://localhost:3000
   ```

3. **Production with Reverse Proxy**
   ```bash
   docker-compose --profile production up -d
   # Access at http://localhost
   ```

4. **Manual Docker Development** (Alternative)
   ```bash
   # Direct Docker command for development
   docker run --rm -it -p 3002:3002 -v ${PWD}:/app -w /app \
     ghcr.io/cirruslabs/flutter:3.35.6 \
     sh -c "flutter config --enable-web && flutter pub get && \
            flutter packages pub run build_runner build --delete-conflicting-outputs && \
            flutter gen-l10n && \
            flutter run -d web-server --web-hostname 0.0.0.0 --web-port 3002"
   ```

## 📱 Mobile Development Setup

### Android Development

#### Prerequisites
- Android Studio with Android SDK
- Android device or emulator
- Java Development Kit (JDK) 11 or higher

#### Setup Steps
1. **Install Android Studio**
   ```bash
   # Verify Android toolchain
   flutter doctor
   ```

2. **Configure Android SDK**
   ```bash
   # Accept Android licenses
   flutter doctor --android-licenses
   
   # Enable Android development
   flutter config --android-sdk <path-to-android-sdk>
   ```

3. **Development Commands**
   ```bash
   # List available devices
   flutter devices
   
   # Run on connected Android device
   flutter run -d android
   
   # Run on specific device
   flutter run -d <device-id>
   
   # Debug mode
   flutter run --debug -d android
   
   # Release mode for testing
   flutter run --release -d android
   ```

4. **Building for Android**
   ```bash
   # Debug APK
   flutter build apk --debug
   
   # Release APK
   flutter build apk --release
   
   # Android App Bundle (recommended for Play Store)
   flutter build appbundle --release
   
   # Install APK on connected device
   flutter install
   ```

### iOS Development

#### Prerequisites
- macOS with Xcode 14.0 or newer
- iOS device or iOS Simulator
- Apple Developer account (for device deployment)
- CocoaPods

#### Setup Steps
1. **Install Xcode and Dependencies**
   ```bash
   # Install CocoaPods
   sudo gem install cocoapods
   
   # Verify iOS toolchain
   flutter doctor
   ```

2. **iOS Configuration**
   ```bash
   # Open iOS project in Xcode
   open ios/Runner.xcworkspace
   
   # Install iOS dependencies
   cd ios && pod install && cd ..
   ```

3. **Development Commands**
   ```bash
   # List iOS simulators
   flutter emulators
   
   # Launch iOS simulator
   flutter emulators --launch apple_ios_simulator
   
   # Run on iOS simulator
   flutter run -d ios
   
   # Run on connected iOS device
   flutter run -d <ios-device-id>
   
   # Debug mode
   flutter run --debug -d ios
   
   # Release mode
   flutter run --release -d ios
   ```

4. **Building for iOS**
   ```bash
   # Build iOS app
   flutter build ios --release
   
   # Build for iOS simulator
   flutter build ios --debug --simulator
   
   # Create iOS archive (for App Store)
   flutter build ipa --release
   ```

### Mobile-Specific Configuration

#### App Signing (Android)
1. **Generate keystore**:
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. **Configure in `android/key.properties`**:
   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=upload
   storeFile=<path-to-keystore>
   ```

3. **Update `android/app/build.gradle`**:
   ```gradle
   signingConfigs {
       release {
           keyAlias keystoreProperties['keyAlias']
           keyPassword keystoreProperties['keyPassword']
           storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
           storePassword keystoreProperties['storePassword']
       }
   }
   ```

#### App Configuration
- **Android**: Edit `android/app/src/main/AndroidManifest.xml`
- **iOS**: Configure in Xcode or edit `ios/Runner/Info.plist`
- **App Icons**: Use `flutter_launcher_icons` package
- **Splash Screen**: Use `flutter_native_splash` package

## ✨ Key Features

- **🌍 Multi-language Support**: English, French, Spanish with dynamic switching
- **📱 Cross-platform**: Windows (primary), Web, iOS, Android
- **🔄 Mock API Backend**: Complete offline development with realistic data
- **📦 Barrel Imports**: Clean import system with `package:deliver_gaz/models.dart`
- **🏗️ JSON Serialization**: Automatic model generation with build_runner
- **🚚 Gas Delivery Domain**: Orders, cylinders, regulators, delivery tracking

## 🛠️ Development Workflow

### Essential Commands
```bash
# Start development (Windows - primary)
flutter run -d windows

# Web development in Edge (recommended browser)
flutter run -d edge --web-port 8080

# Docker development with hot reload (recommended for web)
docker-compose --profile development up delivergaz-dev
# Access at http://localhost:3002 with hot reload

# Native web development server
flutter run -d web-server --web-hostname localhost --web-port 3000

# After model changes
flutter packages pub run build_runner build --delete-conflicting-outputs

# After translation updates
flutter gen-l10n

# Code analysis
flutter analyze

# Docker development workflow
docker-compose --profile development up delivergaz-dev  # Start dev server
# Press 'r' in terminal for hot reload, 'q' to quit
```

### Docker Development Workflow 🐳

**Recommended for web development with hot reload:**

```bash
# Start development container
docker-compose --profile development up delivergaz-dev

# Container will:
# 1. Install Flutter dependencies
# 2. Run build_runner for JSON serialization
# 3. Generate localization files
# 4. Start Flutter web server at http://localhost:3002
# 5. Enable hot reload (press 'r' in terminal)
```

**Development Features:**
- ✅ **Hot Reload**: Press `r` for instant code changes
- ✅ **Live Code Sync**: Changes in VS Code automatically sync to container
- ✅ **Persistent Cache**: Flutter pub cache preserved across container restarts
- ✅ **Port 3002**: Accessible at http://localhost:3002
- ✅ **Debug Mode**: Full debugging capabilities

**Container Commands:**
```bash
r    # Hot reload 🔥🔥🔥
R    # Hot restart
c    # Clear screen
q    # Quit container
d    # Detach (keep running)
h    # Help
```

### Testing Mock APIs
1. Navigate to Orders page
2. Use "Create Test Order" from the menu
3. Test filtering, sorting, and status updates
4. All APIs include 500ms delay for realistic UX testing

### Mobile Testing
```bash
# Run unit tests
flutter test

# Integration tests on Android
flutter drive --target=test_driver/app.dart -d android

# Integration tests on iOS
flutter drive --target=test_driver/app.dart -d ios

# Performance testing
flutter run --profile -d <device-id>

# Test on multiple devices
flutter run -d all  # Runs on all connected devices
```

### Platform-Specific Testing
- **Android**: Test on various API levels (21+) and screen sizes
- **iOS**: Test on iPhone/iPad simulators and physical devices
- **Web**: Test responsive design in Edge/Chrome/Safari
- **Windows**: Test desktop interactions and window resizing

### Adding Translations
1. Edit `lib/l10n/app_*.arb` files
2. Run `flutter gen-l10n`
3. Use `AppLocalizations.of(context)!.messageKey` in widgets

## 📁 Project Architecture

### Import System
```dart
// ✅ Use barrel imports
import 'package:deliver_gaz/models.dart';
import 'package:deliver_gaz/services.dart';
import 'package:deliver_gaz/l10n/app_localizations.dart';

// ❌ Avoid relative imports
import '../models/order.model.dart';
```

### Service Layer
- **API Clients** (`services/`) - Clean interfaces to mock services
- **Mock Services** (`mock/`) - Realistic REST API simulation
- **Models** (`models/`) - JSON serializable data classes with generated code

### Data Flow
```
UI Pages → API Clients → Mock Services → Models
```

## 📚 Documentation

- **[API Routes](API_ROUTES.md)** - Complete mock API documentation
- **[Internationalization](INTERNATIONALIZATION.md)** - Multi-language setup guide
- **[Path Aliasing](PATH_ALIASING.md)** - Import system documentation
- **[Docker Setup](DOCKER.md)** - Containerization guide
- **[AI Guidelines](.github/copilot-instructions.md)** - AI coding assistant instructions

## 🔧 Troubleshooting

### Common Issues

1. **Build errors after model changes**:
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

2. **Missing translations**:
   ```bash
   flutter gen-l10n
   ```

3. **Windows build issues**:
   ```bash
   flutter config --enable-windows-desktop
   flutter create --platforms windows .
   ```

4. **Edge/Web development issues**:
   ```bash
   # Enable web support
   flutter config --enable-web
   
   # Clear web cache
   flutter clean
   flutter pub get
   
   # Specify Edge explicitly
   flutter run -d edge --web-renderer html
   ```

5. **Android development issues**:
   ```bash
   # Check Android setup
   flutter doctor -v
   
   # Accept licenses
   flutter doctor --android-licenses
   
   # Clean and rebuild
   flutter clean
   cd android && ./gradlew clean && cd ..
   flutter pub get
   
   # Fix Gradle issues
   cd android && ./gradlew wrapper --gradle-version 7.6 && cd ..
   ```

6. **iOS development issues**:
   ```bash
   # Clean iOS build
   flutter clean
   cd ios && rm -rf Pods Podfile.lock && pod install && cd ..
   
   # Update CocoaPods
   sudo gem install cocoapods
   cd ios && pod repo update && pod install && cd ..
   
   # Reset iOS simulator
   xcrun simctl erase all
   ```

7. **Docker development issues**:
   ```bash
   # Stop containers and clean up
   docker-compose down
   docker system prune -f
   
   # Rebuild containers
   docker-compose up --build
   
   # Development container troubleshooting
   docker-compose --profile development down delivergaz-dev
   docker-compose --profile development up delivergaz-dev
   
   # Check container logs
   docker-compose logs delivergaz-dev
   
   # Port conflicts (if 3002 is in use)
   # Edit docker-compose.yml to change port mapping
   ```

## 🎯 Platform Targets & Deployment

### Development Priority
- **Primary**: Windows Desktop (`flutter run -d windows`)
- **Secondary**: Web via Edge (`flutter run -d edge`)
- **Mobile**: Android and iOS support

### Deployment Options

#### Android Deployment
```bash
# Debug testing
flutter build apk --debug

# Production release
flutter build appbundle --release

# Deploy to Play Store Console
# Upload the .aab file from build/app/outputs/bundle/release/
```

#### iOS Deployment
```bash
# Debug testing
flutter build ios --debug --simulator

# Production release
flutter build ipa --release

# Deploy to App Store Connect
# Upload via Xcode or Application Loader
```

#### Web Deployment
```bash
# Build for web
flutter build web --release

# Deploy to any web server or use Docker
docker-compose up -d  # Serves at localhost:3000

# Development deployment with hot reload
docker-compose --profile development up delivergaz-dev  # Serves at localhost:3002
```

## 🌐 Accessing the Application

### Development URLs
- **Docker Development**: http://localhost:3002 (with hot reload)
- **Production Docker**: http://localhost:3000  
- **Native Flutter Web**: http://localhost:8080 (or specified port)

### Browsers Tested
- ✅ **Microsoft Edge** (recommended)
- ✅ **Google Chrome**
- ✅ **Firefox**
- ✅ **Safari** (macOS/iOS)

#### Desktop Deployment
```bash
# Windows executable
flutter build windows --release

# Distribute via Microsoft Store or direct download
```

## 🤝 Contributing

1. Follow the barrel import system
2. Update translations in all `.arb` files
3. Run `flutter analyze` before commits
4. Use the provided VS Code tasks
5. Test with mock APIs using "Create Test Order"

## 📄 License

This project is a private delivery application for gas services.
