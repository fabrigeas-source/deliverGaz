# API Documentation

## Table of Contents

1. [Overview](#overview)
2. [Authentication](#authentication)
3. [Base URL](#base-url)
4. [Response Format](#response-format)
5. [Error Handling](#error-handling)
6. [Rate Limiting](#rate-limiting)
7. [Endpoints](#endpoints)
   - [Authentication](#authentication-endpoints)
   - [Users](#users-endpoints)
   - [Products](#products-endpoints)
   - [Orders](#orders-endpoints)
   - [Cart](#cart-endpoints)

## Overview

The DeliverGaz API is a RESTful API that provides access to the gas delivery platform functionality. It supports JSON request and response bodies and uses standard HTTP response codes.

### API Version
Current API version: `v1`

### Content Type
All requests should include the following headers:
```
Content-Type: application/json
Accept: application/json
```

## Authentication

The API uses JWT (JSON Web Tokens) for authentication. Include the token in the Authorization header:

```
Authorization: Bearer <your-jwt-token>
```

### Token Expiration
- Access tokens expire after 24 hours
- Refresh tokens expire after 7 days

## Base URL

**Development**: `http://localhost:3000/api/v1`
**Production**: `https://api.delivergaz.com/api/v1`

## Response Format

All API responses follow this format:

### Success Response
```json
{
  "success": true,
  "data": {
    // Response data
  },
  "message": "Success message",
  "timestamp": "2025-10-11T10:30:00.000Z"
}
```

### Error Response
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Error description",
    "details": {}
  },
  "timestamp": "2025-10-11T10:30:00.000Z"
}
```

### Pagination Response
```json
{
  "success": true,
  "data": {
    "items": [],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 100,
      "pages": 10,
      "hasNext": true,
      "hasPrev": false
    }
  },
  "message": "Success message",
  "timestamp": "2025-10-11T10:30:00.000Z"
}
```

## Error Handling

### HTTP Status Codes

| Code | Description |
|------|-------------|
| 200  | OK - Request successful |
| 201  | Created - Resource created successfully |
| 400  | Bad Request - Invalid request format |
| 401  | Unauthorized - Authentication required |
| 403  | Forbidden - Insufficient permissions |
| 404  | Not Found - Resource not found |
| 409  | Conflict - Resource already exists |
| 422  | Unprocessable Entity - Validation error |
| 429  | Too Many Requests - Rate limit exceeded |
| 500  | Internal Server Error - Server error |

### Error Codes

| Code | Description |
|------|-------------|
| `VALIDATION_ERROR` | Request validation failed |
| `UNAUTHORIZED` | Authentication failed |
| `FORBIDDEN` | Access denied |
| `NOT_FOUND` | Resource not found |
| `DUPLICATE_RESOURCE` | Resource already exists |
| `SERVER_ERROR` | Internal server error |

## Rate Limiting

API endpoints are rate limited to prevent abuse:

- **General endpoints**: 100 requests per 15 minutes per IP
- **Authentication endpoints**: 5 requests per 15 minutes per IP
- **Order creation**: 10 requests per hour per user

Rate limit headers are included in responses:
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1635724800
```

## Endpoints

### Authentication Endpoints

#### POST /auth/register
Register a new user account.

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "securePassword123",
  "phone": "+1234567890",
  "address": "123 Main St, City, Country"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "user_id",
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "+1234567890",
      "role": "customer",
      "createdAt": "2025-10-11T10:30:00.000Z"
    },
    "tokens": {
      "accessToken": "jwt_access_token",
      "refreshToken": "jwt_refresh_token"
    }
  },
  "message": "User registered successfully"
}
```

#### POST /auth/login
Authenticate user and receive access tokens.

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "securePassword123"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "user_id",
      "name": "John Doe",
      "email": "john@example.com",
      "role": "customer"
    },
    "tokens": {
      "accessToken": "jwt_access_token",
      "refreshToken": "jwt_refresh_token"
    }
  },
  "message": "Login successful"
}
```

#### POST /auth/refresh
Refresh access token using refresh token.

**Request Body:**
```json
{
  "refreshToken": "jwt_refresh_token"
}
```

#### POST /auth/logout
Logout user and invalidate tokens.

**Headers:** `Authorization: Bearer <access_token>`

### Users Endpoints

#### GET /users/profile
Get current user profile.

**Headers:** `Authorization: Bearer <access_token>`

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "user_id",
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "+1234567890",
      "address": "123 Main St, City, Country",
      "role": "customer",
      "createdAt": "2025-10-11T10:30:00.000Z",
      "updatedAt": "2025-10-11T10:30:00.000Z"
    }
  }
}
```

#### PUT /users/profile
Update user profile.

**Headers:** `Authorization: Bearer <access_token>`

**Request Body:**
```json
{
  "name": "John Smith",
  "phone": "+1234567891",
  "address": "456 Oak St, City, Country"
}
```

### Products Endpoints

#### GET /products
Get list of products with pagination and filtering.

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 10, max: 50)
- `category` (optional): Filter by category
- `search` (optional): Search in product names and descriptions
- `minPrice` (optional): Minimum price filter
- `maxPrice` (optional): Maximum price filter
- `available` (optional): Filter by availability (true/false)

**Response:**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "product_id",
        "name": "Gas Cylinder 15kg",
        "description": "Standard 15kg gas cylinder",
        "price": 25.99,
        "category": "gas-cylinders",
        "image": "https://example.com/image.jpg",
        "available": true,
        "stock": 50,
        "createdAt": "2025-10-11T10:30:00.000Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 25,
      "pages": 3,
      "hasNext": true,
      "hasPrev": false
    }
  }
}
```

#### GET /products/:id
Get product by ID.

**Response:**
```json
{
  "success": true,
  "data": {
    "product": {
      "id": "product_id",
      "name": "Gas Cylinder 15kg",
      "description": "Standard 15kg gas cylinder with safety valve",
      "price": 25.99,
      "category": "gas-cylinders",
      "images": [
        "https://example.com/image1.jpg",
        "https://example.com/image2.jpg"
      ],
      "specifications": {
        "weight": "15kg",
        "material": "Steel",
        "capacity": "15L"
      },
      "available": true,
      "stock": 50,
      "createdAt": "2025-10-11T10:30:00.000Z"
    }
  }
}
```

### Orders Endpoints

#### POST /orders
Create a new order.

**Headers:** `Authorization: Bearer <access_token>`

**Request Body:**
```json
{
  "items": [
    {
      "productId": "product_id",
      "quantity": 2,
      "price": 25.99
    }
  ],
  "deliveryAddress": "123 Main St, City, Country",
  "paymentMethod": "cash",
  "notes": "Please call before delivery"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "order": {
      "id": "order_id",
      "orderNumber": "ORD-001",
      "userId": "user_id",
      "items": [
        {
          "productId": "product_id",
          "productName": "Gas Cylinder 15kg",
          "quantity": 2,
          "price": 25.99,
          "total": 51.98
        }
      ],
      "subtotal": 51.98,
      "deliveryFee": 5.00,
      "total": 56.98,
      "status": "pending",
      "deliveryAddress": "123 Main St, City, Country",
      "paymentMethod": "cash",
      "paymentStatus": "pending",
      "notes": "Please call before delivery",
      "createdAt": "2025-10-11T10:30:00.000Z"
    }
  },
  "message": "Order created successfully"
}
```

#### GET /orders
Get user's orders with pagination.

**Headers:** `Authorization: Bearer <access_token>`

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 10)
- `status` (optional): Filter by status

**Response:**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "order_id",
        "orderNumber": "ORD-001",
        "total": 56.98,
        "status": "delivered",
        "createdAt": "2025-10-11T10:30:00.000Z",
        "deliveredAt": "2025-10-11T15:30:00.000Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 5,
      "pages": 1,
      "hasNext": false,
      "hasPrev": false
    }
  }
}
```

#### GET /orders/:id
Get order details by ID.

**Headers:** `Authorization: Bearer <access_token>`

**Response:**
```json
{
  "success": true,
  "data": {
    "order": {
      "id": "order_id",
      "orderNumber": "ORD-001",
      "userId": "user_id",
      "items": [
        {
          "productId": "product_id",
          "productName": "Gas Cylinder 15kg",
          "quantity": 2,
          "price": 25.99,
          "total": 51.98
        }
      ],
      "subtotal": 51.98,
      "deliveryFee": 5.00,
      "total": 56.98,
      "status": "delivered",
      "deliveryAddress": "123 Main St, City, Country",
      "paymentMethod": "cash",
      "paymentStatus": "completed",
      "tracking": {
        "driverId": "driver_id",
        "driverName": "Mike Wilson",
        "estimatedDelivery": "2025-10-11T15:00:00.000Z",
        "currentLocation": {
          "latitude": 40.7128,
          "longitude": -74.0060
        }
      },
      "createdAt": "2025-10-11T10:30:00.000Z",
      "updatedAt": "2025-10-11T15:30:00.000Z"
    }
  }
}
```

### Cart Endpoints

#### GET /cart
Get user's cart.

**Headers:** `Authorization: Bearer <access_token>`

**Response:**
```json
{
  "success": true,
  "data": {
    "cart": {
      "userId": "user_id",
      "items": [
        {
          "productId": "product_id",
          "productName": "Gas Cylinder 15kg",
          "price": 25.99,
          "quantity": 2,
          "total": 51.98
        }
      ],
      "subtotal": 51.98,
      "itemCount": 2,
      "updatedAt": "2025-10-11T10:30:00.000Z"
    }
  }
}
```

#### POST /cart/items
Add item to cart.

**Headers:** `Authorization: Bearer <access_token>`

**Request Body:**
```json
{
  "productId": "product_id",
  "quantity": 1
}
```

#### PUT /cart/items/:productId
Update item quantity in cart.

**Headers:** `Authorization: Bearer <access_token>`

**Request Body:**
```json
{
  "quantity": 3
}
```

#### DELETE /cart/items/:productId
Remove item from cart.

**Headers:** `Authorization: Bearer <access_token>`

#### DELETE /cart
Clear entire cart.

**Headers:** `Authorization: Bearer <access_token>`

## Webhooks (Future Implementation)

Webhooks will be available for real-time notifications:
- Order status updates
- Payment confirmations
- Delivery notifications

## SDK and Libraries

- **JavaScript/Node.js**: `@delivergaz/api-client`
- **Flutter/Dart**: `delivergaz_api`
- **Postman Collection**: Available in the repository

## Support

For API support:
- **Email**: [api-support@delivergaz.com](mailto:api-support@delivergaz.com)
- **Documentation Issues**: Create an issue on GitHub
- **Status Page**: [status.delivergaz.com](https://status.delivergaz.com)