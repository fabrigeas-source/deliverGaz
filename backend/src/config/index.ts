/**
 * Configuration module exports
 * Central place to import all configuration modules
 */

// Main configuration
export { default as config, validateConfig } from './config';
export type { AppConfig } from './config';

// Individual configuration modules
export { databaseConfig, hasValidDatabaseConfig, getDatabaseUri } from './database';
export type { DatabaseConfig } from './database';

export { authConfig, validateAuthConfig } from './auth';
export type { AuthConfig } from './auth';

export { serverConfig, isDevelopment, isProduction, isTest } from './server';
export type { ServerConfig } from './server';

export { uploadConfig, getMaxFileSizeFormatted, isFileTypeAllowed, getFileExtension } from './upload';
export type { UploadConfig } from './upload';

export { securityConfig, getRateLimitWindowFormatted, isOriginAllowed } from './security';
export type { SecurityConfig } from './security';

export { swaggerConfig, swaggerSpec, swaggerUiOptions } from './swagger';
export type { SwaggerConfig } from './swagger';

// Re-export default config for backward compatibility
import config from './config';
export default config;