#!/usr/bin/env node

/**
 * Quick Start Script for DeliverGaz Backend
 * This script starts the application with an in-memory database for testing
 */

const { spawn } = require('child_process');
const path = require('path');

console.log('\n========================================');
console.log('   DeliverGaz Backend - Quick Start');
console.log('========================================\n');

console.log('🚀 Starting DeliverGaz Backend API...');
console.log('📊 API will be available at: http://localhost:3000');
console.log('📚 API Documentation: http://localhost:3000/api-docs');
console.log('🏥 Health Check: http://localhost:3000/health');
console.log('\nPress Ctrl+C to stop the server\n');

// Set environment variable for quick start
process.env.QUICK_START = 'true';
process.env.NODE_ENV = 'development';

// Start the application
const child = spawn('node', ['dist/server.js'], {
  stdio: 'inherit',
  cwd: process.cwd()
});

child.on('error', (error) => {
  console.error('❌ Failed to start the application:', error.message);
  console.log('\n💡 Try running: npm run build && node quick-start.js');
  process.exit(1);
});

child.on('close', (code) => {
  console.log(`\n👋 Application stopped with code ${code}`);
  process.exit(code);
});