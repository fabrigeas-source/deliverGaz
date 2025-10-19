# Multi-stage Dockerfile for Flutter Web App

# Stage 1: Build environment
FROM ghcr.io/cirruslabs/flutter:3.35.6 AS build-env

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml pubspec.lock ./

# Enable web support
RUN flutter config --enable-web

# Get dependencies
RUN flutter pub get

# Copy source code
COPY . .

# Generate JSON serialization code
RUN flutter packages pub run build_runner build --delete-conflicting-outputs

# Generate localization files
RUN flutter gen-l10n

# Build web app
RUN flutter build web --release

# Stage 2: Production environment with Nginx
FROM nginx:alpine AS production

# Copy built web app to nginx directory
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]