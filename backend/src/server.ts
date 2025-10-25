import 'dotenv/config';
import express, { Application } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import compression from 'compression';
import rateLimit from 'express-rate-limit';
import mongoose from 'mongoose';
import path from 'path';
import fs from 'fs';
import swaggerUi from 'swagger-ui-express';

// Import configuration
import config, { 
  swaggerSpec, 
  swaggerUiOptions, 
  getDatabaseUri, 
  hasValidDatabaseConfig 
} from './config';

// Import middleware (currently not applied globally)
// import { errorHandler, requestLogger } from './middleware';

// Import modular routes
import { 
  authRoutes, 
  usersRoutes, 
  productsRoutes, 
  cartRoutes, 
  ordersRoutes 
} from './routes';

// Create Express application
const app: Application = express();

// Trust proxy for rate limiting
app.set('trust proxy', 1);

// Security middleware
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'", "https://fonts.googleapis.com"],
      fontSrc: ["'self'", "https://fonts.gstatic.com"],
      scriptSrc: ["'self'"],
      imgSrc: ["'self'", "data:", "https:"],
    },
  },
}));

// CORS configuration
const corsOptions = {
  origin: process.env.CORS_ORIGIN?.split(',') || ['http://localhost:3000'],
  credentials: true,
  optionsSuccessStatus: 200,
};
app.use(cors(corsOptions));

// Rate limiting
const limiter = rateLimit({
  windowMs: (parseInt(process.env.RATE_LIMIT_WINDOW || '15')) * 60 * 1000, // 15 minutes
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS || '100'), // limit each IP to 100 requests per windowMs
  message: {
    error: 'Too many requests from this IP, please try again later.',
  },
  standardHeaders: true,
  legacyHeaders: false,
});
app.use('/api/', limiter);

// Compression
app.use(compression());

// Body parsing middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Request logging - temporarily disabled
// app.use(requestLogger);

// Static file serving for uploads
const uploadsDir = path.join(__dirname, '..', config.upload.path);
if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir, { recursive: true });
}
app.use('/uploads', express.static(uploadsDir));

// Static file serving for public assets (root path)
const publicDir = path.join(__dirname, '..', 'public');
if (fs.existsSync(publicDir)) {
  app.use(express.static(publicDir));
}

// Swagger UI setup
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec, swaggerUiOptions));

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    success: true,
    message: 'DeliverGaz Backend API is running',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || 'development',
    version: '1.0.0',
    database: mongoose.connection.readyState === 1 ? 'connected' : 'disconnected',
    endpoints: {
      swagger: '/api-docs',
      health: '/health',
      api: '/api',
    },
  });
});

// API routes - modular routes structure
app.use('/api/auth', authRoutes);
app.use('/api/users', usersRoutes);
app.use('/api/products', productsRoutes);
app.use('/api/cart', cartRoutes);
app.use('/api/orders', ordersRoutes);

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    message: 'Endpoint not found',
    availableEndpoints: {
      health: '/health',
      swagger: '/api-docs',
      auth: '/api/auth',
      products: '/api/products',
      cart: '/api/cart',
      orders: '/api/orders',
    },
  });
});

// Global error handler - temporarily disabled
// app.use(errorHandler);

// Database connection
const connectDatabase = async (): Promise<void> => {
  try {
    // Debug environment variables
    console.log('🔍 Debug info:');
    console.log('- NODE_ENV:', config.server.nodeEnv);
    console.log('- MONGODB_URI defined:', !!process.env.MONGODB_URI);
    console.log('- Database config valid:', hasValidDatabaseConfig());
    console.log('- Server port:', config.server.port);
    
    // Check if MongoDB URI is available
    if (!hasValidDatabaseConfig()) {
      console.log('⚠️  MongoDB URI contains placeholder or is undefined');
      console.log('⚠️  Starting server in development mode without database connection');
      return;
    }
    
    // Connect to MongoDB Atlas
    const databaseUri = getDatabaseUri();
    await mongoose.connect(databaseUri);
    console.log('🗄️  MongoDB Atlas connected successfully');
    
    // Create indexes for better performance
    await createIndexes();
    
  } catch (error) {
    console.error('❌ MongoDB connection error:', error);
    console.log('⚠️  Starting server without database connection...');
    // Don't exit - allow server to start without DB for Swagger docs
  }
};

// Create database indexes
const createIndexes = async (): Promise<void> => {
  try {
    // User indexes
    await mongoose.connection.collection('users').createIndex({ email: 1 }, { unique: true });
    await mongoose.connection.collection('users').createIndex({ phone: 1 });
    
    // Product indexes
    await mongoose.connection.collection('products').createIndex({ name: 'text', description: 'text' });
    await mongoose.connection.collection('products').createIndex({ category: 1 });
    await mongoose.connection.collection('products').createIndex({ isActive: 1 });
    await mongoose.connection.collection('products').createIndex({ createdAt: -1 });
    
    // Cart indexes
    await mongoose.connection.collection('carts').createIndex({ user: 1 }, { unique: true });
    
    // Order indexes
    await mongoose.connection.collection('orders').createIndex({ user: 1 });
    await mongoose.connection.collection('orders').createIndex({ orderNumber: 1 }, { unique: true });
    await mongoose.connection.collection('orders').createIndex({ status: 1 });
    await mongoose.connection.collection('orders').createIndex({ createdAt: -1 });
    
    console.log('📊 Database indexes created successfully');
  } catch (error) {
    console.error('❌ Error creating indexes:', error);
  }
};

// Graceful shutdown
const gracefulShutdown = async (): Promise<void> => {
  console.log('🔄 Received shutdown signal, closing server gracefully...');
  
  try {
    await mongoose.connection.close();
    console.log('🗄️  Database connection closed.');
  } catch (error) {
    console.error('❌ Error closing database connection:', error);
  }
  
  process.exit(0);
};

// Handle shutdown signals
process.on('SIGTERM', gracefulShutdown);
process.on('SIGINT', gracefulShutdown);

// Start server
const startServer = async (): Promise<void> => {
  try {
    // Connect to database (optional for Swagger docs)
    await connectDatabase();
    
    const server = app.listen(config.server.port, config.server.host, () => {
      console.log(`🚀 Server is running on port ${config.server.port}`);
      console.log(`📚 Swagger documentation available at http://localhost:${config.server.port}/api-docs`);
      console.log(`🏥 Health check available at http://localhost:${config.server.port}/health`);
      console.log(`🌍 Environment: ${config.server.nodeEnv}`);
    });

    // Handle server errors
    server.on('error', (error: any) => {
      if (error.code === 'EADDRINUSE') {
        console.error(`❌ Port ${config.server.port} is already in use`);
        process.exit(1);
      } else {
        console.error('❌ Server error:', error);
      }
    });

  } catch (error) {
    console.error('❌ Failed to start server:', error);
    process.exit(1);
  }
};

// Start the server (skip during tests)
if (process.env.NODE_ENV !== 'test') {
  startServer();
}

export default app;
