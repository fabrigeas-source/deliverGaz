# Use the official Node.js runtime as the base image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json (avoid potential package-lock.json auth issues)
COPY package.json ./

# Install dependencies with npm configuration
RUN npm config set registry https://registry.npmjs.org/ && \
    npm config delete //registry.npmjs.org/:_authToken 2>/dev/null || true && \
    npm install && \
    npm cache clean --force

# Copy the rest of the application code
COPY . .

# Build the TypeScript application
RUN npm run build

# Create a non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S delivergaz -u 1001 -G nodejs

# Create uploads directory and set permissions
RUN mkdir -p uploads logs && \
    chown -R delivergaz:nodejs /app

# Switch to the non-root user
USER delivergaz

# Expose the port the app runs on
EXPOSE 4000

# Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "const http = require('http'); http.get('http://localhost:4000/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1); }).on('error', () => process.exit(1));"

# Define the command to run the application
CMD ["npm", "start"]