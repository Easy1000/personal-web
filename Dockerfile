# Stage 1: Build the Next.js app
FROM node:alpine AS builder

# Set working directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install --frozen-lockfile

# Copy all files to the container
COPY . .

# Build the Next.js app
RUN npm run build

# Stage 2: Serve the built app
FROM node:alpine AS runner

# Set environment to production
ENV NODE_ENV=production

# Set working directory
WORKDIR /app

# Copy the built Next.js app from the builder stage
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

# Expose the port that Next.js runs on
EXPOSE 3000

# Run the Next.js app
CMD ["npm", "run", "start"]

