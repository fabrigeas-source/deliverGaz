# DeliverGaz Backend - Quick Start Guide

Get up and running with the DeliverGaz backend API in minutes!

## 🚀 Quick Start Options

### Option 1: Development Mode (Recommended)
Start the server in development mode with hot reload:

```bash
# Install dependencies
npm install

# Start development server
npm run dev
```

**✅ Server starts without database connection** - Perfect for API testing and development!

### Option 2: Use MongoDB Atlas (Free Cloud Database)
1. Go to https://mongodb.com/atlas
2. Create a free account
3. Create a new cluster (free tier)
4. Get your connection string from "Connect" → "Connect your application"
5. Update MONGODB_URI in your .env file:
   ```env
   MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/delivergaz?retryWrites=true&w=majority
   ```

### Option 3: Use Docker (When Working)
```bash
# Start with Docker Compose
docker-compose up -d

# Or run individual commands
docker run -d --name delivergaz-mongo -p 27017:27017 mongo:latest
npm run dev
```

## 📋 Manual Steps

### Step 1: Start Docker Desktop
- Press Windows Key
- Type "Docker Desktop" 
- Launch the application
- Wait for the whale icon in system tray

### Step 2: Run MongoDB Container
```cmd
docker run -d --name delivergaz-mongo -p 27017:27017 mongo:latest
```

### Step 3: Start the Application
```cmd
npm start
```

## 🌐 Access Points

Once your server is running, you'll see:
```
🚀 Server is running on port 3000
📚 Swagger documentation available at http://localhost:3000/api-docs
🏥 Health check available at http://localhost:3000/health
```

**Available URLs:**
- **API Base**: http://localhost:3000/api
- **Interactive API Docs**: http://localhost:3000/api-docs ⭐ **Start here for testing!**
- **Health Check**: http://localhost:3000/health
- **File Uploads**: http://localhost:3000/uploads

## 🧪 Test Your API

### Using Swagger UI (Easiest)
1. Open http://localhost:3000/api-docs
2. Browse available endpoints
3. Click "Try it out" on any endpoint
4. **Note**: URLs are now correct (fixed double /api issue!)

### Using curl (Command Line)
```bash
# Health check
curl http://localhost:3000/health

# Get products with pagination
curl "http://localhost:3000/api/products?page=1&limit=10"

# Get cart (requires auth)
curl http://localhost:3000/api/cart
```

### Using Browser
Simply visit these URLs in your browser:
- http://localhost:3000/health
- http://localhost:3000/api/products
- http://localhost:3000/api-docs

## 🔧 Current Features

✅ **Implemented & Working:**
- Modular route structure with `.route.ts` naming convention
- Comprehensive Swagger documentation for all endpoints
- Authentication routes (register, login, profile, refresh, logout)
- Product management (CRUD operations with pagination & filtering)
- Shopping cart functionality (add, update, remove, clear, count)
- Order management (create, view, update status)
- User management (profile, addresses)
- Error handling and validation
- Rate limiting and security headers
- File upload support

⚠️ **Development Mode:**
- Server runs without database connection
- Mock data responses for testing
- Hot reload enabled with nodemon

## 🆘 Troubleshooting

### Server Won't Start
1. Check if port 3000 is free: `netstat -an | findstr :3000`
2. Kill any process using port 3000: `npx kill-port 3000`
3. Try a different port: `PORT=3001 npm run dev`

### API Returns 404
- ✅ Correct: `http://localhost:3000/api/products`
- ❌ Wrong: `http://localhost:3000/api/api/products` (double /api)

### Database Connection Issues
- Development mode works without database
- For database features, set up MongoDB Atlas (Option 2 above)
- Check MONGODB_URI in .env file

### Need Help?
- Check the full README.md for detailed documentation
- View API_TESTING.md for comprehensive testing guide
- Look at individual route README.md files in src/routes/

## 📞 Need Help?
- Check the README.md for detailed instructions
- View troubleshooting section in README.md