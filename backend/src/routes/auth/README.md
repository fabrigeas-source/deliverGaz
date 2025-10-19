# Authentication Routes

A comprehensive authentication system for the DeliverGaz application, providing user registration, login, and profile management endpoints.

## Overview

This module handles all authentication-related routes including user registration, login, and profile management. It provides RESTful endpoints with comprehensive Swagger documentation and consistent response formatting.

## Features

- 🔐 **User Registration** - New user account creation
- 🚪 **User Login** - Authentication and session management
- 👤 **Profile Management** - User profile retrieval and updates
- 📝 **Swagger Documentation** - Complete API documentation
- ✅ **Consistent Responses** - Standardized response format
- 🧪 **Comprehensive Testing** - Full test coverage

## Files Structure

```
routes/auth/
├── auth.route.ts      # Main authentication routes (updated naming)
├── auth.route.test.ts # Test suite (updated naming)
├── index.ts          # Route exports
└── README.md         # Documentation (this file)
```

## Recent Updates

- ✅ **File Naming**: Updated to `.route.ts` convention for consistency
- ✅ **Swagger Docs**: Comprehensive API documentation with examples
- ✅ **Modular Structure**: Clean separation of concerns
- ✅ **Export System**: Centralized exports through index.ts

## API Endpoints

### POST /api/auth/register
Register a new user account.

**Request Body:**
```json
{
  "firstName": "John",
  "lastName": "Doe",
  "email": "john.doe@example.com",
  "password": "SecurePass123!",
  "phone": "+1234567890"
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "id": "user_id",
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@example.com",
    "phone": "+1234567890",
    "role": "customer",
    "isActive": true,
    "createdAt": "2024-01-01T12:00:00.000Z"
  }
}
```

**Error Responses:**
- `400` - Bad request (validation errors)
- `409` - User already exists

### POST /api/auth/login
Authenticate user and return access token.

**Request Body:**
```json
{
  "email": "john.doe@example.com",
  "password": "SecurePass123!"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": "user_id",
      "firstName": "John",
      "lastName": "Doe",
      "email": "john.doe@example.com",
      "role": "customer"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

**Error Response:**
- `401` - Invalid credentials

### GET /api/auth/profile
Get current user profile (requires authentication).

**Headers:**
```
Authorization: Bearer <jwt_token>
```

**Response (200):**
```json
{
  "success": true,
  "message": "Profile retrieved successfully",
  "data": {
    "id": "user_id",
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@example.com",
    "phone": "+1234567890",
    "role": "customer",
    "isActive": true,
    "createdAt": "2024-01-01T12:00:00.000Z",
    "updatedAt": "2024-01-01T12:00:00.000Z"
  }
}
```

**Error Response:**
- `401` - Unauthorized (invalid or missing token)

## Data Models

### User Schema
```typescript
interface User {
  id: string;                    // Auto-generated user ID
  firstName: string;             // User's first name
  lastName: string;              // User's last name
  email: string;                 // User's email (unique)
  phone: string;                 // User's phone number
  role: 'customer' | 'admin';    // User role
  isActive: boolean;             // Account status
  createdAt: Date;               // Account creation date
  updatedAt: Date;               // Last update date
}
```

### Request/Response Types
```typescript
interface RegisterRequest {
  firstName: string;
  lastName: string;
  email: string;
  password: string;
  phone: string;
}

interface LoginRequest {
  email: string;
  password: string;
}

interface AuthResponse {
  success: boolean;
  message: string;
  data?: any;
}
```

## Usage Examples

### Using with Axios
```javascript
// Register new user
const registerUser = async (userData) => {
  try {
    const response = await axios.post('/api/auth/register', userData);
    console.log('User registered:', response.data);
    return response.data;
  } catch (error) {
    console.error('Registration failed:', error.response.data);
    throw error;
  }
};

// Login user
const loginUser = async (credentials) => {
  try {
    const response = await axios.post('/api/auth/login', credentials);
    const { token } = response.data.data;
    
    // Store token for future requests
    localStorage.setItem('authToken', token);
    
    return response.data;
  } catch (error) {
    console.error('Login failed:', error.response.data);
    throw error;
  }
};

// Get user profile
const getUserProfile = async () => {
  try {
    const token = localStorage.getItem('authToken');
    const response = await axios.get('/api/auth/profile', {
      headers: {
        Authorization: `Bearer ${token}`
      }
    });
    return response.data;
  } catch (error) {
    console.error('Profile fetch failed:', error.response.data);
    throw error;
  }
};
```

### Using with Fetch API
```javascript
// Register user
const register = async (userData) => {
  const response = await fetch('/api/auth/register', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(userData)
  });
  
  if (!response.ok) {
    throw new Error('Registration failed');
  }
  
  return response.json();
};

// Login user
const login = async (credentials) => {
  const response = await fetch('/api/auth/login', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(credentials)
  });
  
  if (!response.ok) {
    throw new Error('Login failed');
  }
  
  return response.json();
};
```

## Validation Rules

### Registration Validation
- `firstName`: Required, string, 2-50 characters
- `lastName`: Required, string, 2-50 characters
- `email`: Required, valid email format, unique
- `password`: Required, minimum 6 characters, must contain letters and numbers
- `phone`: Required, valid phone number format

### Login Validation
- `email`: Required, valid email format
- `password`: Required, minimum 6 characters

## Security Considerations

### Password Security
- Passwords are hashed using bcrypt with salt rounds
- Minimum password requirements enforced
- Password history tracking (future enhancement)

### Token Security
- JWT tokens with configurable expiration
- Secure token storage recommendations
- Token refresh mechanism (future enhancement)

### Rate Limiting
- Login attempt rate limiting to prevent brute force attacks
- Registration rate limiting to prevent spam

### Data Protection
- Email uniqueness validation
- Input sanitization and validation
- SQL injection prevention
- XSS protection

## Testing

### Running Tests
```bash
# Run auth route tests
npm test -- auth.test.ts

# Run tests with coverage
npm run test:coverage -- auth.test.ts

# Run tests in watch mode
npm run test:watch -- auth.test.ts
```

### Test Coverage
The test suite covers:
- ✅ Successful registration, login, and profile retrieval
- ✅ Input validation and error handling
- ✅ HTTP method validation
- ✅ Content-Type handling
- ✅ Response format consistency
- ✅ Authentication flow
- ✅ Edge cases and error scenarios

### Test Examples
```typescript
describe('Auth Routes', () => {
  it('should register a new user', async () => {
    const userData = {
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      password: 'SecurePass123!',
      phone: '+1234567890'
    };

    const response = await request(app)
      .post('/api/auth/register')
      .send(userData)
      .expect(201);

    expect(response.body.success).toBe(true);
    expect(response.body.data.email).toBe(userData.email);
  });
});
```

## Integration

### With Express App
```typescript
import express from 'express';
import authRoutes from './routes/auth/auth';

const app = express();

// Apply middleware
app.use(express.json());

// Mount auth routes
app.use('/api/auth', authRoutes);
```

### With Validation Middleware
```typescript
import { validateUserRegistration, validateUserLogin } from '../middleware/validation';

// Apply validation middleware
router.post('/register', validateUserRegistration, registerController);
router.post('/login', validateUserLogin, loginController);
```

### With Authentication Middleware
```typescript
import { authenticateToken } from '../middleware/auth';

// Protect profile route
router.get('/profile', authenticateToken, getProfileController);
```

## Error Handling

### Error Response Format
```json
{
  "success": false,
  "message": "Descriptive error message",
  "errors": [
    {
      "field": "email",
      "message": "Email already exists"
    }
  ]
}
```

### Common Error Codes
- `400` - Bad Request (validation errors)
- `401` - Unauthorized (invalid credentials or token)
- `403` - Forbidden (insufficient permissions)
- `409` - Conflict (duplicate email)
- `422` - Unprocessable Entity (validation failed)
- `500` - Internal Server Error

## Future Enhancements

### Planned Features
- [ ] Email verification system
- [ ] Password reset functionality
- [ ] Two-factor authentication (2FA)
- [ ] Social login integration (Google, Facebook)
- [ ] Account lockout after failed attempts
- [ ] Session management and logout
- [ ] User role management
- [ ] Profile picture upload
- [ ] Account deactivation/deletion

### API Versioning
- [ ] Version 2.0 with enhanced security
- [ ] Backward compatibility support
- [ ] Migration guides

### Performance Optimizations
- [ ] Response caching for profile data
- [ ] Database query optimization
- [ ] Rate limiting improvements
- [ ] Load balancing considerations

## Troubleshooting

### Common Issues

1. **Registration fails with "User already exists"**
   - Check if email is already registered
   - Verify email uniqueness in database

2. **Login fails with valid credentials**
   - Check password hashing implementation
   - Verify user account is active
   - Check database connection

3. **Profile endpoint returns 401**
   - Verify JWT token is included in Authorization header
   - Check token format: `Bearer <token>`
   - Ensure token hasn't expired

4. **Validation errors on registration**
   - Check all required fields are provided
   - Verify email format
   - Ensure password meets requirements

### Debug Mode
Enable debug logging for detailed request/response information:
```typescript
// Set environment variable
process.env.DEBUG_AUTH = 'true';
```

## Contributing

### Code Style
- Follow TypeScript best practices
- Use async/await for asynchronous operations
- Implement proper error handling
- Write comprehensive tests

### Adding New Endpoints
1. Add route handler in `auth.ts`
2. Add Swagger documentation
3. Create comprehensive tests in `auth.test.ts`
4. Update this README with endpoint documentation

### Testing Guidelines
- Test both success and error scenarios
- Include edge cases and boundary conditions
- Maintain high test coverage (>90%)
- Use descriptive test names

## License

This authentication module is part of the DeliverGaz project and follows the project's licensing terms.