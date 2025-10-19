/**
 * Server configuration module
 */

export interface ServerConfig {
  port: number;
  nodeEnv: string;
  host: string;
  apiPrefix: string;
  enableSwagger: boolean;
}

/**
 * Server configuration
 */
export const serverConfig: ServerConfig = {
  port: parseInt(process.env.PORT || '3000'),
  nodeEnv: process.env.NODE_ENV || 'development',
  host: process.env.HOST || '0.0.0.0',
  apiPrefix: process.env.API_PREFIX || '/api',
  enableSwagger: process.env.ENABLE_SWAGGER !== 'false',
};

/**
 * Check if running in development mode
 */
export const isDevelopment = (): boolean => {
  return serverConfig.nodeEnv === 'development';
};

/**
 * Check if running in production mode
 */
export const isProduction = (): boolean => {
  return serverConfig.nodeEnv === 'production';
};

/**
 * Check if running in test mode
 */
export const isTest = (): boolean => {
  return serverConfig.nodeEnv === 'test';
};