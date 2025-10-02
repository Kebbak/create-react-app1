# Production Deployment Guide

Your Docker image is automatically built and pushed to GitHub Container Registry. Here are several ways to deploy it to production:

## 🐳 Docker Image Location

After each successful build on the `main` branch, your Docker image is available at:
- `ghcr.io/kebbak/create-react-app1:latest` (latest version)
- `ghcr.io/kebbak/create-react-app1:SHA` (specific commit)

## 🚀 Deployment Options

### 1. Local/VPS Deployment

```bash
# Pull and run the latest image
docker pull ghcr.io/kebbak/create-react-app1:latest
docker run -d -p 80:80 --name my-react-app ghcr.io/kebbak/create-react-app1:latest

# Access at http://your-server-ip
```

### 2. Google Cloud Run

```bash
# Deploy to Google Cloud Run
gcloud run deploy my-react-app \
  --image ghcr.io/kebbak/create-react-app1:latest \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

Or add to your GitHub Actions workflow:
```yaml
- name: Deploy to Google Cloud Run
  uses: google-github-actions/deploy-cloudrun@v2
  with:
    service: my-react-app
    image: ghcr.io/kebbak/create-react-app1:latest
    region: us-central1
```

### 3. AWS ECS

Create `task-definition.json`:
```json
{
  "family": "my-react-app",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "256",
  "memory": "512",
  "executionRoleArn": "arn:aws:iam::ACCOUNT:role/ecsTaskExecutionRole",
  "containerDefinitions": [
    {
      "name": "my-react-app",
      "image": "ghcr.io/kebbak/create-react-app1:latest",
      "portMappings": [
        {
          "containerPort": 80,
          "protocol": "tcp"
        }
      ],
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/my-react-app",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
}
```

### 4. Azure Container Instances

```bash
# Deploy to Azure Container Instances
az container create \
  --resource-group myResourceGroup \
  --name my-react-app \
  --image ghcr.io/kebbak/create-react-app1:latest \
  --dns-name-label my-react-app \
  --ports 80
```

### 5. Docker Swarm

```yaml
# docker-compose.prod.yml
version: '3.8'
services:
  app:
    image: ghcr.io/kebbak/create-react-app1:latest
    ports:
      - "80:80"
    deploy:
      replicas: 3
      restart_policy:
        condition: on-failure
      resources:
        limits:
          memory: 512M
        reservations:
          memory: 256M
```

```bash
docker stack deploy -c docker-compose.prod.yml my-react-app
```

### 6. Kubernetes

```yaml
# k8s-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-react-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-react-app
  template:
    metadata:
      labels:
        app: my-react-app
    spec:
      containers:
      - name: my-react-app
        image: ghcr.io/kebbak/create-react-app1:latest
        ports:
        - containerPort: 80
        resources:
          limits:
            memory: 512Mi
            cpu: 500m
          requests:
            memory: 256Mi
            cpu: 250m
---
apiVersion: v1
kind: Service
metadata:
  name: my-react-app-service
spec:
  selector:
    app: my-react-app
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: LoadBalancer
```

### 7. Railway

```bash
# Install Railway CLI and deploy
npm install -g @railway/cli
railway login
railway project new
railway service new
railway up --detach ghcr.io/kebbak/create-react-app1:latest
```

## 🔐 Authentication for Private Registry

If you need to pull from a private registry:

```bash
# GitHub Container Registry authentication
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
```

## 📊 Monitoring & Health Checks

Add health check endpoints to your deployment:

```bash
# Health check URL
curl http://your-app-url/

# Container health check
docker run -d --health-cmd="curl -f http://localhost/ || exit 1" \
  --health-interval=30s \
  --health-timeout=10s \
  --health-retries=3 \
  ghcr.io/kebbak/create-react-app1:latest
```

## 🔄 Continuous Deployment

To enable automatic deployment, uncomment and configure the deployment steps in `.github/workflows/build-and-deploy.yml` for your chosen platform.

## 💡 Environment Variables

If your React app needs environment variables in production:

```bash
# Pass environment variables to the container
docker run -e REACT_APP_API_URL=https://api.production.com \
  -p 80:80 ghcr.io/kebbak/create-react-app1:latest
```

## 🛠️ Troubleshooting

```bash
# Check container logs
docker logs container-name

# Debug running container
docker exec -it container-name sh

# Test container locally
docker run -p 8080:80 ghcr.io/kebbak/create-react-app1:latest
```