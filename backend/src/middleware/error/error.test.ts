import { Request, Response, NextFunction } from 'express';
import { asyncHandler, errorHandler } from './error';

// Mock Express types
const mockRequest = (overrides = {}) => ({
  method: 'GET',
  url: '/test',
  params: {},
  query: {},
  body: {},
  headers: {},
  ...overrides,
}) as Request;

const mockResponse = () => {
  const res = {} as Response;
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  res.send = jest.fn().mockReturnValue(res);
  return res;
};

const mockNext = jest.fn() as NextFunction;

// Custom error classes for testing
class CustomError extends Error {
  statusCode: number;
  isOperational: boolean;

  constructor(message: string, statusCode: number = 500, isOperational: boolean = true) {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = isOperational;
    this.name = 'CustomError';
  }
}

class CastError extends Error {
  constructor(message: string = 'Invalid ObjectId') {
    super(message);
    this.name = 'CastError';
  }
}

class ValidationError extends Error {
  errors: any;

  constructor(errors: any) {
    super('Validation failed');
    this.name = 'ValidationError';
    this.errors = errors;
  }
}

class MongoError extends Error {
  code: number;

  constructor(code: number = 11000) {
    super('MongoDB error');
    this.name = 'MongoError';
    this.code = code;
  }
}

describe('Error Middleware', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    // Mock console.error to prevent test output pollution
    jest.spyOn(console, 'error').mockImplementation(() => {});
  });

  afterEach(() => {
    jest.restoreAllMocks();
  });

  describe('asyncHandler', () => {
    it('should call next function for successful async operations', async () => {
      const mockAsyncFunction = jest.fn().mockResolvedValue('success');
      const wrappedFunction = asyncHandler(mockAsyncFunction);
      
      const req = mockRequest();
      const res = mockResponse();
      
      await wrappedFunction(req, res, mockNext);
      
      expect(mockAsyncFunction).toHaveBeenCalledWith(req, res, mockNext);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next with error for failed async operations', async () => {
      const testError = new Error('Async operation failed');
      const mockAsyncFunction = jest.fn().mockRejectedValue(testError);
      const wrappedFunction = asyncHandler(mockAsyncFunction);
      
      const req = mockRequest();
      const res = mockResponse();
      
      await wrappedFunction(req, res, mockNext);
      
      expect(mockAsyncFunction).toHaveBeenCalledWith(req, res, mockNext);
      expect(mockNext).toHaveBeenCalledWith(testError);
    });

    it('should handle synchronous errors in async functions', async () => {
      const testError = new Error('Sync error in async function');
      const mockAsyncFunction = jest.fn().mockImplementation(() => {
        throw testError;
      });
      const wrappedFunction = asyncHandler(mockAsyncFunction);
      
      const req = mockRequest();
      const res = mockResponse();
      
      await wrappedFunction(req, res, mockNext);
      
      expect(mockNext).toHaveBeenCalledWith(testError);
    });
  });

  describe('errorHandler', () => {
    it('should handle generic errors with default status 500', () => {
      const error = new Error('Generic error');
      const req = mockRequest();
      const res = mockResponse();
      
      errorHandler(error, req, res, mockNext);
      
      expect(res.status).toHaveBeenCalledWith(500);
      expect(res.json).toHaveBeenCalledWith({
        success: false,
        error: 'Generic error'
      });
    });

    it('should handle custom errors with specific status codes', () => {
      const error = new CustomError('Custom error message', 400);
      const req = mockRequest();
      const res = mockResponse();
      
      errorHandler(error, req, res, mockNext);
      
      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json).toHaveBeenCalledWith({
        success: false,
        error: 'Custom error message'
      });
    });

    it('should handle CastError (invalid ObjectId)', () => {
      const error = new CastError();
      const req = mockRequest();
      const res = mockResponse();
      
      errorHandler(error, req, res, mockNext);
      
      expect(res.status).toHaveBeenCalledWith(404);
      expect(res.json).toHaveBeenCalledWith({
        success: false,
        error: 'Resource not found'
      });
    });

    it('should handle MongoDB duplicate key errors', () => {
      const error = new MongoError(11000);
      const req = mockRequest();
      const res = mockResponse();
      
      errorHandler(error, req, res, mockNext);
      
      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json).toHaveBeenCalledWith({
        success: false,
        error: 'Duplicate field value entered'
      });
    });

    it('should handle ValidationError with field messages', () => {
      const validationErrors = {
        email: { message: 'Email is required' },
        password: { message: 'Password must be at least 6 characters' }
      };
      const error = new ValidationError(validationErrors);
      const req = mockRequest();
      const res = mockResponse();
      
      errorHandler(error, req, res, mockNext);
      
      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json).toHaveBeenCalledWith({
        success: false,
        error: 'Email is required, Password must be at least 6 characters'
      });
    });

    it('should include stack trace in development mode', () => {
      const originalEnv = process.env.NODE_ENV;
      process.env.NODE_ENV = 'development';
      
      const error = new Error('Test error');
      error.stack = 'Error stack trace';
      const req = mockRequest();
      const res = mockResponse();
      
      errorHandler(error, req, res, mockNext);
      
      expect(res.json).toHaveBeenCalledWith({
        success: false,
        error: 'Test error',
        stack: 'Error stack trace'
      });
      
      process.env.NODE_ENV = originalEnv;
    });

    it('should not include stack trace in production mode', () => {
      const originalEnv = process.env.NODE_ENV;
      process.env.NODE_ENV = 'production';
      
      const error = new Error('Test error');
      error.stack = 'Error stack trace';
      const req = mockRequest();
      const res = mockResponse();
      
      errorHandler(error, req, res, mockNext);
      
      expect(res.json).toHaveBeenCalledWith({
        success: false,
        error: 'Test error'
      });
      
      process.env.NODE_ENV = originalEnv;
    });

    it('should log errors to console', () => {
      const consoleSpy = jest.spyOn(console, 'error');
      const error = new Error('Test error for logging');
      const req = mockRequest();
      const res = mockResponse();
      
      errorHandler(error, req, res, mockNext);
      
      expect(consoleSpy).toHaveBeenCalledWith('Error:', error);
    });

    it('should handle errors without message', () => {
      const error = new Error();
      error.message = '';
      const req = mockRequest();
      const res = mockResponse();
      
      errorHandler(error, req, res, mockNext);
      
      expect(res.status).toHaveBeenCalledWith(500);
      expect(res.json).toHaveBeenCalledWith({
        success: false,
        error: 'Server Error'
      });
    });
  });

  describe('Error handling integration scenarios', () => {
    it('should work with asyncHandler and errorHandler together', async () => {
      const testError = new CustomError('Integration test error', 422);
      const mockAsyncFunction = jest.fn().mockRejectedValue(testError);
      const wrappedFunction = asyncHandler(mockAsyncFunction);
      
      const req = mockRequest();
      const res = mockResponse();
      
      // Simulate middleware chain
      await wrappedFunction(req, res, (error) => {
        errorHandler(error, req, res, mockNext);
      });
      
      expect(res.status).toHaveBeenCalledWith(422);
      expect(res.json).toHaveBeenCalledWith({
        success: false,
        error: 'Integration test error'
      });
    });

    it('should handle complex validation errors', () => {
      const complexValidationErrors = {
        'user.email': { message: 'Email format is invalid' },
        'user.profile.age': { message: 'Age must be a positive number' },
        'preferences.notifications': { message: 'Invalid notification preference' }
      };
      const error = new ValidationError(complexValidationErrors);
      const req = mockRequest();
      const res = mockResponse();
      
      errorHandler(error, req, res, mockNext);
      
      expect(res.status).toHaveBeenCalledWith(400);
      expect(res.json).toHaveBeenCalledWith({
        success: false,
        error: 'Email format is invalid, Age must be a positive number, Invalid notification preference'
      });
    });
  });
});