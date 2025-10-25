# DeliverGaz 🚚⛽

A modern Flutter delivery application for gas services with comprehensive internationalization support and mock API backend.

> CI: This section intentionally updated to trigger Frontend CI.

Note: This `frontend/` folder is part of a monorepo. The Node/Express backend lives in `../backend`. In production, you can serve the built Flutter web app from the backend's static directory.

## 🚀 Quick Start

### Prerequisites
- **Option 1**: Docker Desktop (recommended for consistent development)
- **Option 2**: Flutter SDK (3.9.2+) for native development
# DeliverGaz 🚚⛽

A modern Flutter delivery application for gas services with internationalization and a mock API backend.

Note: This `frontend/` folder is part of a monorepo; the Node/Express backend lives in `../backend`.

## 📋 Versions

- Flutter: 3.35.6 (Docker image: `ghcr.io/cirruslabs/flutter:3.35.6`)
- Dart: 3.9.2+
- Minimum Flutter: 3.9.2+
- Targets: Windows (primary), Web, Android, iOS

## 🚀 Quick Start

### Option A — Docker (recommended)

```bash
# From repo root or frontend/
docker-compose --profile development up delivergaz-dev
# Open http://localhost:3002 and press 'r' in the terminal for hot reload
```

### Option B — Native Flutter

```bash
cd frontend
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter run -d windows   # primary target
# or run -d edge | chrome | web-server | android | ios
```

## 🌐 Build web and serve via backend

The backend serves static files from `backend/public`.

```bash
# Build web
cd frontend
flutter build web --release

# Publish to backend static dir
rm -rf ../backend/public/*
cp -a build/web/. ../backend/public/

# Start backend
cd ../backend
npm install
npm run build && node dist/server.js
```

Visit the backend root URL (e.g., http://localhost:3000) to see the Flutter app.

## 🛠️ Essential commands

```bash
# Codegen after model changes
flutter packages pub run build_runner build --delete-conflicting-outputs

# Update localizations
flutter gen-l10n

# Analyze & test
flutter analyze
flutter test
```

## 📁 Architecture (high level)

- Barrel imports: `package:deliver_gaz/models.dart`, `services.dart`
- Service layer: `services/` (API clients), `mock/` (mock REST), `models/` (data classes)

## 📚 Documentation

- [API Routes](API_ROUTES.md)
- [Internationalization](INTERNATIONALIZATION.md)
- [Path Aliasing](PATH_ALIASING.md)
- [Docker Setup](DOCKER.md)
- [AI Guidelines](../.github/copilot-instructions.md)

## 🔧 Troubleshooting (quick)

```bash
# Clean & fetch
flutter clean && flutter pub get

# Enable web (first time)
flutter config --enable-web

# Android licenses
flutter doctor --android-licenses
```

## 🎯 Platforms

- Primary: Windows desktop (`flutter run -d windows`)
- Secondary: Web (`-d edge` or `-d chrome`), Android, iOS

## 🤝 Contributing

- Use barrel imports, keep translations updated, run `flutter analyze` before commits.

## 📄 License

Private application for gas delivery services.

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
