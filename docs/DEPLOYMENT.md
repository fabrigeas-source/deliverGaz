# Deployment Guide

This guide covers deployment strategies for both the backend API and Flutter frontend of DeliverGaz.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Environment Setup](#environment-setup)
3. [Backend Deployment](#backend-deployment)
4. [Frontend Deployment](#frontend-deployment)
5. [Database Setup](#database-setup)
6. [CI/CD Pipeline](#cicd-pipeline)
7. [Monitoring and Logging](#monitoring-and-logging)
8. [Troubleshooting](#troubleshooting)

## Prerequisites

### Required Tools
- **Node.js** 18+ and npm
- **Flutter** 3.0+ and Dart SDK
- **Docker** (optional but recommended)
- **Git**

### Cloud Services
- **MongoDB Atlas** (or self-hosted MongoDB)
- **Cloud hosting** (AWS, Google Cloud, Azure, or Heroku)
- **CDN** for static assets (optional)
- **Email service** (SendGrid, AWS SES, etc.)

## Environment Setup

### Environment Variables

Create environment files for different stages:

#### Backend Environment (.env)

```bash
# Server Configuration
NODE_ENV=production
PORT=3000
HOST=0.0.0.0

# Database
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/delivergaz
MONGODB_TEST_URI=mongodb+srv://username:password@cluster.mongodb.net/delivergaz_test

# Authentication
JWT_SECRET=your-super-secret-jwt-key-at-least-32-characters
JWT_EXPIRE=24h
JWT_REFRESH_EXPIRE=7d

# Email Configuration
SMTP_HOST=smtp.sendgrid.net
SMTP_PORT=587
SMTP_USER=apikey
SMTP_PASS=your-sendgrid-api-key
FROM_EMAIL=noreply@delivergaz.com
FROM_NAME=DeliverGaz

# File Upload
MAX_FILE_SIZE=5mb
UPLOAD_PATH=./uploads
ALLOWED_FILE_TYPES=jpg,jpeg,png,pdf

# Security
CORS_ORIGIN=https://yourdomain.com,https://app.yourdomain.com
RATE_LIMIT_WINDOW=15
RATE_LIMIT_MAX=100

# External Services
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...
FIREBASE_ADMIN_SDK_JSON=path/to/firebase-admin-sdk.json

# Logging
LOG_LEVEL=info
LOG_FORMAT=combined
```

#### Frontend Environment

**lib/config/environment.dart:**
```dart
class Environment {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.delivergaz.com/api/v1',
  );
  
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'DeliverGaz',
  );
  
  static const bool isProduction = bool.fromEnvironment(
    'DART_DEFINES_IS_PRODUCTION',
    defaultValue: false,
  );
}
```

## Backend Deployment

### Option 1: Docker Deployment

#### Dockerfile
Create `backend/Dockerfile`:
```dockerfile
FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY . .

# Build TypeScript
RUN npm run build

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001

# Change ownership of the app directory
RUN chown -R nodejs:nodejs /app

USER nodejs

EXPOSE 3000

CMD ["npm", "start"]
```

#### docker-compose.yml
```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - MONGODB_URI=${MONGODB_URI}
      - JWT_SECRET=${JWT_SECRET}
    depends_on:
      - mongodb
    restart: unless-stopped

  mongodb:
    image: mongo:6.0
    ports:
      - "27017:27017"
    environment:
      - MONGO_INITDB_ROOT_USERNAME=${MONGO_USERNAME}
      - MONGO_INITDB_ROOT_PASSWORD=${MONGO_PASSWORD}
    volumes:
      - mongodb_data:/data/db
    restart: unless-stopped

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - app
    restart: unless-stopped

volumes:
  mongodb_data:
```

### Option 2: Heroku Deployment

#### Procfile
```
web: npm start
release: npm run migrate
```

#### Heroku Setup
```bash
# Install Heroku CLI
npm install -g heroku

# Login to Heroku
heroku login

# Create app
heroku create delivergaz-api

# Set environment variables
heroku config:set NODE_ENV=production
heroku config:set MONGODB_URI=mongodb+srv://...
heroku config:set JWT_SECRET=your-secret

# Deploy
git push heroku main
```

### Option 3: AWS Deployment

#### Using AWS Elastic Beanstalk

1. **Install EB CLI:**
```bash
pip install awsebcli
```

2. **Initialize and deploy:**
```bash
cd backend
eb init
eb create production
eb deploy
```

#### Using AWS ECS (Docker)

1. **Build and push to ECR:**
```bash
# Create ECR repository
aws ecr create-repository --repository-name delivergaz-api

# Get login token
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-west-2.amazonaws.com

# Build and push
docker build -t delivergaz-api .
docker tag delivergaz-api:latest 123456789012.dkr.ecr.us-west-2.amazonaws.com/delivergaz-api:latest
docker push 123456789012.dkr.ecr.us-west-2.amazonaws.com/delivergaz-api:latest
```

## Frontend Deployment

### Mobile App Deployment

#### Android (Google Play Store)

1. **Build release APK:**
```bash
cd frontend
flutter build apk --release
```

2. **Build App Bundle (recommended):**
```bash
flutter build appbundle --release
```

3. **Upload to Google Play Console:**
   - Sign the app with your keystore
   - Upload to Google Play Console
   - Complete store listing
   - Submit for review

#### iOS (App Store)

1. **Build for iOS:**
```bash
flutter build ios --release
```

2. **Archive in Xcode:**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Archive the app
   - Upload to App Store Connect

### Web Deployment

#### Build for Web
```bash
flutter build web --release
```

#### Deploy to Firebase Hosting
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase
firebase init hosting

# Deploy
firebase deploy
```

#### Deploy to Netlify
```bash
# Install Netlify CLI
npm install -g netlify-cli

# Login to Netlify
netlify login

# Deploy
netlify deploy --prod --dir=build/web
```

#### Deploy to AWS S3 + CloudFront

1. **Create S3 bucket:**
```bash
aws s3 mb s3://delivergaz-app
```

2. **Configure bucket for static hosting:**
```bash
aws s3 website s3://delivergaz-app --index-document index.html --error-document error.html
```

3. **Upload files:**
```bash
aws s3 sync build/web s3://delivergaz-app
```

4. **Setup CloudFront distribution for CDN**

## Database Setup

### MongoDB Atlas (Recommended)

1. **Create MongoDB Atlas account**
2. **Create cluster**
3. **Configure network access**
4. **Create database user**
5. **Get connection string**

### Self-hosted MongoDB

#### Docker Setup
```yaml
version: '3.8'

services:
  mongodb:
    image: mongo:6.0
    restart: unless-stopped
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: password
    ports:
      - "27017:27017"
    volumes:
      - mongodb_data:/data/db
      - ./mongo-init.js:/docker-entrypoint-initdb.d/mongo-init.js:ro

volumes:
  mongodb_data:
```

#### Security Configuration
```javascript
// mongo-init.js
db = db.getSiblingDB('delivergaz');

db.createUser({
  user: 'api_user',
  pwd: 'secure_password',
  roles: [
    {
      role: 'readWrite',
      db: 'delivergaz'
    }
  ]
});
```

## CI/CD Pipeline

### GitHub Actions

#### Backend CI/CD (.github/workflows/backend.yml)
```yaml
name: Backend CI/CD

on:
  push:
    branches: [main]
    paths: ['backend/**']
  pull_request:
    branches: [main]
    paths: ['backend/**']

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      mongodb:
        image: mongo:6.0
        ports:
          - 27017:27017
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'
          cache-dependency-path: backend/package-lock.json
      
      - name: Install dependencies
        run: |
          cd backend
          npm ci
      
      - name: Run linting
        run: |
          cd backend
          npm run lint
      
      - name: Run tests
        run: |
          cd backend
          npm test
        env:
          MONGODB_TEST_URI: mongodb://localhost:27017/delivergaz_test
          JWT_SECRET: test-secret
  
  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Deploy to Heroku
        uses: akhileshns/heroku-deploy@v3.12.12
        with:
          heroku_api_key: ${{secrets.HEROKU_API_KEY}}
          heroku_app_name: "delivergaz-api"
          heroku_email: ${{secrets.HEROKU_EMAIL}}
```

#### Frontend CI/CD (.github/workflows/frontend.yml)
```yaml
name: Frontend CI/CD

on:
  push:
    branches: [main]
    paths: ['frontend/**']
  pull_request:
    branches: [main]
    paths: ['frontend/**']

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
          cache: true
      
      - name: Install dependencies
        run: |
          cd frontend
          flutter pub get
      
      - name: Run analyzer
        run: |
          cd frontend
          flutter analyze
      
      - name: Run tests
        run: |
          cd frontend
          flutter test
  
  build-web:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
          cache: true
      
      - name: Build web
        run: |
          cd frontend
          flutter build web --release
      
      - name: Deploy to Firebase
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
          projectId: delivergaz-app
```

### Required GitHub Secrets for EC2 Deployment

The Release workflow (`.github/workflows/release.yml`) requires the following secrets to be configured in your GitHub repository settings to deploy to EC2:

#### Required Secrets

1. **EC2_HOST**
   - Description: The public IP address or hostname of your EC2 instance
   - Example: `ec2-12-34-56-78.compute-1.amazonaws.com` or `12.34.56.78`

2. **EC2_USER**
   - Description: SSH username for connecting to the EC2 instance
   - Example: `ubuntu` (for Ubuntu), `ec2-user` (for Amazon Linux), or `admin` (for Debian)

3. **EC2_SSH_KEY**
   - Description: Private SSH key for authentication (PEM format)
   - How to get: This is the private key corresponding to the key pair you created when launching the EC2 instance
   - **Important**: Include the entire key including `-----BEGIN RSA PRIVATE KEY-----` and `-----END RSA PRIVATE KEY-----`

4. **GHCR_USERNAME**
   - Description: GitHub Container Registry username
   - Example: Your GitHub username or organization name

5. **GHCR_PAT**
   - Description: GitHub Personal Access Token with `read:packages` scope
   - How to create: GitHub Settings → Developer settings → Personal access tokens → Generate new token (classic)
   - Required scope: `read:packages`

#### Optional Secrets

6. **EC2_PORT**
   - Description: SSH port (defaults to 22 if not specified)
   - Example: `22` or custom port if you've changed the SSH port

7. **API_BASE_URL_PROD**
   - Description: Production API base URL for the Flutter frontend build
   - Example: `https://api.yourdomain.com/api/v1`

#### How to Configure Secrets

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add each secret with its name and value
5. Click **Add secret**

#### Workflow Behavior

- If any required secret is missing, the deployment step will be **skipped** (not failed)
- The workflow will display which secrets are missing in the job logs
- The backend Docker image will still be built and pushed to GitHub Container Registry
- Once all secrets are configured, deployments will run automatically on pushes to the `stage` branch

## Monitoring and Logging

### Backend Monitoring

#### Application Monitoring
```typescript
// src/middleware/monitoring.ts
import { Request, Response, NextFunction } from 'express';

export const monitoringMiddleware = (req: Request, res: Response, next: NextFunction) => {
  const startTime = Date.now();
  
  res.on('finish', () => {
    const duration = Date.now() - startTime;
    console.log({
      method: req.method,
      url: req.url,
      statusCode: res.statusCode,
      duration,
      userAgent: req.get('User-Agent'),
      ip: req.ip,
      timestamp: new Date().toISOString()
    });
  });
  
  next();
};
```

#### Health Check Endpoint
```typescript
// src/routes/health.ts
import { Router } from 'express';
import mongoose from 'mongoose';

const router = Router();

router.get('/health', async (req, res) => {
  const health = {
    status: 'ok',
    timestamp: new Date().toISOString(),
    services: {
      database: mongoose.connection.readyState === 1 ? 'connected' : 'disconnected',
      memory: process.memoryUsage(),
      uptime: process.uptime()
    }
  };
  
  res.status(200).json(health);
});

export default router;
```

### Logging Setup

#### Winston Logger
```typescript
// src/config/logger.ts
import winston from 'winston';

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ filename: 'logs/error.log', level: 'error' }),
    new winston.transports.File({ filename: 'logs/combined.log' })
  ]
});

export default logger;
```

## Troubleshooting

### Common Issues

#### Backend Issues

1. **MongoDB Connection Issues**
```bash
# Check connection string
echo $MONGODB_URI

# Test connection
node -e "const mongoose = require('mongoose'); mongoose.connect(process.env.MONGODB_URI).then(() => console.log('Connected')).catch(err => console.error(err))"
```

2. **Environment Variables**
```bash
# Check if variables are loaded
node -e "console.log(process.env.JWT_SECRET)"
```

3. **Port Issues**
```bash
# Check if port is in use
lsof -i :3000

# Kill process using port
kill -9 $(lsof -t -i:3000)
```

#### Frontend Issues

1. **Build Issues**
```bash
# Clean build
flutter clean
flutter pub get
flutter pub deps

# Check for issues
flutter doctor
flutter analyze
```

2. **Platform-specific Issues**
```bash
# iOS
cd ios && pod install && cd ..

# Android
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..
```

### Performance Optimization

#### Backend Optimization
- Enable gzip compression
- Use Redis for caching
- Optimize database queries
- Implement connection pooling
- Use CDN for static assets

#### Frontend Optimization
- Optimize images and assets
- Implement lazy loading
- Use code splitting
- Minimize bundle size
- Enable web caching

### Security Checklist

- [ ] HTTPS enabled
- [ ] Environment variables secured
- [ ] Database access restricted
- [ ] API rate limiting enabled
- [ ] Input validation implemented
- [ ] CORS properly configured
- [ ] Security headers added
- [ ] Dependencies updated
- [ ] Secrets rotation scheduled
- [ ] Monitoring and alerting setup

## Support

For deployment support:
- **Email**: [devops@delivergaz.com](mailto:devops@delivergaz.com)
- **Documentation**: Check GitHub issues
- **Emergency**: [emergency@delivergaz.com](mailto:emergency@delivergaz.com)