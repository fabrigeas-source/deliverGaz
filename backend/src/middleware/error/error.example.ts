/**
 * Error Middleware Examples
 * 
 * This file demonstrates comprehensive usage of error handling middleware
 * including asyncHandler, errorHandler, and custom error patterns.
 */

import express, { Request, Response, NextFunction } from 'express';
import { asyncHandler, errorHandler } from './error';

const app = express();

// ================================
// Custom Error Classes
// ================================

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

class ValidationError extends Error {
  statusCode: number;
  errors: any[];

  constructor(message: string, errors: any[] = []) {
    super(message);
    this.statusCode = 400;
    this.errors = errors;
    this.name = 'ValidationError';
  }
}

class NotFoundError extends APIError {
  constructor(resource: string = 'Resource') {
    super(`${resource} not found`, 404);
    this.name = 'NotFoundError';
  }
}

class UnauthorizedError extends APIError {
  constructor(message: string = 'Unauthorized access') {
    super(message, 401);
    this.name = 'UnauthorizedError';
  }
}

class ForbiddenError extends APIError {
  constructor(message: string = 'Forbidden access') {
    super(message, 403);
    this.name = 'ForbiddenError';
  }
}

class ConflictError extends APIError {
  constructor(message: string = 'Resource conflict') {
    super(message, 409);
    this.name = 'ConflictError';
  }
}

// ================================
// Basic Usage Examples
// ================================

// Example 1: Simple async route with error handling
app.get('/api/basic-async', asyncHandler(async (req: Request, res: Response) => {
  // Simulate async operation that might fail
  const shouldFail = req.query.fail === 'true';
  
  if (shouldFail) {
    throw new APIError('Simulated async error', 400);
  }
  
  // Simulate async database operation
  await new Promise(resolve => setTimeout(resolve, 100));
  
  res.json({
    success: true,
    message: 'Async operation completed successfully',
    data: { timestamp: new Date().toISOString() }
  });
}));

// Example 2: Route with database simulation and error handling
app.get('/api/users/:id', asyncHandler(async (req: Request, res: Response) => {
  const { id } = req.params;
  
  // Simulate invalid ObjectId (CastError)
  if (id === 'invalid-id') {
    const error = new Error('Cast to ObjectId failed');
    error.name = 'CastError';
    throw error;
  }
  
  // Simulate user not found
  if (id === '999') {
    throw new NotFoundError('User');
  }
  
  // Simulate successful user retrieval
  const user = {
    id,
    name: 'John Doe',
    email: 'john@example.com'
  };
  
  res.json({
    success: true,
    data: user
  });
}));

// ================================
// Validation Error Examples
// ================================

// Example 3: Route with validation errors
app.post('/api/users', asyncHandler(async (req: Request, res: Response) => {
  const { email, password, age } = req.body;
  
  // Simulate validation errors
  const errors: any = {};
  
  if (!email) {
    errors.email = { message: 'Email is required' };
  } else if (!email.includes('@')) {
    errors.email = { message: 'Email format is invalid' };
  }
  
  if (!password) {
    errors.password = { message: 'Password is required' };
  } else if (password.length < 6) {
    errors.password = { message: 'Password must be at least 6 characters long' };
  }
  
  if (age && (age < 0 || age > 120)) {
    errors.age = { message: 'Age must be between 0 and 120' };
  }
  
  if (Object.keys(errors).length > 0) {
    const validationError = new Error('Validation failed');
    validationError.name = 'ValidationError';
    (validationError as any).errors = errors;
    throw validationError;
  }
  
  // Simulate duplicate email (MongoDB duplicate key error)
  if (email === 'duplicate@example.com') {
    const mongoError = new Error('E11000 duplicate key error');
    mongoError.name = 'MongoError';
    (mongoError as any).code = 11000;
    throw mongoError;
  }
  
  res.status(201).json({
    success: true,
    message: 'User created successfully',
    data: { id: Date.now(), email, age }
  });
}));

// ================================
// Custom Error Handling Examples
// ================================

// Example 4: Authentication middleware with custom errors
const simulateAuth = (req: Request, res: Response, next: NextFunction) => {
  const token = req.headers.authorization?.replace('Bearer ', '');
  
  if (!token) {
    throw new UnauthorizedError('Authentication token is required');
  }
  
  if (token === 'invalid-token') {
    throw new UnauthorizedError('Invalid authentication token');
  }
  
  if (token === 'expired-token') {
    throw new UnauthorizedError('Authentication token has expired');
  }
  
  // Simulate successful authentication
  (req as any).user = { id: 1, email: 'user@example.com', role: 'user' };
  next();
};

// Example 5: Authorization middleware
const requireAdmin = (req: Request, res: Response, next: NextFunction) => {
  const user = (req as any).user;
  
  if (!user) {
    throw new UnauthorizedError('Authentication required');
  }
  
  if (user.role !== 'admin') {
    throw new ForbiddenError('Admin access required');
  }
  
  next();
};

// Protected admin route
app.get('/api/admin/users', 
  asyncHandler(simulateAuth),
  asyncHandler(requireAdmin),
  asyncHandler(async (req: Request, res: Response) => {
    res.json({
      success: true,
      message: 'Admin access granted',
      data: [
        { id: 1, email: 'user1@example.com' },
        { id: 2, email: 'user2@example.com' }
      ]
    });
  })
);

// ================================
// File Upload Error Examples
// ================================

// Example 6: File upload with size and type validation
app.post('/api/upload', asyncHandler(async (req: Request, res: Response) => {
  // Simulate file validation
  const file = req.body.file;
  
  if (!file) {
    throw new ValidationError('File is required');
  }
  
  // Simulate file size check (5MB limit)
  if (file.size > 5 * 1024 * 1024) {
    throw new APIError('File size exceeds 5MB limit', 413);
  }
  
  // Simulate file type validation
  const allowedTypes = ['image/jpeg', 'image/png', 'image/gif'];
  if (!allowedTypes.includes(file.type)) {
    throw new APIError('Invalid file type. Only JPEG, PNG, and GIF are allowed', 415);
  }
  
  res.json({
    success: true,
    message: 'File uploaded successfully',
    data: { filename: file.name, size: file.size }
  });
}));

// ================================
// Rate Limiting Error Examples
// ================================

// Example 7: Rate limiting simulation
const rateLimitStore = new Map();

const rateLimit = (maxRequests: number, windowMs: number) => {
  return (req: Request, res: Response, next: NextFunction) => {
    const clientId = req.ip || 'unknown';
    const now = Date.now();
    const windowStart = now - windowMs;
    
    // Get or create client record
    let clientRequests = rateLimitStore.get(clientId) || [];
    
    // Remove old requests outside the window
    clientRequests = clientRequests.filter((time: number) => time > windowStart);
    
    // Check if limit exceeded
    if (clientRequests.length >= maxRequests) {
      throw new APIError('Too many requests, please try again later', 429);
    }
    
    // Add current request
    clientRequests.push(now);
    rateLimitStore.set(clientId, clientRequests);
    
    next();
  };
};

// Rate limited endpoint
app.get('/api/limited', 
  asyncHandler(rateLimit(5, 60000)), // 5 requests per minute
  asyncHandler(async (req: Request, res: Response) => {
    res.json({
      success: true,
      message: 'Rate limited endpoint accessed successfully'
    });
  })
);

// ================================
// Database Connection Error Examples
// ================================

// Example 8: Database connection simulation
app.get('/api/database-test', asyncHandler(async (req: Request, res: Response) => {
  const testType = req.query.test as string;
  
  switch (testType) {
    case 'connection-error':
      throw new APIError('Database connection failed', 503);
    
    case 'timeout':
      throw new APIError('Database operation timed out', 504);
    
    case 'constraint-violation':
      throw new ConflictError('Database constraint violation');
    
    case 'deadlock':
      throw new APIError('Database deadlock detected, please retry', 409);
    
    default:
      res.json({
        success: true,
        message: 'Database connection successful',
        data: { status: 'connected', latency: '2ms' }
      });
  }
}));

// ================================
// Business Logic Error Examples
// ================================

// Example 9: E-commerce business logic errors
app.post('/api/orders', asyncHandler(async (req: Request, res: Response) => {
  const { productId, quantity, userId } = req.body;
  
  // Simulate various business logic errors
  if (productId === 'out-of-stock') {
    throw new ConflictError('Product is currently out of stock');
  }
  
  if (quantity > 10) {
    throw new APIError('Maximum quantity per order is 10', 400);
  }
  
  if (userId === 'suspended') {
    throw new ForbiddenError('Your account is suspended and cannot place orders');
  }
  
  if (productId === 'discontinued') {
    throw new APIError('This product has been discontinued', 410);
  }
  
  res.status(201).json({
    success: true,
    message: 'Order created successfully',
    data: {
      orderId: Date.now(),
      productId,
      quantity,
      status: 'pending'
    }
  });
}));

// ================================
// External API Error Examples
// ================================

// Example 10: Third-party service integration errors
app.get('/api/external-service', asyncHandler(async (req: Request, res: Response) => {
  const serviceType = req.query.service as string;
  
  // Simulate external service errors
  switch (serviceType) {
    case 'payment-gateway':
      throw new APIError('Payment gateway is temporarily unavailable', 503);
    
    case 'shipping-api':
      throw new APIError('Shipping API rate limit exceeded', 429);
    
    case 'inventory-service':
      throw new APIError('Inventory service authentication failed', 502);
    
    case 'notification-service':
      // This would be a non-critical error that shouldn't fail the main operation
      console.warn('Notification service unavailable, continuing without notifications');
      break;
    
    default:
      break;
  }
  
  res.json({
    success: true,
    message: 'External service integration successful',
    data: { service: serviceType || 'default', status: 'success' }
  });
}));

// ================================
// Development vs Production Error Handling
// ================================

// Example 11: Environment-specific error responses
app.get('/api/environment-test', asyncHandler(async (req: Request, res: Response) => {
  throw new Error('This error will show different information based on environment');
}));

// ================================
// Error Recovery Examples
// ================================

// Example 12: Graceful error recovery
app.get('/api/retry-example', asyncHandler(async (req: Request, res: Response) => {
  const attemptNumber = parseInt(req.query.attempt as string) || 1;
  
  if (attemptNumber < 3) {
    throw new APIError(`Temporary failure (attempt ${attemptNumber})`, 503);
  }
  
  res.json({
    success: true,
    message: 'Operation succeeded after retry',
    data: { attempt: attemptNumber }
  });
}));

// ================================
// Global Error Handler Registration
// ================================

// Apply the global error handler (this should be the last middleware)
app.use(errorHandler);

// 404 handler for unmatched routes
app.use('*', (req: Request, res: Response) => {
  throw new NotFoundError(`Route ${req.originalUrl} not found`);
});

// ================================
// Usage Instructions
// ================================

/*
To test these examples, run the server and make requests to:

1. Basic async error:
   GET /api/basic-async?fail=true

2. CastError simulation:
   GET /api/users/invalid-id

3. Not found error:
   GET /api/users/999

4. Validation errors:
   POST /api/users
   Body: { "email": "invalid", "password": "123" }

5. Duplicate key error:
   POST /api/users
   Body: { "email": "duplicate@example.com", "password": "password123" }

6. Unauthorized error:
   GET /api/admin/users
   (without Authorization header)

7. File upload error:
   POST /api/upload
   Body: { "file": { "size": 10000000, "type": "text/plain" } }

8. Rate limiting:
   GET /api/limited
   (make more than 5 requests within a minute)

9. Database errors:
   GET /api/database-test?test=connection-error

10. Business logic errors:
    POST /api/orders
    Body: { "productId": "out-of-stock", "quantity": 1, "userId": "user123" }

11. External service errors:
    GET /api/external-service?service=payment-gateway

12. Environment-specific errors:
    GET /api/environment-test

13. Retry example:
    GET /api/retry-example?attempt=1
    GET /api/retry-example?attempt=3

14. 404 error:
    GET /api/nonexistent-route
*/

export { app };
export default app;