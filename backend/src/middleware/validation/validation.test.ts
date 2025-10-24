/**
 * Unit tests for validation middleware
 * Run with: npm test
 */

import request from 'supertest';
import express, { Request, Response } from 'express';
import {
  validateUserRegistration,
  validateUserLogin,
  validateProduct,
  validateOrder,
  handleValidationErrors,
  validateObjectId
} from './index';

// Create test app
const createTestApp = () => {
  const app = express();
  app.use(express.json());
  return app;
};

describe('Validation Middleware Tests', () => {
  let app: express.Application;

  beforeEach(() => {
    app = createTestApp();
  });

  describe('User Registration Validation', () => {
    beforeEach(() => {
      app.post('/test-register', validateUserRegistration, (req, res) => {
        res.status(201).json({ success: true, data: req.body });
      });
    });

    test('should accept valid registration data', async () => {
      const validData = {
        email: 'john.doe@example.com',
        password: 'SecurePass123!',
        firstName: 'John',
        lastName: 'Doe',
        phoneNumber: '+1234567890'
      };

      const response = await request(app)
        .post('/test-register')
        .send(validData);
      // Debug: show response when not 201
      if (response.status !== 201) {
        // eslint-disable-next-line no-console
        console.error('Register validData response:', response.body);
      }
      expect(response.status).toBe(201);
      expect(response.body.success).toBe(true);
      expect(response.body.data.email).toBe('john.doe@example.com'); // Normalized
    });

    test('should reject invalid email format', async () => {
      const invalidData = {
        email: 'invalid-email',
        password: 'SecurePass123!',
        firstName: 'John',
        lastName: 'Doe'
      };

      const response = await request(app)
        .post('/test-register')
        .send(invalidData);

      expect(response.status).toBe(400);
      expect(response.body.success).toBe(false);
      expect(response.body.errors).toContainEqual(
        expect.objectContaining({
          field: 'email',
          message: 'Please provide a valid email address'
        })
      );
    });

    test('should reject weak password', async () => {
      const invalidData = {
        email: 'john@example.com',
        password: 'weak',
        firstName: 'John',
        lastName: 'Doe'
      };

      const response = await request(app)
        .post('/test-register')
        .send(invalidData);

      expect(response.status).toBe(400);
      expect(response.body.success).toBe(false);
      expect(response.body.errors).toContainEqual(
        expect.objectContaining({
          field: 'password',
          message: 'Password must be at least 8 characters long'
        })
      );
    });

    test('should reject invalid names', async () => {
      const invalidData = {
        email: 'john@example.com',
        password: 'SecurePass123!',
        firstName: 'J', // Too short
        lastName: 'Doe123' // Contains numbers
      };

      const response = await request(app)
        .post('/test-register')
        .send(invalidData);

      expect(response.status).toBe(400);
      expect(response.body.success).toBe(false);
      expect(response.body.errors.length).toBeGreaterThanOrEqual(2);
    });

    test('should accept valid role', async () => {
      const validData = {
        email: 'admin@example.com',
        password: 'SecurePass123!',
        firstName: 'Admin',
        lastName: 'User',
        role: 'admin'
      };

      const response = await request(app)
        .post('/test-register')
        .send(validData);

      expect(response.status).toBe(201);
      expect(response.body.data.role).toBe('admin');
    });

    test('should reject invalid role', async () => {
      const invalidData = {
        email: 'john@example.com',
        password: 'SecurePass123!',
        firstName: 'John',
        lastName: 'Doe',
        role: 'invalid_role'
      };

      const response = await request(app)
        .post('/test-register')
        .send(invalidData);

      expect(response.status).toBe(400);
      expect(response.body.errors).toContainEqual(
        expect.objectContaining({
          field: 'role',
          message: 'Role must be one of: customer, delivery_agent, admin'
        })
      );
    });
  });

  describe('User Login Validation', () => {
    beforeEach(() => {
      app.post('/test-login', validateUserLogin, (req, res) => {
        res.json({ success: true, data: req.body });
      });
    });

    test('should accept valid login data', async () => {
      const validData = {
        email: 'user@example.com',
        password: 'anypassword'
      };

      const response = await request(app)
        .post('/test-login')
        .send(validData);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
    });

    test('should reject missing password', async () => {
      const invalidData = {
        email: 'user@example.com'
      };

      const response = await request(app)
        .post('/test-login')
        .send(invalidData);

      expect(response.status).toBe(400);
      expect(response.body.errors).toContainEqual(
        expect.objectContaining({
          field: 'password',
          message: 'Password is required'
        })
      );
    });
  });

  describe('Product Validation', () => {
    beforeEach(() => {
      app.post('/test-product', validateProduct, (req, res) => {
        res.status(201).json({ success: true, data: req.body });
      });
    });

    test('should accept valid product data', async () => {
      const validData = {
        name: 'Test Product',
        description: 'This is a test product with detailed description',
        price: 29.99,
        category: 'Electronics',
        brand: 'TestBrand',
        weight: 1.5,
        dimensions: {
          length: 10,
          width: 5,
          height: 3
        },
        inStock: true,
        stockQuantity: 100
      };

      const response = await request(app)
        .post('/test-product')
        .send(validData);

      expect(response.status).toBe(201);
      expect(response.body.success).toBe(true);
      expect(response.body.data.price).toBe(29.99);
    });

    test('should reject invalid price', async () => {
      const invalidData = {
        name: 'Test Product',
        description: 'This is a test product with detailed description',
        price: -10, // Negative price
        category: 'Electronics'
      };

      const response = await request(app)
        .post('/test-product')
        .send(invalidData);

      expect(response.status).toBe(400);
      expect(response.body.errors).toContainEqual(
        expect.objectContaining({
          field: 'price',
          message: 'Price must be a positive number'
        })
      );
    });

    test('should reject short description', async () => {
      const invalidData = {
        name: 'Test Product',
        description: 'Too short', // Less than 10 characters
        price: 29.99,
        category: 'Electronics'
      };

      const response = await request(app)
        .post('/test-product')
        .send(invalidData);

      expect(response.status).toBe(400);
      expect(response.body.errors).toContainEqual(
        expect.objectContaining({
          field: 'description',
          message: 'Product description must be between 10 and 1000 characters'
        })
      );
    });
  });

  describe('Order Validation', () => {
    beforeEach(() => {
      app.post('/test-order', validateOrder, (req, res) => {
        res.status(201).json({ success: true, data: req.body });
      });
    });

    test('should accept valid order data', async () => {
      const validData = {
        items: [
          {
            productId: '507f1f77bcf86cd799439011',
            quantity: 2,
            price: 29.99
          }
        ],
        address: {
          street: '123 Main Street',
          city: 'Anytown',
          state: 'Anystate',
          postalCode: '12345',
          country: 'USA'
        },
        paymentMethod: 'cash_on_delivery',
        notes: 'Please ring the doorbell'
      };

      const response = await request(app)
        .post('/test-order')
        .send(validData);

      expect(response.status).toBe(201);
      expect(response.body.success).toBe(true);
    });

    test('should reject empty items array', async () => {
      const invalidData = {
        items: [], // Empty array
        address: {
          street: '123 Main Street',
          city: 'Anytown',
          postalCode: '12345',
          country: 'USA'
        },
        paymentMethod: 'cash_on_delivery'
      };

      const response = await request(app)
        .post('/test-order')
        .send(invalidData);

      expect(response.status).toBe(400);
      expect(response.body.errors).toContainEqual(
        expect.objectContaining({
          field: 'items',
          message: 'Order must contain at least one item'
        })
      );
    });

    test('should reject invalid payment method', async () => {
      const invalidData = {
        items: [
          {
            productId: '507f1f77bcf86cd799439011',
            quantity: 1,
            price: 29.99
          }
        ],
        address: {
          street: '123 Main Street',
          city: 'Anytown',
          postalCode: '12345',
          country: 'USA'
        },
        paymentMethod: 'invalid_method'
      };

      const response = await request(app)
        .post('/test-order')
        .send(invalidData);

      expect(response.status).toBe(400);
      expect(response.body.errors).toContainEqual(
        expect.objectContaining({
          field: 'paymentMethod',
          message: 'Payment method must be one of: cash_on_delivery, mobile_money, bank_transfer, card'
        })
      );
    });
  });

  describe('ObjectId Validation', () => {
    beforeEach(() => {
      app.put('/test-object/:id', [
        validateObjectId('id', 'param'),
        handleValidationErrors
      ], (req, res) => {
        res.json({ success: true, id: req.params.id });
      });
    });

    test('should accept valid MongoDB ObjectId', async () => {
      const validId = '507f1f77bcf86cd799439011';

      const response = await request(app)
        .put(`/test-object/${validId}`)
        .send({});

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.id).toBe(validId);
    });

    test('should reject invalid ObjectId', async () => {
      const invalidId = 'invalid-id';

      const response = await request(app)
        .put(`/test-object/${invalidId}`)
        .send({});

      expect(response.status).toBe(400);
      expect(response.body.errors).toContainEqual(
        expect.objectContaining({
          field: 'id',
          message: 'id must be a valid MongoDB ObjectId'
        })
      );
    });
  });

  describe('Error Response Format', () => {
    beforeEach(() => {
      app.post('/test-error-format', validateUserLogin, (req, res) => {
        res.json({ success: true });
      });
    });

    test('should return properly formatted error response', async () => {
      const response = await request(app)
        .post('/test-error-format')
        .send({ email: 'invalid-email' }); // Missing password and invalid email

      expect(response.status).toBe(400);
      expect(response.body).toMatchObject({
        success: false,
        message: 'Validation failed',
        errors: expect.arrayContaining([
          expect.objectContaining({
            field: expect.any(String),
            value: expect.anything(),
            message: expect.any(String),
            location: expect.any(String)
          })
        ]),
        error: {
          code: 'VALIDATION_ERROR',
          type: 'ValidationError',
          timestamp: expect.stringMatching(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z$/)
        }
      });
    });
  });
});

// Integration test example
describe('Validation Integration Tests', () => {
  let app: express.Application;

  beforeEach(() => {
    app = createTestApp();
    
    // Simulate a complete registration endpoint
    app.post('/api/register', validateUserRegistration, (req, res) => {
      // Simulate successful registration
      res.status(201).json({
        success: true,
        message: 'User registered successfully',
        data: {
          id: 'generated-user-id',
          email: req.body.email,
          firstName: req.body.firstName,
          lastName: req.body.lastName,
          role: req.body.role || 'customer'
        }
      });
    });
  });

  test('should handle complete user registration flow', async () => {
    const userData = {
      email: 'newuser@example.com',
      password: 'SecurePassword123!',
      firstName: 'New',
      lastName: 'User',
      phoneNumber: '+1234567890',
      dateOfBirth: '1990-01-01T00:00:00.000Z'
    };

    const response = await request(app)
      .post('/api/register')
      .send(userData);

    expect(response.status).toBe(201);
    expect(response.body).toMatchObject({
      success: true,
      message: 'User registered successfully',
      data: {
        id: expect.any(String),
        email: 'newuser@example.com',
        firstName: 'New',
        lastName: 'User',
        role: 'customer'
      }
    });
  });
});

export {};