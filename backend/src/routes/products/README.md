# Products Routes

A comprehensive product management system for the DeliverGaz application, providing CRUD operations for product catalog management.

## Overview

This module handles all product-related routes including product listing, creation, retrieval, updating, and deletion. It provides RESTful endpoints with comprehensive Swagger documentation and supports advanced features like pagination, filtering, and search.

## Features

- 📦 **Product Catalog** - Complete product management system
- 🔍 **Search & Filter** - Advanced product search and filtering
- 📄 **Pagination** - Efficient large dataset handling
- 📝 **CRUD Operations** - Create, Read, Update, Delete products
- 🏷️ **Category Management** - Product categorization
- 📊 **Inventory Tracking** - Stock management
- 📸 **Image Management** - Product image handling
- 📝 **Swagger Documentation** - Complete API documentation
- ✅ **Consistent Responses** - Standardized response format
- 🧪 **Comprehensive Testing** - Full test coverage

## Files Structure

```
routes/products/
├── products.route.ts      # Main product routes (updated naming)
├── products.route.test.ts # Test suite (updated naming) 
├── index.ts              # Route exports
└── README.md             # Documentation (this file)
```

## Recent Updates

- ✅ **File Naming**: Updated to `.route.ts` convention for consistency
- ✅ **Comprehensive Swagger Docs**: Detailed API documentation with examples
- ✅ **Enhanced Filtering**: Advanced search and category filtering
- ✅ **Pagination Support**: Efficient handling of large product catalogs
- ✅ **Mock Data Ready**: Development-friendly mock responses
- ✅ **Admin Features**: Role-based access for product management

## API Endpoints

### GET /api/products
Retrieve paginated list of products with optional filtering and search.

**Query Parameters:**
- `page` (integer, default: 1) - Page number
- `limit` (integer, default: 10) - Products per page
- `category` (string) - Filter by category
- `search` (string) - Search by name or description
- `minPrice` (number) - Minimum price filter
- `maxPrice` (number) - Maximum price filter
- `inStock` (boolean) - Filter by stock availability

**Example Request:**
```
GET /api/products?page=2&limit=20&category=gas&search=cylinder&minPrice=20&maxPrice=50
```

**Response (200):**
```json
{
  "success": true,
  "message": "Products retrieved successfully",
  "data": {
    "products": [
      {
        "id": "product_123",
        "name": "Gas Cylinder 15kg",
        "description": "High-quality gas cylinder for cooking",
        "price": 25.99,
        "category": "Gas Cylinders",
        "stock": 100,
        "unit": "piece",
        "images": ["image1.jpg", "image2.jpg"],
        "isActive": true,
        "createdAt": "2024-01-01T12:00:00.000Z",
        "updatedAt": "2024-01-01T12:00:00.000Z"
      }
    ],
    "pagination": {
      "currentPage": 2,
      "totalPages": 15,
      "totalProducts": 148,
      "hasNext": true,
      "hasPrev": true
    }
  }
}
```

### GET /api/products/:id
Retrieve a specific product by ID.

**Parameters:**
- `id` (string, required) - Product ID

**Response (200):**
```json
{
  "success": true,
  "message": "Product retrieved successfully",
  "data": {
    "id": "product_123",
    "name": "Gas Cylinder 15kg",
    "description": "High-quality gas cylinder for cooking",
    "price": 25.99,
    "category": "Gas Cylinders",
    "stock": 100,
    "unit": "piece",
    "images": ["image1.jpg", "image2.jpg"],
    "isActive": true,
    "createdAt": "2024-01-01T12:00:00.000Z",
    "updatedAt": "2024-01-01T12:00:00.000Z"
  }
}
```

**Error Response:**
- `404` - Product not found

### POST /api/products
Create a new product (Admin only).

**Headers:**
```
Authorization: Bearer <admin_jwt_token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "Gas Cylinder 15kg",
  "description": "High-quality gas cylinder for cooking",
  "price": 25.99,
  "category": "Gas Cylinders",
  "stock": 100,
  "unit": "piece",
  "images": ["image1.jpg", "image2.jpg"]
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "Product created successfully",
  "data": {
    "id": "product_456",
    "name": "Gas Cylinder 15kg",
    "description": "High-quality gas cylinder for cooking",
    "price": 25.99,
    "category": "Gas Cylinders",
    "stock": 100,
    "unit": "piece",
    "images": ["image1.jpg", "image2.jpg"],
    "isActive": true,
    "createdAt": "2024-01-01T12:00:00.000Z",
    "updatedAt": "2024-01-01T12:00:00.000Z"
  }
}
```

**Error Responses:**
- `400` - Bad request (validation errors)
- `401` - Unauthorized
- `403` - Forbidden (admin access required)

### PUT /api/products/:id
Update an existing product (Admin only).

**Headers:**
```
Authorization: Bearer <admin_jwt_token>
Content-Type: application/json
```

**Parameters:**
- `id` (string, required) - Product ID

**Request Body (partial updates allowed):**
```json
{
  "name": "Updated Gas Cylinder 15kg",
  "price": 27.99,
  "stock": 85,
  "isActive": true
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Product updated successfully",
  "data": {
    "id": "product_123",
    "name": "Updated Gas Cylinder 15kg",
    "description": "High-quality gas cylinder for cooking",
    "price": 27.99,
    "category": "Gas Cylinders",
    "stock": 85,
    "unit": "piece",
    "images": ["image1.jpg", "image2.jpg"],
    "isActive": true,
    "createdAt": "2024-01-01T12:00:00.000Z",
    "updatedAt": "2024-01-01T13:30:00.000Z"
  }
}
```

**Error Responses:**
- `400` - Bad request (validation errors)
- `401` - Unauthorized
- `403` - Forbidden (admin access required)
- `404` - Product not found

### DELETE /api/products/:id
Delete a product (Admin only).

**Headers:**
```
Authorization: Bearer <admin_jwt_token>
```

**Parameters:**
- `id` (string, required) - Product ID

**Response (200):**
```json
{
  "success": true,
  "message": "Product deleted successfully"
}
```

**Error Responses:**
- `401` - Unauthorized
- `403` - Forbidden (admin access required)
- `404` - Product not found

## Data Models

### Product Schema
```typescript
interface Product {
  id: string;                    // Auto-generated product ID
  name: string;                  // Product name (required)
  description?: string;          // Product description
  price: number;                 // Product price (required)
  category: string;              // Product category (required)
  stock: number;                 // Available stock quantity
  unit: string;                  // Unit of measurement (piece, kg, liter, etc.)
  images: string[];              // Array of image URLs
  isActive: boolean;             // Whether product is active/visible
  specifications?: object;       // Additional product specifications
  tags?: string[];              // Product tags for search
  createdAt: Date;              // Creation timestamp
  updatedAt: Date;              // Last update timestamp
}
```

### Request/Response Types
```typescript
interface CreateProductRequest {
  name: string;
  description?: string;
  price: number;
  category: string;
  stock?: number;
  unit?: string;
  images?: string[];
  specifications?: object;
  tags?: string[];
}

interface UpdateProductRequest {
  name?: string;
  description?: string;
  price?: number;
  category?: string;
  stock?: number;
  unit?: string;
  images?: string[];
  isActive?: boolean;
  specifications?: object;
  tags?: string[];
}

interface ProductListResponse {
  success: boolean;
  message: string;
  data: {
    products: Product[];
    pagination: {
      currentPage: number;
      totalPages: number;
      totalProducts: number;
      hasNext: boolean;
      hasPrev: boolean;
    };
  };
}

interface ProductResponse {
  success: boolean;
  message: string;
  data: Product;
}
```

## Usage Examples

### Using with Axios
```javascript
// Get all products with pagination and filters
const getProducts = async (filters = {}) => {
  try {
    const params = new URLSearchParams(filters);
    const response = await axios.get(`/api/products?${params}`);
    return response.data;
  } catch (error) {
    console.error('Failed to fetch products:', error.response.data);
    throw error;
  }
};

// Get specific product
const getProduct = async (productId) => {
  try {
    const response = await axios.get(`/api/products/${productId}`);
    return response.data;
  } catch (error) {
    console.error('Failed to fetch product:', error.response.data);
    throw error;
  }
};

// Create new product (admin only)
const createProduct = async (productData, authToken) => {
  try {
    const response = await axios.post('/api/products', productData, {
      headers: {
        Authorization: `Bearer ${authToken}`,
        'Content-Type': 'application/json'
      }
    });
    return response.data;
  } catch (error) {
    console.error('Failed to create product:', error.response.data);
    throw error;
  }
};

// Update product (admin only)
const updateProduct = async (productId, updateData, authToken) => {
  try {
    const response = await axios.put(`/api/products/${productId}`, updateData, {
      headers: {
        Authorization: `Bearer ${authToken}`,
        'Content-Type': 'application/json'
      }
    });
    return response.data;
  } catch (error) {
    console.error('Failed to update product:', error.response.data);
    throw error;
  }
};

// Delete product (admin only)
const deleteProduct = async (productId, authToken) => {
  try {
    const response = await axios.delete(`/api/products/${productId}`, {
      headers: {
        Authorization: `Bearer ${authToken}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Failed to delete product:', error.response.data);
    throw error;
  }
};
```

### Using with React
```jsx
import React, { useState, useEffect } from 'react';
import axios from 'axios';

const ProductCatalog = () => {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);
  const [filters, setFilters] = useState({});

  useEffect(() => {
    fetchProducts();
  }, [page, filters]);

  const fetchProducts = async () => {
    try {
      setLoading(true);
      const params = { page, limit: 20, ...filters };
      const response = await axios.get('/api/products', { params });
      setProducts(response.data.data.products);
    } catch (error) {
      console.error('Failed to fetch products:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleSearch = (searchTerm) => {
    setFilters({ ...filters, search: searchTerm });
    setPage(1);
  };

  const handleCategoryFilter = (category) => {
    setFilters({ ...filters, category });
    setPage(1);
  };

  if (loading) return <div>Loading products...</div>;

  return (
    <div>
      <h1>Product Catalog</h1>
      {/* Search and filter components */}
      <div className="products-grid">
        {products.map(product => (
          <div key={product.id} className="product-card">
            <h3>{product.name}</h3>
            <p>{product.description}</p>
            <p className="price">${product.price}</p>
            <p className="stock">Stock: {product.stock} {product.unit}</p>
          </div>
        ))}
      </div>
    </div>
  );
};
```

## Search and Filtering

### Advanced Search
```javascript
// Search by name or description
const searchProducts = async (searchTerm) => {
  const response = await axios.get(`/api/products?search=${encodeURIComponent(searchTerm)}`);
  return response.data;
};

// Filter by category
const getProductsByCategory = async (category) => {
  const response = await axios.get(`/api/products?category=${encodeURIComponent(category)}`);
  return response.data;
};

// Price range filter
const getProductsByPriceRange = async (minPrice, maxPrice) => {
  const response = await axios.get(`/api/products?minPrice=${minPrice}&maxPrice=${maxPrice}`);
  return response.data;
};

// Combined filters
const getFilteredProducts = async (filters) => {
  const params = new URLSearchParams();
  Object.entries(filters).forEach(([key, value]) => {
    if (value !== undefined && value !== '') {
      params.append(key, value);
    }
  });
  
  const response = await axios.get(`/api/products?${params}`);
  return response.data;
};
```

### Pagination
```javascript
const ProductPagination = ({ currentPage, totalPages, onPageChange }) => {
  const handlePrevious = () => {
    if (currentPage > 1) {
      onPageChange(currentPage - 1);
    }
  };

  const handleNext = () => {
    if (currentPage < totalPages) {
      onPageChange(currentPage + 1);
    }
  };

  return (
    <div className="pagination">
      <button 
        onClick={handlePrevious} 
        disabled={currentPage === 1}
      >
        Previous
      </button>
      <span>Page {currentPage} of {totalPages}</span>
      <button 
        onClick={handleNext} 
        disabled={currentPage === totalPages}
      >
        Next
      </button>
    </div>
  );
};
```

## Validation Rules

### Product Creation
- `name`: Required, string, 3-100 characters
- `price`: Required, positive number, max 2 decimal places
- `category`: Required, string, from predefined categories
- `description`: Optional, string, max 1000 characters
- `stock`: Optional, non-negative integer, default: 0
- `unit`: Optional, string, from predefined units
- `images`: Optional, array of valid image URLs

### Product Updates
- All fields optional for updates
- Same validation rules apply to provided fields
- `isActive`: Boolean to activate/deactivate product

## Security Considerations

### Access Control
- Product listing and viewing: Public access
- Product creation: Admin access required
- Product updates: Admin access required
- Product deletion: Admin access required

### Input Validation
- SQL injection prevention
- XSS protection for text fields
- File upload validation for images
- Price validation (positive numbers only)
- Stock validation (non-negative integers)

### Rate Limiting
- Search endpoint rate limiting to prevent abuse
- API endpoint rate limiting for anonymous users
- Relaxed limits for authenticated users

## Performance Optimization

### Database Indexing
```javascript
// Recommended indexes for MongoDB
db.products.createIndex({ name: "text", description: "text" }); // Text search
db.products.createIndex({ category: 1 }); // Category filtering
db.products.createIndex({ price: 1 }); // Price sorting/filtering
db.products.createIndex({ isActive: 1, createdAt: -1 }); // Active products, newest first
```

### Caching Strategy
```javascript
// Cache frequently accessed products
const getCachedProduct = async (productId) => {
  const cached = await redis.get(`product:${productId}`);
  if (cached) {
    return JSON.parse(cached);
  }
  
  const product = await Product.findById(productId);
  await redis.setex(`product:${productId}`, 3600, JSON.stringify(product)); // 1 hour cache
  return product;
};
```

## Testing

### Running Tests
```bash
# Run product route tests
npm test -- products.test.ts

# Run tests with coverage
npm run test:coverage -- products.test.ts

# Run tests in watch mode
npm run test:watch -- products.test.ts
```

### Test Coverage
The test suite covers:
- ✅ CRUD operations for all endpoints
- ✅ Query parameter handling and validation
- ✅ Pagination and filtering
- ✅ HTTP method validation
- ✅ Content-Type handling
- ✅ Response format consistency
- ✅ Error handling and edge cases
- ✅ Special characters and encoding
- ✅ Large payload handling
- ✅ Authentication and authorization

## Integration

### With Express App
```typescript
import express from 'express';
import productsRoutes from './routes/products/products';
import { authenticateToken, requireAdmin } from './middleware/auth';

const app = express();

// Apply middleware
app.use(express.json());

// Mount product routes
app.use('/api/products', productsRoutes);

// Apply admin authentication to write operations
app.use('/api/products', (req, res, next) => {
  if (['POST', 'PUT', 'DELETE'].includes(req.method)) {
    return authenticateToken(req, res, () => {
      requireAdmin(req, res, next);
    });
  }
  next();
});
```

### With Validation Middleware
```typescript
import { validateProduct, validatePagination } from '../middleware/validation';

// Apply validation
router.get('/', validatePagination, getProductsController);
router.post('/', validateProduct, createProductController);
router.put('/:id', validateProduct, updateProductController);
```

## Error Handling

### Error Response Format
```json
{
  "success": false,
  "message": "Descriptive error message",
  "errors": [
    {
      "field": "price",
      "message": "Price must be a positive number"
    }
  ]
}
```

### Common Error Codes
- `400` - Bad Request (validation errors)
- `401` - Unauthorized (missing or invalid token)
- `403` - Forbidden (insufficient permissions)
- `404` - Not Found (product doesn't exist)
- `422` - Unprocessable Entity (validation failed)
- `500` - Internal Server Error

## Future Enhancements

### Planned Features
- [ ] Product reviews and ratings
- [ ] Product variants (size, color, etc.)
- [ ] Bulk operations (import/export)
- [ ] Product recommendations
- [ ] Inventory alerts and notifications
- [ ] Product analytics and reporting
- [ ] Multi-language support
- [ ] Advanced search with filters
- [ ] Product comparison features
- [ ] Wishlist functionality

### API Improvements
- [ ] GraphQL support for flexible queries
- [ ] Real-time inventory updates via WebSocket
- [ ] Advanced caching strategies
- [ ] CDN integration for images
- [ ] Elasticsearch integration for advanced search

## Troubleshooting

### Common Issues

1. **Products not appearing in search**
   - Check if products are marked as `isActive: true`
   - Verify text indexes are created in database
   - Check search term formatting

2. **Pagination not working correctly**
   - Verify page and limit parameters are positive integers
   - Check total count calculation in database query

3. **Image upload failures**
   - Verify image URL format and accessibility
   - Check file size and format restrictions
   - Ensure proper image storage configuration

4. **Performance issues with large catalogs**
   - Implement database indexes
   - Use caching for frequently accessed products
   - Consider pagination with smaller page sizes

## Contributing

### Code Style
- Follow TypeScript best practices
- Use async/await for asynchronous operations
- Implement proper error handling
- Write comprehensive tests
- Include Swagger documentation for new endpoints

### Adding New Features
1. Add route handler with proper validation
2. Include comprehensive Swagger documentation
3. Create thorough tests covering all scenarios
4. Update this README with feature documentation
5. Consider performance implications

## License

This products module is part of the DeliverGaz project and follows the project's licensing terms.