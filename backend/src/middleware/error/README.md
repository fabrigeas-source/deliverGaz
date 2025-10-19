# Error Handling Middleware

A comprehensive error handling system for the DeliverGaz application, providing centralized error management, async operation handling, and consistent error responses.

## Overview

This module provides robust error handling capabilities for Express.js applications, including async function wrapping, global error handling, and standardized error responses. It handles various types of errors including validation errors, database errors, authentication failures, and custom application errors.

## Features

- 🔄 **Async Handler** - Automatic async/await error catching
- 🎯 **Global Error Handler** - Centralized error processing
- 🏷️ **Custom Error Types** - Structured error classification
- 📊 **Database Error Mapping** - MongoDB/Mongoose error handling
- 🔍 **Development Debug Info** - Stack traces in development mode
- 📝 **Consistent API Responses** - Standardized error format
- 🔒 **Security-First** - No sensitive data exposure in production

## Files Structure

```
middleware/error/
├── error.ts          # Main error handling middleware
├── error.test.ts     # Test suite
├── error.example.ts  # Usage examples
└── README.md         # Documentation (this file)
```

## Quick Start

### Basic Setup

```typescript
import express from 'express';
import { asyncHandler, errorHandler } from './middleware/error';

const app = express();

// Your routes with async handling
app.get('/api/users', asyncHandler(async (req, res) => {
  const users = await User.find();
  res.json({ success: true, data: users });
}));

// Global error handler (must be last middleware)
app.use(errorHandler);
```

## Core Components

### AsyncHandler

Wraps async route handlers to automatically catch and forward errors to the error handler.

```typescript
import { asyncHandler } from './middleware/error';

// Without asyncHandler (manual error handling)
app.get('/api/manual', async (req, res, next) => {
  try {
    const data = await someAsyncOperation();
    res.json({ success: true, data });
  } catch (error) {
    next(error);
  }
});

// With asyncHandler (automatic error handling)
app.get('/api/auto', asyncHandler(async (req, res) => {
  const data = await someAsyncOperation();
  res.json({ success: true, data });
}));
```

### Global Error Handler

Processes all errors and returns consistent JSON responses.

```typescript
import { errorHandler } from './middleware/error';

// Apply as the last middleware
app.use(errorHandler);
```

## Custom Error Classes

Create structured errors for different scenarios:

```typescript
class APIError extends Error {
  statusCode: number;
  isOperational: boolean;

  constructor(message: string, statusCode: number = 500, isOperational: boolean = true) {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = isOperational;
    this.name = 'APIError';
  }
}

// Usage
throw new APIError('Invalid user input', 400);
```

### Common Custom Errors

```typescript
class NotFoundError extends APIError {
  constructor(resource: string = 'Resource') {
    super(`${resource} not found`, 404);
  }
}

class UnauthorizedError extends APIError {
  constructor(message: string = 'Unauthorized access') {
    super(message, 401);
  }
}

class ValidationError extends APIError {
  constructor(message: string, errors: any[] = []) {
    super(message, 400);
    this.errors = errors;
  }
}

// Usage examples
throw new NotFoundError('User');
throw new UnauthorizedError('Invalid token');
throw new ValidationError('Validation failed', validationErrors);
```

## Error Response Format

All errors return a consistent JSON structure:

```json
{
  "success": false,
  "error": "Error message here",
  "stack": "Stack trace (development only)"
}
```

### Environment-Specific Responses

**Development Mode:**
```json
{
  "success": false,
  "error": "Database connection failed",
  "stack": "Error: Database connection failed\n    at DatabaseManager.connect (/app/db.js:15:11)..."
}
```

**Production Mode:**
```json
{
  "success": false,
  "error": "Database connection failed"
}
```

## Automatic Error Type Handling

The error handler automatically processes specific error types:

### MongoDB/Mongoose Errors

#### CastError (Invalid ObjectId)
```typescript
// Automatically converts to 404
// Input: CastError: Cast to ObjectId failed for value "invalid-id"
// Output: { success: false, error: "Resource not found" }
```

#### Duplicate Key Error
```typescript
// Automatically converts to 400
// Input: MongoError: E11000 duplicate key error
// Output: { success: false, error: "Duplicate field value entered" }
```

#### Validation Error
```typescript
// Automatically formats validation messages
// Input: ValidationError with multiple field errors
// Output: { success: false, error: "Email is required, Password must be at least 6 characters" }
```

## Usage Patterns

### Basic Route with Error Handling

```typescript
app.get('/api/users/:id', asyncHandler(async (req, res) => {
  const user = await User.findById(req.params.id);
  
  if (!user) {
    throw new NotFoundError('User');
  }
  
  res.json({ success: true, data: user });
}));
```

### Validation with Custom Errors

```typescript
app.post('/api/users', asyncHandler(async (req, res) => {
  const { email, password } = req.body;
  
  if (!email) {
    throw new ValidationError('Email is required');
  }
  
  if (password.length < 6) {
    throw new ValidationError('Password must be at least 6 characters');
  }
  
  const user = await User.create({ email, password });
  res.status(201).json({ success: true, data: user });
}));
```

### Authentication Middleware with Errors

```typescript
const authenticate = asyncHandler(async (req, res, next) => {
  const token = req.headers.authorization?.replace('Bearer ', '');
  
  if (!token) {
    throw new UnauthorizedError('Authentication token required');
  }
  
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    throw new UnauthorizedError('Invalid token');
  }
});
```

### Business Logic Errors

```typescript
app.post('/api/orders', asyncHandler(async (req, res) => {
  const { productId, quantity } = req.body;
  
  const product = await Product.findById(productId);
  if (!product) {
    throw new NotFoundError('Product');
  }
  
  if (product.stock < quantity) {
    throw new APIError('Insufficient stock available', 409);
  }
  
  if (quantity > product.maxOrderQuantity) {
    throw new APIError(`Maximum order quantity is ${product.maxOrderQuantity}`, 400);
  }
  
  const order = await Order.create({ productId, quantity });
  res.status(201).json({ success: true, data: order });
}));
```

## Error Categories and Status Codes

### Client Errors (4xx)

- **400 Bad Request** - Invalid input, validation errors
- **401 Unauthorized** - Authentication required
- **403 Forbidden** - Access denied
- **404 Not Found** - Resource not found
- **409 Conflict** - Resource conflict, duplicate data
- **413 Payload Too Large** - File size exceeded
- **415 Unsupported Media Type** - Invalid file type
- **429 Too Many Requests** - Rate limit exceeded

### Server Errors (5xx)

- **500 Internal Server Error** - Generic server error
- **502 Bad Gateway** - External service error
- **503 Service Unavailable** - Temporary service unavailability
- **504 Gateway Timeout** - External service timeout

## Best Practices

### Error Creation

```typescript
// ✅ Good: Specific, actionable error messages
throw new APIError('Email address is already registered', 409);

// ❌ Bad: Generic, unhelpful messages
throw new Error('Something went wrong');
```

### Error Logging

```typescript
// The error handler automatically logs errors
// Additional context can be added before throwing
console.error('User registration failed:', { email, timestamp: new Date() });
throw new APIError('Registration failed', 400);
```

### Error Recovery

```typescript
app.get('/api/users', asyncHandler(async (req, res) => {
  try {
    // Try primary database
    const users = await User.find();
    res.json({ success: true, data: users });
  } catch (primaryError) {
    try {
      // Fallback to cache
      const cachedUsers = await getFromCache('users');
      res.json({ 
        success: true, 
        data: cachedUsers,
        source: 'cache'
      });
    } catch (cacheError) {
      // Both failed, throw original error
      throw primaryError;
    }
  }
}));
```

## Testing Error Handling

### Unit Tests

```typescript
import request from 'supertest';
import app from '../app';

describe('Error Handling', () => {
  it('should return 404 for non-existent user', async () => {
    const response = await request(app)
      .get('/api/users/nonexistent-id')
      .expect(404);
    
    expect(response.body).toEqual({
      success: false,
      error: 'User not found'
    });
  });
  
  it('should return 400 for validation errors', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ email: 'invalid-email' })
      .expect(400);
    
    expect(response.body.success).toBe(false);
    expect(response.body.error).toContain('validation');
  });
});
```

### Integration Tests

```typescript
describe('Error Handler Integration', () => {
  it('should handle async errors properly', async () => {
    // Mock a service that throws
    jest.spyOn(UserService, 'create').mockRejectedValue(
      new APIError('Service unavailable', 503)
    );
    
    const response = await request(app)
      .post('/api/users')
      .send({ email: 'test@example.com', password: 'password123' })
      .expect(503);
    
    expect(response.body).toEqual({
      success: false,
      error: 'Service unavailable'
    });
  });
});
```

## Performance Considerations

### Error Object Creation

```typescript
// ✅ Efficient: Create error objects only when needed
if (condition) {
  throw new APIError('Condition failed', 400);
}

// ❌ Inefficient: Creating errors unnecessarily
const error = new APIError('Condition failed', 400);
if (condition) {
  throw error;
}
```

### Stack Trace Management

```typescript
// Stack traces are automatically excluded in production
// For development debugging, enable with:
process.env.NODE_ENV = 'development';
```

## Security Considerations

### Information Disclosure

```typescript
// ✅ Safe: Generic error messages in production
throw new APIError('Authentication failed', 401);

// ❌ Risky: Exposing internal details
throw new APIError('User password hash verification failed at bcrypt.compare', 401);
```

### Error Logging

```typescript
// ✅ Log detailed errors for debugging (server-side only)
console.error('Database error:', {
  error: error.message,
  stack: error.stack,
  query: query,
  timestamp: new Date()
});

// ✅ Return safe error to client
throw new APIError('Database operation failed', 500);
```

## Monitoring and Observability

### Error Tracking

```typescript
// Integration with error tracking services
const errorHandler = (err, req, res, next) => {
  // Log to monitoring service
  if (process.env.NODE_ENV === 'production') {
    // Sentry, Rollbar, etc.
    errorTracker.captureException(err, {
      user: req.user,
      url: req.url,
      method: req.method
    });
  }
  
  // Continue with standard error handling
  // ... rest of error handler logic
};
```

### Health Checks

```typescript
app.get('/health', asyncHandler(async (req, res) => {
  try {
    // Check critical services
    await db.ping();
    await redis.ping();
    
    res.json({ 
      success: true, 
      status: 'healthy',
      timestamp: new Date()
    });
  } catch (error) {
    throw new APIError('Service unhealthy', 503);
  }
}));
```

## Troubleshooting

### Common Issues

1. **Unhandled Promise Rejections**
   ```typescript
   // ✅ Always use asyncHandler or try/catch
   app.get('/api/data', asyncHandler(async (req, res) => {
     const data = await fetchData();
     res.json(data);
   }));
   ```

2. **Error Handler Not Catching Errors**
   ```typescript
   // ✅ Ensure error handler is the last middleware
   app.use('/api', routes);
   app.use(errorHandler); // Must be after all routes
   ```

3. **Headers Already Sent Errors**
   ```typescript
   // ✅ Don't send response after error
   if (error) {
     throw new APIError('Something failed', 400);
     // Don't call res.json() after throwing
   }
   ```

## Contributing

When extending the error handling system:

1. Create specific error classes for different scenarios
2. Use appropriate HTTP status codes
3. Provide clear, actionable error messages
4. Add comprehensive tests for new error types
5. Update documentation with examples
6. Consider security implications of error messages

## License

This error handling middleware is part of the DeliverGaz project and follows the project's licensing terms.