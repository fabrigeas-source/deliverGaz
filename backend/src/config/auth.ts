/**
 * Authentication configuration module
 */

export interface AuthConfig {
  jwt: {
    secret: string;
    expiresIn: string;
    refreshSecret: string;
    refreshExpiresIn: string;
  };
  bcrypt: {
    saltRounds: number;
  };
}

/**
 * Authentication configuration
 */
export const authConfig: AuthConfig = {
  jwt: {
    secret: process.env.JWT_SECRET || 'your_jwt_secret_key_change_in_production',
    expiresIn: process.env.JWT_EXPIRES_IN || '7d',
    refreshSecret: process.env.JWT_REFRESH_SECRET || 'your_refresh_secret_key_change_in_production',
    refreshExpiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '30d',
  },
  bcrypt: {
    saltRounds: parseInt(process.env.BCRYPT_SALT_ROUNDS || '12'),
  },
};

/**
 * Validate authentication configuration
 */
export const validateAuthConfig = (): boolean => {
  const isProduction = process.env.NODE_ENV === 'production';
  
  if (isProduction) {
    const hasStrongJwtSecret = authConfig.jwt.secret.length >= 32 && 
                               !authConfig.jwt.secret.includes('change_in_production');
    const hasStrongRefreshSecret = authConfig.jwt.refreshSecret.length >= 32 && 
                                   !authConfig.jwt.refreshSecret.includes('change_in_production');
    
    if (!hasStrongJwtSecret || !hasStrongRefreshSecret) {
      console.warn('⚠️  Weak JWT secrets detected in production environment');
      return false;
    }
  }
  
  return true;
};