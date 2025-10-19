/**
 * Logger Middleware Examples
 * 
 * This file demonstrates comprehensive usage of logging middleware
 * including request logging, response logging, and custom logging patterns.
 */

import express, { Request, Response, NextFunction } from 'express';
import { requestLogger } from './logger';

const app = express();

// ================================
// Enhanced Logger Implementations
// ================================

// Interface for structured logging
interface LogEntry {
  timestamp: string;
  level: 'info' | 'warn' | 'error' | 'debug';
  method?: string;
  url?: string;
  statusCode?: number;
  responseTime?: number;
  ip?: string;
  userAgent?: string;
  userId?: string;
  message: string;
  metadata?: any;
}

// Enhanced logger class
class Logger {
  private static formatLog(entry: LogEntry): string {
    return JSON.stringify(entry, null, 2);
  }

  static info(message: string, metadata?: any) {
    const entry: LogEntry = {
      timestamp: new Date().toISOString(),
      level: 'info',
      message,
      metadata
    };
    console.log(this.formatLog(entry));
  }

  static warn(message: string, metadata?: any) {
    const entry: LogEntry = {
      timestamp: new Date().toISOString(),
      level: 'warn',
      message,
      metadata
    };
    console.warn(this.formatLog(entry));
  }

  static error(message: string, error?: Error, metadata?: any) {
    const entry: LogEntry = {
      timestamp: new Date().toISOString(),
      level: 'error',
      message,
      metadata: {
        ...metadata,
        error: error ? {
          name: error.name,
          message: error.message,
          stack: error.stack
        } : undefined
      }
    };
    console.error(this.formatLog(entry));
  }

  static debug(message: string, metadata?: any) {
    if (process.env.NODE_ENV === 'development') {
      const entry: LogEntry = {
        timestamp: new Date().toISOString(),
        level: 'debug',
        message,
        metadata
      };
      console.debug(this.formatLog(entry));
    }
  }
}

// ================================
// Advanced Request Logger
// ================================

// Enhanced request logger with more details
const enhancedRequestLogger = (req: Request, res: Response, next: NextFunction) => {
  const start = Date.now();
  const requestId = Math.random().toString(36).substring(7);
  
  // Add request ID to request object for tracking
  (req as any).requestId = requestId;
  
  // Extract user information if available
  const userId = (req as any).user?.id || 'anonymous';
  const userAgent = req.get('User-Agent') || 'unknown';
  
  // Log incoming request with detailed information
  Logger.info('Incoming request', {
    requestId,
    method: req.method,
    url: req.originalUrl,
    ip: req.ip,
    userAgent,
    userId,
    headers: req.headers,
    query: req.query,
    ...(req.method !== 'GET' && { body: req.body })
  });
  
  // Log response when finished
  res.on('finish', () => {
    const duration = Date.now() - start;
    const logLevel = res.statusCode >= 400 ? 'warn' : 'info';
    
    const logMessage = res.statusCode >= 400 ? 'Request completed with error' : 'Request completed successfully';
    
    Logger[logLevel](logMessage, {
      requestId,
      method: req.method,
      url: req.originalUrl,
      statusCode: res.statusCode,
      responseTime: duration,
      ip: req.ip,
      userId
    });
  });
  
  next();
};

// ================================
// Middleware Usage Examples
// ================================

// Apply basic request logger globally
app.use(requestLogger);

// Apply enhanced logger selectively
app.use('/api', enhancedRequestLogger);

// ================================
// Route Examples with Logging
// ================================

// Example 1: Basic route with automatic logging
app.get('/api/basic', (req: Request, res: Response) => {
  Logger.info('Processing basic request');
  
  res.json({
    success: true,
    message: 'Basic endpoint accessed',
    timestamp: new Date().toISOString()
  });
});

// Example 2: Route with custom logging
app.get('/api/users/:id', (req: Request, res: Response) => {
  const { id } = req.params;
  
  Logger.info('Fetching user', { userId: id });
  
  // Simulate user lookup
  if (id === '404') {
    Logger.warn('User not found', { requestedUserId: id });
    return res.status(404).json({
      success: false,
      error: 'User not found'
    });
  }
  
  const user = {
    id,
    name: 'John Doe',
    email: 'john@example.com'
  };
  
  Logger.info('User retrieved successfully', { 
    userId: id,
    userEmail: user.email 
  });
  
  res.json({
    success: true,
    data: user
  });
});

// Example 3: Route with error logging
app.post('/api/users', (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;
    
    Logger.info('Creating new user', { email });
    
    // Simulate validation
    if (!email || !password) {
      Logger.warn('User creation failed - missing required fields', {
        hasEmail: !!email,
        hasPassword: !!password
      });
      
      return res.status(400).json({
        success: false,
        error: 'Email and password are required'
      });
    }
    
    // Simulate duplicate email check
    if (email === 'duplicate@example.com') {
      Logger.warn('User creation failed - duplicate email', { email });
      
      return res.status(409).json({
        success: false,
        error: 'Email already exists'
      });
    }
    
    // Simulate user creation
    const newUser = {
      id: Date.now(),
      email,
      createdAt: new Date().toISOString()
    };
    
    Logger.info('User created successfully', {
      userId: newUser.id,
      email: newUser.email
    });
    
    res.status(201).json({
      success: true,
      data: newUser
    });
    
  } catch (error) {
    Logger.error('Unexpected error during user creation', error as Error, {
      requestBody: req.body
    });
    
    res.status(500).json({
      success: false,
      error: 'Internal server error'
    });
  }
});

// ================================
// Performance Logging Examples
// ================================

// Performance monitoring middleware
const performanceLogger = (threshold: number = 1000) => {
  return (req: Request, res: Response, next: NextFunction) => {
    const start = Date.now();
    
    res.on('finish', () => {
      const duration = Date.now() - start;
      
      if (duration > threshold) {
        Logger.warn('Slow request detected', {
          method: req.method,
          url: req.originalUrl,
          responseTime: duration,
          threshold,
          statusCode: res.statusCode
        });
      }
    });
    
    next();
  };
};

// Apply performance monitoring
app.use(performanceLogger(2000)); // Warn for requests > 2 seconds

// Example slow endpoint
app.get('/api/slow', (req: Request, res: Response) => {
  Logger.info('Processing slow endpoint');
  
  // Simulate slow operation
  setTimeout(() => {
    Logger.info('Slow operation completed');
    res.json({
      success: true,
      message: 'Slow operation completed',
      processingTime: '3 seconds'
    });
  }, 3000);
});

// ================================
// Business Logic Logging Examples
// ================================

// Example 4: E-commerce order processing with detailed logging
app.post('/api/orders', (req: Request, res: Response) => {
  const { productId, quantity, userId } = req.body;
  const orderId = Date.now();
  
  Logger.info('Order processing started', {
    orderId,
    productId,
    quantity,
    userId
  });
  
  try {
    // Simulate inventory check
    Logger.debug('Checking inventory', { productId, quantity });
    
    if (productId === 'out-of-stock') {
      Logger.warn('Order failed - insufficient inventory', {
        orderId,
        productId,
        requestedQuantity: quantity,
        availableQuantity: 0
      });
      
      return res.status(409).json({
        success: false,
        error: 'Product out of stock'
      });
    }
    
    // Simulate payment processing
    Logger.info('Processing payment', { orderId, userId });
    
    if (userId === 'payment-failed') {
      Logger.error('Payment processing failed', new Error('Payment declined'), {
        orderId,
        userId,
        amount: quantity * 29.99
      });
      
      return res.status(402).json({
        success: false,
        error: 'Payment failed'
      });
    }
    
    // Simulate order creation
    Logger.info('Creating order record', { orderId });
    
    const order = {
      id: orderId,
      productId,
      quantity,
      userId,
      status: 'confirmed',
      createdAt: new Date().toISOString()
    };
    
    Logger.info('Order created successfully', {
      orderId: order.id,
      userId,
      status: order.status,
      totalAmount: quantity * 29.99
    });
    
    res.status(201).json({
      success: true,
      data: order
    });
    
  } catch (error) {
    Logger.error('Order processing failed', error as Error, {
      orderId,
      productId,
      quantity,
      userId
    });
    
    res.status(500).json({
      success: false,
      error: 'Order processing failed'
    });
  }
});

// ================================
// Authentication Logging Examples
// ================================

// Authentication middleware with logging
const authLogger = (req: Request, res: Response, next: NextFunction) => {
  const token = req.headers.authorization?.replace('Bearer ', '');
  const ip = req.ip;
  
  if (!token) {
    Logger.warn('Authentication attempt without token', {
      ip,
      url: req.originalUrl,
      userAgent: req.get('User-Agent')
    });
    
    return res.status(401).json({
      success: false,
      error: 'Authentication required'
    });
  }
  
  // Simulate token validation
  if (token === 'invalid-token') {
    Logger.warn('Authentication failed - invalid token', {
      ip,
      url: req.originalUrl,
      tokenPrefix: token.substring(0, 10) + '...'
    });
    
    return res.status(401).json({
      success: false,
      error: 'Invalid token'
    });
  }
  
  // Simulate successful authentication
  const user = { id: 123, email: 'user@example.com' };
  (req as any).user = user;
  
  Logger.info('Authentication successful', {
    userId: user.id,
    userEmail: user.email,
    ip,
    url: req.originalUrl
  });
  
  next();
};

// Protected route with authentication logging
app.get('/api/protected', authLogger, (req: Request, res: Response) => {
  const user = (req as any).user;
  
  Logger.info('Protected resource accessed', {
    userId: user.id,
    resource: req.originalUrl
  });
  
  res.json({
    success: true,
    message: 'Protected resource accessed',
    user: user
  });
});

// ================================
// File Upload Logging Examples
// ================================

// File upload logging
app.post('/api/upload', (req: Request, res: Response) => {
  const file = req.body.file; // Simulated file object
  
  Logger.info('File upload started', {
    filename: file?.name,
    size: file?.size,
    type: file?.type,
    userId: (req as any).user?.id
  });
  
  try {
    // Simulate file validation
    if (!file) {
      Logger.warn('File upload failed - no file provided');
      return res.status(400).json({
        success: false,
        error: 'No file provided'
      });
    }
    
    if (file.size > 5 * 1024 * 1024) { // 5MB
      Logger.warn('File upload failed - file too large', {
        filename: file.name,
        size: file.size,
        maxSize: 5 * 1024 * 1024
      });
      
      return res.status(413).json({
        success: false,
        error: 'File too large'
      });
    }
    
    // Simulate successful upload
    const uploadResult = {
      id: Date.now(),
      filename: file.name,
      size: file.size,
      url: `/uploads/${file.name}`,
      uploadedAt: new Date().toISOString()
    };
    
    Logger.info('File uploaded successfully', {
      fileId: uploadResult.id,
      filename: uploadResult.filename,
      size: uploadResult.size,
      userId: (req as any).user?.id
    });
    
    res.json({
      success: true,
      data: uploadResult
    });
    
  } catch (error) {
    Logger.error('File upload error', error as Error, {
      filename: file?.name,
      size: file?.size
    });
    
    res.status(500).json({
      success: false,
      error: 'Upload failed'
    });
  }
});

// ================================
// Health Check Logging
// ================================

// Health check with service status logging
app.get('/health', (req: Request, res: Response) => {
  Logger.info('Health check requested');
  
  const services = {
    database: 'healthy',
    redis: 'healthy',
    externalApi: 'healthy'
  };
  
  // Simulate service checks
  const simulate = req.query.simulate as string;
  
  if (simulate === 'db-error') {
    services.database = 'unhealthy';
    Logger.error('Database health check failed', new Error('Connection timeout'));
  }
  
  if (simulate === 'redis-error') {
    services.redis = 'unhealthy';
    Logger.error('Redis health check failed', new Error('Connection refused'));
  }
  
  const isHealthy = Object.values(services).every(status => status === 'healthy');
  const statusCode = isHealthy ? 200 : 503;
  
  Logger.info('Health check completed', {
    status: isHealthy ? 'healthy' : 'unhealthy',
    services,
    statusCode
  });
  
  res.status(statusCode).json({
    success: isHealthy,
    status: isHealthy ? 'healthy' : 'unhealthy',
    services,
    timestamp: new Date().toISOString()
  });
});

// ================================
// Development vs Production Logging
// ================================

// Environment-specific logging configuration
if (process.env.NODE_ENV === 'development') {
  // Enable detailed logging in development
  app.use((req: Request, res: Response, next: NextFunction) => {
    Logger.debug('Development mode - detailed request info', {
      method: req.method,
      url: req.originalUrl,
      headers: req.headers,
      query: req.query,
      body: req.body,
      cookies: req.cookies
    });
    next();
  });
} else {
  // Production logging - minimal but essential
  app.use((req: Request, res: Response, next: NextFunction) => {
    Logger.info('Request processed', {
      method: req.method,
      url: req.originalUrl,
      ip: req.ip,
      userAgent: req.get('User-Agent')
    });
    next();
  });
}

// ================================
// Usage Instructions
// ================================

/*
To test these logging examples, run the server and make requests to:

1. Basic logging:
   GET /api/basic

2. User operations with custom logging:
   GET /api/users/123
   GET /api/users/404 (triggers not found warning)
   POST /api/users with { "email": "test@example.com", "password": "password123" }

3. Error logging:
   POST /api/users with invalid data
   POST /api/users with { "email": "duplicate@example.com", "password": "password123" }

4. Performance logging:
   GET /api/slow (will trigger slow request warning)

5. Business logic logging:
   POST /api/orders with { "productId": "123", "quantity": 2, "userId": "user123" }
   POST /api/orders with { "productId": "out-of-stock", "quantity": 1, "userId": "user123" }

6. Authentication logging:
   GET /api/protected (without Authorization header)
   GET /api/protected with Authorization: Bearer invalid-token
   GET /api/protected with Authorization: Bearer valid-token

7. File upload logging:
   POST /api/upload with file data

8. Health check logging:
   GET /health
   GET /health?simulate=db-error

Check your console output to see the structured logs with different levels and metadata.
*/

export { app, Logger, enhancedRequestLogger, performanceLogger };
export default app;