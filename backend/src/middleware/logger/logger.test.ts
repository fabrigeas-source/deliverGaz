import { Request, Response, NextFunction } from 'express';
import { requestLogger } from './logger';

// Mock console methods
const originalConsoleLog = console.log;
const mockConsoleLog = jest.fn();

// Mock Express types
const mockRequest = (overrides = {}) => ({
  method: 'GET',
  originalUrl: '/api/test',
  url: '/api/test',
  ip: '192.168.1.1',
  headers: {},
  query: {},
  params: {},
  body: {},
  ...overrides,
}) as Request;

const mockResponse = () => {
  const res = {} as Response;
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  res.send = jest.fn().mockReturnValue(res);
  res.on = jest.fn();
  res.statusCode = 200;
  return res;
};

const mockNext = jest.fn() as NextFunction;

describe('Logger Middleware', () => {
  beforeEach(() => {
    jest.clearAllMocks();
    console.log = mockConsoleLog;
    jest.useFakeTimers();
    jest.setSystemTime(new Date('2024-01-01T12:00:00.000Z'));
  });

  afterEach(() => {
    console.log = originalConsoleLog;
    jest.useRealTimers();
  });

  describe('requestLogger', () => {
    it('should log incoming request information', () => {
      const req = mockRequest({
        method: 'POST',
        originalUrl: '/api/users',
        ip: '127.0.0.1'
      });
      const res = mockResponse();

      requestLogger(req, res, mockNext);

      expect(mockConsoleLog).toHaveBeenCalledWith(
        '2024-01-01T12:00:00.000Z - POST /api/users - IP: 127.0.0.1'
      );
      expect(mockNext).toHaveBeenCalled();
    });

    it('should log response information when response finishes', () => {
      const req = mockRequest({
        method: 'GET',
        originalUrl: '/api/products',
        ip: '192.168.1.100'
      });
      const res = mockResponse();
      res.statusCode = 404;

      // Mock res.on to capture the finish callback
      let finishCallback: Function;
      res.on = jest.fn().mockImplementation((event, callback) => {
        if (event === 'finish') {
          finishCallback = callback;
        }
      });

      requestLogger(req, res, mockNext);

      // Clear the initial request log
      mockConsoleLog.mockClear();

      // Simulate response completion after 150ms
      jest.advanceTimersByTime(150);
      finishCallback();

      expect(mockConsoleLog).toHaveBeenCalledWith(
        '2024-01-01T12:00:00.150Z - GET /api/products - 404 - 150ms'
      );
    });

    it('should handle different HTTP methods', () => {
      const methods = ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'];
      
      methods.forEach(method => {
        mockConsoleLog.mockClear();
        
        const req = mockRequest({
          method,
          originalUrl: `/api/test-${method.toLowerCase()}`,
          ip: '10.0.0.1'
        });
        const res = mockResponse();

        requestLogger(req, res, mockNext);

        expect(mockConsoleLog).toHaveBeenCalledWith(
          `2024-01-01T12:00:00.000Z - ${method} /api/test-${method.toLowerCase()} - IP: 10.0.0.1`
        );
      });
    });

    it('should handle different status codes', () => {
      const statusCodes = [200, 201, 400, 401, 404, 500];
      
      statusCodes.forEach(statusCode => {
        const req = mockRequest({
          method: 'GET',
          originalUrl: '/api/test',
          ip: '172.16.0.1'
        });
        const res = mockResponse();
        res.statusCode = statusCode;

        let finishCallback: Function;
        res.on = jest.fn().mockImplementation((event, callback) => {
          if (event === 'finish') {
            finishCallback = callback;
          }
        });

        requestLogger(req, res, mockNext);
        mockConsoleLog.mockClear();

        // Simulate response completion
        jest.advanceTimersByTime(100);
        finishCallback();

        expect(mockConsoleLog).toHaveBeenCalledWith(
          `2024-01-01T12:00:00.100Z - GET /api/test - ${statusCode} - 100ms`
        );
      });
    });

    it('should measure response time accurately', () => {
      const req = mockRequest();
      const res = mockResponse();

      let finishCallback: Function;
      res.on = jest.fn().mockImplementation((event, callback) => {
        if (event === 'finish') {
          finishCallback = callback;
        }
      });

      requestLogger(req, res, mockNext);
      mockConsoleLog.mockClear();

      // Simulate a longer response time
      jest.advanceTimersByTime(2500); // 2.5 seconds
      finishCallback();

      expect(mockConsoleLog).toHaveBeenCalledWith(
        '2024-01-01T12:00:02.500Z - GET /api/test - 200 - 2500ms'
      );
    });

    it('should handle requests without IP address', () => {
      const req = mockRequest({
        ip: undefined
      });
      const res = mockResponse();

      requestLogger(req, res, mockNext);

      expect(mockConsoleLog).toHaveBeenCalledWith(
        '2024-01-01T12:00:00.000Z - GET /api/test - IP: undefined'
      );
    });

    it('should handle requests with complex URLs', () => {
      const complexUrls = [
        '/api/users/123/orders?page=1&limit=10',
        '/api/products/search?q=laptop&category=electronics&sort=price',
        '/api/admin/reports/daily?date=2024-01-01&format=json'
      ];

      complexUrls.forEach(url => {
        mockConsoleLog.mockClear();
        
        const req = mockRequest({
          originalUrl: url,
          ip: '203.0.113.1'
        });
        const res = mockResponse();

        requestLogger(req, res, mockNext);

        expect(mockConsoleLog).toHaveBeenCalledWith(
          `2024-01-01T12:00:00.000Z - GET ${url} - IP: 203.0.113.1`
        );
      });
    });

    it('should call next() to continue middleware chain', () => {
      const req = mockRequest();
      const res = mockResponse();

      requestLogger(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledTimes(1);
      expect(mockNext).toHaveBeenCalledWith();
    });

    it('should set up response finish listener', () => {
      const req = mockRequest();
      const res = mockResponse();

      requestLogger(req, res, mockNext);

      expect(res.on).toHaveBeenCalledTimes(1);
      expect(res.on).toHaveBeenCalledWith('finish', expect.any(Function));
    });

    it('should handle multiple simultaneous requests', () => {
      const requests = [
        { method: 'GET', url: '/api/users', ip: '192.168.1.1' },
        { method: 'POST', url: '/api/orders', ip: '192.168.1.2' },
        { method: 'PUT', url: '/api/products/123', ip: '192.168.1.3' }
      ];

      const finishCallbacks: Function[] = [];

      requests.forEach((reqData, index) => {
        const req = mockRequest({
          method: reqData.method,
          originalUrl: reqData.url,
          ip: reqData.ip
        });
        const res = mockResponse();
        res.statusCode = 200 + index;

        res.on = jest.fn().mockImplementation((event, callback) => {
          if (event === 'finish') {
            finishCallbacks[index] = callback;
          }
        });

        requestLogger(req, res, mockNext);
      });

      // Verify all initial request logs
      expect(mockConsoleLog).toHaveBeenCalledTimes(3);
      expect(mockConsoleLog).toHaveBeenNthCalledWith(1,
        '2024-01-01T12:00:00.000Z - GET /api/users - IP: 192.168.1.1'
      );
      expect(mockConsoleLog).toHaveBeenNthCalledWith(2,
        '2024-01-01T12:00:00.000Z - POST /api/orders - IP: 192.168.1.2'
      );
      expect(mockConsoleLog).toHaveBeenNthCalledWith(3,
        '2024-01-01T12:00:00.000Z - PUT /api/products/123 - IP: 192.168.1.3'
      );

      mockConsoleLog.mockClear();

      // Simulate responses finishing at different times
      jest.advanceTimersByTime(100);
      finishCallbacks[0](); // First request finishes

      jest.advanceTimersByTime(50);
      finishCallbacks[2](); // Third request finishes

      jest.advanceTimersByTime(75);
      finishCallbacks[1](); // Second request finishes

      expect(mockConsoleLog).toHaveBeenCalledTimes(3);
      expect(mockConsoleLog).toHaveBeenNthCalledWith(1,
        '2024-01-01T12:00:00.100Z - GET /api/users - 200 - 100ms'
      );
      expect(mockConsoleLog).toHaveBeenNthCalledWith(2,
        '2024-01-01T12:00:00.150Z - PUT /api/products/123 - 202 - 150ms'
      );
      expect(mockConsoleLog).toHaveBeenNthCalledWith(3,
        '2024-01-01T12:00:00.225Z - POST /api/orders - 201 - 225ms'
      );
    });

    it('should handle zero response time', () => {
      const req = mockRequest();
      const res = mockResponse();

      let finishCallback: Function;
      res.on = jest.fn().mockImplementation((event, callback) => {
        if (event === 'finish') {
          finishCallback = callback;
        }
      });

      requestLogger(req, res, mockNext);
      mockConsoleLog.mockClear();

      // Finish immediately without advancing time
      finishCallback();

      expect(mockConsoleLog).toHaveBeenCalledWith(
        '2024-01-01T12:00:00.000Z - GET /api/test - 200 - 0ms'
      );
    });

    it('should format timestamp consistently', () => {
      // Test different times to ensure consistent ISO formatting
      const testTimes = [
        new Date('2024-01-01T00:00:00.000Z'),
        new Date('2024-06-15T15:30:45.123Z'),
        new Date('2024-12-31T23:59:59.999Z')
      ];

      testTimes.forEach(testTime => {
        jest.setSystemTime(testTime);
        mockConsoleLog.mockClear();

        const req = mockRequest();
        const res = mockResponse();

        requestLogger(req, res, mockNext);

        expect(mockConsoleLog).toHaveBeenCalledWith(
          `${testTime.toISOString()} - GET /api/test - IP: 192.168.1.1`
        );
      });
    });
  });

  describe('Edge cases', () => {
    it('should handle missing originalUrl', () => {
      const req = mockRequest({
        originalUrl: undefined,
        url: '/fallback-url'
      });
      const res = mockResponse();

      requestLogger(req, res, mockNext);

      expect(mockConsoleLog).toHaveBeenCalledWith(
        '2024-01-01T12:00:00.000Z - GET undefined - IP: 192.168.1.1'
      );
    });

    it('should handle missing method', () => {
      const req = mockRequest({
        method: undefined
      });
      const res = mockResponse();

      requestLogger(req, res, mockNext);

      expect(mockConsoleLog).toHaveBeenCalledWith(
        '2024-01-01T12:00:00.000Z - undefined /api/test - IP: 192.168.1.1'
      );
    });

    it('should handle response finish event being called multiple times', () => {
      const req = mockRequest();
      const res = mockResponse();

      let finishCallback: Function;
      res.on = jest.fn().mockImplementation((event, callback) => {
        if (event === 'finish') {
          finishCallback = callback;
        }
      });

      requestLogger(req, res, mockNext);
      mockConsoleLog.mockClear();

      // Call finish callback multiple times
      jest.advanceTimersByTime(100);
      finishCallback();
      finishCallback();
      finishCallback();

      // Should only log once
      expect(mockConsoleLog).toHaveBeenCalledTimes(3);
      expect(mockConsoleLog).toHaveBeenCalledWith(
        '2024-01-01T12:00:00.100Z - GET /api/test - 200 - 100ms'
      );
    });
  });
});