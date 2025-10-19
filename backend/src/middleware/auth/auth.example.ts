/**
 * Auth Middleware Examples
 * Demonstrates how to use authentication and authorization middleware
 */

import express, { Request, Response, NextFunction } from 'express';
import {
  authenticateToken,
  optionalAuth,
  requireRole,
  requireAdmin,
  requireEmailVerification,
  requireOwnerOrAdmin,
  rateLimitByUser,
  generateTokens,
  AuthenticatedRequest
} from './auth';

const app = express();

/**
 * Example 1: Public Route (No Authentication Required)
 */
app.get('/api/public', (req: Request, res: Response) => {
  res.json({
    message: 'This is a public endpoint',
    timestamp: new Date().toISOString()
  });
});

/**
 * Example 2: Protected Route (Authentication Required)
 * Uses authenticateToken middleware to verify JWT token
 */
app.get('/api/protected', authenticateToken, (req: AuthenticatedRequest, res: Response) => {
  res.json({
    message: 'This is a protected endpoint',
    user: req.user,
    timestamp: new Date().toISOString()
  });
});

/**
 * Example 3: Optional Authentication
 * Route works for both authenticated and anonymous users
 */
app.get('/api/optional-auth', optionalAuth, (req: AuthenticatedRequest, res: Response) => {
  const isAuthenticated = !!req.user;
  
  res.json({
    message: isAuthenticated ? `Welcome back, ${req.user!.firstName}!` : 'Welcome, guest!',
    authenticated: isAuthenticated,
    user: req.user || null,
    timestamp: new Date().toISOString()
  });
});

/**
 * Example 4: Role-Based Access Control
 * Only admin and super_admin users can access this route
 */
app.get('/api/admin-only', 
  authenticateToken, 
  requireAdmin, 
  (req: AuthenticatedRequest, res: Response) => {
    res.json({
      message: 'This endpoint is only accessible by administrators',
      user: req.user,
      timestamp: new Date().toISOString()
    });
  }
);

/**
 * Example 5: Multiple Role Access
 * Only users with specific roles can access this route
 */
app.get('/api/delivery-agents', 
  authenticateToken, 
  requireRole('delivery_agent', 'admin', 'super_admin'), 
  (req: AuthenticatedRequest, res: Response) => {
    res.json({
      message: 'This endpoint is accessible by delivery agents and administrators',
      user: req.user,
      timestamp: new Date().toISOString()
    });
  }
);

/**
 * Example 6: Email Verification Required
 * Only users with verified email addresses can access this route
 */
app.post('/api/verified-users-only', 
  authenticateToken, 
  requireEmailVerification, 
  (req: AuthenticatedRequest, res: Response) => {
    res.json({
      message: 'This endpoint requires email verification',
      user: req.user,
      timestamp: new Date().toISOString()
    });
  }
);

/**
 * Example 7: Owner or Admin Access
 * Users can only access their own data, unless they are admin
 */
app.get('/api/users/:userId/profile', 
  authenticateToken, 
  requireOwnerOrAdmin('userId'), 
  (req: AuthenticatedRequest, res: Response) => {
    res.json({
      message: 'User profile data',
      userId: req.params.userId,
      requestedBy: req.user,
      timestamp: new Date().toISOString()
    });
  }
);

/**
 * Example 8: Rate Limiting by User
 * Limit requests per user (100 requests per 15 minutes)
 */
app.post('/api/rate-limited', 
  authenticateToken, 
  rateLimitByUser(100, 15 * 60 * 1000), 
  (req: AuthenticatedRequest, res: Response) => {
    res.json({
      message: 'This endpoint is rate limited per user',
      user: req.user,
      timestamp: new Date().toISOString()
    });
  }
);

/**
 * Example 9: Login Route (Token Generation)
 */
app.post('/api/auth/login', async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;
    
    // In real implementation, validate credentials against database
    // This is just a demonstration
    if (email === 'admin@example.com' && password === 'password123') {
      const tokens = generateTokens({
        userId: '507f1f77bcf86cd799439011',
        email,
        role: 'admin'
      });
      
      // Set refresh token as HTTP-only cookie
      res.cookie('refreshToken', tokens.refreshToken, {
        httpOnly: true,
        secure: process.env.NODE_ENV === 'production',
        sameSite: 'strict',
        maxAge: 7 * 24 * 60 * 60 * 1000 // 7 days
      });
      
      res.json({
        success: true,
        message: 'Login successful',
        accessToken: tokens.accessToken,
        user: {
          id: '507f1f77bcf86cd799439011',
          email,
          role: 'admin'
        }
      });
    } else {
      res.status(401).json({
        success: false,
        message: 'Invalid credentials'
      });
    }
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Login failed',
      error: process.env.NODE_ENV === 'development' ? (error as Error).message : undefined
    });
  }
});

/**
 * Example 10: Logout Route
 */
app.post('/api/auth/logout', authenticateToken, (req: AuthenticatedRequest, res: Response) => {
  // Clear refresh token cookie
  res.clearCookie('refreshToken');
  
  res.json({
    success: true,
    message: 'Logout successful'
  });
});

/**
 * Example 11: Multiple Middleware Chain
 * Demonstrates combining multiple auth middlewares
 */
app.put('/api/admin/users/:userId', 
  authenticateToken,           // Must be authenticated
  requireEmailVerification,    // Must have verified email
  requireAdmin,               // Must be admin
  rateLimitByUser(10, 60000), // Rate limit: 10 requests per minute
  (req: AuthenticatedRequest, res: Response) => {
    res.json({
      message: 'User updated successfully',
      updatedBy: req.user,
      targetUserId: req.params.userId,
      timestamp: new Date().toISOString()
    });
  }
);

/**
 * Example 12: Custom Authorization Logic
 */
const requireCustomPermission = (permission: string) => {
  return (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
    if (!req.user) {
      return res.status(401).json({
        success: false,
        message: 'Authentication required'
      });
    }
    
    // In real implementation, check user permissions from database
    const userPermissions = ['read_products', 'write_products']; // Mock permissions
    
    if (!userPermissions.includes(permission)) {
      return res.status(403).json({
        success: false,
        message: `Permission '${permission}' required`
      });
    }
    
    next();
  };
};

app.post('/api/products', 
  authenticateToken, 
  requireCustomPermission('write_products'), 
  (req: AuthenticatedRequest, res: Response) => {
    res.json({
      message: 'Product created successfully',
      createdBy: req.user,
      timestamp: new Date().toISOString()
    });
  }
);

/**
 * Example 13: Error Handling for Auth Middleware
 */
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  if (err.name === 'JsonWebTokenError') {
    return res.status(403).json({
      success: false,
      message: 'Invalid token'
    });
  }
  
  if (err.name === 'TokenExpiredError') {
    return res.status(401).json({
      success: false,
      message: 'Token expired'
    });
  }
  
  // Pass to default error handler
  next(err);
});

/**
 * Usage Examples in Different Scenarios:
 * 
 * 1. E-commerce API:
 *    - Public: Product listing, category browsing
 *    - Customer: Cart management, order history
 *    - Admin: Product management, user management
 * 
 * 2. Delivery App:
 *    - Public: Restaurant listing, menu viewing
 *    - Customer: Order placement, tracking
 *    - Delivery Agent: Order assignment, status updates
 *    - Admin: System monitoring, user management
 * 
 * 3. SaaS Application:
 *    - Public: Marketing pages, pricing
 *    - User: Dashboard, feature access
 *    - Admin: User management, billing
 *    - Super Admin: System configuration
 */

export default app;