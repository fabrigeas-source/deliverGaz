/**
 * Validation Middleware Usage Examples
 * 
 * This file demonstrates how to use the validation middleware
 * in your route handlers and controllers.
 */

import { Router, Request, Response } from 'express';
import {
  validateUserRegistration,
  validateUserLogin,
  validateUserProfileUpdate,
  validatePasswordChange,
  validateProduct,
  validateProductUpdate,
  validateOrder,
  validateOrderStatusUpdate,
  validateCartItem,
  validateSearch,
  validatePagination,
  validateDeliveryUpdate,
  validateReview,
  validateFileUpload,
  sanitizeInput,
  handleValidationErrors,
  validateObjectId,
  combineValidations
} from './index';

const router = Router();

/**
 * Example: User Registration
 * POST /api/auth/register
 */
router.post('/auth/register', validateUserRegistration, async (req: Request, res: Response) => {
  // If we reach this point, validation has passed
  const { email, password, firstName, lastName, phoneNumber, role, dateOfBirth } = req.body;
  
  try {
    // Your user registration logic here
    res.status(201).json({
      success: true,
      message: 'User registered successfully',
      data: {
        id: 'generated-user-id',
        email,
        firstName,
        lastName,
        role: role || 'customer'
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Registration failed',
      error: error instanceof Error ? error.message : 'Unknown error'
    });
  }
});

/**
 * Example: User Login
 * POST /api/auth/login
 */
router.post('/auth/login', validateUserLogin, async (req: Request, res: Response) => {
  const { email, password } = req.body;
  
  try {
    // Your authentication logic here
    res.json({
      success: true,
      message: 'Login successful',
      data: {
        user: { email, role: 'customer' },
        tokens: {
          accessToken: 'generated-access-token',
          refreshToken: 'generated-refresh-token'
        }
      }
    });
  } catch (error) {
    res.status(401).json({
      success: false,
      message: 'Invalid credentials',
      error: error instanceof Error ? error.message : 'Unknown error'
    });
  }
});

/**
 * Example: Profile Update
 * PUT /api/users/profile
 */
router.put('/users/profile', validateUserProfileUpdate, async (req: Request, res: Response) => {
  try {
    // Your profile update logic here
    res.json({
      success: true,
      message: 'Profile updated successfully',
      data: req.body
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Profile update failed',
      error: error instanceof Error ? error.message : 'Unknown error'
    });
  }
});

/**
 * Example: Password Change
 * PUT /api/users/change-password
 */
router.put('/users/change-password', validatePasswordChange, async (req: Request, res: Response) => {
  const { currentPassword, newPassword } = req.body;
  
  try {
    // Your password change logic here
    res.json({
      success: true,
      message: 'Password changed successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Password change failed',
      error: error instanceof Error ? error.message : 'Unknown error'
    });
  }
});

/**
 * Example: Create Product
 * POST /api/products
 */
router.post('/products', validateProduct, async (req: Request, res: Response) => {
  try {
    // Your product creation logic here
    res.status(201).json({
      success: true,
      message: 'Product created successfully',
      data: {
        id: 'generated-product-id',
        ...req.body,
        createdAt: new Date().toISOString()
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Product creation failed',
      error: error instanceof Error ? error.message : 'Unknown error'
    });
  }
});

/**
 * Example: Update Product
 * PUT /api/products/:id
 */
router.put('/products/:id', 
  validateObjectId('id'),
  handleValidationErrors,
  validateProductUpdate,
  async (req: Request, res: Response) => {
    const { id } = req.params;
    
    try {
      // Your product update logic here
      res.json({
        success: true,
        message: 'Product updated successfully',
        data: {
          id,
          ...req.body,
          updatedAt: new Date().toISOString()
        }
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Product update failed',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }
);

/**
 * Example: Create Order
 * POST /api/orders
 */
router.post('/orders', validateOrder, async (req: Request, res: Response) => {
  try {
    // Your order creation logic here
    res.status(201).json({
      success: true,
      message: 'Order created successfully',
      data: {
        id: 'generated-order-id',
        ...req.body,
        status: 'pending',
        createdAt: new Date().toISOString()
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Order creation failed',
      error: error instanceof Error ? error.message : 'Unknown error'
    });
  }
});

/**
 * Example: Update Order Status
 * PUT /api/orders/:id/status
 */
router.put('/orders/:id/status',
  validateObjectId('id'),
  handleValidationErrors,
  validateOrderStatusUpdate,
  async (req: Request, res: Response) => {
    const { id } = req.params;
    const { status, notes } = req.body;
    
    try {
      // Your order status update logic here
      res.json({
        success: true,
        message: 'Order status updated successfully',
        data: {
          id,
          status,
          notes,
          updatedAt: new Date().toISOString()
        }
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Order status update failed',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }
);

/**
 * Example: Add Item to Cart
 * POST /api/cart/items
 */
router.post('/cart/items', validateCartItem, async (req: Request, res: Response) => {
  try {
    // Your cart item addition logic here
    res.status(201).json({
      success: true,
      message: 'Item added to cart successfully',
      data: {
        ...req.body,
        addedAt: new Date().toISOString()
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to add item to cart',
      error: error instanceof Error ? error.message : 'Unknown error'
    });
  }
});

/**
 * Example: Search Products with Pagination
 * GET /api/products/search
 */
router.get('/products/search',
  validateSearch,
  async (req: Request, res: Response) => {
    const { q, category, minPrice, maxPrice, sortBy, sortOrder, page, limit } = req.query;
    
    try {
      // Your search logic here
      res.json({
        success: true,
        message: 'Search completed successfully',
        data: {
          products: [], // Your search results
          pagination: {
            page: page || 1,
            limit: limit || 20,
            total: 0,
            pages: 0
          },
          filters: {
            query: q,
            category,
            priceRange: { min: minPrice, max: maxPrice },
            sortBy: sortBy || 'createdAt',
            sortOrder: sortOrder || 'desc'
          }
        }
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Search failed',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }
);

/**
 * Example: Update Delivery Status
 * PUT /api/deliveries/:orderId/status
 */
router.put('/deliveries/:orderId/status', validateDeliveryUpdate, async (req: Request, res: Response) => {
  const { orderId } = req.params;
  const { currentLatitude, currentLongitude, status, estimatedArrival, notes } = req.body;
  
  try {
    // Your delivery update logic here
    res.json({
      success: true,
      message: 'Delivery status updated successfully',
      data: {
        orderId,
        location: {
          latitude: currentLatitude,
          longitude: currentLongitude
        },
        status,
        estimatedArrival,
        notes,
        updatedAt: new Date().toISOString()
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Delivery status update failed',
      error: error instanceof Error ? error.message : 'Unknown error'
    });
  }
});

/**
 * Example: Submit Product Review
 * POST /api/reviews
 */
router.post('/reviews', validateReview, async (req: Request, res: Response) => {
  try {
    // Your review creation logic here
    res.status(201).json({
      success: true,
      message: 'Review submitted successfully',
      data: {
        id: 'generated-review-id',
        ...req.body,
        createdAt: new Date().toISOString()
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Review submission failed',
      error: error instanceof Error ? error.message : 'Unknown error'
    });
  }
});

/**
 * Example: File Upload with Validation
 * POST /api/products/:id/images
 */
router.post('/products/:id/images',
  validateObjectId('id'),
  handleValidationErrors,
  validateFileUpload('image', ['image/jpeg', 'image/png', 'image/gif'], 5 * 1024 * 1024),
  async (req: Request, res: Response) => {
    const { id } = req.params;
    
    try {
      // Your file upload logic here
      res.status(201).json({
        success: true,
        message: 'Image uploaded successfully',
        data: {
          productId: id,
          imageUrl: 'path/to/uploaded/image.jpg',
          uploadedAt: new Date().toISOString()
        }
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Image upload failed',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }
);

/**
 * Example: Using Sanitization Middleware
 * Apply sanitization to all POST and PUT routes
 */
router.use(['/api/*'], sanitizeInput);

/**
 * Example: Custom Validation Combination
 * GET /api/products/:id/reviews
 */
router.get('/products/:id/reviews',
  validateObjectId('id'),
  validatePagination,
  async (req: Request, res: Response) => {
    const { id } = req.params;
    const { page, limit } = req.query;
    
    try {
      // Your logic to fetch product reviews here
      res.json({
        success: true,
        message: 'Reviews fetched successfully',
        data: {
          productId: id,
          reviews: [], // Your reviews data
          pagination: {
            page: page || 1,
            limit: limit || 10,
            total: 0,
            pages: 0
          }
        }
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Failed to fetch reviews',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }
);

export default router;