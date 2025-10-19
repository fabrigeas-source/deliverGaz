# DeliverGaz API Testing Guide

Complete guide for testing the DeliverGaz backend API endpoints.

## 🚀 Getting Started

### Prerequisites
1. Start the development server: `npm run dev`
2. Server should be running at: http://localhost:3000
3. Swagger UI available at: http://localhost:3000/api-docs

### Testing Methods
- **🌐 Swagger UI** (Recommended) - Interactive testing
- **💻 PowerShell** - Command line testing  
- **🖥️ Browser** - Simple GET requests
- **📡 Postman/Insomnia** - Full-featured API client

## 🧪 Core Endpoint Testing

### 🏥 Health Check
```bash
# PowerShell
Invoke-RestMethod -Uri "http://localhost:3000/health" -Method GET

# curl
curl http://localhost:3000/health

# Browser: http://localhost:3000/health
```

**Expected Response:**
```json
{
  "success": true,
  "message": "DeliverGaz Backend API is running",
  "timestamp": "2025-10-12T11:15:56.000Z",
  "uptime": 1234.56,
  "environment": "development",
  "version": "1.0.0",
  "database": "disconnected",
  "endpoints": {
    "swagger": "/api-docs",
    "health": "/health",
    "api": "/api"
  }
}
```

### 📚 API Documentation
- **Interactive Docs**: http://localhost:3000/api-docs
- **Test directly in browser** with "Try it out" buttons
- **All endpoints documented** with request/response schemas

## 🔐 Authentication Endpoints

### 👤 User Registration
```bash
# PowerShell
$body = @{
    firstName = "John"
    lastName = "Doe"
    email = "john.doe@example.com"
    password = "SecurePass123!"
    phoneNumber = "+1234567890"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/api/auth/register" -Method POST -Body $body -ContentType "application/json"

# curl
curl -X POST "http://localhost:3000/api/auth/register" \
  -H "Content-Type: application/json" \
  -d '{"firstName":"John","lastName":"Doe","email":"john.doe@example.com","password":"SecurePass123!","phoneNumber":"+1234567890"}'
```

### 🔐 User Login
```bash
# PowerShell
$loginBody = @{
    email = "john.doe@example.com"
    password = "SecurePass123!"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "http://localhost:3000/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
$token = $response.data.token
Write-Host "JWT Token: $token"

# curl
curl -X POST "http://localhost:3000/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"john.doe@example.com","password":"SecurePass123!"}'
```

### � Get User Profile
```bash
# PowerShell (replace $token with your JWT)
$headers = @{ "Authorization" = "Bearer $token" }
Invoke-RestMethod -Uri "http://localhost:3000/api/auth/profile" -Method GET -Headers $headers

# curl
curl -X GET "http://localhost:3000/api/auth/profile" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## �📦 Product Endpoints

### Get All Products (Public)
```bash
# PowerShell - with pagination
Invoke-RestMethod -Uri "http://localhost:3000/api/products?page=1&limit=10" -Method GET

# curl - with filtering
curl "http://localhost:3000/api/products?page=1&limit=10&category=Gas Cylinders&search=15kg"

# Browser
# http://localhost:3000/api/products?page=1&limit=10
```

### Get Product by ID
```bash
# PowerShell
Invoke-RestMethod -Uri "http://localhost:3000/api/products/60d5ecb74f1a6b2f8c8b4567" -Method GET

# curl
curl "http://localhost:3000/api/products/60d5ecb74f1a6b2f8c8b4567"
```

### Create Product (Admin Only)
```bash
# PowerShell
$headers = @{ "Authorization" = "Bearer $adminToken"; "Content-Type" = "application/json" }
$productBody = @{
    name = "Gas Cylinder 15kg"
    description = "High-quality gas cylinder for cooking"
    price = 25.99
    category = "Gas Cylinders"
    stock = 100
    unit = "piece"
    images = @("image1.jpg", "image2.jpg")
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/api/products" -Method POST -Body $productBody -Headers $headers
```

## 🛒 Cart Endpoints

### Get User Cart
```bash
# PowerShell
$headers = @{ "Authorization" = "Bearer $token" }
Invoke-RestMethod -Uri "http://localhost:3000/api/cart" -Method GET -Headers $headers

# curl
curl -X GET "http://localhost:3000/api/cart" -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### Add Item to Cart
```bash
# PowerShell
$headers = @{ "Authorization" = "Bearer $token"; "Content-Type" = "application/json" }
$cartBody = @{
    productId = "60d5ecb74f1a6b2f8c8b4567"
    quantity = 2
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/api/cart/add" -Method POST -Body $cartBody -Headers $headers
```

### Update Cart Item Quantity
```bash
# PowerShell
$headers = @{ "Authorization" = "Bearer $token"; "Content-Type" = "application/json" }
$updateBody = @{ quantity = 3 } | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/api/cart/update/60d5ecb74f1a6b2f8c8b4567" -Method PUT -Body $updateBody -Headers $headers
```

### Remove Item from Cart
```bash
# PowerShell
$headers = @{ "Authorization" = "Bearer $token" }
Invoke-RestMethod -Uri "http://localhost:3000/api/cart/remove/60d5ecb74f1a6b2f8c8b4567" -Method DELETE -Headers $headers
```

### Clear Entire Cart
```bash
# PowerShell
$headers = @{ "Authorization" = "Bearer $token" }
Invoke-RestMethod -Uri "http://localhost:3000/api/cart/clear" -Method DELETE -Headers $headers
```

### Get Cart Count (Lightweight)
```bash
# PowerShell
$headers = @{ "Authorization" = "Bearer $token" }
Invoke-RestMethod -Uri "http://localhost:3000/api/cart/count" -Method GET -Headers $headers
```

## 📋 Order Endpoints

### Get User Orders
```bash
# PowerShell
$headers = @{ "Authorization" = "Bearer $token" }
Invoke-RestMethod -Uri "http://localhost:3000/api/orders?page=1&limit=10&sortBy=createdAt&sortOrder=desc" -Method GET -Headers $headers

# curl
curl "http://localhost:3000/api/orders?page=1&limit=10" -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### Get Order by ID
```bash
# PowerShell
$headers = @{ "Authorization" = "Bearer $token" }
Invoke-RestMethod -Uri "http://localhost:3000/api/orders/60d5ecb74f1a6b2f8c8b4567" -Method GET -Headers $headers
```

### Create Order from Cart
```bash
# PowerShell
$headers = @{ "Authorization" = "Bearer $token"; "Content-Type" = "application/json" }
$orderBody = @{
    deliveryAddress = @{
        street = "123 Main St"
        city = "New York"
        state = "NY"
        zipCode = "10001"
        country = "USA"
    }
    paymentMethod = "cash_on_delivery"
    notes = "Please call before delivery"
} | ConvertTo-Json -Depth 3

Invoke-RestMethod -Uri "http://localhost:3000/api/orders" -Method POST -Body $orderBody -Headers $headers
```

## 👥 User Management Endpoints

### Get All Users (Admin Only)
```bash
# PowerShell
$headers = @{ "Authorization" = "Bearer $adminToken" }
Invoke-RestMethod -Uri "http://localhost:3000/api/users" -Method GET -Headers $headers
```

### Get User by ID
```bash
# PowerShell
$headers = @{ "Authorization" = "Bearer $token" }
Invoke-RestMethod -Uri "http://localhost:3000/api/users/60d5ecb74f1a6b2f8c8b4567" -Method GET -Headers $headers
```

### Update User Profile
```bash
# PowerShell
$headers = @{ "Authorization" = "Bearer $token"; "Content-Type" = "application/json" }
$updateBody = @{
    firstName = "John Updated"
    lastName = "Doe Updated"
    phoneNumber = "+1234567890"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/api/users/60d5ecb74f1a6b2f8c8b4567" -Method PUT -Body $updateBody -Headers $headers
```

### Add User Address
```bash
# PowerShell
$headers = @{ "Authorization" = "Bearer $token"; "Content-Type" = "application/json" }
$addressBody = @{
    street = "456 Oak Ave"
    city = "Los Angeles"
    state = "CA"
    zipCode = "90210"
    country = "USA"
    isDefault = $false
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/api/users/60d5ecb74f1a6b2f8c8b4567/addresses" -Method POST -Body $addressBody -Headers $headers
```

## 🚨 Common Issues & Solutions

### ❌ 404 Error: "Endpoint not found"
**Problem**: Using double `/api` in URL
```bash
# Wrong: http://localhost:3000/api/api/products
# Correct: http://localhost:3000/api/products
```

### ❌ 401 Error: "Unauthorized"
**Problem**: Missing or invalid JWT token
```bash
# Make sure to include Authorization header:
-H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### ❌ Connection Refused
**Problem**: Server not running
```bash
# Start the server:
npm run dev
```

### ❌ Rate Limited
**Problem**: Too many requests
```bash
# Wait 15 minutes or restart server
# Rate limit: 100 requests per 15 minutes per IP
```

## 📊 Response Format

All API responses follow this consistent format:

### Success Response
```json
{
  "success": true,
  "message": "Operation completed successfully",
  "data": {
    // Response data here
  }
}
```

### Error Response
```json
{
  "success": false,
  "message": "Error description",
  "errors": [
    {
      "field": "fieldName",
      "message": "Field-specific error message"
    }
  ]
}
```

## 🔍 Development Features

- **✅ Mock Data**: Server returns sample data in development mode
- **✅ Hot Reload**: Server restarts automatically on file changes
- **✅ Detailed Logging**: Request/response logging in development
- **✅ Error Handling**: Comprehensive error messages
- **✅ Rate Limiting**: 100 requests per 15 minutes per IP
- **✅ CORS**: Cross-origin requests enabled for development
- **✅ Security Headers**: Helmet.js security middleware
- **✅ Request Logging**: All requests logged with timestamps
# PowerShell
Invoke-RestMethod -Uri "http://localhost:4000/api/products" -Method GET

# With authentication (after login)
$headers = @{ Authorization = "Bearer $token" }
Invoke-RestMethod -Uri "http://localhost:4000/api/products" -Method GET -Headers $headers
```

### 🛒 Cart Operations
```bash
# Add item to cart (requires authentication)
$cartBody = @{
    productId = "product_id_here"
    quantity = 2
} | ConvertTo-Json

$headers = @{ Authorization = "Bearer $token" }
Invoke-RestMethod -Uri "http://localhost:4000/api/cart/add" -Method POST -Body $cartBody -ContentType "application/json" -Headers $headers
```

### 📋 Create Order
```bash
# Create order from cart (requires authentication)
$orderBody = @{
    deliveryAddress = @{
        street = "123 Main Street"
        city = "New York"
        state = "NY"
        postalCode = "10001"
        country = "USA"
    }
    paymentMethod = "cash"
    notes = "Please call before delivery"
} | ConvertTo-Json -Depth 3

$headers = @{ Authorization = "Bearer $token" }
Invoke-RestMethod -Uri "http://localhost:4000/api/orders" -Method POST -Body $orderBody -ContentType "application/json" -Headers $headers
```

## 🔍 Testing Tips

1. **Use the Swagger UI**: Visit http://localhost:4000/api-docs for interactive testing
2. **Check Response Status**: Look for 200, 201, 400, 401, 500 status codes
3. **Save JWT Token**: After login, save the token for authenticated requests
4. **Test Error Cases**: Try invalid data to test error handling

## 🚀 Quick Test Sequence

1. Check health endpoint
2. Register a new user
3. Login with the user
4. Get products list
5. Add item to cart
6. Create an order

This will test the complete user flow!