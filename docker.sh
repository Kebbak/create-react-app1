#!/bin/bash

# Docker helper scripts for React app

case "$1" in
    "build")
        echo "Building Docker image..."
        docker build -t my-react-app:latest ./my-app
        ;;
    "build-test")
        echo "Building and running tests in Docker..."
        docker build -t my-react-app:test --target test ./my-app
        ;;
    "run")
        echo "Running production Docker container on port 8080..."
        docker run -d -p 8080:80 --name my-react-app my-react-app:latest
        echo "App available at http://localhost:8080"
        ;;
    "run-dev")
        echo "Starting development environment with docker-compose..."
        docker-compose up app-dev
        ;;
    "run-prod")
        echo "Starting production environment with docker-compose..."
        docker-compose up app-prod
        ;;
    "test")
        echo "Running tests with docker-compose..."
        docker-compose run --rm app-test
        ;;
    "stop")
        echo "Stopping and removing containers..."
        docker stop my-react-app 2>/dev/null || true
        docker rm my-react-app 2>/dev/null || true
        docker-compose down
        ;;
    "clean")
        echo "Cleaning up Docker resources..."
        docker stop my-react-app 2>/dev/null || true
        docker rm my-react-app 2>/dev/null || true
        docker-compose down
        docker rmi my-react-app:latest my-react-app:test 2>/dev/null || true
        ;;
    "logs")
        echo "Showing container logs..."
        docker logs my-react-app
        ;;
    *)
        echo "Usage: $0 {build|build-test|run|run-dev|run-prod|test|stop|clean|logs}"
        echo ""
        echo "Commands:"
        echo "  build      - Build production Docker image"
        echo "  build-test - Build and run tests in Docker"
        echo "  run        - Run production container on port 8080"
        echo "  run-dev    - Start development server with hot reload"
        echo "  run-prod   - Start production server"
        echo "  test       - Run tests in container"
        echo "  stop       - Stop and remove containers"
        echo "  clean      - Clean up all Docker resources"
        echo "  logs       - Show container logs"
        ;;
esac