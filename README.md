# React App with Docker & CI/CD Pipeline 🚀

A modern React application with comprehensive Docker support, automated testing, and deployment pipeline using GitHub Actions.

## 📋 Table of Contents

- [Features](#features)
- [Quick Start](#quick-start)
- [Docker Support](#docker-support)
- [Testing](#testing)
- [CI/CD Pipeline](#cicd-pipeline)
- [Development](#development)
- [Deployment](#deployment)
- [Project Structure](#project-structure)

## ✨ Features

- **React 18** with Create React App
- **Docker** multi-stage builds for development and production
- **Unit Testing** with Jest and React Testing Library
- **E2E Testing** with Playwright
- **GitHub Actions** CI/CD pipeline
- **Docker Compose** for local development
- **Nginx** optimized production serving
- **Code Coverage** reporting
- **Multi-browser testing** (Chrome, Mobile)
- **Performance testing** with load time validation

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- Node.js 18+ (for local development)
- Git

### 1. Clone the Repository
```bash
git clone https://github.com/Kebbak/create-react-app1.git
cd create-react-app1
```

### 2. Run with Docker (Recommended)
```bash
# Build and run production version
./docker.sh build
./docker.sh run

# Access at http://localhost:8080
```

### 3. Development Mode
```bash
# Start development server with hot reload
./docker.sh run-dev

# Access at http://localhost:3000
```

## 🐳 Docker Support

### Available Docker Commands

```bash
./docker.sh build        # Build production image
./docker.sh run          # Run production container (port 8080)
./docker.sh run-dev      # Development with hot reload (port 3000)
./docker.sh test         # Run unit tests in container
./docker.sh test-e2e     # Run E2E tests with Playwright
./docker.sh stop         # Stop all containers
./docker.sh clean        # Clean up Docker resources
./docker.sh logs         # View container logs
```

### Docker Compose Services

```bash
# Development
docker-compose up app-dev

# Unit Testing
docker-compose run --rm app-test

# E2E Testing
docker-compose up app-e2e
```

### Multi-Stage Build Architecture

```dockerfile
Stage 1 (builder): Node.js → Install deps → Build React app
Stage 2 (test):    Node.js → Install deps → Run tests  
Stage 3 (prod):    Nginx   → Copy built files → Serve optimized app
```

## 🧪 Testing

### Unit Tests
- **Framework**: Jest + React Testing Library
- **Coverage**: Automated code coverage reporting
- **CI Integration**: Runs on every push/PR

```bash
# Run unit tests locally
cd my-app && npm test

# Run with Docker
./docker.sh test
```

### E2E Tests
- **Framework**: Playwright
- **Browsers**: Chrome, Mobile (Pixel 5)
- **Features**: Performance testing, responsive design validation

```bash
# Run E2E tests
./docker.sh test-e2e

# View test reports
open e2e/playwright-report/index.html
```

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow

The pipeline runs on every push and includes:

1. **Build & Test Job**
   - ✅ Install dependencies
   - ✅ Run unit tests with coverage
   - ✅ Build production bundle
   - ✅ Deploy to GitHub Pages

2. **Docker Job**
   - ✅ Build Docker images (test & production)
   - ✅ Run tests in containers
   - ✅ Push to GitHub Container Registry
   - ✅ Cache Docker layers for performance

3. **E2E Testing Job**
   - ✅ Run end-to-end tests
   - ✅ Multi-browser validation
   - ✅ Performance benchmarking

### Container Registry

Docker images are automatically published to:
```
ghcr.io/kebbak/create-react-app1:latest
ghcr.io/kebbak/create-react-app1:pr-<number>
```

## 💻 Development

### Local Development (without Docker)
```bash
cd my-app
npm install
npm start          # Development server
npm test           # Run tests
npm run build      # Production build
```

### Development with Docker
```bash
./docker.sh run-dev   # Hot reload enabled
```

### Environment Variables
```bash
# Development
CHOKIDAR_USEPOLLING=true  # For Docker file watching

# Production
NODE_ENV=production
```

## 🚀 Deployment

### Production Deployment Options

#### 1. GitHub Pages (Automatic)
- Deploys on every push to `main`
- URL: `https://kebbak.github.io/create-react-app1`

#### 2. Docker Container Deployment
```bash
# Pull and run the latest image
docker run -p 80:80 ghcr.io/kebbak/create-react-app1:latest
```

#### 3. Cloud Platforms
```bash
# Google Cloud Run
gcloud run deploy --image ghcr.io/kebbak/create-react-app1:latest

# AWS ECS
aws ecs update-service --cluster my-cluster --service my-service

# Azure Container Instances
az container create --image ghcr.io/kebbak/create-react-app1:latest
```

### Deployment Script
```bash
./deploy.sh deploy    # Deploy to configured platform
./deploy.sh status    # Check deployment status
```

## 📁 Project Structure

```
create-react-app1/
├── .github/workflows/     # GitHub Actions CI/CD
│   └── build-and-deploy.yml
├── my-app/               # React application
│   ├── src/              # Source code
│   ├── public/           # Public assets
│   ├── package.json      # Dependencies
│   ├── Dockerfile        # Multi-stage Docker build
│   └── nginx.conf        # Production server config
├── e2e/                  # End-to-end tests
│   ├── tests/            # Playwright test files
│   ├── package.json      # E2E dependencies
│   ├── playwright.config.js
│   └── Dockerfile        # E2E testing container
├── docker-compose.yml    # Multi-service orchestration
├── docker.sh            # Docker helper script
├── deploy.sh            # Deployment automation
└── README.md            # This file
```

## 🔧 Configuration Files

- **Dockerfile**: Multi-stage build for optimized production images
- **docker-compose.yml**: Development and testing orchestration
- **playwright.config.js**: E2E testing configuration
- **.dockerignore**: Optimize Docker build context
- **.github/workflows/**: Automated CI/CD pipeline

## 📊 Performance Optimizations

- **Docker**: Multi-stage builds minimize image size
- **Nginx**: Gzip compression, static asset caching
- **React**: Production build optimization
- **CI/CD**: Docker layer caching, parallel jobs
- **Testing**: Automated performance budgets

## 🐛 Troubleshooting

### Common Issues

#### Docker Build Fails
```bash
# Clean Docker cache
./docker.sh clean
docker system prune -f

# Rebuild from scratch
./docker.sh build --no-cache
```

#### E2E Tests Timeout
```bash
# Increase timeout in docker-compose.yml
environment:
  - COMPOSE_HTTP_TIMEOUT=120
```

#### Development Server Not Accessible
```bash
# Check port binding
docker-compose ps
# Ensure CHOKIDAR_USEPOLLING=true for file watching
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes
4. Run tests: `./docker.sh test && ./docker.sh test-e2e`
5. Commit changes: `git commit -m "Add your feature"`
6. Push to branch: `git push origin feature/your-feature`
7. Create a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 🔗 Links

- **Live Demo**: [GitHub Pages](https://kebbak.github.io/create-react-app1)
- **Container Registry**: [GitHub Packages](https://github.com/Kebbak/create-react-app1/pkgs/container/create-react-app1)
- **CI/CD Pipeline**: [GitHub Actions](https://github.com/Kebbak/create-react-app1/actions)
