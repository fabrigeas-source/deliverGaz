@echo off
echo.
echo ========================================
echo   DeliverGaz Backend Startup Script
echo ========================================
echo.

echo [1/4] Checking Docker...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not installed or not in PATH
    echo Please install Docker Desktop from: https://www.docker.com/products/docker-desktop/
    pause
    exit /b 1
)

echo ✅ Docker is installed

echo [2/4] Checking if Docker is running...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Desktop is not running
    echo.
    echo Please start Docker Desktop:
    echo   1. Press Windows Key
    echo   2. Type "Docker Desktop"
    echo   3. Click to launch Docker Desktop
    echo   4. Wait for Docker to start (whale icon in system tray)
    echo   5. Run this script again
    echo.
    pause
    exit /b 1
)

echo ✅ Docker is running

echo [3/4] Starting MongoDB container...
docker ps -a --filter "name=delivergaz-mongo" --format "{{.Names}}" | findstr delivergaz-mongo >nul
if %errorlevel% equ 0 (
    echo MongoDB container exists, starting it...
    docker start delivergaz-mongo
) else (
    echo Creating new MongoDB container...
    docker run -d --name delivergaz-mongo -p 27017:27017 mongo:latest
)

if %errorlevel% neq 0 (
    echo ❌ Failed to start MongoDB container
    pause
    exit /b 1
)

echo ✅ MongoDB container is running

echo [4/4] Starting DeliverGaz Backend API...
echo.
echo 🚀 Starting the application...
echo 📊 API will be available at: http://localhost:3000
echo 📚 API Documentation: http://localhost:3000/api-docs
echo 🏥 Health Check: http://localhost:3000/health
echo.
echo Press Ctrl+C to stop the server
echo.

npm start