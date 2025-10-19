# DeliverGaz Backend Startup Script (PowerShell)
# This script will check prerequisites and start the backend API

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   DeliverGaz Backend Startup Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Function to check if a command exists
function Test-Command($command) {
    $null = Get-Command $command -ErrorAction SilentlyContinue
    return $?
}

# Step 1: Check Docker
Write-Host "[1/4] Checking Docker..." -ForegroundColor Yellow
if (-not (Test-Command "docker")) {
    Write-Host "❌ Docker is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Docker Desktop from: https://www.docker.com/products/docker-desktop/" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host "✅ Docker is installed" -ForegroundColor Green

# Step 2: Check if Docker is running
Write-Host "[2/4] Checking if Docker is running..." -ForegroundColor Yellow
try {
    docker info | Out-Null
    Write-Host "✅ Docker is running" -ForegroundColor Green
}
catch {
    Write-Host "❌ Docker Desktop is not running" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please start Docker Desktop:" -ForegroundColor Yellow
    Write-Host "  1. Press Windows Key" -ForegroundColor White
    Write-Host "  2. Type 'Docker Desktop'" -ForegroundColor White
    Write-Host "  3. Click to launch Docker Desktop" -ForegroundColor White
    Write-Host "  4. Wait for Docker to start (whale icon in system tray)" -ForegroundColor White
    Write-Host "  5. Run this script again" -ForegroundColor White
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

# Step 3: Start MongoDB container
Write-Host "[3/4] Starting MongoDB container..." -ForegroundColor Yellow
$containerExists = docker ps -a --filter "name=delivergaz-mongo" --format "{{.Names}}" | Select-String "delivergaz-mongo"

if ($containerExists) {
    Write-Host "MongoDB container exists, starting it..." -ForegroundColor Blue
    docker start delivergaz-mongo | Out-Null
} else {
    Write-Host "Creating new MongoDB container..." -ForegroundColor Blue
    docker run -d --name delivergaz-mongo -p 27017:27017 mongo:latest | Out-Null
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to start MongoDB container" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host "✅ MongoDB container is running" -ForegroundColor Green

# Step 4: Start the application
Write-Host "[4/4] Starting DeliverGaz Backend API..." -ForegroundColor Yellow
Write-Host ""
Write-Host "🚀 Starting the application..." -ForegroundColor Magenta
Write-Host "📊 API will be available at: http://localhost:3000" -ForegroundColor Cyan
Write-Host "📚 API Documentation: http://localhost:3000/api-docs" -ForegroundColor Cyan
Write-Host "🏥 Health Check: http://localhost:3000/health" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

# Start the Node.js application
npm start