/**
 * Security configuration module
 */

export interface SecurityConfig {
  cors: {
    origin: string[];
    credentials: boolean;
    methods: string[];
    allowedHeaders: string[];
  };
  rateLimit: {
    windowMs: number;
    maxRequests: number;
    message: string;
    standardHeaders: boolean;
    legacyHeaders: boolean;
  };
  helmet: {
    contentSecurityPolicy: boolean;
    crossOriginEmbedderPolicy: boolean;
  };
}

/**
 * Security configuration
 */
export const securityConfig: SecurityConfig = {
  cors: {
    origin: (process.env.CORS_ORIGIN || 'http://localhost:3000,http://localhost:8080').split(',').map(origin => origin.trim()),
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
  },
  rateLimit: {
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW || '900000'), // 15 minutes default
    maxRequests: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS || '100'),
    message: 'Too many requests from this IP, please try again later.',
    standardHeaders: true,
    legacyHeaders: false,
  },
  helmet: {
    contentSecurityPolicy: process.env.NODE_ENV === 'production',
    crossOriginEmbedderPolicy: process.env.NODE_ENV === 'production',
  },
};

/**
 * Get rate limit window in human readable format
 */
export const getRateLimitWindowFormatted = (): string => {
  const minutes = securityConfig.rateLimit.windowMs / (1000 * 60);
  return `${minutes} minutes`;
};

/**
 * Check if origin is allowed for CORS
 */
export const isOriginAllowed = (origin: string): boolean => {
  return securityConfig.cors.origin.includes(origin) || securityConfig.cors.origin.includes('*');
};