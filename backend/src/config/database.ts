/**
 * Database configuration module
 */

export interface DatabaseConfig {
  uri: string;
  name: string;
  options: {
    retryWrites: boolean;
    w: string;
    appName: string;
  };
}

/**
 * Database connection configuration
 */
export const databaseConfig: DatabaseConfig = {
  uri: process.env.MONGODB_URI || 'mongodb+srv://fabrigeas:<db_password>@delivergaz.lvonzed.mongodb.net/?retryWrites=true&w=majority&appName=deliverGaz',
  name: process.env.DB_NAME || 'delivergaz',
  options: {
    retryWrites: true,
    w: 'majority',
    appName: 'deliverGaz',
  },
};

/**
 * Check if database URI has placeholder
 */
export const hasValidDatabaseConfig = (): boolean => {
  return !!(databaseConfig.uri && !databaseConfig.uri.includes('<db_password>'));
};

/**
 * Get processed database URI with password replacement
 */
export const getDatabaseUri = (): string => {
  if (!databaseConfig.uri) {
    throw new Error('Database URI is not configured');
  }

  // Replace password placeholder if needed
  if (databaseConfig.uri.includes('<db_password>') && process.env.DB_PASSWORD) {
    return databaseConfig.uri.replace('<db_password>', process.env.DB_PASSWORD);
  }

  return databaseConfig.uri;
};