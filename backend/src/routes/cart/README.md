# Cart Routes

A comprehensive shopping cart management system for the DeliverGaz application, providing complete cart functionality including item management, quantity updates, and cart operations.

## Overview

This module handles all cart-related operations for users, enabling them to manage their shopping cart items before placing orders. It provides RESTful endpoints with comprehensive Swagger documentation and supports essential cart operations like adding, updating, removing items, and cart clearing.

## Features

- 🛒 **Shopping Cart Management** - Complete cart operations
- ➕ **Add to Cart** - Add products with quantity management
- ✏️ **Update Items** - Modify item quantities in cart
- 🗑️ **Remove Items** - Remove specific items or clear entire cart
- 📊 **Cart Summary** - Quick access to cart count and totals
- 💰 **Total Calculation** - Automatic price calculation and subtotals
- 🔒 **User Authentication** - Secure cart access per user
- 📝 **Swagger Documentation** - Complete API documentation
- ✅ **Consistent Responses** - Standardized response format
- 🧪 **Comprehensive Testing** - Full test coverage

## Files Structure

```
routes/cart/
├── cart.route.ts      # Main cart routes (updated naming)
├── cart.route.test.ts # Test suite (updated naming)
├── index.ts          # Route exports
└── README.md         # Documentation (this file)
```

## Recent Updates

- ✅ **File Naming**: Updated to `.route.ts` convention for consistency
- ✅ **Comprehensive Swagger Docs**: Full API documentation with detailed schemas
- ✅ **Enhanced Error Handling**: Improved error responses with field-specific messages
- ✅ **Modular Structure**: Clean separation of concerns with proper exports
- ✅ **Mock Data Support**: Development-friendly mock responses

## API Endpoints

### GET /api/cart
Retrieve the user's complete cart with all items and totals.

**Headers:**
```
Authorization: Bearer <jwt_token>
```

**Response (200):**
```json
{
  "success": true,
  "message": "Cart retrieved successfully",
  "data": {
    "id": "cart_123456",
    "user": "user_789012",
    "items": [
      {
        "product": "60d5ecb74f1a6b2f8c8b4567",
        "quantity": 2,
        "price": 25.99,
        "subtotal": 51.98,
        "addedAt": "2024-01-01T12:00:00.000Z"
      },
      {
        "product": "60d5ecb74f1a6b2f8c8b4568",
        "quantity": 1,
        "price": 15.50,
        "subtotal": 15.50,
        "addedAt": "2024-01-01T12:30:00.000Z"
      }
    ],
    "itemCount": 3,
    "total": 67.48,
    "currency": "USD",
    "lastUpdated": "2024-01-01T12:30:00.000Z",
    "createdAt": "2024-01-01T10:00:00.000Z",
    "updatedAt": "2024-01-01T12:30:00.000Z"
  }
}
```

**Error Responses:**
- `401` - Unauthorized (invalid or missing token)
- `500` - Internal server error

### POST /api/cart/add
Add an item to the cart or update quantity if item already exists.

**Headers:**
```
Authorization: Bearer <jwt_token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "productId": "60d5ecb74f1a6b2f8c8b4567",
  "quantity": 2
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Item added to cart successfully",
  "data": {
    "id": "cart_123456",
    "user": "user_789012",
    "items": [
      {
        "product": "60d5ecb74f1a6b2f8c8b4567",
        "quantity": 2,
        "price": 25.99,
        "subtotal": 51.98,
        "addedAt": "2024-01-01T12:00:00.000Z"
      }
    ],
    "itemCount": 2,
    "total": 51.98,
    "currency": "USD",
    "lastUpdated": "2024-01-01T12:00:00.000Z",
    "createdAt": "2024-01-01T10:00:00.000Z",
    "updatedAt": "2024-01-01T12:00:00.000Z"
  }
}
```

**Error Responses:**
- `400` - Bad request (validation errors)
- `401` - Unauthorized
- `404` - Product not found or not available
- `500` - Internal server error

### PUT /api/cart/update/:productId
Update the quantity of a specific item in the cart.

**Headers:**
```
Authorization: Bearer <jwt_token>
Content-Type: application/json
```

**Parameters:**
- `productId` (string, required) - Product ID to update

**Request Body:**
```json
{
  "quantity": 5
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Cart item updated successfully",
  "data": {
    "id": "cart_123456",
    "user": "user_789012",
    "items": [
      {
        "product": "60d5ecb74f1a6b2f8c8b4567",
        "quantity": 5,
        "price": 25.99,
        "subtotal": 129.95,
        "addedAt": "2024-01-01T12:00:00.000Z"
      }
    ],
    "itemCount": 5,
    "total": 129.95,
    "currency": "USD",
    "lastUpdated": "2024-01-01T13:00:00.000Z",
    "createdAt": "2024-01-01T10:00:00.000Z",
    "updatedAt": "2024-01-01T13:00:00.000Z"
  }
}
```

**Error Responses:**
- `400` - Bad request (validation errors)
- `401` - Unauthorized
- `404` - Item not found in cart
- `500` - Internal server error

### DELETE /api/cart/remove/:productId
Remove a specific item from the cart completely.

**Headers:**
```
Authorization: Bearer <jwt_token>
```

**Parameters:**
- `productId` (string, required) - Product ID to remove

**Response (200):**
```json
{
  "success": true,
  "message": "Item removed from cart successfully",
  "data": {
    "id": "cart_123456",
    "user": "user_789012",
    "items": [],
    "itemCount": 0,
    "total": 0,
    "currency": "USD",
    "lastUpdated": "2024-01-01T13:30:00.000Z",
    "createdAt": "2024-01-01T10:00:00.000Z",
    "updatedAt": "2024-01-01T13:30:00.000Z"
  }
}
```

**Error Responses:**
- `401` - Unauthorized
- `404` - Item not found in cart
- `500` - Internal server error

### DELETE /api/cart/clear
Clear the entire cart (remove all items).

**Headers:**
```
Authorization: Bearer <jwt_token>
```

**Response (200):**
```json
{
  "success": true,
  "message": "Cart cleared successfully",
  "data": {
    "id": "cart_123456",
    "user": "user_789012",
    "items": [],
    "itemCount": 0,
    "total": 0,
    "currency": "USD",
    "lastUpdated": "2024-01-01T14:00:00.000Z",
    "createdAt": "2024-01-01T10:00:00.000Z",
    "updatedAt": "2024-01-01T14:00:00.000Z"
  }
}
```

**Error Responses:**
- `401` - Unauthorized
- `500` - Internal server error

### GET /api/cart/count
Get cart summary (item count and total) without full cart details - lightweight endpoint.

**Headers:**
```
Authorization: Bearer <jwt_token>
```

**Response (200):**
```json
{
  "success": true,
  "message": "Cart count retrieved successfully",
  "data": {
    "itemCount": 3,
    "total": 67.48
  }
}
```

**Error Responses:**
- `401` - Unauthorized
- `500` - Internal server error

## Data Models

### Cart Schema
```typescript
interface Cart {
  id: string;                    // Auto-generated cart ID
  user: string;                  // User ID (required)
  items: CartItem[];             // Array of cart items
  itemCount: number;             // Total quantity of all items
  total: number;                 // Total cart value
  currency: string;              // Currency code (default: "USD")
  lastUpdated: Date;             // Last time cart was modified
  createdAt: Date;               // Cart creation timestamp
  updatedAt: Date;               // Last update timestamp
}
```

### CartItem Schema
```typescript
interface CartItem {
  product: string;               // Product ID (required)
  quantity: number;              // Item quantity (required, min: 1)
  price: number;                 // Price at time of adding to cart
  subtotal: number;              // Calculated subtotal (quantity * price)
  addedAt: Date;                 // When item was added to cart
}
```

### Request/Response Types
```typescript
interface AddToCartRequest {
  productId: string;             // Product ID to add
  quantity: number;              // Quantity to add (min: 1, max: 99)
}

interface UpdateCartItemRequest {
  quantity: number;              // New quantity (min: 1, max: 99)
}

interface CartResponse {
  success: boolean;
  message: string;
  data: Cart;
}

interface CartCountResponse {
  success: boolean;
  message: string;
  data: {
    itemCount: number;
    total: number;
  };
}
```

## Usage Examples

### Using with Axios
```javascript
// Get full cart
const getCart = async (authToken) => {
  try {
    const response = await axios.get('/api/cart', {
      headers: {
        Authorization: `Bearer ${authToken}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Failed to fetch cart:', error.response.data);
    throw error;
  }
};

// Add item to cart
const addToCart = async (productId, quantity, authToken) => {
  try {
    const response = await axios.post('/api/cart/add', {
      productId,
      quantity
    }, {
      headers: {
        Authorization: `Bearer ${authToken}`,
        'Content-Type': 'application/json'
      }
    });
    return response.data;
  } catch (error) {
    console.error('Failed to add item to cart:', error.response.data);
    throw error;
  }
};

// Update item quantity
const updateCartItem = async (productId, quantity, authToken) => {
  try {
    const response = await axios.put(`/api/cart/update/${productId}`, {
      quantity
    }, {
      headers: {
        Authorization: `Bearer ${authToken}`,
        'Content-Type': 'application/json'
      }
    });
    return response.data;
  } catch (error) {
    console.error('Failed to update cart item:', error.response.data);
    throw error;
  }
};

// Remove item from cart
const removeFromCart = async (productId, authToken) => {
  try {
    const response = await axios.delete(`/api/cart/remove/${productId}`, {
      headers: {
        Authorization: `Bearer ${authToken}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Failed to remove item from cart:', error.response.data);
    throw error;
  }
};

// Clear entire cart
const clearCart = async (authToken) => {
  try {
    const response = await axios.delete('/api/cart/clear', {
      headers: {
        Authorization: `Bearer ${authToken}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Failed to clear cart:', error.response.data);
    throw error;
  }
};

// Get cart count (lightweight)
const getCartCount = async (authToken) => {
  try {
    const response = await axios.get('/api/cart/count', {
      headers: {
        Authorization: `Bearer ${authToken}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Failed to get cart count:', error.response.data);
    throw error;
  }
};
```

### Using with React
```jsx
import React, { useState, useEffect, useContext } from 'react';
import axios from 'axios';
import { AuthContext } from '../contexts/AuthContext';

const ShoppingCart = () => {
  const [cart, setCart] = useState(null);
  const [loading, setLoading] = useState(true);
  const [updating, setUpdating] = useState(false);
  const { user, token } = useContext(AuthContext);

  useEffect(() => {
    if (token) {
      fetchCart();
    }
  }, [token]);

  const fetchCart = async () => {
    try {
      setLoading(true);
      const response = await axios.get('/api/cart', {
        headers: { Authorization: `Bearer ${token}` }
      });
      setCart(response.data.data);
    } catch (error) {
      console.error('Failed to fetch cart:', error);
    } finally {
      setLoading(false);
    }
  };

  const addToCart = async (productId, quantity = 1) => {
    try {
      setUpdating(true);
      const response = await axios.post('/api/cart/add', {
        productId,
        quantity
      }, {
        headers: { 
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      });
      setCart(response.data.data);
    } catch (error) {
      console.error('Failed to add to cart:', error);
      alert('Failed to add item to cart');
    } finally {
      setUpdating(false);
    }
  };

  const updateQuantity = async (productId, quantity) => {
    try {
      setUpdating(true);
      const response = await axios.put(`/api/cart/update/${productId}`, {
        quantity
      }, {
        headers: { 
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json'  
        }
      });
      setCart(response.data.data);
    } catch (error) {
      console.error('Failed to update quantity:', error);
      alert('Failed to update item quantity');
    } finally {
      setUpdating(false);
    }
  };

  const removeItem = async (productId) => {
    try {
      setUpdating(true);
      const response = await axios.delete(`/api/cart/remove/${productId}`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      setCart(response.data.data);
    } catch (error) {
      console.error('Failed to remove item:', error);
      alert('Failed to remove item from cart');
    } finally {
      setUpdating(false);
    }
  };

  const clearCart = async () => {
    if (!window.confirm('Are you sure you want to clear your cart?')) {
      return;
    }

    try {
      setUpdating(true);
      const response = await axios.delete('/api/cart/clear', {
        headers: { Authorization: `Bearer ${token}` }
      });
      setCart(response.data.data);
    } catch (error) {
      console.error('Failed to clear cart:', error);
      alert('Failed to clear cart');
    } finally {
      setUpdating(false);
    }
  };

  if (loading) {
    return <div className="cart-loading">Loading cart...</div>;
  }

  if (!cart || cart.items.length === 0) {
    return (
      <div className="cart-empty">
        <h2>Your cart is empty</h2>
        <p>Add some items to get started!</p>
      </div>
    );
  }

  return (
    <div className="shopping-cart">
      <div className="cart-header">
        <h2>Shopping Cart ({cart.itemCount} items)</h2>
        <button 
          onClick={clearCart}
          disabled={updating}
          className="btn-clear-cart"
        >
          Clear Cart
        </button>
      </div>

      <div className="cart-items">
        {cart.items.map((item) => (
          <div key={item.product} className="cart-item">
            <div className="item-info">
              <h4>Product: {item.product}</h4>
              <p>Price: ${item.price}</p>
            </div>
            
            <div className="quantity-controls">
              <button 
                onClick={() => updateQuantity(item.product, item.quantity - 1)}
                disabled={updating || item.quantity <= 1}
              >
                -
              </button>
              <span>{item.quantity}</span>
              <button 
                onClick={() => updateQuantity(item.product, item.quantity + 1)}
                disabled={updating}
              >
                +
              </button>
            </div>

            <div className="item-total">
              <p>Subtotal: ${item.subtotal}</p>
              <button 
                onClick={() => removeItem(item.product)}
                disabled={updating}
                className="btn-remove"
              >
                Remove
              </button>
            </div>
          </div>
        ))}
      </div>

      <div className="cart-summary">
        <div className="cart-total">
          <h3>Total: ${cart.total}</h3>
        </div>
        <button 
          className="btn-checkout"
          disabled={updating}
        >
          Proceed to Checkout
        </button>
      </div>
    </div>
  );
};

export default ShoppingCart;
```

### Cart Counter Component
```jsx
import React, { useState, useEffect, useContext } from 'react';
import axios from 'axios';
import { AuthContext } from '../contexts/AuthContext';

const CartCounter = () => {
  const [cartCount, setCartCount] = useState(0);
  const [cartTotal, setCartTotal] = useState(0);
  const { token } = useContext(AuthContext);

  useEffect(() => {
    if (token) {
      fetchCartCount();
      
      // Poll for cart updates every 30 seconds
      const interval = setInterval(fetchCartCount, 30000);
      return () => clearInterval(interval);
    }
  }, [token]);

  const fetchCartCount = async () => {
    try {
      const response = await axios.get('/api/cart/count', {
        headers: { Authorization: `Bearer ${token}` }
      });
      setCartCount(response.data.data.itemCount);
      setCartTotal(response.data.data.total);
    } catch (error) {
      console.error('Failed to fetch cart count:', error);
    }
  };

  if (!token) {
    return null;
  }

  return (
    <div className="cart-counter">
      <span className="cart-icon">🛒</span>
      {cartCount > 0 && (
        <>
          <span className="cart-count">{cartCount}</span>
          <span className="cart-total">${cartTotal.toFixed(2)}</span>
        </>
      )}
    </div>
  );
};

export default CartCounter;
```

## Validation Rules

### Add to Cart
- `productId`: Required, string, valid product ID format
- `quantity`: Required, positive integer, range: 1-99

### Update Cart Item  
- `quantity`: Required, positive integer, range: 1-99
- `productId`: Must exist in user's cart

### Remove/Clear Operations
- User must be authenticated
- Cart must exist for user

## Security Considerations

### Authentication & Authorization
- All endpoints require valid JWT token
- Cart access restricted to cart owner only
- Token validation on every request
- User ID extracted from authenticated token

### Input Validation
- Quantity limits (1-99) to prevent abuse
- Product ID format validation
- SQL injection prevention
- XSS protection for all inputs

### Rate Limiting
- Cart operations rate limiting to prevent spam
- Different limits for read vs write operations
- User-based rate limiting

### Data Protection
- Cart data encrypted in transit (HTTPS)
- Sensitive cart data not logged
- User cart isolation and privacy

## Performance Optimization

### Caching Strategy
```javascript
// Cache user cart for quick access
const getCachedCart = async (userId) => {
  const cacheKey = `cart:${userId}`;
  const cached = await redis.get(cacheKey);
  
  if (cached) {
    return JSON.parse(cached);
  }
  
  const cart = await Cart.findOne({ user: userId }).populate('items.product');
  await redis.setex(cacheKey, 1800, JSON.stringify(cart)); // 30 min cache
  return cart;
};

// Invalidate cache on cart updates
const invalidateCartCache = async (userId) => {
  await redis.del(`cart:${userId}`);
};
```

### Database Optimization
```javascript
// Recommended indexes for MongoDB
db.carts.createIndex({ user: 1 }); // User cart lookup
db.carts.createIndex({ "items.product": 1 }); // Product lookups
db.carts.createIndex({ updatedAt: -1 }); // Recent carts
db.carts.createIndex({ user: 1, updatedAt: -1 }); // User + recency
```

### Response Optimization
- Lightweight `/count` endpoint for frequent checks
- Product details populated only when needed
- Pagination for large carts (if needed)
- Compressed responses for large cart data

## Testing

### Running Tests
```bash
# Run cart route tests
npm test -- cart.test.ts

# Run tests with coverage
npm run test:coverage -- cart.test.ts

# Run tests in watch mode
npm run test:watch -- cart.test.ts
```

### Test Coverage
The test suite covers:
- ✅ Complete CRUD operations for cart management
- ✅ Input validation and error handling
- ✅ Authentication and authorization scenarios
- ✅ HTTP method validation for all endpoints
- ✅ Content-Type handling and validation
- ✅ Response format consistency
- ✅ Edge cases and error conditions
- ✅ Special characters and encoding
- ✅ Large payload handling
- ✅ Concurrent operations handling
- ✅ Performance and load testing

## Integration

### With Express App
```typescript
import express from 'express';
import cartRoutes from './routes/cart/cart';
import { authenticateToken } from './middleware/auth';

const app = express();

// Apply middleware
app.use(express.json());

// Apply authentication to all cart routes
app.use('/api/cart', authenticateToken);

// Mount cart routes
app.use('/api/cart', cartRoutes);
```

### With Authentication Middleware
```typescript
import jwt from 'jsonwebtoken';

const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({
      success: false,
      message: 'Access token required'
    });
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({
        success: false,
        message: 'Invalid or expired token'
      });
    }
    
    req.user = user;
    next();
  });
};
```

### With Validation Middleware
```typescript
import { body, param, validationResult } from 'express-validator';

// Validation rules for adding to cart
export const validateAddToCart = [
  body('productId')
    .notEmpty()
    .withMessage('Product ID is required')
    .isLength({ min: 1, max: 100 })
    .withMessage('Product ID must be between 1 and 100 characters'),
  
  body('quantity')
    .isInt({ min: 1, max: 99 })
    .withMessage('Quantity must be between 1 and 99'),

  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: errors.array()
      });
    }
    next();
  }
];

// Usage in routes
router.post('/add', validateAddToCart, addToCartController);
```

## Error Handling

### Error Response Format
```json
{
  "success": false,
  "message": "Descriptive error message",
  "errors": [
    {
      "field": "quantity",
      "message": "Quantity must be at least 1"
    }
  ]
}
```

### Common Error Codes
- `400` - Bad Request (validation errors)
- `401` - Unauthorized (missing or invalid token)
- `403` - Forbidden (token expired)
- `404` - Not Found (item not in cart)
- `413` - Payload Too Large
- `429` - Too Many Requests (rate limiting)
- `500` - Internal Server Error

## Real-time Updates

### WebSocket Integration
```javascript
// Notify clients of cart updates
const notifyCartUpdate = (userId, cartData) => {
  const userSocket = connectedUsers.get(userId);
  if (userSocket) {
    userSocket.emit('cart:updated', {
      type: 'cart_update',
      data: cartData,
      timestamp: new Date().toISOString()
    });
  }
};

// Usage in cart operations
router.post('/add', async (req, res) => {
  // ... add item logic
  
  // Notify real-time updates
  notifyCartUpdate(req.user.id, updatedCart);
});
```

## Future Enhancements

### Planned Features
- [ ] Cart persistence across devices
- [ ] Guest cart functionality
- [ ] Cart sharing between users
- [ ] Saved for later functionality
- [ ] Cart recovery after session expiry
- [ ] Bulk operations (add multiple items)
- [ ] Cart templates/favorites
- [ ] Price change notifications
- [ ] Stock availability checking
- [ ] Automatic cart cleanup

### API Improvements
- [ ] GraphQL support for flexible cart queries
- [ ] Real-time cart synchronization
- [ ] Cart merge functionality
- [ ] Advanced cart analytics
- [ ] Cart recommendation engine
- [ ] Multi-currency support
- [ ] Cart export/import functionality

## Troubleshooting

### Common Issues

1. **Cart not updating after operations**
   - Check authentication token validity
   - Verify user permissions
   - Check for network connectivity issues
   - Clear application cache if needed

2. **Items not persisting in cart**
   - Verify database connection
   - Check cart model validation
   - Ensure proper transaction handling

3. **Performance issues with large carts**
   - Implement cart item pagination
   - Use cart summary endpoints for counts
   - Enable cart caching
   - Optimize database queries

4. **Authentication failures**
   - Verify JWT token format and expiry
   - Check authentication middleware configuration
   - Ensure proper token headers

## Contributing

### Code Style
- Follow TypeScript best practices
- Use async/await for asynchronous operations
- Implement comprehensive error handling
- Write detailed tests for all scenarios
- Include Swagger documentation

### Adding New Features
1. Add route handler with validation
2. Include comprehensive Swagger documentation
3. Create thorough tests covering all cases
4. Update this README with feature documentation
5. Consider performance and security implications

## License

This cart module is part of the DeliverGaz project and follows the project's licensing terms.