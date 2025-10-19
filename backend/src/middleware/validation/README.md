# Validation Middleware Documentation

This document provides comprehensive information about the validation middleware system for the DeliverGaz backend application.

## Overview

The validation middleware uses `express-validator` to provide robust input validation, sanitization, and error handling for API endpoints. It includes pre-built validation chains for common entities and operations in a delivery service application.

## Features

- **Comprehensive Validation**: Covers all major entities (Users, Products, Orders, Cart, Reviews)
- **Security-First**: Includes XSS protection, input sanitization, and secure validation patterns
- **TypeScript Support**: Full TypeScript integration with proper type safety
- **Flexible Architecture**: Modular validation chains that can be combined and reused
- **Detailed Error Messages**: User-friendly error responses with specific field-level feedback
- **File Upload Validation**: Built-in support for file upload validation with size and type checks

## Installation

The required dependencies are already included in `package.json`:

```json
{
  "dependencies": {
    "express-validator": "^7.0.1"
  }
}
```

## Basic Usage

### Import the validation functions

```typescript
import {
  validateUserRegistration,
  validateUserLogin,
  validateProduct,
  handleValidationErrors,
  sanitizeInput
} from '../middleware/validation';
```

### Apply validation to routes

```typescript
import { Router } from 'express';
const router = Router();

// User registration with validation
router.post('/register', validateUserRegistration, async (req, res) => {
  // If we reach here, validation passed
  const { email, password, firstName, lastName } = req.body;
  // Your registration logic...
});

// Product creation with validation
router.post('/products', validateProduct, async (req, res) => {
  // Validated product data available in req.body
  // Your product creation logic...
});
```

## Available Validation Chains

### User Validation

#### `validateUserRegistration`
Validates user registration data including:
- Email (required, valid format, normalized)
- Password (required, min 8 chars, complexity rules)
- First name (required, 2-50 chars, letters only)
- Last name (required, 2-50 chars, letters only)
- Phone number (optional, international format)
- Role (optional, predefined values)
- Date of birth (optional, ISO 8601 format)

#### `validateUserLogin`
Validates login credentials:
- Email (required, valid format)
- Password (required, non-empty)

#### `validateUserProfileUpdate`
Validates profile updates (all fields optional):
- First name, last name, phone number
- Date of birth, address fields

#### `validatePasswordChange`
Validates password change requests:
- Current password (required)
- New password (required, complexity rules)
- Confirm password (required, must match new password)

### Product Validation

#### `validateProduct`
Validates product creation:
- Name (required, 2-200 chars)
- Description (required, 10-1000 chars)
- Price (required, positive number)
- Category (required, 2-100 chars)
- Brand (optional, 2-100 chars)
- Weight, dimensions (optional, positive numbers)
- Stock information (optional)

#### `validateProductUpdate`
Same as `validateProduct` but all fields are optional.

### Order Validation

#### `validateOrder`
Validates order creation:
- Items array (required, min 1 item)
- Each item: productId, quantity, price
- Delivery address (required)
- Delivery date (optional, must be future)
- Payment method (required, predefined values)
- Notes (optional, max 500 chars)

#### `validateOrderStatusUpdate`
Validates order status changes:
- Status (required, predefined values)
- Notes (optional, max 500 chars)

### Cart Validation

#### `validateCartItem`
Validates cart item operations:
- Product ID (required, valid MongoDB ObjectId)
- Quantity (required, positive integer)

### Search and Filtering

#### `validateSearch`
Validates search parameters:
- Query string (optional, 1-200 chars)
- Category filter (optional)
- Price range (optional, positive numbers)
- Sort options (optional, predefined values)

#### `validatePagination`
Validates pagination parameters:
- Page (optional, positive integer)
- Limit (optional, 1-100)

### Review Validation

#### `validateReview`
Validates product reviews:
- Product ID (required, valid MongoDB ObjectId)
- Rating (required, 1-5 integer)
- Comment (optional, 10-1000 chars)

### Delivery Validation

#### `validateDeliveryUpdate`
Validates delivery status updates:
- Order ID (required, valid MongoDB ObjectId)
- Current coordinates (required, valid lat/lng)
- Status (required, predefined values)
- Estimated arrival (optional, future date)
- Notes (optional, max 500 chars)

## Individual Validation Helpers

### Common Validators

```typescript
// Email validation
validateEmail('email') // or custom field name

// Password validation
validatePassword('password', false) // required
validatePassword('newPassword', true) // optional

// Name validation
validateName('firstName', false) // required
validateName('middleName', true) // optional

// Phone number validation
validatePhoneNumber('phone', true) // optional

// MongoDB ObjectId validation
validateObjectId('userId', 'param') // from route params
validateObjectId('productId', 'body') // from request body
validateObjectId('orderId', 'query') // from query string

// Price and quantity validation
validatePrice('price', false) // required
validateQuantity('quantity', true) // optional

// Coordinates validation
validateCoordinates('lat', 'lng') // returns array of validators

// Address validation
validateAddress(false) // required address
validateAddress(true) // optional address
```

## File Upload Validation

```typescript
import { validateFileUpload } from '../middleware/validation';

// Image upload validation
router.post('/upload', 
  validateFileUpload(
    'image', // field name
    ['image/jpeg', 'image/png', 'image/gif'], // allowed types
    5 * 1024 * 1024 // max size (5MB)
  ),
  async (req, res) => {
    // File is validated and available in req.file
  }
);
```

## Error Handling

### Automatic Error Handling

Most validation chains include `handleValidationErrors` at the end, which automatically:
- Collects all validation errors
- Formats them into a consistent response structure
- Returns a 400 status code with detailed error information

### Manual Error Handling

```typescript
import { handleValidationErrors } from '../middleware/validation';

router.post('/custom', [
  body('field').isLength({ min: 5 }),
  handleValidationErrors // Add this manually
], async (req, res) => {
  // Your logic here
});
```

### Error Response Format

```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [
    {
      "field": "email",
      "value": "invalid-email",
      "message": "Please provide a valid email address",
      "location": "body"
    }
  ],
  "error": {
    "code": "VALIDATION_ERROR",
    "type": "ValidationError",
    "timestamp": "2025-10-12T10:30:45.123Z"
  }
}
```

## Security Features

### Input Sanitization

```typescript
import { sanitizeInput } from '../middleware/validation';

// Apply to all routes
app.use(sanitizeInput);

// Or apply to specific routes
router.post('/data', sanitizeInput, (req, res) => {
  // All inputs are sanitized
});
```

### XSS Protection

The sanitization middleware automatically:
- Removes `<script>` tags and their content
- Sanitizes nested objects and arrays
- Preserves legitimate HTML entities

## Advanced Usage

### Combining Validations

```typescript
import { combineValidations } from '../middleware/validation';

// Note: Only use with pure ValidationChain arrays
const customValidation = combineValidations(
  [body('field1').notEmpty()],
  [body('field2').isEmail()]
);

router.post('/custom', customValidation, handleValidationErrors, (req, res) => {
  // Your logic
});
```

### Conditional Validation

```typescript
import { conditionalValidation } from '../middleware/validation';

const conditionalEmail = conditionalValidation(
  (req) => req.body.type === 'email',
  body('email').isEmail()
);
```

### Custom Validators

```typescript
import { body } from 'express-validator';

const customValidator = body('field').custom((value, { req }) => {
  if (value !== 'expected') {
    throw new Error('Custom validation failed');
  }
  return true;
});

router.post('/custom', [customValidator, handleValidationErrors], (req, res) => {
  // Your logic
});
```

## Best Practices

### 1. Always Handle Validation Errors

```typescript
// Good
router.post('/endpoint', validateUser, async (req, res) => {
  // Validation errors are automatically handled
});

// Also good for custom validations
router.post('/endpoint', [
  body('field').notEmpty(),
  handleValidationErrors
], async (req, res) => {
  // Custom validation with error handling
});
```

### 2. Use Appropriate Validation Chains

```typescript
// Good - Use pre-built chains for common operations
router.post('/register', validateUserRegistration, handler);

// Good - Combine ObjectId validation for route params
router.put('/users/:id', [
  validateObjectId('id', 'param'),
  handleValidationErrors,
  validateUserProfileUpdate
], handler);
```

### 3. Sanitize Inputs

```typescript
// Apply sanitization globally or per route
app.use('/api', sanitizeInput);
```

### 4. Validate File Uploads

```typescript
// Always validate file uploads
router.post('/upload', [
  validateFileUpload('image', ['image/jpeg', 'image/png'], 2 * 1024 * 1024),
  // Your upload logic
], handler);
```

### 5. Use Type Safety

```typescript
// The middleware preserves TypeScript types
interface CreateUserRequest {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
}

router.post('/users', validateUserRegistration, async (req: Request, res: Response) => {
  const userData: CreateUserRequest = req.body; // Type-safe after validation
});
```

## Testing Validation

### Unit Testing Example

```typescript
import request from 'supertest';
import app from '../app';

describe('User Registration Validation', () => {
  it('should reject invalid email', async () => {
    const response = await request(app)
      .post('/api/auth/register')
      .send({
        email: 'invalid-email',
        password: 'ValidPass123!',
        firstName: 'John',
        lastName: 'Doe'
      });

    expect(response.status).toBe(400);
    expect(response.body.success).toBe(false);
    expect(response.body.errors).toContainEqual(
      expect.objectContaining({
        field: 'email',
        message: 'Please provide a valid email address'
      })
    );
  });

  it('should accept valid registration data', async () => {
    const response = await request(app)
      .post('/api/auth/register')
      .send({
        email: 'john@example.com',
        password: 'ValidPass123!',
        firstName: 'John',
        lastName: 'Doe'
      });

    expect(response.status).toBe(201);
    expect(response.body.success).toBe(true);
  });
});
```

## Migration Guide

If you have existing validation code, here's how to migrate:

### Before (Manual Validation)

```typescript
router.post('/users', (req, res) => {
  const { email, password } = req.body;
  
  if (!email || !email.includes('@')) {
    return res.status(400).json({ error: 'Invalid email' });
  }
  
  if (!password || password.length < 8) {
    return res.status(400).json({ error: 'Password too short' });
  }
  
  // User creation logic...
});
```

### After (Validation Middleware)

```typescript
import { validateUserRegistration } from '../middleware/validation';

router.post('/users', validateUserRegistration, (req, res) => {
  // Validation is handled automatically
  // If we reach here, all data is valid
  const { email, password } = req.body;
  
  // User creation logic...
});
```

## Contributing

When adding new validation chains:

1. Follow the established naming convention (`validate[Entity][Operation]`)
2. Include comprehensive field validation
3. Add `handleValidationErrors` at the end
4. Update this documentation
5. Add examples to `validation.examples.ts`
6. Write unit tests

## Examples

See `validation.examples.ts` for complete working examples of all validation chains in action.