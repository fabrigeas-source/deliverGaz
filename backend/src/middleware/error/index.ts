/**
 * Error Handling Middleware
 * 
 * This module exports all error handling middleware functions
 * for the DeliverGaz application.
 */

// Re-export all error handling functions
export * from './error';

// Also export as default for convenience
export { errorHandler as default } from './error';