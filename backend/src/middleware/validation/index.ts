/**
 * Validation middleware using express-validator
 * Provides comprehensive validation for DeliverGaz API endpoints
 */

import { Request, Response, NextFunction } from 'express';
import { body, param, query, validationResult, ValidationChain, type ValidationError as EVValidationError } from 'express-validator';

/**
 * Multer file interface
 */
interface MulterFile {
  fieldname: string;
  originalname: string;
  encoding: string;
  mimetype: string;
  buffer: Buffer;
  size: number;
  destination?: string;
  filename?: string;
  path?: string;
}

/**
 * Extended Request interface for file uploads
 */
interface RequestWithFile extends Request {
  file?: MulterFile;
  files?: MulterFile[] | { [fieldname: string]: MulterFile[] };
}

/**
 * Custom validation error interface
 */
export interface ValidationError {
  success: false;
  message: string;
  errors: Array<{
    field: string;
    value: any;
    message: string;
    location: string;
  }>;
  error: {
    code: string;
    type: string;
    timestamp: string;
  };
}

/**
 * Middleware to handle validation results
 * Should be used after validation chains
 */
export const handleValidationErrors = (
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  const errors = validationResult(req);
  
  if (!errors.isEmpty()) {
    const formattedErrors = errors.array().map((error: EVValidationError) => ({
      field: error.type === 'field' ? error.path : 'unknown',
      value: error.type === 'field' ? error.value : undefined,
      message: error.msg,
      location: error.type === 'field' ? error.location : 'body'
    }));

    const response: ValidationError = {
      success: false,
      message: 'Validation failed',
      errors: formattedErrors,
      error: {
        code: 'VALIDATION_ERROR',
        type: 'ValidationError',
        timestamp: new Date().toISOString(),
      },
    };

    res.status(400).json(response);
    return;
  }

  next();
};

/**
 * Common validation patterns
 */

// Email validation
export const validateEmail = (field: string = 'email') =>
  body(field)
    .isEmail()
    .withMessage('Please provide a valid email address')
    .normalizeEmail()
    .toLowerCase();

// Password validation
export const validatePassword = (field: string = 'password', isOptional: boolean = false) => {
  const validator = body(field)
    .isLength({ min: 8 })
    .withMessage('Password must be at least 8 characters long')
    .matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]/)
    .withMessage('Password must contain at least one lowercase letter, one uppercase letter, one number, and one special character');
  
  return isOptional ? validator.optional() : validator;
};

// Phone number validation (international format)
export const validatePhoneNumber = (field: string = 'phoneNumber', isOptional: boolean = false) => {
  const validator = body(field)
    .isString()
    .withMessage('Please provide a valid phone number');
  
  return isOptional ? validator.optional() : validator;
};

// Name validation
export const validateName = (field: string, isOptional: boolean = false) => {
  const validator = body(field)
    .isLength({ min: 2, max: 50 })
    .withMessage(`${field} must be between 2 and 50 characters`)
    .matches(/^[a-zA-Z\s'-]+$/)
    .withMessage(`${field} can only contain letters, spaces, hyphens, and apostrophes`)
    .trim();
  
  return isOptional ? validator.optional() : validator;
};

// MongoDB ObjectId validation
export const validateObjectId = (field: string, location: 'body' | 'param' | 'query' = 'param') => {
  const validator = location === 'body' ? body(field) : 
                   location === 'param' ? param(field) : 
                   query(field);
                   
  return validator
    .isMongoId()
    .withMessage(`${field} must be a valid MongoDB ObjectId`);
};

// Price validation
export const validatePrice = (field: string = 'price', isOptional: boolean = false) => {
  const validator = body(field)
    .isFloat({ min: 0 })
    .withMessage('Price must be a positive number')
    .toFloat();
  
  return isOptional ? validator.optional() : validator;
};

// Quantity validation
export const validateQuantity = (field: string = 'quantity', isOptional: boolean = false) => {
  const validator = body(field)
    .isInt({ min: 1 })
    .withMessage('Quantity must be a positive integer')
    .toInt();
  
  return isOptional ? validator.optional() : validator;
};

// Coordinates validation (latitude, longitude)
export const validateCoordinates = (latField: string = 'latitude', lngField: string = 'longitude') => [
  body(latField)
    .isFloat({ min: -90, max: 90 })
    .withMessage('Latitude must be between -90 and 90 degrees')
    .toFloat(),
  body(lngField)
    .isFloat({ min: -180, max: 180 })
    .withMessage('Longitude must be between -180 and 180 degrees')
    .toFloat()
];

// Address validation
export const validateAddress = (isOptional: boolean = false) => {
  const validators = [
    body('address.street')
      .isLength({ min: 5, max: 200 })
      .withMessage('Street address must be between 5 and 200 characters')
      .trim(),
    body('address.city')
      .isLength({ min: 2, max: 100 })
      .withMessage('City must be between 2 and 100 characters')
      .matches(/^[a-zA-Z\s'-]+$/)
      .withMessage('City can only contain letters, spaces, hyphens, and apostrophes')
      .trim(),
    body('address.state')
      .optional()
      .isLength({ min: 2, max: 100 })
      .withMessage('State must be between 2 and 100 characters')
      .trim(),
    body('address.postalCode')
      .isLength({ min: 3, max: 20 })
      .withMessage('Postal code must be between 3 and 20 characters')
      .trim(),
    body('address.country')
      .isLength({ min: 2, max: 100 })
      .withMessage('Country must be between 2 and 100 characters')
      .trim()
  ];

  return isOptional ? validators.map(v => v.optional()) : validators;
};

/**
 * Entity-specific validation chains
 */

// User registration validation
export const validateUserRegistration = [
  validateEmail(),
  validatePassword(),
  validateName('firstName'),
  validateName('lastName'),
  body('phoneNumber').optional().custom(() => true),
  body('role')
    .optional()
    .isIn(['customer', 'delivery_agent', 'admin'])
    .withMessage('Role must be one of: customer, delivery_agent, admin'),
  body('dateOfBirth')
    .optional()
    .isISO8601()
    .withMessage('Date of birth must be a valid ISO 8601 date')
    .toDate(),
  handleValidationErrors
];

// User login validation
export const validateUserLogin = [
  validateEmail(),
  body('password')
    .notEmpty()
    .withMessage('Password is required'),
  handleValidationErrors
];

// User profile update validation
export const validateUserProfileUpdate = [
  validateName('firstName', true),
  validateName('lastName', true),
  validatePhoneNumber('phoneNumber', true),
  body('dateOfBirth')
    .optional()
    .isISO8601()
    .withMessage('Date of birth must be a valid ISO 8601 date')
    .toDate(),
  ...validateAddress(true),
  handleValidationErrors
];

// Password change validation
export const validatePasswordChange = [
  body('currentPassword')
    .notEmpty()
    .withMessage('Current password is required'),
  validatePassword('newPassword'),
  body('confirmPassword')
    .custom((value, { req }) => {
      if (value !== req.body.newPassword) {
        throw new Error('Password confirmation does not match new password');
      }
      return true;
    }),
  handleValidationErrors
];

// Product validation
export const validateProduct = [
  body('name')
    .isLength({ min: 2, max: 200 })
    .withMessage('Product name must be between 2 and 200 characters')
    .trim(),
  body('description')
    .isLength({ min: 10, max: 1000 })
    .withMessage('Product description must be between 10 and 1000 characters')
    .trim(),
  validatePrice(),
  body('category')
    .isLength({ min: 2, max: 100 })
    .withMessage('Category must be between 2 and 100 characters')
    .trim(),
  body('brand')
    .optional()
    .isLength({ min: 2, max: 100 })
    .withMessage('Brand must be between 2 and 100 characters')
    .trim(),
  body('weight')
    .optional()
    .isFloat({ min: 0 })
    .withMessage('Weight must be a positive number')
    .toFloat(),
  body('dimensions.length')
    .optional()
    .isFloat({ min: 0 })
    .withMessage('Length must be a positive number')
    .toFloat(),
  body('dimensions.width')
    .optional()
    .isFloat({ min: 0 })
    .withMessage('Width must be a positive number')
    .toFloat(),
  body('dimensions.height')
    .optional()
    .isFloat({ min: 0 })
    .withMessage('Height must be a positive number')
    .toFloat(),
  body('inStock')
    .optional()
    .isBoolean()
    .withMessage('inStock must be a boolean value')
    .toBoolean(),
  body('stockQuantity')
    .optional()
    .isInt({ min: 0 })
    .withMessage('Stock quantity must be a non-negative integer')
    .toInt(),
  handleValidationErrors
];

// Product update validation (all fields optional)
export const validateProductUpdate = [
  body('name')
    .optional()
    .isLength({ min: 2, max: 200 })
    .withMessage('Product name must be between 2 and 200 characters')
    .trim(),
  body('description')
    .optional()
    .isLength({ min: 10, max: 1000 })
    .withMessage('Product description must be between 10 and 1000 characters')
    .trim(),
  validatePrice('price', true),
  body('category')
    .optional()
    .isLength({ min: 2, max: 100 })
    .withMessage('Category must be between 2 and 100 characters')
    .trim(),
  body('brand')
    .optional()
    .isLength({ min: 2, max: 100 })
    .withMessage('Brand must be between 2 and 100 characters')
    .trim(),
  body('weight')
    .optional()
    .isFloat({ min: 0 })
    .withMessage('Weight must be a positive number')
    .toFloat(),
  body('inStock')
    .optional()
    .isBoolean()
    .withMessage('inStock must be a boolean value')
    .toBoolean(),
  body('stockQuantity')
    .optional()
    .isInt({ min: 0 })
    .withMessage('Stock quantity must be a non-negative integer')
    .toInt(),
  handleValidationErrors
];

// Order validation
export const validateOrder = [
  body('items')
    .isArray({ min: 1 })
    .withMessage('Order must contain at least one item'),
  body('items.*.productId')
    .isMongoId()
    .withMessage('Product ID must be a valid MongoDB ObjectId'),
  body('items.*.quantity')
    .isInt({ min: 1 })
    .withMessage('Item quantity must be a positive integer')
    .toInt(),
  body('items.*.price')
    .isFloat({ min: 0 })
    .withMessage('Item price must be a positive number')
    .toFloat(),
  ...validateAddress(),
  body('deliveryDate')
    .optional()
    .isISO8601()
    .withMessage('Delivery date must be a valid ISO 8601 date')
    .custom((value) => {
      const deliveryDate = new Date(value);
      const now = new Date();
      if (deliveryDate <= now) {
        throw new Error('Delivery date must be in the future');
      }
      return true;
    })
    .toDate(),
  body('paymentMethod')
    .isIn(['cash_on_delivery', 'mobile_money', 'bank_transfer', 'card'])
    .withMessage('Payment method must be one of: cash_on_delivery, mobile_money, bank_transfer, card'),
  body('notes')
    .optional()
    .isLength({ max: 500 })
    .withMessage('Notes must not exceed 500 characters')
    .trim(),
  handleValidationErrors
];

// Order status update validation
export const validateOrderStatusUpdate = [
  body('status')
    .isIn(['pending', 'confirmed', 'preparing', 'ready_for_pickup', 'out_for_delivery', 'delivered', 'cancelled'])
    .withMessage('Status must be a valid order status'),
  body('notes')
    .optional()
    .isLength({ max: 500 })
    .withMessage('Notes must not exceed 500 characters')
    .trim(),
  handleValidationErrors
];

// Cart item validation
export const validateCartItem = [
  validateObjectId('productId', 'body'),
  validateQuantity(),
  handleValidationErrors
];

// Search and filter validation
export const validateSearch = [
  query('q')
    .optional()
    .isLength({ min: 1, max: 200 })
    .withMessage('Search query must be between 1 and 200 characters')
    .trim(),
  query('category')
    .optional()
    .isLength({ min: 2, max: 100 })
    .withMessage('Category must be between 2 and 100 characters')
    .trim(),
  query('minPrice')
    .optional()
    .isFloat({ min: 0 })
    .withMessage('Minimum price must be a positive number')
    .toFloat(),
  query('maxPrice')
    .optional()
    .isFloat({ min: 0 })
    .withMessage('Maximum price must be a positive number')
    .toFloat(),
  query('sortBy')
    .optional()
    .isIn(['name', 'price', 'createdAt', 'category', 'rating'])
    .withMessage('Sort field must be one of: name, price, createdAt, category, rating'),
  query('sortOrder')
    .optional()
    .isIn(['asc', 'desc'])
    .withMessage('Sort order must be either asc or desc'),
  handleValidationErrors
];

// Pagination validation
export const validatePagination = [
  query('page')
    .optional()
    .isInt({ min: 1 })
    .withMessage('Page must be a positive integer')
    .toInt(),
  query('limit')
    .optional()
    .isInt({ min: 1, max: 100 })
    .withMessage('Limit must be between 1 and 100')
    .toInt(),
  handleValidationErrors
];

// Delivery tracking validation
export const validateDeliveryUpdate = [
  validateObjectId('orderId', 'param'),
  ...validateCoordinates('currentLatitude', 'currentLongitude'),
  body('status')
    .isIn(['picked_up', 'in_transit', 'delivered', 'failed_delivery'])
    .withMessage('Delivery status must be valid'),
  body('estimatedArrival')
    .optional()
    .isISO8601()
    .withMessage('Estimated arrival must be a valid ISO 8601 date')
    .toDate(),
  body('notes')
    .optional()
    .isLength({ max: 500 })
    .withMessage('Notes must not exceed 500 characters')
    .trim(),
  handleValidationErrors
];

// Rating and review validation
export const validateReview = [
  validateObjectId('productId', 'body'),
  body('rating')
    .isInt({ min: 1, max: 5 })
    .withMessage('Rating must be between 1 and 5')
    .toInt(),
  body('comment')
    .optional()
    .isLength({ min: 10, max: 1000 })
    .withMessage('Comment must be between 10 and 1000 characters')
    .trim(),
  handleValidationErrors
];

/**
 * Custom validation helpers
 */

// Custom validator for file uploads
export const validateFileUpload = (
  fieldName: string,
  allowedTypes: string[] = ['image/jpeg', 'image/png', 'image/gif'],
  maxSize: number = 5 * 1024 * 1024 // 5MB default
) => {
  return (req: RequestWithFile, res: Response, next: NextFunction): void => {
    const file = req.file;
    
    if (!file) {
      res.status(400).json({
        success: false,
        message: 'No file uploaded',
        error: {
          code: 'FILE_REQUIRED',
          type: 'ValidationError',
          timestamp: new Date().toISOString(),
        },
      });
      return;
    }

    if (!allowedTypes.includes(file.mimetype)) {
      res.status(400).json({
        success: false,
        message: `File type not allowed. Allowed types: ${allowedTypes.join(', ')}`,
        error: {
          code: 'INVALID_FILE_TYPE',
          type: 'ValidationError',
          timestamp: new Date().toISOString(),
        },
      });
      return;
    }

    if (file.size > maxSize) {
      res.status(400).json({
        success: false,
        message: `File size too large. Maximum size: ${Math.round(maxSize / (1024 * 1024))}MB`,
        error: {
          code: 'FILE_TOO_LARGE',
          type: 'ValidationError',
          timestamp: new Date().toISOString(),
        },
      });
      return;
    }

    next();
  };
};

// Sanitization helper
export const sanitizeInput = (req: Request, res: Response, next: NextFunction): void => {
  // Remove any potentially dangerous characters from string inputs
  const sanitize = (input: unknown): unknown => {
    if (typeof input === 'string') {
      return input.replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '');
    }
    if (Array.isArray(input)) {
      return input.map((v) => sanitize(v));
    }
    if (typeof input === 'object' && input !== null) {
      const obj = input as Record<string, unknown>;
      const sanitized: Record<string, unknown> = {};
      for (const key of Object.keys(obj)) {
        if (Object.prototype.hasOwnProperty.call(obj, key)) {
          sanitized[key] = sanitize(obj[key]);
        }
      }
      return sanitized;
    }
    return input;
  };

  req.body = sanitize(req.body) as typeof req.body;
  req.query = sanitize(req.query) as typeof req.query;
  req.params = sanitize(req.params) as typeof req.params;
  
  next();
};

/**
 * Validation chain combiner utility
 */
export const combineValidations = (...validations: ValidationChain[][]): ValidationChain[] => {
  return validations.flat();
};

/**
 * Conditional validation helper
 */
export const conditionalValidation = (
  condition: (req: Request) => boolean,
  validationChain: ValidationChain
): ValidationChain => {
  return validationChain.if(condition);
};

export default {
  handleValidationErrors,
  validateEmail,
  validatePassword,
  validatePhoneNumber,
  validateName,
  validateObjectId,
  validatePrice,
  validateQuantity,
  validateCoordinates,
  validateAddress,
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
  combineValidations,
  conditionalValidation
};
