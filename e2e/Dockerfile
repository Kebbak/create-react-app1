// filepath: /home/kkanyi/create-react-app1/e2e/Dockerfile
FROM mcr.microsoft.com/playwright:v1.40.0-focal

WORKDIR /app

# Install Node.js 18
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy package files and install dependencies
COPY e2e/package*.json ./
RUN npm install && npx playwright install

# Copy test files
COPY e2e/ ./

# Run tests
CMD ["npm", "test"]