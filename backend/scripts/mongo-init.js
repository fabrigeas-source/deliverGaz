// MongoDB initialization script for Docker
// This script runs when the MongoDB container starts for the first time

// Switch to the delivergaz database
db = db.getSiblingDB('delivergaz');

// Create collections with validation
db.createCollection('users', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['firstName', 'lastName', 'email', 'password'],
      properties: {
        firstName: { bsonType: 'string' },
        lastName: { bsonType: 'string' },
        email: { bsonType: 'string' },
        password: { bsonType: 'string' },
        role: { enum: ['customer', 'admin'] }
      }
    }
  }
});

db.createCollection('products', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['name', 'price', 'category'],
      properties: {
        name: { bsonType: 'string' },
        price: { bsonType: 'number', minimum: 0 },
        category: { bsonType: 'string' },
        stock: { bsonType: 'number', minimum: 0 }
      }
    }
  }
});

// Create indexes for better performance
db.users.createIndex({ "email": 1 }, { unique: true });
db.users.createIndex({ "phone": 1 }, { unique: true, sparse: true });
db.products.createIndex({ "name": 1 });
db.products.createIndex({ "category": 1 });
db.products.createIndex({ "price": 1 });
db.products.createIndex({ "createdAt": -1 });

// Insert sample data for development (optional)
if (db.users.countDocuments() === 0) {
  print('Inserting sample data...');
  
  // Sample admin user (password: Admin123!)
  db.users.insertOne({
    firstName: 'Admin',
    lastName: 'User',
    email: 'admin@delivergaz.com',
    password: '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtTqaH8.q4QJG.G0j6h0J5Z8QJF6', // Admin123!
    phone: '+1234567890',
    role: 'admin',
    isActive: true,
    createdAt: new Date(),
    updatedAt: new Date()
  });

  // Sample customer user (password: Customer123!)
  db.users.insertOne({
    firstName: 'John',
    lastName: 'Doe',
    email: 'customer@example.com',
    password: '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtTqaH8.q4QJG.G0j6h0J5Z8QJF6', // Customer123!
    phone: '+1234567891',
    role: 'customer',
    isActive: true,
    address: {
      street: '123 Main Street',
      city: 'New York',
      state: 'NY',
      postalCode: '10001',
      country: 'USA'
    },
    createdAt: new Date(),
    updatedAt: new Date()
  });

  // Sample products
  db.products.insertMany([
    {
      name: 'Standard Gas Cylinder',
      description: 'Standard 5kg gas cylinder for household cooking',
      price: 25.99,
      category: 'Gas Cylinders',
      stock: 50,
      unit: 'piece',
      weight: 5,
      dimensions: { height: 30, diameter: 20 },
      images: [],
      isActive: true,
      createdAt: new Date(),
      updatedAt: new Date()
    },
    {
      name: 'Premium Gas Cylinder',
      description: 'Premium 10kg gas cylinder with enhanced safety features',
      price: 45.99,
      category: 'Gas Cylinders',
      stock: 30,
      unit: 'piece',
      weight: 10,
      dimensions: { height: 40, diameter: 25 },
      images: [],
      isActive: true,
      createdAt: new Date(),
      updatedAt: new Date()
    },
    {
      name: 'Gas Hose',
      description: 'High-quality gas hose for safe gas connection',
      price: 12.99,
      category: 'Accessories',
      stock: 100,
      unit: 'piece',
      length: 1.5,
      material: 'Rubber',
      images: [],
      isActive: true,
      createdAt: new Date(),
      updatedAt: new Date()
    },
    {
      name: 'Gas Regulator',
      description: 'Pressure regulator for gas cylinders',
      price: 18.50,
      category: 'Accessories',
      stock: 75,
      unit: 'piece',
      maxPressure: '30 PSI',
      material: 'Brass',
      images: [],
      isActive: true,
      createdAt: new Date(),
      updatedAt: new Date()
    }
  ]);

  print('Sample data inserted successfully!');
}

print('MongoDB initialization completed!');