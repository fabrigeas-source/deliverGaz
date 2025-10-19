import { Request, Response, NextFunction } from 'express';
import * as jwt from 'jsonwebtoken';
import { JwtPayload } from 'jsonwebtoken';
import { authConfig } from '../../config/auth';
// import { User } from '../models/User'; // TODO: Uncomment when User model is implemented

/**
 * User interface for mock service
 */
interface UserDocument {
  _id: string;
  email: string;
  firstName: string;
  lastName: string;
  role: string;
  status: 'active' | 'inactive' | 'banned';
  isEmailVerified: boolean;
}

/**
 * Mock User service - replace with actual User model when available
 */
const UserService = {
  async findById(id: string): Promise<UserDocument | null> {
    // TODO: Replace with actual User.findById when model is implemented
    // For now, return null to indicate user service is not implemented
    console.warn('⚠️  User model not implemented. Authentication will fail.');
    return null;
  }
};

/**
 * Extended Request interface with user information
 */
export interface AuthenticatedRequest extends Request {
  user?: {
    id: string;
    email: string;
    firstName: string;
    lastName: string;
    role: string;
    isEmailVerified: boolean;
  };
  token?: string;
}

/**
 * JWT Payload interface
 */
export interface JWTPayload extends JwtPayload {
  userId: string;
  email: string;
  role?: string;
  tokenType: 'access' | 'refresh';
}

/**
 * Authentication error types
 */
export class AuthError extends Error {
  constructor(
    message: string,
    public statusCode: number = 401,
    public code: string = 'AUTH_ERROR'
  ) {
    super(message);
    this.name = 'AuthError';
  }
}

/**
 * Extract token from Authorization header
 */
const extractToken = (req: Request): string | null => {
  const authHeader = req.headers.authorization;
  
  if (!authHeader) {
    return null;
  }

  // Support both "Bearer token" and "token" formats
  if (authHeader.startsWith('Bearer ')) {
    return authHeader.substring(7);
  }
  
  return authHeader;
};

/**
 * Verify JWT token
 */
const verifyToken = (token: string, secret: string): JWTPayload => {
  try {
    const decoded = jwt.verify(token, secret) as JWTPayload;
    
    if (!decoded.userId) {
      throw new AuthError('Invalid token payload', 401, 'INVALID_TOKEN');
    }
    
    return decoded;
  } catch (error) {
    if (error instanceof jwt.TokenExpiredError) {
      throw new AuthError('Token has expired', 401, 'TOKEN_EXPIRED');
    }
    
    if (error instanceof jwt.JsonWebTokenError) {
      throw new AuthError('Invalid token', 401, 'INVALID_TOKEN');
    }
    
    throw error;
  }
};

/**
 * Main authentication middleware
 * Verifies JWT token and attaches user info to request
 */
export const authenticateToken = async (
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    // Extract token from request
    const token = extractToken(req);
    
    if (!token) {
      res.status(401).json({
        success: false,
        message: 'Access token is required',
        error: {
          code: 'TOKEN_MISSING',
          type: 'AuthenticationError',
        },
      });
      return;
    }

    // Verify token
    const decoded = verifyToken(token, authConfig.jwt.secret);
    
    if (decoded.tokenType !== 'access') {
      res.status(401).json({
        success: false,
        message: 'Invalid token type',
        error: {
          code: 'INVALID_TOKEN_TYPE',
          type: 'AuthenticationError',
        },
      });
      return;
    }

    // Find user in database
    const user = await UserService.findById(decoded.userId);
    
    if (!user) {
      res.status(401).json({
        success: false,
        message: 'User not found',
        error: {
          code: 'USER_NOT_FOUND',
          type: 'AuthenticationError',
        },
      });
      return;
    }

    // Check if user account is active
    if (user.status === 'inactive' || user.status === 'banned') {
      res.status(403).json({
        success: false,
        message: 'Account is inactive',
        error: {
          code: 'ACCOUNT_INACTIVE',
          type: 'AuthenticationError',
        },
      });
      return;
    }

    // Attach user info to request
    req.user = {
      id: user._id?.toString() || decoded.userId,
      email: user.email || decoded.email,
      firstName: user.firstName || '',
      lastName: user.lastName || '',
      role: user.role || 'user',
      isEmailVerified: user.isEmailVerified || false,
    };
    
    req.token = token;

    next();
  } catch (error) {
    if (error instanceof AuthError) {
      res.status(error.statusCode).json({
        success: false,
        message: error.message,
        error: {
          code: error.code,
          type: 'AuthenticationError',
        },
      });
      return;
    }

    // Handle unexpected errors
    console.error('Authentication error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal authentication error',
      error: {
        code: 'INTERNAL_ERROR',
        type: 'AuthenticationError',
      },
    });
  }
};

/**
 * Optional authentication middleware
 * Attaches user info if token is present but doesn't require it
 */
export const optionalAuth = async (
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const token = extractToken(req);
    
    if (!token) {
      return next();
    }

    const decoded = verifyToken(token, authConfig.jwt.secret);
    
    if (decoded.tokenType === 'access') {
      const user = await UserService.findById(decoded.userId);
      
      if (user && user.status === 'active') {
        req.user = {
          id: user._id.toString(),
          email: user.email,
          firstName: user.firstName,
          lastName: user.lastName,
          role: user.role || 'user',
          isEmailVerified: user.isEmailVerified || false,
        };
        req.token = token;
      }
    }

    next();
  } catch (error) {
    // For optional auth, we continue even if token is invalid
    next();
  }
};

/**
 * Role-based authorization middleware
 */
export const requireRole = (...allowedRoles: string[]) => {
  return (req: AuthenticatedRequest, res: Response, next: NextFunction): void => {
    if (!req.user) {
      res.status(401).json({
        success: false,
        message: 'Authentication required',
        error: {
          code: 'AUTH_REQUIRED',
          type: 'AuthorizationError',
        },
      });
      return;
    }

    const userRole = req.user.role;
    
    if (!allowedRoles.includes(userRole)) {
      res.status(403).json({
        success: false,
        message: 'Insufficient permissions',
        error: {
          code: 'INSUFFICIENT_PERMISSIONS',
          type: 'AuthorizationError',
          details: {
            required: allowedRoles,
            current: userRole,
          },
        },
      });
      return;
    }

    next();
  };
};

/**
 * Email verification requirement middleware
 */
export const requireEmailVerification = (
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction
): void => {
  if (!req.user) {
    res.status(401).json({
      success: false,
      message: 'Authentication required',
      error: {
        code: 'AUTH_REQUIRED',
        type: 'AuthorizationError',
      },
    });
    return;
  }

  if (!req.user.isEmailVerified) {
    res.status(403).json({
      success: false,
      message: 'Email verification required',
      error: {
        code: 'EMAIL_NOT_VERIFIED',
        type: 'AuthorizationError',
      },
    });
    return;
  }

  next();
};

/**
 * Admin role requirement middleware
 */
export const requireAdmin = requireRole('admin', 'super_admin');

/**
 * Owner or admin access middleware
 * Allows access if user owns the resource or is admin
 */
export const requireOwnerOrAdmin = (userIdParam: string = 'userId') => {
  return (req: AuthenticatedRequest, res: Response, next: NextFunction): void => {
    if (!req.user) {
      res.status(401).json({
        success: false,
        message: 'Authentication required',
        error: {
          code: 'AUTH_REQUIRED',
          type: 'AuthorizationError',
        },
      });
      return;
    }

    const targetUserId = req.params[userIdParam] || req.body[userIdParam];
    const currentUserId = req.user.id;
    const userRole = req.user.role;

    // Allow if user is admin or super_admin
    if (['admin', 'super_admin'].includes(userRole)) {
      next();
      return;
    }

    // Allow if user is accessing their own resource
    if (targetUserId === currentUserId) {
      next();
      return;
    }

    res.status(403).json({
      success: false,
      message: 'Access denied. You can only access your own resources.',
      error: {
        code: 'ACCESS_DENIED',
        type: 'AuthorizationError',
      },
    });
  };
};

/**
 * Rate limiting by user ID
 */
export const rateLimitByUser = (maxRequests: number = 100, windowMs: number = 15 * 60 * 1000) => {
  const userRequests = new Map<string, { count: number; resetTime: number }>();

  return (req: AuthenticatedRequest, res: Response, next: NextFunction): void => {
    if (!req.user) {
      return next(); // Skip rate limiting for unauthenticated requests
    }

    const userId = req.user.id;
    const now = Date.now();
    const userLimit = userRequests.get(userId);

    if (!userLimit || now > userLimit.resetTime) {
      userRequests.set(userId, {
        count: 1,
        resetTime: now + windowMs,
      });
      return next();
    }

    if (userLimit.count >= maxRequests) {
      res.status(429).json({
        success: false,
        message: 'Too many requests. Please try again later.',
        error: {
          code: 'RATE_LIMIT_EXCEEDED',
          type: 'RateLimitError',
          retryAfter: Math.ceil((userLimit.resetTime - now) / 1000),
        },
      });
      return;
    }

    userLimit.count++;
    next();
  };
};

/**
 * JWT token generation utilities
 */
export const generateTokens = (payload: { userId: string; email: string; role?: string }) => {
  const accessTokenPayload = {
    ...payload,
    tokenType: 'access' as const,
  };

  const refreshTokenPayload = {
    ...payload,
    tokenType: 'refresh' as const,
  };

  // Ensure secrets are strings
  const jwtSecret = authConfig.jwt.secret as string;
  const refreshSecret = authConfig.jwt.refreshSecret as string;

  const accessToken = jwt.sign(accessTokenPayload, jwtSecret, {
    expiresIn: authConfig.jwt.expiresIn,
  } as jwt.SignOptions);

  const refreshToken = jwt.sign(refreshTokenPayload, refreshSecret, {
    expiresIn: authConfig.jwt.refreshExpiresIn,
  } as jwt.SignOptions);

  return {
    accessToken,
    refreshToken,
    expiresIn: authConfig.jwt.expiresIn,
  };
};

/**
 * Verify and decode refresh token
 */
export const verifyRefreshToken = (token: string): JWTPayload => {
  try {
    const decoded = jwt.verify(token, authConfig.jwt.refreshSecret) as JWTPayload;
    
    if (decoded.tokenType !== 'refresh') {
      throw new AuthError('Invalid refresh token type', 401, 'INVALID_TOKEN_TYPE');
    }
    
    return decoded;
  } catch (error) {
    if (error instanceof jwt.TokenExpiredError) {
      throw new AuthError('Refresh token has expired', 401, 'REFRESH_TOKEN_EXPIRED');
    }
    
    if (error instanceof jwt.JsonWebTokenError) {
      throw new AuthError('Invalid refresh token', 401, 'INVALID_REFRESH_TOKEN');
    }
    
    throw error;
  }
};