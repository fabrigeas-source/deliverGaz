# Authentication & Authorization Middleware

A comprehensive authentication and authorization middleware system for the DeliverGaz application, built with Express.js and TypeScript.

## Overview

This module provides secure authentication and role-based authorization middleware for protecting API endpoints. It includes JWT token validation, role-based access control, email verification requirements, and rate limiting capabilities.

## Features

- 🔐 **JWT Authentication** - Secure token-based authentication
- 👥 **Role-Based Access Control (RBAC)** - Fine-grained permissions
- ✉️ **Email Verification** - Ensure verified user accounts
- ⚡ **Rate Limiting** - Prevent abuse and protect resources
- 🛡️ **Security Headers** - Enhanced security measures
- 🔄 **Refresh Tokens** - Secure token renewal mechanism
- 📝 **Comprehensive Logging** - Audit trail for security events

## Files Structure

```
middleware/auth/
├── auth.ts          # Main authentication middleware
└── README.md        # Documentation (this file)
```

## Recent Updates

- ✅ **Config Path Fix**: Updated import path for auth configuration
- ✅ **Modular Structure**: Clean separation of middleware concerns
- ✅ **Enhanced Security**: Improved JWT validation and error handling
- ✅ **Development Ready**: Works with mock services in development mode

## Quick Start

### Basic Authentication

```typescript
import { authenticateToken } from './middleware/auth';

// Protect a route with authentication
app.get('/api/protected', authenticateToken, (req, res) => {
  res.json({ message: 'Access granted', user: req.user });
});
```

### Role-Based Authorization

```typescript
import { authenticateToken, requireRole, requireAdmin } from './middleware/auth';

// Admin only route
app.get('/api/admin', authenticateToken, requireAdmin, (req, res) => {
  res.json({ message: 'Admin access granted' });
});

// Multiple roles
app.get('/api/staff', authenticateToken, requireRole('admin', 'manager'), (req, res) => {
  res.json({ message: 'Staff access granted' });
});
```

## Available Middleware Functions

### Core Authentication

#### `authenticateToken`
Validates JWT tokens and populates `req.user` with user information.

```typescript
app.get('/api/profile', authenticateToken, (req: AuthenticatedRequest, res) => {
  console.log(req.user); // { id, email, firstName, lastName, role, isEmailVerified }
});
```

#### `optionalAuth`
Attempts authentication but doesn't block access if token is missing.

```typescript
app.get('/api/posts', optionalAuth, (req: AuthenticatedRequest, res) => {
  const isAuthenticated = !!req.user;
  // Show personalized content if authenticated
});
```

### Authorization

#### `requireRole(...roles: string[])`
Restricts access to users with specific roles.

```typescript
// Single role
app.get('/api/delivery', authenticateToken, requireRole('delivery_agent'), handler);

// Multiple roles
app.get('/api/management', authenticateToken, requireRole('admin', 'super_admin'), handler);
```

#### `requireAdmin`
Shorthand for admin and super_admin roles.

```typescript
app.delete('/api/users/:id', authenticateToken, requireAdmin, handler);
```

#### `requireEmailVerification`
Ensures user has verified their email address.

```typescript
app.post('/api/orders', authenticateToken, requireEmailVerification, handler);
```

#### `requireOwnerOrAdmin(userIdParam: string)`
Allows access if user owns the resource or is an administrator.

```typescript
app.get('/api/users/:userId/orders', 
  authenticateToken, 
  requireOwnerOrAdmin('userId'), 
  handler
);
```

### Security & Rate Limiting

#### `rateLimitByUser(maxRequests: number, windowMs: number)`
Rate limiting per authenticated user.

```typescript
// 10 requests per minute per user
app.post('/api/upload', 
  authenticateToken, 
  rateLimitByUser(10, 60000), 
  handler
);
```

### Token Management

#### `generateTokens(payload: TokenPayload)`
Generates access and refresh token pair.

```typescript
const tokens = generateTokens({
  userId: user.id,
  email: user.email,
  role: user.role
});
```

#### `verifyRefreshToken(token: string)`
Validates refresh tokens for token renewal.

```typescript
try {
  const payload = verifyRefreshToken(refreshToken);
  // Generate new access token
} catch (error) {
  // Token invalid or expired
}
```

## User Roles

The system supports four user roles with hierarchical permissions:

- **`customer`** - Regular application users
- **`delivery_agent`** - Delivery personnel
- **`admin`** - System administrators
- **`super_admin`** - Full system access

## Configuration

Set these environment variables:

```env
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRATION=1h
REFRESH_TOKEN_SECRET=your-refresh-token-secret
REFRESH_TOKEN_EXPIRATION=7d
```

## Security Best Practices

### Token Security
- Use strong, unique secrets for JWT signing
- Implement token rotation for refresh tokens
- Store refresh tokens securely (HTTP-only cookies)
- Use short expiration times for access tokens

### API Security
- Always use HTTPS in production
- Implement rate limiting to prevent abuse
- Log authentication attempts for monitoring
- Validate all input data

### Role Management
- Follow principle of least privilege
- Regularly audit user permissions
- Implement role inheritance where appropriate
- Use resource-based permissions for fine-grained control

## Error Handling

The middleware provides consistent error responses:

```json
{
  "success": false,
  "message": "Descriptive error message",
  "code": "ERROR_CODE",
  "action": "suggested_action"
}
```

Common error codes:
- `TOKEN_MISSING` - No authorization header
- `TOKEN_INVALID` - Malformed or invalid token
- `TOKEN_EXPIRED` - Token has expired
- `INSUFFICIENT_PERMISSIONS` - User lacks required role
- `EMAIL_NOT_VERIFIED` - Email verification required
- `RATE_LIMIT_EXCEEDED` - Too many requests

## Testing

Run the test suite:

```bash
npm test middleware/auth
```

The test suite covers:
- Token validation and parsing
- Role-based access control
- Email verification checks
- Rate limiting functionality
- Error handling scenarios

## Performance Considerations

- Token verification is CPU-intensive; consider caching for high-traffic applications
- Use Redis for distributed rate limiting
- Implement token blacklisting for immediate revocation
- Monitor authentication performance metrics

## Integration Examples

### Express Router
```typescript
const router = express.Router();

// Apply authentication to all routes in this router
router.use(authenticateToken);

// Specific authorization for each route
router.get('/profile', (req, res) => { /* handler */ });
router.put('/profile', requireEmailVerification, (req, res) => { /* handler */ });
router.delete('/account', requireAdmin, (req, res) => { /* handler */ });
```

### Middleware Chaining
```typescript
app.put('/api/sensitive-operation',
  authenticateToken,           // Must be logged in
  requireEmailVerification,    // Must have verified email
  requireRole('admin'),        // Must be admin
  rateLimitByUser(5, 60000),  // Max 5 requests per minute
  validationMiddleware,        // Validate request data
  (req, res) => {
    // Your handler logic here
  }
);
```

## Troubleshooting

### Common Issues

1. **"Invalid token" errors**
   - Check JWT secret configuration
   - Verify token format (Bearer prefix)
   - Ensure clock synchronization

2. **Rate limiting issues**
   - Check Redis connection (if using distributed rate limiting)
   - Verify time window calculations
   - Monitor memory usage for in-memory rate limiting

3. **Role authorization failures**
   - Verify user role assignments in database
   - Check role hierarchy configuration
   - Ensure role names match exactly

## Contributing

When extending this middleware:

1. Follow the existing error handling patterns
2. Add comprehensive tests for new functionality
3. Update this documentation
4. Consider backward compatibility
5. Implement proper logging for security events

## License

This middleware is part of the DeliverGaz project and follows the project's licensing terms.