# Logger Middleware

A comprehensive logging system for the DeliverGaz application, providing request/response logging, structured logging, and performance monitoring capabilities.

## Overview

This module provides flexible logging middleware for Express.js applications, enabling detailed request tracking, response monitoring, and structured logging patterns. It supports both simple console logging and advanced structured logging for production environments.

## Features

- 📝 **Request/Response Logging** - Automatic HTTP request and response tracking
- ⏱️ **Response Time Monitoring** - Precise timing measurement
- 🏷️ **Structured Logging** - JSON-formatted log entries with metadata
- 🎯 **Log Levels** - Info, Warning, Error, and Debug levels
- 🔍 **Request Tracking** - Unique request IDs for tracing
- 📊 **Performance Monitoring** - Slow request detection
- 🛡️ **Security Logging** - Authentication and authorization events
- 🌍 **Environment Aware** - Different logging levels for dev/prod
- 📈 **Business Logic Logging** - Application-specific event tracking

## Files Structure

```
middleware/logger/
├── logger.ts          # Main logging middleware
├── logger.test.ts     # Test suite
├── logger.example.ts  # Usage examples
└── README.md          # Documentation (this file)
```

## Quick Start

### Basic Request Logging

```typescript
import express from 'express';
import { requestLogger } from './middleware/logger';

const app = express();

// Apply request logging to all routes
app.use(requestLogger);

app.get('/api/users', (req, res) => {
  res.json({ users: [] });
});
```

### Console Output
```
2024-01-01T12:00:00.000Z - GET /api/users - IP: 192.168.1.1
2024-01-01T12:00:00.150Z - GET /api/users - 200 - 150ms
```

## Core Components

### Basic Request Logger

The `requestLogger` middleware automatically logs all HTTP requests and responses:

```typescript
import { requestLogger } from './middleware/logger';

// Logs request start and completion
app.use(requestLogger);
```

**Log Format:**
- **Request:** `{timestamp} - {method} {url} - IP: {ip}`
- **Response:** `{timestamp} - {method} {url} - {statusCode} - {responseTime}ms`

### Enhanced Logger Class

For structured logging throughout your application:

```typescript
class Logger {
  static info(message: string, metadata?: any): void
  static warn(message: string, metadata?: any): void
  static error(message: string, error?: Error, metadata?: any): void
  static debug(message: string, metadata?: any): void
}
```

## Usage Patterns

### Basic HTTP Logging

```typescript
import { requestLogger } from './middleware/logger';

// Apply to all routes
app.use(requestLogger);

// Or apply to specific routes
app.use('/api', requestLogger);
app.use('/admin', requestLogger);
```

### Structured Application Logging

```typescript
import { Logger } from './middleware/logger';

app.get('/api/users/:id', async (req, res) => {
  const { id } = req.params;
  
  Logger.info('Fetching user', { userId: id });
  
  try {
    const user = await User.findById(id);
    
    if (!user) {
      Logger.warn('User not found', { requestedUserId: id });
      return res.status(404).json({ error: 'User not found' });
    }
    
    Logger.info('User retrieved successfully', { 
      userId: id,
      userEmail: user.email 
    });
    
    res.json({ success: true, data: user });
    
  } catch (error) {
    Logger.error('Database error during user fetch', error, { userId: id });
    res.status(500).json({ error: 'Internal server error' });
  }
});
```

### Performance Monitoring

```typescript
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

// Monitor requests slower than 2 seconds
app.use(performanceLogger(2000));
```

### Request Tracking with IDs

```typescript
const enhancedRequestLogger = (req: Request, res: Response, next: NextFunction) => {
  const requestId = Math.random().toString(36).substring(7);
  (req as any).requestId = requestId;
  
  Logger.info('Incoming request', {
    requestId,
    method: req.method,
    url: req.originalUrl,
    ip: req.ip,
    userAgent: req.get('User-Agent')
  });
  
  res.on('finish', () => {
    Logger.info('Request completed', {
      requestId,
      statusCode: res.statusCode,
      responseTime: Date.now() - start
    });
  });
  
  next();
};
```

## Log Levels and Output

### Info Level
Used for general application flow and successful operations:

```typescript
Logger.info('User login successful', {
  userId: user.id,
  email: user.email,
  loginTime: new Date()
});
```

Output:
```json
{
  "timestamp": "2024-01-01T12:00:00.000Z",
  "level": "info",
  "message": "User login successful",
  "metadata": {
    "userId": 123,
    "email": "user@example.com",
    "loginTime": "2024-01-01T12:00:00.000Z"
  }
}
```

### Warning Level
For handled errors, validation failures, or concerning events:

```typescript
Logger.warn('Invalid login attempt', {
  email: 'user@example.com',
  ip: req.ip,
  attemptCount: 3
});
```

### Error Level
For exceptions, system errors, and critical failures:

```typescript
Logger.error('Database connection failed', error, {
  operation: 'user-fetch',
  userId: 123,
  retryCount: 3
});
```

### Debug Level
For detailed debugging information (development only):

```typescript
Logger.debug('Processing order validation', {
  orderId: 123,
  validationRules: ['inventory', 'payment', 'shipping'],
  requestData: req.body
});
```

## Environment Configuration

### Development Mode
- All log levels enabled (including debug)
- Pretty-printed JSON output
- Detailed request/response information
- Stack traces included

```typescript
if (process.env.NODE_ENV === 'development') {
  app.use((req, res, next) => {
    Logger.debug('Detailed request info', {
      headers: req.headers,
      query: req.query,
      body: req.body
    });
    next();
  });
}
```

### Production Mode
- Info, warning, and error levels only
- Compact JSON output
- Essential information only
- No sensitive data in logs

```typescript
if (process.env.NODE_ENV === 'production') {
  // Minimal production logging
  app.use((req, res, next) => {
    Logger.info('Request', {
      method: req.method,
      url: req.originalUrl,
      ip: req.ip
    });
    next();
  });
}
```

## Specialized Logging Patterns

### Authentication Logging

```typescript
const authLogger = (req: Request, res: Response, next: NextFunction) => {
  const token = req.headers.authorization?.replace('Bearer ', '');
  
  if (!token) {
    Logger.warn('Authentication attempt without token', {
      ip: req.ip,
      url: req.originalUrl,
      userAgent: req.get('User-Agent')
    });
    return res.status(401).json({ error: 'Authentication required' });
  }
  
  // Token validation logic...
  
  Logger.info('Authentication successful', {
    userId: user.id,
    ip: req.ip,
    url: req.originalUrl
  });
  
  next();
};
```

### Business Logic Logging

```typescript
app.post('/api/orders', async (req, res) => {
  const { productId, quantity, userId } = req.body;
  const orderId = Date.now();
  
  Logger.info('Order processing started', {
    orderId,
    productId,
    quantity,
    userId
  });
  
  try {
    // Check inventory
    Logger.debug('Checking inventory', { productId, quantity });
    
    const product = await Product.findById(productId);
    if (product.stock < quantity) {
      Logger.warn('Order failed - insufficient inventory', {
        orderId,
        productId,
        requestedQuantity: quantity,
        availableQuantity: product.stock
      });
      
      return res.status(409).json({ error: 'Insufficient stock' });
    }
    
    // Process payment
    Logger.info('Processing payment', { orderId, userId });
    const paymentResult = await processPayment(userId, quantity * product.price);
    
    if (!paymentResult.success) {
      Logger.error('Payment processing failed', paymentResult.error, {
        orderId,
        userId,
        amount: quantity * product.price
      });
      
      return res.status(402).json({ error: 'Payment failed' });
    }
    
    // Create order
    const order = await Order.create({
      id: orderId,
      productId,
      quantity,
      userId,
      status: 'confirmed'
    });
    
    Logger.info('Order created successfully', {
      orderId: order.id,
      userId,
      status: order.status,
      totalAmount: quantity * product.price
    });
    
    res.status(201).json({ success: true, data: order });
    
  } catch (error) {
    Logger.error('Order processing failed', error, {
      orderId,
      productId,
      quantity,
      userId
    });
    
    res.status(500).json({ error: 'Order processing failed' });
  }
});
```

### File Upload Logging

```typescript
app.post('/api/upload', (req, res) => {
  const file = req.file;
  
  Logger.info('File upload started', {
    filename: file.originalname,
    size: file.size,
    mimetype: file.mimetype,
    userId: req.user?.id
  });
  
  try {
    // Validate file
    if (file.size > 5 * 1024 * 1024) {
      Logger.warn('File upload failed - file too large', {
        filename: file.originalname,
        size: file.size,
        maxSize: 5 * 1024 * 1024
      });
      
      return res.status(413).json({ error: 'File too large' });
    }
    
    // Process upload
    const result = await uploadFile(file);
    
    Logger.info('File uploaded successfully', {
      fileId: result.id,
      filename: result.filename,
      size: result.size,
      url: result.url,
      userId: req.user?.id
    });
    
    res.json({ success: true, data: result });
    
  } catch (error) {
    Logger.error('File upload error', error, {
      filename: file?.originalname,
      size: file?.size
    });
    
    res.status(500).json({ error: 'Upload failed' });
  }
});
```

## Log Analysis and Monitoring

### Log Format Structure

All structured logs follow this format:

```json
{
  "timestamp": "2024-01-01T12:00:00.000Z",
  "level": "info|warn|error|debug",
  "message": "Human-readable message",
  "metadata": {
    "key": "value",
    "nested": {
      "data": "allowed"
    }
  }
}
```

### Common Metadata Fields

- `requestId` - Unique identifier for request tracking
- `userId` - User associated with the action
- `ip` - Client IP address
- `userAgent` - Client user agent string
- `method` - HTTP method
- `url` - Request URL
- `statusCode` - HTTP status code
- `responseTime` - Request processing time in milliseconds
- `error` - Error object with name, message, and stack trace

### Log Aggregation

For production environments, consider using:

- **ELK Stack** (Elasticsearch, Logstash, Kibana)
- **Fluentd** for log collection
- **Winston** for more advanced logging features
- **Sentry** for error tracking
- **DataDog** or **New Relic** for APM

### Query Examples

Search for slow requests:
```json
{
  "query": {
    "bool": {
      "must": [
        { "term": { "level": "warn" } },
        { "term": { "message": "Slow request detected" } },
        { "range": { "metadata.responseTime": { "gte": 2000 } } }
      ]
    }
  }
}
```

Find authentication failures:
```json
{
  "query": {
    "bool": {
      "must": [
        { "term": { "level": "warn" } },
        { "wildcard": { "message": "*Authentication*" } }
      ]
    }
  }
}
```

## Best Practices

### Message Writing

```typescript
// ✅ Good: Clear, actionable messages
Logger.info('User profile updated successfully', { userId, changedFields });
Logger.warn('Rate limit exceeded for user', { userId, currentLimit, requestCount });
Logger.error('Database connection timeout', error, { operation: 'user-fetch', retryCount });

// ❌ Bad: Vague, unhelpful messages
Logger.info('Something happened');
Logger.warn('Warning');
Logger.error('Error occurred');
```

### Metadata Usage

```typescript
// ✅ Good: Relevant, structured metadata
Logger.info('Order placed', {
  orderId: 12345,
  userId: 67890,
  productId: 'abc123',
  quantity: 2,
  totalAmount: 59.98,
  paymentMethod: 'credit_card'
});

// ❌ Bad: Too much or irrelevant data
Logger.info('Order placed', {
  ...req.body,  // Potentially sensitive data
  ...req.headers,  // Too much noise
  serverMemory: process.memoryUsage()  // Irrelevant
});
```

### Performance Considerations

```typescript
// ✅ Efficient: Log only when necessary
if (process.env.NODE_ENV === 'development') {
  Logger.debug('Debug info', expensiveOperation());
}

// ✅ Efficient: Use appropriate log levels
Logger.info('Normal operation');  // Always logged
Logger.debug('Detailed debug');   // Only in development

// ❌ Inefficient: Expensive operations in production
Logger.info('User data', {
  user: await User.findById(id).populate('everything')  // Expensive query just for logging
});
```

### Security Considerations

```typescript
// ✅ Safe: No sensitive data
Logger.info('User login', {
  userId: user.id,
  email: user.email,
  loginTime: new Date()
});

// ❌ Risky: Sensitive data exposure
Logger.info('User login', {
  password: user.password,     // Never log passwords
  creditCard: user.creditCard, // Never log payment info
  ssn: user.ssn               // Never log PII
});
```

## Testing

### Unit Tests

```typescript
describe('Logger Middleware', () => {
  beforeEach(() => {
    jest.spyOn(console, 'log').mockImplementation();
  });

  it('should log request information', () => {
    const req = mockRequest();
    const res = mockResponse();
    
    requestLogger(req, res, mockNext);
    
    expect(console.log).toHaveBeenCalledWith(
      expect.stringContaining('GET /api/test - IP:')
    );
  });
});
```

### Integration Tests

```typescript
describe('Request Logging Integration', () => {
  it('should log complete request lifecycle', async () => {
    const response = await request(app)
      .get('/api/users')
      .expect(200);
    
    // Verify request log
    expect(mockLogger.info).toHaveBeenCalledWith(
      'Incoming request',
      expect.objectContaining({
        method: 'GET',
        url: '/api/users'
      })
    );
    
    // Verify response log
    expect(mockLogger.info).toHaveBeenCalledWith(
      'Request completed successfully',
      expect.objectContaining({
        statusCode: 200,
        responseTime: expect.any(Number)
      })
    );
  });
});
```

## Troubleshooting

### Common Issues

1. **Missing Request Logs**
   - Ensure middleware is applied before routes
   - Check if `next()` is called in middleware chain

2. **Performance Issues**
   - Reduce log level in production
   - Avoid expensive operations in log metadata
   - Consider async logging for high-traffic applications

3. **Log Format Issues**
   - Ensure JSON serializable metadata
   - Handle circular references in objects
   - Use structured logging consistently

## Advanced Features

### Log Rotation

```typescript
// For production, implement log rotation
import winston from 'winston';
import 'winston-daily-rotate-file';

const logger = winston.createLogger({
  transports: [
    new winston.transports.DailyRotateFile({
      filename: 'logs/application-%DATE%.log',
      datePattern: 'YYYY-MM-DD',
      maxSize: '20m',
      maxFiles: '14d'
    })
  ]
});
```

### Custom Log Formatters

```typescript
const customFormatter = (info: any) => {
  return `[${info.timestamp}] ${info.level.toUpperCase()}: ${info.message} ${
    info.metadata ? JSON.stringify(info.metadata) : ''
  }`;
};
```

## Contributing

When extending the logging system:

1. Follow established log level conventions
2. Include relevant metadata for debugging
3. Add tests for new logging functionality
4. Update documentation with examples
5. Consider performance impact of logging changes
6. Ensure security of logged data

## License

This logging middleware is part of the DeliverGaz project and follows the project's licensing terms.