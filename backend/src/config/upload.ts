/**
 * File upload configuration module
 */

export interface UploadConfig {
  path: string;
  maxFileSize: number;
  allowedFileTypes: string[];
  maxFiles: number;
  preserveFileName: boolean;
}

/**
 * File upload configuration
 */
export const uploadConfig: UploadConfig = {
  path: process.env.UPLOAD_PATH || 'uploads/',
  maxFileSize: parseInt(process.env.MAX_FILE_SIZE || '5242880'), // 5MB default
  allowedFileTypes: (process.env.ALLOWED_FILE_TYPES || 'jpg,jpeg,png,gif,webp,pdf').split(',').map(type => type.trim()),
  maxFiles: parseInt(process.env.MAX_FILES || '10'),
  preserveFileName: process.env.PRESERVE_FILE_NAME === 'true',
};

/**
 * Get maximum file size in human readable format
 */
export const getMaxFileSizeFormatted = (): string => {
  const sizeInMB = uploadConfig.maxFileSize / (1024 * 1024);
  return `${sizeInMB}MB`;
};

/**
 * Check if file type is allowed
 */
export const isFileTypeAllowed = (fileType: string): boolean => {
  return uploadConfig.allowedFileTypes.includes(fileType.toLowerCase());
};

/**
 * Get file extension from filename
 */
export const getFileExtension = (filename: string): string => {
  return filename.split('.').pop()?.toLowerCase() || '';
};