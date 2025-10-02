# React App with Docker

This project includes Docker support for building, testing, and deploying the React application.

## Docker Files

- `my-app/Dockerfile` - Multi-stage Dockerfile for building the React app
- `docker-compose.yml` - Docker Compose configuration for different environments
- `docker.sh` - Helper script for common Docker operations

## Quick Start

### Using Helper Script

```bash
# Build the Docker image
./docker.sh build

# Run production container
./docker.sh run

# Start development environment with hot reload
./docker.sh run-dev

# Run tests in container
./docker.sh test

# Stop containers
./docker.sh stop

# Clean up all Docker resources
./docker.sh clean
```

### Manual Docker Commands

```bash
# Build production image
docker build -t my-react-app:latest ./my-app

# Run production container
docker run -d -p 8080:80 --name my-react-app my-react-app:latest

# Build and run tests
docker build -t my-react-app:test --target test ./my-app

# Access the application
open http://localhost:8080
```

### Using Docker Compose

```bash
# Development (with hot reload)
docker-compose up app-dev

# Production
docker-compose up app-prod

# Run tests
docker-compose run --rm app-test
```

## Docker Stages

The Dockerfile uses multi-stage builds:

1. **Builder Stage**: Installs dependencies and builds the React app
2. **Test Stage**: Runs tests with coverage
3. **Production Stage**: Serves the built app with Nginx

## GitHub Actions Integration

The workflow includes Docker build and test steps:

- Builds Docker images for both test and production
- Runs tests in the Docker test stage
- Tests the production image by starting a container and making HTTP requests
- Caches Docker layers for faster builds
- Saves the Docker image as an artifact

## Configuration

### Nginx Configuration

The production image uses Nginx with:
- Client-side routing support
- Static asset caching
- Security headers
- Gzip compression

### Environment Variables

For development, you can set environment variables in docker-compose.yml or pass them to docker run:

```bash
docker run -e REACT_APP_API_URL=https://api.example.com -p 8080:80 my-react-app:latest
```

## Troubleshooting

### Common Issues

1. **Port already in use**: Change the port mapping in docker run or docker-compose.yml
2. **Build fails**: Check Docker build logs and ensure all dependencies are correctly specified
3. **Tests fail in Docker**: Ensure test configuration works in CI mode

### Debugging

```bash
# View container logs
./docker.sh logs

# Access running container
docker exec -it my-react-app sh

# Debug build process
docker build --no-cache -t my-react-app:debug ./my-app
```