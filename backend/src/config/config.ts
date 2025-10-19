import 'dotenv/config';
import { databaseConfig } from './database';
import { authConfig } from './auth';
import { serverConfig } from './server';
import { uploadConfig } from './upload';
import { securityConfig } from './security';

/**
 * Main application configuration
 * Aggregates all configuration modules
 */
export interface AppConfig {
  database: typeof databaseConfig;
  auth: typeof authConfig;
  server: typeof serverConfig;
  upload: typeof uploadConfig;
  security: typeof securityConfig;
}

/**
 * Centralized configuration object
 */
const config: AppConfig = {
  database: databaseConfig,
  auth: authConfig,
  server: serverConfig,
  upload: uploadConfig,
  security: securityConfig,
};

/**
 * Environment validation
 */
export const validateConfig = (): void => {
  const requiredEnvVars = [
    'JWT_SECRET',
    'JWT_REFRESH_SECRET',
  ];

  const missingVars = requiredEnvVars.filter(varName => !process.env[varName]);
  
  if (missingVars.length > 0) {
    console.warn(`⚠️  Missing environment variables: ${missingVars.join(', ')}`);
    console.warn('⚠️  Using default values for development');
  }

  if (config.server.nodeEnv === 'production' && missingVars.length > 0) {
    throw new Error(`Missing required environment variables: ${missingVars.join(', ')}`);
  }
};

// Validate configuration on import
validateConfig();

export default config;
