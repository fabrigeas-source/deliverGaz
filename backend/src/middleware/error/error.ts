import { Request, Response, NextFunction } from 'express';

// Error handling types
interface ApiError extends Error {
  statusCode?: number;
  isOperational?: boolean;
}

// Async handler wrapper with proper typing
type AsyncMiddleware = (req: Request, res: Response, next: NextFunction) => unknown | Promise<unknown>;
export const asyncHandler = (fn: AsyncMiddleware) => (req: Request, res: Response, next: NextFunction) => {
  return Promise.resolve()
    .then(() => fn(req, res, next))
    .catch(next);
};

// Global error handler
export const errorHandler = (err: ApiError, req: Request, res: Response, _next: NextFunction) => {
  let error = { ...err };
  error.message = err.message;

  // Log error
  console.error('Error:', err);

  // Mongoose bad ObjectId
  if (err.name === 'CastError') {
    const message = 'Resource not found';
    error = { name: 'CastError', message, statusCode: 404 } as ApiError;
  }

  // Mongoose duplicate key
  if (
    err.name === 'MongoError' &&
    typeof (err as { code?: unknown }).code === 'number' &&
    (err as { code?: number }).code === 11000
  ) {
    const message = 'Duplicate field value entered';
    error = { name: 'MongoError', message, statusCode: 400 } as ApiError;
  }

  // Mongoose validation error
  if (err.name === 'ValidationError') {
    type FieldErr = { message: string };
    const errs = (err as { errors?: Record<string, FieldErr> }).errors;
    const message = errs
      ? Object.values(errs).map((val) => val.message).join(', ')
      : 'Validation error';
    error = { name: 'ValidationError', message, statusCode: 400 } as ApiError;
  }

  res.status(error.statusCode || 500).json({
    success: false,
    error: error.message || 'Server Error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
  });
};

export default errorHandler;
