# Architecture Documentation

This document provides a comprehensive overview of the DeliverGaz system architecture, including design decisions, patterns, and technical specifications.

## Table of Contents

1. [System Overview](#system-overview)
2. [Architecture Patterns](#architecture-patterns)
3. [Backend Architecture](#backend-architecture)
4. [Frontend Architecture](#frontend-architecture)
5. [Database Design](#database-design)
6. [API Design](#api-design)
7. [Security Architecture](#security-architecture)
8. [Infrastructure](#infrastructure)
9. [Scalability Considerations](#scalability-considerations)
10. [Performance Optimization](#performance-optimization)

## System Overview

DeliverGaz is a full-stack gas delivery platform built with modern technologies and following industry best practices. The system consists of:

- **Backend API**: Node.js/Express server with TypeScript
- **Mobile App**: Flutter application for iOS and Android
- **Web App**: Flutter web application
- **Database**: MongoDB for data persistence
- **Authentication**: JWT-based authentication system
- **File Storage**: Cloud storage for images and documents

### High-Level Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Mobile App    │    │    Web App      │    │  Admin Panel    │
│   (Flutter)     │    │   (Flutter)     │    │   (Future)      │
└─────────┬───────┘    └─────────┬───────┘    └─────────┬───────┘
          │                      │                      │
          └──────────────────────┼──────────────────────┘
                                 │
                    ┌─────────────┴───────────┐
                    │     API Gateway        │
                    │   (Rate Limiting,      │
                    │   Load Balancing)      │
                    └─────────────┬───────────┘
                                 │
                    ┌─────────────┴───────────┐
                    │   Backend API Server   │
                    │  (Node.js/Express/TS)  │
                    └─────────────┬───────────┘
                                 │
          ┌──────────────────────┼──────────────────────┐
          │                      │                      │
┌─────────┴───────┐    ┌─────────┴───────┐    ┌─────────┴───────┐
│   MongoDB       │    │ File Storage    │    │ External APIs   │
│   Database      │    │ (AWS S3/GCS)    │    │ (Payment, SMS)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Architecture Patterns

### Backend Patterns

1. **MVC (Model-View-Controller)**
   - Models: Data structures and business logic
   - Views: JSON responses (API responses)
   - Controllers: Request handling and orchestration

2. **Repository Pattern**
   - Abstraction layer for data access
   - Enables easier testing and database switching

3. **Middleware Pattern**
   - Cross-cutting concerns (authentication, logging, validation)
   - Chainable request processors

4. **Dependency Injection**
   - Loose coupling between components
   - Better testability

### Frontend Patterns

1. **BLoC (Business Logic Component)**
   - Separation of business logic from UI
   - Reactive programming with streams
   - State management

2. **Repository Pattern**
   - Data access abstraction
   - Offline-first capability

3. **Provider Pattern**
   - Dependency injection for Flutter
   - Widget tree optimization

## Backend Architecture

### Directory Structure

```
backend/
├── src/
│   ├── config/          # Configuration files
│   ├── controllers/     # Request handlers
│   ├── middleware/      # Express middleware
│   ├── models/          # Database models
│   ├── routes/          # API routes
│   ├── services/        # Business logic
│   ├── types/           # TypeScript types
│   ├── utils/           # Utility functions
│   └── server.ts        # Application entry point
├── tests/               # Test files
├── docs/               # API documentation
└── package.json
```

### Core Components

#### 1. Application Layer (Controllers)

```typescript
// Example Controller Structure
export class UserController {
  constructor(private userService: UserService) {}

  async createUser(req: Request, res: Response): Promise<void> {
    try {
      const userData = req.body;
      const user = await this.userService.createUser(userData);
      res.status(201).json(ApiResponse.success(user, 'User created successfully'));
    } catch (error) {
      res.status(400).json(ApiResponse.error(error.message));
    }
  }
}
```

#### 2. Business Logic Layer (Services)

```typescript
// Example Service Structure
export class UserService {
  constructor(private userRepository: UserRepository) {}

  async createUser(userData: CreateUserDTO): Promise<User> {
    // Validation
    await this.validateUserData(userData);
    
    // Business logic
    const hashedPassword = await bcrypt.hash(userData.password, 10);
    
    // Data persistence
    return this.userRepository.create({
      ...userData,
      password: hashedPassword
    });
  }
}
```

#### 3. Data Access Layer (Repositories)

```typescript
// Example Repository Structure
export class UserRepository {
  async create(userData: Partial<User>): Promise<User> {
    return UserModel.create(userData);
  }

  async findById(id: string): Promise<User | null> {
    return UserModel.findById(id);
  }

  async findByEmail(email: string): Promise<User | null> {
    return UserModel.findOne({ email });
  }
}
```

### Middleware Stack

```typescript
// Middleware stack in server.ts
app.use(helmet());                    // Security headers
app.use(cors(corsOptions));           // CORS configuration
app.use(rateLimit(rateLimitOptions)); // Rate limiting
app.use(express.json());              // JSON parsing
app.use(express.urlencoded());        // URL encoding
app.use(requestLogger);               // Request logging
app.use(authMiddleware);              // Authentication
app.use(errorHandler);                // Error handling
```

## Frontend Architecture

### Directory Structure

```
frontend/lib/
├── core/                # Core utilities and constants
├── l10n/               # Internationalization
├── models/             # Data models
├── pages/              # UI screens
├── services/           # Data services
├── widgets/            # Reusable UI components
├── blocs/              # Business logic components
└── main.dart           # Application entry point
```

### Architecture Layers

#### 1. Presentation Layer (UI)

```dart
// Example Page Structure
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return LoadingWidget();
        } else if (state is ProductLoaded) {
          return ProductListWidget(products: state.products);
        } else if (state is ProductError) {
          return ErrorWidget(message: state.message);
        }
        return Container();
      },
    );
  }
}
```

#### 2. Business Logic Layer (BLoCs)

```dart
// Example BLoC Structure
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<RefreshProducts>(_onRefreshProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await productRepository.getProducts();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }
}
```

#### 3. Data Layer (Repositories)

```dart
// Example Repository Structure
class ProductRepository {
  final ApiService apiService;
  final DatabaseService databaseService;

  ProductRepository({
    required this.apiService,
    required this.databaseService,
  });

  Future<List<Product>> getProducts() async {
    try {
      // Try to get from API first
      final products = await apiService.getProducts();
      
      // Cache in local database
      await databaseService.cacheProducts(products);
      
      return products;
    } catch (e) {
      // Fallback to cached data
      return databaseService.getCachedProducts();
    }
  }
}
```

## Database Design

### Schema Overview

```
Users Collection
├── _id: ObjectId
├── name: String
├── email: String (unique)
├── password: String (hashed)
├── phone: String
├── address: Object
├── role: Enum ['customer', 'driver', 'admin']
├── isActive: Boolean
├── createdAt: Date
└── updatedAt: Date

Products Collection
├── _id: ObjectId
├── name: String
├── description: String
├── price: Number
├── category: String
├── images: Array[String]
├── specifications: Object
├── stock: Number
├── isActive: Boolean
├── createdAt: Date
└── updatedAt: Date

Orders Collection
├── _id: ObjectId
├── orderNumber: String (unique)
├── userId: ObjectId (ref: Users)
├── items: Array[OrderItem]
├── subtotal: Number
├── deliveryFee: Number
├── total: Number
├── status: Enum
├── deliveryAddress: Object
├── paymentMethod: String
├── paymentStatus: Enum
├── driverId: ObjectId (ref: Users)
├── tracking: Object
├── createdAt: Date
└── updatedAt: Date

Carts Collection
├── _id: ObjectId
├── userId: ObjectId (ref: Users)
├── items: Array[CartItem]
├── subtotal: Number
├── itemCount: Number
└── updatedAt: Date
```

### Indexing Strategy

```javascript
// Performance indexes
db.users.createIndex({ "email": 1 }, { unique: true })
db.orders.createIndex({ "userId": 1, "createdAt": -1 })
db.orders.createIndex({ "orderNumber": 1 }, { unique: true })
db.products.createIndex({ "category": 1, "isActive": 1 })
db.products.createIndex({ "name": "text", "description": "text" })
```

## API Design

### RESTful Principles

The API follows REST conventions:

- **Resource-based URLs**: `/api/v1/users`, `/api/v1/products`
- **HTTP methods**: GET, POST, PUT, DELETE
- **Status codes**: Proper HTTP status codes
- **Stateless**: No server-side session storage

### API Versioning

```
/api/v1/users      # Version 1
/api/v2/users      # Version 2 (future)
```

### Response Format Standardization

```typescript
interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
    details?: any;
  };
  pagination?: {
    page: number;
    limit: number;
    total: number;
    pages: number;
  };
  timestamp: string;
}
```

## Security Architecture

### Authentication Flow

```
1. User submits credentials
2. Server validates credentials
3. Server generates JWT tokens (access + refresh)
4. Client stores tokens securely
5. Client includes access token in requests
6. Server validates token on each request
7. Token refresh when access token expires
```

### Security Measures

1. **Password Security**
   - bcrypt hashing with salt
   - Minimum password requirements
   - Password history prevention

2. **JWT Security**
   - Short-lived access tokens (15 minutes)
   - Longer-lived refresh tokens (7 days)
   - Token rotation on refresh
   - Blacklist for revoked tokens

3. **API Security**
   - Rate limiting per IP and user
   - Input validation and sanitization
   - CORS configuration
   - Helmet.js security headers
   - Request size limits

4. **Data Security**
   - Field-level encryption for sensitive data
   - Database connection encryption
   - Secure file upload validation
   - Environment variable secrets

## Infrastructure

### Development Environment

```
Local Development
├── Node.js server (port 3000)
├── MongoDB local instance
├── Flutter development server
└── Hot reload enabled
```

### Production Environment

```
Production Stack
├── Load Balancer (Nginx/AWS ALB)
├── API Servers (Multiple instances)
├── MongoDB Cluster (Replica Set)
├── CDN for static assets
├── File storage (AWS S3/GCS)
└── Monitoring (New Relic/DataDog)
```

### Containerization

```dockerfile
# Multi-stage Docker build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:18-alpine AS runtime
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

## Scalability Considerations

### Horizontal Scaling

1. **Stateless Design**
   - No server-side sessions
   - JWT tokens for authentication
   - Database for state persistence

2. **Load Balancing**
   - Round-robin distribution
   - Health check endpoints
   - Session affinity not required

3. **Database Scaling**
   - Read replicas for queries
   - Sharding for large datasets
   - Indexing optimization

### Vertical Scaling

1. **Performance Monitoring**
   - CPU and memory usage
   - Database query performance
   - API response times

2. **Optimization Strategies**
   - Connection pooling
   - Query optimization
   - Caching layers
   - Code splitting

## Performance Optimization

### Backend Optimization

1. **Database Optimization**
   - Proper indexing
   - Query optimization
   - Connection pooling
   - Aggregation pipelines

2. **Caching Strategy**
   - Redis for session data
   - Application-level caching
   - CDN for static assets
   - Database query caching

3. **Code Optimization**
   - Async/await patterns
   - Stream processing
   - Memory management
   - Error handling

### Frontend Optimization

1. **Bundle Optimization**
   - Code splitting
   - Tree shaking
   - Asset optimization
   - Lazy loading

2. **Rendering Optimization**
   - Widget optimization
   - State management
   - Build context optimization
   - Image caching

3. **Network Optimization**
   - API request batching
   - Offline-first approach
   - Progressive loading
   - Compression

## Monitoring and Observability

### Logging Strategy

```typescript
// Structured logging
logger.info('User created', {
  userId: user.id,
  email: user.email,
  timestamp: new Date().toISOString(),
  requestId: req.id
});
```

### Metrics Collection

1. **Application Metrics**
   - Request count and duration
   - Error rates
   - Memory and CPU usage
   - Database performance

2. **Business Metrics**
   - User registrations
   - Order completion rates
   - Revenue tracking
   - User engagement

### Health Checks

```typescript
// Health check endpoint
app.get('/health', async (req, res) => {
  const health = {
    status: 'ok',
    timestamp: new Date().toISOString(),
    services: {
      database: await checkDatabaseHealth(),
      redis: await checkRedisHealth(),
      external: await checkExternalServices()
    }
  };
  
  res.status(200).json(health);
});
```

This architecture provides a solid foundation for the DeliverGaz platform, ensuring scalability, maintainability, and security while following industry best practices.