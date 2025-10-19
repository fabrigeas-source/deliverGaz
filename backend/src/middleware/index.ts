/**
 * Middleware Index
 * 
 * Central export point for all middleware modules in the DeliverGaz application.
 * This provides a clean API for importing middleware throughout the application.
 */

// Authentication and Authorization middleware
export * from './auth';

// Error handling middleware
export * from './error';

// Logging middleware
export * from './logger';

// Validation middleware
export * from './validation';

// Re-export commonly used middleware with convenient names
export { 
  authenticateToken,
  requireRole,
  requireAdmin,
  requireEmailVerification,
  optionalAuth
} from './auth';

export { 
  errorHandler,
  asyncHandler
} from './error';

export { 
  requestLogger
} from './logger';

export { 
  validateUserRegistration,
  validateUserLogin,
  validateProduct,
  validateOrder,
  validateCartItem
} from './validation';