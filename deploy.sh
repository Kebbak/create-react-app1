#!/bin/bash

# Production deployment script for React app Docker image

IMAGE_NAME="ghcr.io/kebbak/create-react-app1:latest"
CONTAINER_NAME="my-react-app-prod"
PORT="80"

case "$1" in
    "deploy")
        echo "🚀 Deploying React app to production..."
        
        # Stop and remove existing container
        docker stop $CONTAINER_NAME 2>/dev/null || true
        docker rm $CONTAINER_NAME 2>/dev/null || true
        
        # Pull latest image
        echo "📦 Pulling latest Docker image..."
        docker pull $IMAGE_NAME
        
        # Run new container
        echo "▶️ Starting new container..."
        docker run -d \
            --name $CONTAINER_NAME \
            -p $PORT:80 \
            --restart unless-stopped \
            --health-cmd="curl -f http://localhost/ || exit 1" \
            --health-interval=30s \
            --health-timeout=10s \
            --health-retries=3 \
            $IMAGE_NAME
        
        echo "✅ Deployment complete!"
        echo "🌐 App available at: http://localhost:$PORT"
        ;;
        
    "status")
        echo "📊 Container status:"
        docker ps -f name=$CONTAINER_NAME
        echo ""
        echo "📈 Container stats:"
        docker stats $CONTAINER_NAME --no-stream 2>/dev/null || echo "Container not running"
        ;;
        
    "logs")
        echo "📜 Container logs:"
        docker logs $CONTAINER_NAME -f
        ;;
        
    "health")
        echo "🏥 Health check:"
        curl -f http://localhost:$PORT/ && echo "✅ App is healthy" || echo "❌ App is not responding"
        echo ""
        echo "🐳 Docker health status:"
        docker inspect $CONTAINER_NAME --format='{{.State.Health.Status}}' 2>/dev/null || echo "Container not running"
        ;;
        
    "stop")
        echo "🛑 Stopping production container..."
        docker stop $CONTAINER_NAME
        echo "✅ Container stopped"
        ;;
        
    "restart")
        echo "🔄 Restarting production container..."
        docker restart $CONTAINER_NAME
        echo "✅ Container restarted"
        ;;
        
    "update")
        echo "🔄 Updating to latest version..."
        $0 deploy
        ;;
        
    "rollback")
        if [ -z "$2" ]; then
            echo "❌ Please specify a commit SHA: $0 rollback <commit-sha>"
            exit 1
        fi
        
        ROLLBACK_IMAGE="ghcr.io/kebbak/create-react-app1:$2"
        
        echo "⏪ Rolling back to commit: $2"
        
        # Stop current container
        docker stop $CONTAINER_NAME 2>/dev/null || true
        docker rm $CONTAINER_NAME 2>/dev/null || true
        
        # Pull specific version
        docker pull $ROLLBACK_IMAGE
        
        # Run rollback version
        docker run -d \
            --name $CONTAINER_NAME \
            -p $PORT:80 \
            --restart unless-stopped \
            $ROLLBACK_IMAGE
        
        echo "✅ Rollback complete!"
        ;;
        
    "cleanup")
        echo "🧹 Cleaning up old Docker images..."
        docker image prune -f
        echo "✅ Cleanup complete"
        ;;
        
    *)
        echo "🐳 Production Deployment Script for React App"
        echo ""
        echo "Usage: $0 {deploy|status|logs|health|stop|restart|update|rollback|cleanup}"
        echo ""
        echo "Commands:"
        echo "  deploy     - Deploy latest version to production"
        echo "  status     - Show container status and stats"
        echo "  logs       - Show container logs (follow mode)"
        echo "  health     - Check application health"
        echo "  stop       - Stop the production container"
        echo "  restart    - Restart the production container"
        echo "  update     - Update to latest version (same as deploy)"
        echo "  rollback   - Rollback to specific commit (usage: rollback <commit-sha>)"
        echo "  cleanup    - Remove unused Docker images"
        echo ""
        echo "Examples:"
        echo "  $0 deploy                    # Deploy latest version"
        echo "  $0 rollback abc123           # Rollback to commit abc123"
        echo "  $0 health                    # Check if app is healthy"
        ;;
esac