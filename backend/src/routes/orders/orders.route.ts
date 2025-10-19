import { Router, Request, Response } from 'express';

const router = Router();

/**
 * @swagger
 * components:
 *   schemas:
 *     OrderItem:
 *       type: object
 *       required:
 *         - product
 *         - quantity
 *         - price
 *       properties:
 *         product:
 *           type: string
 *           description: Product ID
 *           example: "60d5ecb74f1a6b2f8c8b4567"
 *         productName:
 *           type: string
 *           description: Product name at time of order
 *           example: "Gas Cylinder 15kg"
 *         quantity:
 *           type: number
 *           description: Quantity ordered
 *           minimum: 1
 *           example: 2
 *         price:
 *           type: number
 *           description: Price per unit at time of order
 *           minimum: 0
 *           example: 25.99
 *         subtotal:
 *           type: number
 *           description: Item subtotal (quantity * price)
 *           example: 51.98
 *     DeliveryAddress:
 *       type: object
 *       required:
 *         - street
 *         - city
 *         - country
 *       properties:
 *         street:
 *           type: string
 *           description: Street address
 *           example: "123 Main Street, Apt 4B"
 *           maxLength: 200
 *         city:
 *           type: string
 *           description: City name
 *           example: "New York"
 *           maxLength: 100
 *         state:
 *           type: string
 *           description: State or province
 *           example: "NY"
 *           maxLength: 50
 *         postalCode:
 *           type: string
 *           description: Postal/ZIP code
 *           example: "10001"
 *           maxLength: 20
 *         country:
 *           type: string
 *           description: Country name
 *           example: "USA"
 *           maxLength: 50
 *         coordinates:
 *           type: object
 *           properties:
 *             latitude:
 *               type: number
 *               example: 40.7128
 *             longitude:
 *               type: number
 *               example: -74.0060
 *     Order:
 *       type: object
 *       properties:
 *         id:
 *           type: string
 *           description: Order ID
 *           example: "order_123456789"
 *         orderNumber:
 *           type: string
 *           description: Human-readable order number
 *           example: "ORD-20240101-001"
 *         user:
 *           type: string
 *           description: User ID
 *           example: "user_789012"
 *         items:
 *           type: array
 *           items:
 *             $ref: '#/components/schemas/OrderItem'
 *           minItems: 1
 *         itemCount:
 *           type: number
 *           description: Total number of items
 *           example: 3
 *         subtotal:
 *           type: number
 *           description: Order subtotal (before taxes and fees)
 *           minimum: 0
 *           example: 75.50
 *         tax:
 *           type: number
 *           description: Tax amount
 *           minimum: 0
 *           example: 7.55
 *         deliveryFee:
 *           type: number
 *           description: Delivery fee
 *           minimum: 0
 *           example: 5.00
 *         total:
 *           type: number
 *           description: Total order value (subtotal + tax + fees)
 *           minimum: 0
 *           example: 88.05
 *         currency:
 *           type: string
 *           description: Currency code
 *           example: "USD"
 *         status:
 *           type: string
 *           enum: [pending, confirmed, preparing, out_for_delivery, delivered, cancelled, refunded]
 *           description: Current order status
 *           example: "confirmed"
 *         paymentMethod:
 *           type: string
 *           enum: [cash, card, mobile_money, bank_transfer]
 *           description: Payment method
 *           example: "cash"
 *         paymentStatus:
 *           type: string
 *           enum: [pending, paid, failed, refunded]
 *           description: Payment status
 *           example: "pending"
 *         deliveryAddress:
 *           $ref: '#/components/schemas/DeliveryAddress'
 *         estimatedDelivery:
 *           type: string
 *           format: date-time
 *           description: Estimated delivery time
 *           example: "2024-01-02T14:00:00.000Z"
 *         actualDelivery:
 *           type: string
 *           format: date-time
 *           description: Actual delivery time
 *           example: "2024-01-02T13:45:00.000Z"
 *         notes:
 *           type: string
 *           description: Special delivery instructions
 *           example: "Please call before delivery"
 *           maxLength: 500
 *         tracking:
 *           type: object
 *           properties:
 *             trackingNumber:
 *               type: string
 *               example: "TRK123456789"
 *             courier:
 *               type: string
 *               example: "DeliverGaz Express"
 *             status:
 *               type: string
 *               example: "out_for_delivery"
 *             lastUpdate:
 *               type: string
 *               format: date-time
 *         createdAt:
 *           type: string
 *           format: date-time
 *           example: "2024-01-01T10:00:00.000Z"
 *         updatedAt:
 *           type: string
 *           format: date-time
 *           example: "2024-01-01T15:30:00.000Z"
 *     CreateOrderRequest:
 *       type: object
 *       required:
 *         - deliveryAddress
 *         - paymentMethod
 *       properties:
 *         deliveryAddress:
 *           $ref: '#/components/schemas/DeliveryAddress'
 *         paymentMethod:
 *           type: string
 *           enum: [cash, card, mobile_money, bank_transfer]
 *           example: "cash"
 *         notes:
 *           type: string
 *           maxLength: 500
 *           example: "Please ring doorbell twice"
 *         scheduledDelivery:
 *           type: string
 *           format: date-time
 *           description: Preferred delivery time
 *           example: "2024-01-02T14:00:00.000Z"
 *     UpdateOrderStatusRequest:
 *       type: object
 *       required:
 *         - status
 *       properties:
 *         status:
 *           type: string
 *           enum: [confirmed, preparing, out_for_delivery, delivered, cancelled]
 *           example: "confirmed"
 *         notes:
 *           type: string
 *           maxLength: 500
 *           example: "Order confirmed and being prepared"
 *         trackingInfo:
 *           type: object
 *           properties:
 *             trackingNumber:
 *               type: string
 *             courier:
 *               type: string
 *     OrderResponse:
 *       type: object
 *       properties:
 *         success:
 *           type: boolean
 *           example: true
 *         message:
 *           type: string
 *           example: "Order retrieved successfully"
 *         data:
 *           $ref: '#/components/schemas/Order'
 *     OrderListResponse:
 *       type: object
 *       properties:
 *         success:
 *           type: boolean
 *           example: true
 *         message:
 *           type: string
 *           example: "Orders retrieved successfully"
 *         data:
 *           type: object
 *           properties:
 *             orders:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Order'
 *             pagination:
 *               type: object
 *               properties:
 *                 currentPage:
 *                   type: number
 *                   example: 1
 *                 totalPages:
 *                   type: number
 *                   example: 5
 *                 totalOrders:
 *                   type: number
 *                   example: 48
 *                 hasNext:
 *                   type: boolean
 *                   example: true
 *                 hasPrev:
 *                   type: boolean
 *                   example: false
 *     ErrorResponse:
 *       type: object
 *       properties:
 *         success:
 *           type: boolean
 *           example: false
 *         message:
 *           type: string
 *           example: "Error message"
 *         errors:
 *           type: array
 *           items:
 *             type: object
 *             properties:
 *               field:
 *                 type: string
 *               message:
 *                 type: string
 */

/**
 * @swagger
 * /api/orders:
 *   get:
 *     summary: Get user's orders with pagination and filtering
 *     tags: [Orders]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           minimum: 1
 *           default: 1
 *         description: Page number for pagination
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 50
 *           default: 10
 *         description: Number of orders per page
 *       - in: query
 *         name: status
 *         schema:
 *           type: string
 *           enum: [pending, confirmed, preparing, out_for_delivery, delivered, cancelled, refunded]
 *         description: Filter orders by status
 *       - in: query
 *         name: startDate
 *         schema:
 *           type: string
 *           format: date
 *         description: Filter orders from this date (YYYY-MM-DD)
 *       - in: query
 *         name: endDate
 *         schema:
 *           type: string
 *           format: date
 *         description: Filter orders to this date (YYYY-MM-DD)
 *       - in: query
 *         name: sortBy
 *         schema:
 *           type: string
 *           enum: [createdAt, updatedAt, total, orderNumber]
 *           default: createdAt
 *         description: Sort orders by field
 *       - in: query
 *         name: sortOrder
 *         schema:
 *           type: string
 *           enum: [asc, desc]
 *           default: desc
 *         description: Sort order
 *     responses:
 *       200:
 *         description: Orders retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/OrderListResponse'
 *       400:
 *         description: Bad request - Invalid query parameters
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       401:
 *         description: Unauthorized - Invalid or missing token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.get('/', async (req: Request, res: Response) => {
  try {
    const {
      page = 1,
      limit = 10,
      status,
      startDate,
      endDate,
      sortBy = 'createdAt',
      sortOrder = 'desc'
    } = req.query;

    // TODO: Implement order retrieval logic
    // 1. Get user ID from authenticated request
    // 2. Build query filters based on parameters
    // 3. Apply pagination and sorting
    // 4. Retrieve orders with populated product details
    // 5. Calculate pagination metadata
    // 6. Return formatted response

    // Mock data for development
    const mockOrders = [
      {
        id: "order_123456789",
        orderNumber: "ORD-20240101-001",
        user: "user_789012",
        items: [
          {
            product: "60d5ecb74f1a6b2f8c8b4567",
            productName: "Gas Cylinder 15kg",
            quantity: 2,
            price: 25.99,
            subtotal: 51.98
          }
        ],
        itemCount: 2,
        subtotal: 51.98,
        tax: 5.20,
        deliveryFee: 5.00,
        total: 62.18,
        currency: "USD",
        status: "confirmed",
        paymentMethod: "cash",
        paymentStatus: "pending",
        deliveryAddress: {
          street: "123 Main Street",
          city: "New York",
          state: "NY",
          postalCode: "10001",
          country: "USA"
        },
        estimatedDelivery: "2024-01-02T14:00:00.000Z",
        notes: "Please call before delivery",
        createdAt: "2024-01-01T10:00:00.000Z",
        updatedAt: "2024-01-01T10:30:00.000Z"
      }
    ];

    const pagination = {
      currentPage: parseInt(page as string),
      totalPages: 1,
      totalOrders: mockOrders.length,
      hasNext: false,
      hasPrev: false
    };

    res.status(200).json({
      success: true,
      message: 'Orders retrieved successfully',
      data: {
        orders: mockOrders,
        pagination
      }
    });
  } catch (error) {
    console.error('Error retrieving orders:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve orders',
      errors: [{ field: 'general', message: 'Internal server error' }]
    });
  }
});

/**
 * @swagger
 * /api/orders:
 *   post:
 *     summary: Create new order from user's cart
 *     tags: [Orders]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/CreateOrderRequest'
 *     responses:
 *       201:
 *         description: Order created successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/OrderResponse'
 *       400:
 *         description: Bad request - Empty cart or validation errors
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       401:
 *         description: Unauthorized - Invalid or missing token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       422:
 *         description: Unprocessable entity - Cart empty or products unavailable
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.post('/', async (req: Request, res: Response) => {
  try {
    const { deliveryAddress, paymentMethod, notes, scheduledDelivery } = req.body;

    // TODO: Implement order creation logic
    // 1. Validate request data
    // 2. Get user ID from authenticated request
    // 3. Retrieve and validate user's cart
    // 4. Check product availability and stock
    // 5. Calculate totals (subtotal, tax, delivery fee)
    // 6. Generate order number
    // 7. Create order record
    // 8. Clear user's cart
    // 9. Send order confirmation
    // 10. Return created order

    // Basic validation
    if (!deliveryAddress || !paymentMethod) {
      return res.status(400).json({
        success: false,
        message: 'Delivery address and payment method are required',
        errors: [
          { field: 'deliveryAddress', message: 'Delivery address is required' },
          { field: 'paymentMethod', message: 'Payment method is required' }
        ]
      });
    }

    // Validate delivery address
    const { street, city, country } = deliveryAddress;
    if (!street || !city || !country) {
      return res.status(400).json({
        success: false,
        message: 'Street, city, and country are required in delivery address',
        errors: [
          { field: 'deliveryAddress.street', message: 'Street is required' },
          { field: 'deliveryAddress.city', message: 'City is required' },
          { field: 'deliveryAddress.country', message: 'Country is required' }
        ]
      });
    }

    // Validate payment method
    const validPaymentMethods = ['cash', 'card', 'mobile_money', 'bank_transfer'];
    if (!validPaymentMethods.includes(paymentMethod)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid payment method',
        errors: [{
          field: 'paymentMethod',
          message: `Payment method must be one of: ${validPaymentMethods.join(', ')}`
        }]
      });
    }

    // Mock order creation
    const mockOrder = {
      id: "order_" + Date.now(),
      orderNumber: `ORD-${new Date().toISOString().slice(0, 10).replace(/-/g, '')}-${Math.floor(Math.random() * 1000).toString().padStart(3, '0')}`,
      user: "user_789012",
      items: [
        {
          product: "60d5ecb74f1a6b2f8c8b4567",
          productName: "Gas Cylinder 15kg",
          quantity: 2,
          price: 25.99,
          subtotal: 51.98
        }
      ],
      itemCount: 2,
      subtotal: 51.98,
      tax: 5.20,
      deliveryFee: 5.00,
      total: 62.18,
      currency: "USD",
      status: "pending",
      paymentMethod,
      paymentStatus: "pending",
      deliveryAddress,
      estimatedDelivery: scheduledDelivery || new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString(),
      notes: notes || "",
      tracking: {
        trackingNumber: `TRK${Date.now()}`,
        courier: "DeliverGaz Express",
        status: "order_placed",
        lastUpdate: new Date().toISOString()
      },
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };

    res.status(201).json({
      success: true,
      message: 'Order created successfully',
      data: mockOrder
    });
  } catch (error) {
    console.error('Error creating order:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to create order',
      errors: [{ field: 'general', message: 'Internal server error' }]
    });
  }
});

/**
 * @swagger
 * /api/orders/{id}:
 *   get:
 *     summary: Get specific order by ID
 *     tags: [Orders]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Order ID
 *         example: "order_123456789"
 *     responses:
 *       200:
 *         description: Order retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/OrderResponse'
 *       401:
 *         description: Unauthorized - Invalid or missing token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       403:
 *         description: Forbidden - Not authorized to view this order
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       404:
 *         description: Order not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.get('/:id', async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    // TODO: Implement order retrieval by ID logic
    // 1. Validate order ID format
    // 2. Get user ID from authenticated request
    // 3. Find order by ID
    // 4. Verify order belongs to user (or user is admin)
    // 5. Populate product details
    // 6. Return order data

    if (!id) {
      return res.status(400).json({
        success: false,
        message: 'Order ID is required',
        errors: [{ field: 'id', message: 'Order ID is required' }]
      });
    }

    // Mock order retrieval
    const mockOrder = {
      id: id,
      orderNumber: "ORD-20240101-001",
      user: "user_789012",
      items: [
        {
          product: "60d5ecb74f1a6b2f8c8b4567",
          productName: "Gas Cylinder 15kg",
          quantity: 2,
          price: 25.99,
          subtotal: 51.98
        }
      ],
      itemCount: 2,
      subtotal: 51.98,
      tax: 5.20,
      deliveryFee: 5.00,
      total: 62.18,
      currency: "USD",
      status: "confirmed",
      paymentMethod: "cash",
      paymentStatus: "pending",
      deliveryAddress: {
        street: "123 Main Street",
        city: "New York",
        state: "NY",
        postalCode: "10001",
        country: "USA"
      },
      estimatedDelivery: "2024-01-02T14:00:00.000Z",
      notes: "Please call before delivery",
      tracking: {
        trackingNumber: "TRK123456789",
        courier: "DeliverGaz Express",
        status: "confirmed",
        lastUpdate: new Date().toISOString()
      },
      createdAt: "2024-01-01T10:00:00.000Z",
      updatedAt: "2024-01-01T10:30:00.000Z"
    };

    res.status(200).json({
      success: true,
      message: 'Order retrieved successfully',
      data: mockOrder
    });
  } catch (error) {
    console.error('Error retrieving order:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve order',
      errors: [{ field: 'general', message: 'Internal server error' }]
    });
  }
});

/**
 * @swagger
 * /api/orders/{id}/status:
 *   put:
 *     summary: Update order status (Admin only)
 *     tags: [Orders]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Order ID
 *         example: "order_123456789"
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/UpdateOrderStatusRequest'
 *     responses:
 *       200:
 *         description: Order status updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/OrderResponse'
 *       400:
 *         description: Bad request - Invalid status or validation errors
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       401:
 *         description: Unauthorized - Invalid or missing token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       403:
 *         description: Forbidden - Admin access required
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       404:
 *         description: Order not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.put('/:id/status', async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { status, notes, trackingInfo } = req.body;

    // TODO: Implement order status update logic
    // 1. Verify admin permissions
    // 2. Validate order ID and status
    // 3. Find order by ID
    // 4. Update order status and tracking info
    // 5. Send notification to customer
    // 6. Log status change
    // 7. Return updated order

    if (!status) {
      return res.status(400).json({
        success: false,
        message: 'Status is required',
        errors: [{ field: 'status', message: 'Status is required' }]
      });
    }

    const validStatuses = ['confirmed', 'preparing', 'out_for_delivery', 'delivered', 'cancelled'];
    if (!validStatuses.includes(status)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid status',
        errors: [{
          field: 'status',
          message: `Status must be one of: ${validStatuses.join(', ')}`
        }]
      });
    }

    // Mock status update
    const mockUpdatedOrder = {
      id: id,
      orderNumber: "ORD-20240101-001",
      user: "user_789012",
      items: [
        {
          product: "60d5ecb74f1a6b2f8c8b4567",
          productName: "Gas Cylinder 15kg",
          quantity: 2,
          price: 25.99,
          subtotal: 51.98
        }
      ],
      itemCount: 2,
      subtotal: 51.98,
      tax: 5.20,
      deliveryFee: 5.00,
      total: 62.18,
      currency: "USD",
      status: status,
      paymentMethod: "cash",
      paymentStatus: status === 'delivered' ? 'paid' : 'pending',
      deliveryAddress: {
        street: "123 Main Street",
        city: "New York",
        state: "NY",
        postalCode: "10001",
        country: "USA"
      },
      estimatedDelivery: "2024-01-02T14:00:00.000Z",
      actualDelivery: status === 'delivered' ? new Date().toISOString() : null,
      notes: notes || "Please call before delivery",
      tracking: {
        trackingNumber: trackingInfo?.trackingNumber || "TRK123456789",
        courier: trackingInfo?.courier || "DeliverGaz Express",
        status: status,
        lastUpdate: new Date().toISOString()
      },
      createdAt: "2024-01-01T10:00:00.000Z",
      updatedAt: new Date().toISOString()
    };

    res.status(200).json({
      success: true,
      message: 'Order status updated successfully',
      data: mockUpdatedOrder
    });
  } catch (error) {
    console.error('Error updating order status:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to update order status',
      errors: [{ field: 'general', message: 'Internal server error' }]
    });
  }
});

/**
 * @swagger
 * /api/orders/{id}/cancel:
 *   put:
 *     summary: Cancel order (Customer or Admin)
 *     tags: [Orders]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Order ID
 *         example: "order_123456789"
 *     requestBody:
 *       required: false
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               reason:
 *                 type: string
 *                 maxLength: 500
 *                 example: "Changed my mind"
 *     responses:
 *       200:
 *         description: Order cancelled successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/OrderResponse'
 *       400:
 *         description: Bad request - Order cannot be cancelled
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       401:
 *         description: Unauthorized - Invalid or missing token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       403:
 *         description: Forbidden - Not authorized to cancel this order
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       404:
 *         description: Order not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.put('/:id/cancel', async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { reason } = req.body;

    // TODO: Implement order cancellation logic
    // 1. Find order by ID
    // 2. Verify user owns order (or is admin)
    // 3. Check if order can be cancelled (not delivered, etc.)
    // 4. Update order status to cancelled
    // 5. Process refund if payment was made
    // 6. Restore product stock
    // 7. Send cancellation notification
    // 8. Log cancellation with reason

    // Mock cancellation
    const mockCancelledOrder = {
      id: id,
      orderNumber: "ORD-20240101-001",
      user: "user_789012",
      items: [
        {
          product: "60d5ecb74f1a6b2f8c8b4567",
          productName: "Gas Cylinder 15kg",
          quantity: 2,
          price: 25.99,
          subtotal: 51.98
        }
      ],
      itemCount: 2,
      subtotal: 51.98,
      tax: 5.20,
      deliveryFee: 5.00,
      total: 62.18,
      currency: "USD",
      status: "cancelled",
      paymentMethod: "cash",
      paymentStatus: "refunded",
      deliveryAddress: {
        street: "123 Main Street",
        city: "New York",
        state: "NY",
        postalCode: "10001",
        country: "USA"
      },
      estimatedDelivery: "2024-01-02T14:00:00.000Z",
      notes: reason || "Order cancelled by customer",
      tracking: {
        trackingNumber: "TRK123456789",
        courier: "DeliverGaz Express",
        status: "cancelled",
        lastUpdate: new Date().toISOString()
      },
      createdAt: "2024-01-01T10:00:00.000Z",
      updatedAt: new Date().toISOString()
    };

    res.status(200).json({
      success: true,
      message: 'Order cancelled successfully',
      data: mockCancelledOrder
    });
  } catch (error) {
    console.error('Error cancelling order:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to cancel order',
      errors: [{ field: 'general', message: 'Internal server error' }]
    });
  }
});

export default router;