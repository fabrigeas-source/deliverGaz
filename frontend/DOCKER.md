# DeliverGaz Docker Setup

This directory contains Docker configuration for containerizing the DeliverGaz Flutter web application.

## Files Overview

- `Dockerfile` - Multi-stage build for production web deployment
- `docker-compose.yml` - Complete orchestration with development and production profiles
- `nginx.conf` - Nginx configuration for serving the Flutter web app
- `nginx-proxy.conf` - Reverse proxy configuration for production
- `.dockerignore` - Excludes unnecessary files from Docker context

## Quick Start

### Production Build
```bash
# Build and run the production web app
docker-compose up -d

# Access at http://localhost:3000
```

### Development with Hot Reload
```bash
# Run development container with hot reload
docker-compose --profile development up -d delivergaz-dev

# Access at http://localhost:3001
```

### Production with Reverse Proxy
```bash
# Run with nginx reverse proxy
docker-compose --profile production up -d

# Access at http://localhost (port 80)
```

## Docker Commands

### Build Only
```bash
# Build the Docker image
docker build -t delivergaz-frontend .

# Run the container
docker run -p 3000:80 delivergaz-frontend
```

### Development Workflow
```bash
# Start development environment
docker-compose --profile development up -d

# View logs
docker-compose logs -f delivergaz-dev

# Stop development
docker-compose --profile development down
```

### Production Deployment
```bash
# Start production services
docker-compose --profile production up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## Architecture

### Multi-Stage Build
1. **Build Stage**: Uses `cirrusci/flutter:stable` to build the web app
2. **Production Stage**: Uses `nginx:alpine` to serve static files

### Services
- **delivergaz-frontend**: Main Flutter web app (port 3000)
- **nginx-proxy**: Reverse proxy for production (ports 80/443)
- **delivergaz-dev**: Development container with hot reload (port 3001)

### Networks
- `delivergaz-network`: Bridge network for service communication

### Volumes
- `flutter-cache`: Persistent Flutter cache for development
- `flutter-pub-cache`: Persistent pub cache for faster rebuilds

## Configuration

### Environment Variables
The app supports standard Flutter web environment variables:

```bash
# In docker-compose.yml or .env file
NODE_ENV=production
FLUTTER_WEB_USE_SKIA=true
```

### SSL/HTTPS Setup
For production with SSL:

1. Place certificates in `./certs/` directory
2. Uncomment HTTPS server block in `nginx-proxy.conf`
3. Update server_name with your domain
4. Run with production profile

### Nginx Customization
- **Main app**: Edit `nginx.conf`
- **Reverse proxy**: Edit `nginx-proxy.conf`
- **Security headers**: Already configured in nginx.conf
- **Gzip compression**: Enabled for static assets

## Health Checks

All containers include health checks:

```bash
# Check container health
docker-compose ps

# Manual health check
curl http://localhost:3000/health
```

## Troubleshooting

### Common Issues

1. **Build fails on build_runner**:
   ```bash
   # Clear build cache
   docker-compose down
   docker system prune -f
   docker-compose up --build
   ```

2. **Web app not accessible**:
   ```bash
   # Check if container is running
   docker ps
   
   # Check logs
   docker-compose logs delivergaz-frontend
   ```

3. **Hot reload not working in development**:
   ```bash
   # Ensure proper volume mounting
   docker-compose --profile development down
   docker-compose --profile development up -d --build
   ```

### Performance Optimization

1. **Multi-platform builds**:
   ```bash
   docker buildx build --platform linux/amd64,linux/arm64 -t delivergaz-frontend .
   ```

2. **Layer caching**:
   The Dockerfile is optimized for layer caching by copying pubspec files first.

3. **Build cache**:
   Development profile uses named volumes for Flutter and pub caches.

## Production Considerations

- Use production profile for live deployment
- Configure SSL certificates for HTTPS
- Set up proper logging and monitoring
- Consider using Docker Swarm or Kubernetes for scaling
- Implement proper backup strategies for any persistent data

## Integration with CI/CD

Example GitHub Actions workflow:

```yaml
- name: Build Docker image
  run: docker build -t delivergaz-frontend .

- name: Run tests in container
  run: docker run --rm delivergaz-frontend flutter test

- name: Deploy to production
  run: docker-compose --profile production up -d
```