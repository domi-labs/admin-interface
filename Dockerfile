# Use a slim Node.js image as the first stage
FROM node:10-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy only the package files first to leverage cache busting
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy all application files after dependencies are installed
COPY . .

# Build the application for production
RUN npm run build:prod

# Use the official Nginx image as the second stage
FROM nginx:alpine

# Copy the built application into the Nginx container
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose the default HTTP port
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]