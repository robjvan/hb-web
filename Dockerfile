# -----------------------------
# Build Stage
# -----------------------------
FROM node:20-alpine AS build

WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json ./
RUN npm install --frozen-lockfile

# Copy source code
COPY . .

# Build Angular app for production
RUN npm run build -- --configuration production

# -----------------------------
# Serve Stage
# -----------------------------
FROM nginx:alpine

# Remove default Nginx welcome files
RUN rm -rf /usr/share/nginx/html/*

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy Angular build output
COPY --from=build /app/dist/browser/ /usr/share/nginx/html

# Fix permissions for Alpine Nginx
RUN chown -R nginx:nginx /usr/share/nginx/html \
    && find /usr/share/nginx/html -type d -exec chmod 755 {} \; \
    && find /usr/share/nginx/html -type f -exec chmod 644 {} \;

# Expose port 80 (Traefik will handle routing)
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
