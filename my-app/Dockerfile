# Multi-stage Dockerfile for React App

# Stage 1: Build stage
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install all dependencies (needed for building)
RUN npm ci

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Test stage (for running tests)
FROM node:18-alpine AS test

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install all dependencies (including dev dependencies for testing)
RUN npm ci

# Copy source code
COPY . .

# Run tests
RUN npm run test -- --coverage --ci --watchAll=false

# # Stage 3: Production stage
# FROM nginx:alpine AS production

# # Copy built assets from builder stage
# COPY --from=builder /app/build /usr/share/nginx/html

# # Copy custom nginx configuration (optional)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# # Expose port 80
# EXPOSE 80

# # Start nginx
# CMD ["nginx", "-g", "daemon off;"]