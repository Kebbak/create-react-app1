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
    "run-dev")
        echo "Starting development environment with docker-compose..."
        docker-compose up app-dev
        ;;
    "test")
        echo "Running unit tests with docker-compose..."
        docker-compose run --rm app-test
        ;;
    "test-e2e")
        echo "Running E2E tests with docker-compose..."
        echo "Starting development server..."
        docker-compose up -d app-dev
        echo "Waiting for server to be ready..."
        sleep 10
        echo "Running E2E tests..."
        docker-compose --profile e2e run --rm app-e2e
        echo "Stopping development server..."
        docker-compose down
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
        echo "Usage: $0 {build|build-test|run|run-dev|run-prod|test|test-e2e|stop|clean|logs}"
        echo ""
        echo "Commands:"
        echo "  build      - Build production Docker image"
        echo "  build-test - Build and run tests in Docker"
        echo "  run        - Run production container on port 8080"
        echo "  run-dev    - Start development server with hot reload"
        echo "  run-prod   - Start production server"
        echo "  test       - Run unit tests in container"
        echo "  test-e2e   - Run E2E tests (starts dev server automatically)"
        echo "  stop       - Stop and remove containers"
        echo "  clean      - Clean up all Docker resources"
        echo "  logs       - Show container logs"
        ;;
esac