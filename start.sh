#!/bin/sh
set -e

# Wait for PostgreSQL to be ready
until pg_isready -h odoo-DB -p 5432 -U postgres; do
  echo "Waiting for PostgreSQL..."
  sleep 2
done

# Run Prisma db push to apply the schema
sed -i '/binaryTargets/d' /app/webstudio/packages/prisma-client/prisma/schema.prisma
npx prisma db push --schema packages/prisma-client/prisma/schema.prisma

# Install any missing dependencies
pnpm install

# Start the development server
pnpm dev
