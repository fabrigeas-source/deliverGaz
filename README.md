# DeliverGaz 🚚⛽

[![Backend CI](https://github.com/fabrigeas-source/deliverGaz/actions/workflows/backend-ci.yml/badge.svg?branch=main)](https://github.com/fabrigeas-source/deliverGaz/actions/workflows/backend-ci.yml)
[![Frontend CI](https://github.com/fabrigeas-source/deliverGaz/actions/workflows/frontend-ci.yml/badge.svg?branch=main)](https://github.com/fabrigeas-source/deliverGaz/actions/workflows/frontend-ci.yml)
[![Backend Deploy](https://github.com/fabrigeas-source/deliverGaz/actions/workflows/backend-deploy.yml/badge.svg?branch=stage)](https://github.com/fabrigeas-source/deliverGaz/actions/workflows/backend-deploy.yml)
[![Umbrella CI](https://github.com/fabrigeas-source/deliverGaz/actions/workflows/umbrella-ci.yml/badge.svg?branch=main)](https://github.com/fabrigeas-source/deliverGaz/actions/workflows/umbrella-ci.yml)

A modern full-stack gas delivery platform built with Flutter and Node.js, providing seamless gas ordering and delivery services across multiple platforms.

## 🌟 Overview

DeliverGaz is a comprehensive delivery application that connects customers with gas suppliers through an intuitive mobile and web interface. The platform features real-time order tracking, secure payments, and efficient delivery management.

### ✨ Key Features

- 📱 **Cross-Platform Support**: iOS, Android, Web, Windows, macOS, and Linux
- 🌍 **Internationalization**: Full i18n support with multiple languages
- 🔐 **Secure Authentication**: JWT-based authentication with refresh tokens
- 📍 **Real-time Tracking**: Live order and delivery tracking
- 💳 **Payment Integration**: Secure payment processing
- 📊 **Admin Dashboard**: Comprehensive order and delivery management
- 🐳 **Docker Support**: Containerized development and deployment
- 📚 **API Documentation**: Interactive Swagger/OpenAPI documentation

## 🏗️ Architecture

This project follows a modern architecture:

- **Frontend**: Flutter application (exclusively under `/frontend/`)
- **Backend**: Node.js/Express API with TypeScript (`/backend/`)
- **Database**: MongoDB Atlas with Mongoose ODM
- **Documentation**: Comprehensive docs (`/docs/`)

## 🚀 Quick Start

### Prerequisites

- **Docker Desktop** (recommended for fastest setup)
- **Flutter SDK** 3.9.2+ (for native development)
- **Node.js** 18+ (for backend development)
- **VS Code** (recommended IDE)

### 🐳 Docker Setup (Recommended)

1. **Clone the repository**
   ```bash
   git clone https://github.com/fabrigeas-source/deliverGaz.git
   cd DeliverGaz
   ```

2. **Start the full stack**
   ```bash
   # Start backend services
   cd backend
   # Prefer the helper script which handles Docker permissions gracefully
   npm run start:docker

   # Or use docker-compose directly
   # docker-compose up -d

   # Start frontend development
   cd ../frontend
   docker-compose --profile development up delivergaz-dev
   ```

3. **Access the application**
   - Frontend: http://localhost:3002
   - Backend API: http://localhost:3000
   - API Documentation: http://localhost:3000/api-docs

### 🛠️ Native Development Setup

#### Backend Setup
```bash
cd backend
npm install
cp .env.example .env
# Configure your MongoDB connection in .env
npm run dev
```

#### Frontend Setup
```bash
cd frontend
flutter pub get
flutter packages pub run build_runner build
flutter run -d windows  # or your preferred platform
```

## 📁 Project Structure

```
DeliverGaz/
├── 📱 frontend/          # Flutter application
│   ├── lib/             # Dart source code
│   ├── assets/          # Images, fonts, etc.
│   └── l10n/           # Internationalization files
├── 🖥️ backend/           # Node.js API server
│   ├── src/            # TypeScript source code
│   ├── scripts/        # Database setup scripts
│   └── docker/         # Docker configurations
├── 📚 docs/             # Project documentation
│   ├── API.md          # API documentation
│   ├── ARCHITECTURE.md # System architecture
│   └── DEPLOYMENT.md   # Deployment guide
├── 🐳 Docker files      # Container configurations
└── 📋 Configuration     # Project setup files
```

## ⚙️ CI/CD Workflows

This repository uses small, focused workflows plus an umbrella orchestrator. Reusable steps live in `pipelines/` as composite actions.

- Workflows
   - `backend-ci.yml`: Lint, build, and test the backend (runs on backend changes; manual run supported)
   - `frontend-ci.yml`: Analyze and test the Flutter frontend (runs on frontend changes; manual run supported)
   - `umbrella-ci.yml`: Runs both backend and frontend pipelines on `main`/`develop` and on manual dispatch
   - `backend-deploy.yml`: Builds the backend image and deploys to EC2 on `stage`

- Reusable composites (DRY building blocks)
   - `pipelines/backend-ci`: Node setup, install, lint, build, test
   - `pipelines/frontend-ci`: Flutter setup, pub get, analyze, test
   - `pipelines/docker-build-push`: Buildx + login + build/push
   - `pipelines/ec2-ssh-deploy`: SSH to EC2, docker login/pull, restart container

You can trigger any CI workflow manually from the Actions tab via “Run workflow”.

## 🔧 Development

### Available Scripts

**Frontend (Flutter) — lives in `frontend/`**
```bash
flutter run -d windows     # Run on Windows
flutter run -d chrome      # Run on Web
flutter build apk          # Build Android APK
flutter test               # Run tests
```

**Backend (Node.js)**
```bash
npm run dev               # Development with hot reload
npm run build             # Build TypeScript
npm run start             # Production start (builds first, then runs dist/server.js)
npm run start:docker      # Start backend via Docker Compose (auto-fallback for docker group perms)
npm run stop:docker       # Stop Docker stack
npm run logs:docker       # Follow Docker logs
npm test                  # Run tests
```

### 🌍 Internationalization

The app supports multiple languages. To add a new language:

1. Add translation files in `frontend/lib/l10n/`
2. Update `l10n.yaml` configuration
3. Run `flutter gen-l10n` to generate code

## 📖 Documentation

- 🏗️ [Architecture Guide](docs/ARCHITECTURE.md)
- 🚀 [Deployment Guide](docs/DEPLOYMENT.md)
- 📡 [API Documentation](docs/API.md)
- 🌍 [Internationalization](frontend/INTERNATIONALIZATION.md)
- 🛣️ [Path Aliasing](frontend/PATH_ALIASING.md)

## 🧪 Testing

```bash
# Frontend tests
cd frontend
flutter test

# Backend tests
cd backend
npm test

# Integration tests
npm run test:integration
```

## 🚢 Deployment

### Production Deployment

1. **Backend Deployment**
   ```bash
   cd backend
   docker build -t delivergaz-backend .
   docker run -p 3000:3000 delivergaz-backend
   ```

2. **Frontend Deployment**
   ```bash
   cd frontend
   flutter build web
   # Deploy to your hosting provider
   ```

See [DEPLOYMENT.md](docs/DEPLOYMENT.md) for detailed deployment instructions.

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- 📧 **Email**: support@delivergaz.com
- 🐛 **Issues**: [GitHub Issues](https://github.com/fabrigeas-source/deliverGaz/issues)
- 📖 **Documentation**: [Project Wiki](https://github.com/fabrigeas-source/deliverGaz/wiki)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Node.js community for excellent tools
- All contributors who help improve this project

---

Made with ❤️ by the DeliverGaz Team
