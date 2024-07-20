# Use the latest official Node.js runtime as a parent image
FROM node:20-alpine

# Install git and postgresql-client
RUN apk add --no-cache git postgresql-client

# Set the working directory
WORKDIR /app

# Copy the clone_or_pull.sh script
COPY clone_or_pull.sh /app/clone_or_pull.sh

# Ensure the script is executable
RUN chmod +x /app/clone_or_pull.sh

# Run the clone_or_pull.sh script
RUN /app/clone_or_pull.sh

# Set the working directory to the cloned repository
WORKDIR /app/webstudio

# Install pnpm
RUN npm install -g pnpm@9.0.2

# Modify vite.config.ts to bind to 0.0.0.0
RUN sed -i 's/host: true/host: "0.0.0.0"/' /app/webstudio/apps/builder/vite.config.ts

# Modify the AUTH_SECRET in the .env file
RUN sed -i 's/^AUTH_SECRET=.*/AUTH_SECRET=6364b7130763c7fa415ad6d0c38b688185f468dcc172b93f69108eec60fd5a37/' /app/webstudio/apps/builder/.env

# Create .env file with necessary environment variables
RUN echo "DATABASE_URL=postgresql://postgres:pass@odoo-DB:5432/webstudio?pgbouncer=true" > /app/webstudio/.env && \
    echo "DIRECT_URL=postgresql://postgres:pass@odoo-DB:5432/webstudio" >> /app/webstudio/.env \

# Install dependencies using pnpm
RUN pnpm install --frozen-lockfile

# Copy and ensure init-db.sh is executable for the PostgreSQL container
COPY init-db.sh /docker-entrypoint-initdb.d/init-db.sh
RUN chmod +x /docker-entrypoint-initdb.d/init-db.sh

# Copy the start.sh script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Expose the port the app runs on
EXPOSE 5173

# Start the application using the start.sh script
CMD ["/app/start.sh"]
