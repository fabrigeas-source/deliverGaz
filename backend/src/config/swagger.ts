import swaggerJsdoc from 'swagger-jsdoc';
import { SwaggerDefinition } from 'swagger-jsdoc';
import { serverConfig } from './server';

/**
 * Swagger configuration module
 */

export interface SwaggerConfig {
  definition: SwaggerDefinition;
  apis: string[];
}

/**
 * Swagger API documentation configuration
 */
export const swaggerConfig: SwaggerConfig = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'DeliverGaz API',
      version: '1.0.0',
      description: 'A comprehensive REST API for the DeliverGaz delivery application built with Node.js, Express, and TypeScript.',
      contact: {
        name: 'DeliverGaz Team',
        email: 'contact@delivergaz.com',
      },
      license: {
        name: 'MIT',
        url: 'https://opensource.org/licenses/MIT',
      },
    },
    servers: [
      {
        url: `http://localhost:${serverConfig.port}`,
        description: 'Development server',
      },
      {
        url: `https://api.delivergaz.com`,
        description: 'Production server',
      },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
          description: 'Enter JWT token',
        },
        refreshToken: {
          type: 'apiKey',
          in: 'header',
          name: 'x-refresh-token',
          description: 'Refresh token for generating new access tokens',
        },
      },
      schemas: {
        Error: {
          type: 'object',
          properties: {
            success: {
              type: 'boolean',
              example: false,
            },
            message: {
              type: 'string',
              example: 'Error message',
            },
            error: {
              type: 'string',
              example: 'Detailed error information',
            },
          },
        },
        Success: {
          type: 'object',
          properties: {
            success: {
              type: 'boolean',
              example: true,
            },
            message: {
              type: 'string',
              example: 'Operation completed successfully',
            },
            data: {
              type: 'object',
              description: 'Response data',
            },
          },
        },
        User: {
          type: 'object',
          properties: {
            _id: {
              type: 'string',
              example: '507f1f77bcf86cd799439011',
            },
            email: {
              type: 'string',
              format: 'email',
              example: 'user@example.com',
            },
            firstName: {
              type: 'string',
              example: 'John',
            },
            lastName: {
              type: 'string',
              example: 'Doe',
            },
            phoneNumber: {
              type: 'string',
              example: '+1234567890',
            },
            role: {
              type: 'string',
              enum: ['customer', 'delivery_agent', 'admin', 'super_admin'],
              example: 'customer',
            },
            status: {
              type: 'string',
              enum: ['active', 'inactive', 'banned', 'pending_verification'],
              example: 'active',
            },
            addresses: {
              type: 'array',
              items: { $ref: '#/components/schemas/Address' },
            },
          },
        },
        Address: {
          type: 'object',
          properties: {
            _id: {
              type: 'string',
              example: '507f1f77bcf86cd799439012',
            },
            street: {
              type: 'string',
              example: '123 Main St',
            },
            city: {
              type: 'string',
              example: 'New York',
            },
            state: {
              type: 'string',
              example: 'NY',
            },
            postalCode: {
              type: 'string',
              example: '10001',
            },
            country: {
              type: 'string',
              example: 'USA',
            },
            coordinates: {
              type: 'object',
              properties: {
                latitude: { type: 'number', example: 40.7128 },
                longitude: { type: 'number', example: -74.0060 },
              },
            },
            isDefault: {
              type: 'boolean',
              example: false,
            },
            label: {
              type: 'string',
              example: 'Home',
            },
          },
        },
        Product: {
          type: 'object',
          properties: {
            _id: {
              type: 'string',
              example: '507f1f77bcf86cd799439013',
            },
            name: {
              type: 'string',
              example: 'Gas Cylinder 15kg',
            },
            description: {
              type: 'string',
              example: 'High-quality gas cylinder for cooking',
            },
            price: {
              type: 'number',
              example: 29.99,
            },
            category: {
              type: 'string',
              example: 'gas-cylinders',
            },
            images: {
              type: 'array',
              items: { type: 'string' },
              example: ['image1.jpg', 'image2.jpg'],
            },
            inventory: {
              type: 'object',
              properties: {
                quantity: { type: 'number', example: 100 },
                reserved: { type: 'number', example: 5 },
                available: { type: 'number', example: 95 },
              },
            },
            status: {
              type: 'string',
              enum: ['active', 'inactive', 'out_of_stock'],
              example: 'active',
            },
          },
        },
        CartItem: {
          type: 'object',
          properties: {
            productId: {
              type: 'string',
              example: '507f1f77bcf86cd799439013',
            },
            quantity: {
              type: 'number',
              example: 2,
            },
            price: {
              type: 'number',
              example: 29.99,
            },
            options: {
              type: 'object',
              example: { size: 'large', color: 'blue' },
            },
          },
        },
        Cart: {
          type: 'object',
          properties: {
            _id: {
              type: 'string',
              example: '507f1f77bcf86cd799439014',
            },
            userId: {
              type: 'string',
              example: '507f1f77bcf86cd799439011',
            },
            items: {
              type: 'array',
              items: { $ref: '#/components/schemas/CartItem' },
            },
            totalItems: {
              type: 'number',
              example: 3,
            },
            totalAmount: {
              type: 'number',
              example: 89.97,
            },
            status: {
              type: 'string',
              enum: ['active', 'abandoned', 'converted'],
              example: 'active',
            },
            summary: {
              type: 'object',
              properties: {
                itemCount: { type: 'number', example: 3 },
                subtotal: { type: 'number', example: 89.97 },
                tax: { type: 'number', example: 9.00 },
                discount: { type: 'number', example: 0 },
                total: { type: 'number', example: 98.97 },
                hasItems: { type: 'boolean', example: true },
              },
            },
          },
        },
        OrderItem: {
          type: 'object',
          properties: {
            productId: {
              type: 'string',
              example: '507f1f77bcf86cd799439013',
            },
            quantity: {
              type: 'number',
              example: 2,
            },
            price: {
              type: 'number',
              example: 29.99,
            },
            subtotal: {
              type: 'number',
              example: 59.98,
            },
          },
        },
        Order: {
          type: 'object',
          properties: {
            _id: {
              type: 'string',
              example: '507f1f77bcf86cd799439015',
            },
            userId: {
              type: 'string',
              example: '507f1f77bcf86cd799439011',
            },
            items: {
              type: 'array',
              items: { $ref: '#/components/schemas/OrderItem' },
            },
            totalAmount: {
              type: 'number',
              example: 98.97,
            },
            status: {
              type: 'string',
              enum: ['pending', 'confirmed', 'preparing', 'ready_for_pickup', 'out_for_delivery', 'delivered', 'cancelled'],
              example: 'pending',
            },
            paymentStatus: {
              type: 'string',
              enum: ['pending', 'paid', 'failed', 'refunded'],
              example: 'pending',
            },
            deliveryAddress: { $ref: '#/components/schemas/Address' },
            paymentMethod: {
              type: 'string',
              enum: ['cash', 'card', 'mobile_money'],
              example: 'cash',
            },
            estimatedDeliveryTime: {
              type: 'string',
              format: 'date-time',
              example: '2023-12-01T15:30:00Z',
            },
            tracking: {
              type: 'object',
              properties: {
                currentLocation: {
                  type: 'object',
                  properties: {
                    latitude: { type: 'number', example: 40.7128 },
                    longitude: { type: 'number', example: -74.0060 },
                  },
                },
                lastUpdated: {
                  type: 'string',
                  format: 'date-time',
                  example: '2023-12-01T14:30:00Z',
                },
              },
            },
          },
        },
      },
    },
    tags: [
      {
        name: 'Authentication',
        description: 'User authentication and authorization endpoints',
      },
      {
        name: 'Users',
        description: 'User management endpoints',
      },
      {
        name: 'Products',
        description: 'Product catalog management',
      },
      {
        name: 'Orders',
        description: 'Order processing and management',
      },
      {
        name: 'Cart',
        description: 'Shopping cart functionality',
      },
      {
        name: 'Health',
        description: 'System health and monitoring',
      },
    ],
  },
  apis: [
    './src/routes/**/*.ts',
    './src/server.ts',
    './src/models/**/*.ts',
  ],
};

/**
 * Generate Swagger specification
 */
export const swaggerSpec = swaggerJsdoc(swaggerConfig);

/**
 * Swagger UI options
 */
export const swaggerUiOptions = {
  explorer: true,
  swaggerOptions: {
    filter: true,
    showRequestHeaders: true,
    docExpansion: 'none',
    defaultModelsExpandDepth: 2,
    defaultModelExpandDepth: 2,
  },
  customCss: `
    .swagger-ui .topbar { display: none }
    .swagger-ui .info .title { color: #2c3e50; }
    .swagger-ui .scheme-container { background: #f8f9fa; }
  `,
  customSiteTitle: 'DeliverGaz API Documentation',
};