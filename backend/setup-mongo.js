#!/usr/bin/env node
/**
 * Simple MongoDB Docker Setup Script
 */

const { exec } = require('child_process');

console.log('🐳 Setting up MongoDB with Docker...\n');

// Step 1: Check Docker
exec('docker --version', (error, stdout, stderr) => {
  if (error) {
    console.error('❌ Docker is not installed or not running');
    process.exit(1);
  }
  
  console.log('✅ Docker found:', stdout.trim());
  
  // Step 2: Start MongoDB container
  console.log('🗄️  Starting MongoDB container...');
  
  const mongoCommand = 'docker run -d --name delivergaz-mongo -p 27017:27017 -e MONGO_INITDB_DATABASE=delivergaz mongo:latest';
  
  exec(mongoCommand, (error, stdout, stderr) => {
    if (error) {
      if (error.message.includes('Sign-in enforcement')) {
        console.log('🔐 Please sign in to Docker Desktop first:');
        console.log('   1. Click Docker Desktop icon in system tray');
        console.log('   2. Sign in with your Docker Hub account');
        console.log('   3. Run this script again\n');
      } else if (error.message.includes('already in use')) {
        console.log('✅ MongoDB container already exists, starting it...');
        exec('docker start delivergaz-mongo', (startError, startStdout) => {
          if (!startError) {
            console.log('✅ MongoDB is now running on port 27017');
            console.log('🚀 You can now start your application with: npm run dev');
          }
        });
      } else {
        console.error('❌ Error starting MongoDB:', error.message);
      }
      return;
    }
    
    console.log('✅ MongoDB container started successfully!');
    console.log('🗄️  MongoDB is running on: mongodb://localhost:27017/delivergaz');
    console.log('🚀 You can now start your application with: npm run dev');
  });
});