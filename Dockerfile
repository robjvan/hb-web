# FROM node:20-alpine AS build

# WORKDIR /app

# COPY package.json package-lock.json ./ 
# RUN npm install

# COPY . .
# RUN npm run build -- --output-path=./dist/hb-web/browser --configuration=production

# FROM nginx:alpine AS serve

# COPY nginx.conf /etc/nginx/conf.d/default.conf
# COPY --from=build /app/dist/hb-web/browser /usr/share/nginx/html

# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]

# -----------------------------
# Build Stage
# -----------------------------
FROM node:20-alpine AS build

WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json ./
RUN npm install --frozen-lockfile

# Copy source files
COPY . .

# Build Angular app for production
RUN npm run build -- --output-path=dist/browser --configuration=production

# -----------------------------
# Serve Stage
# -----------------------------
FROM nginx:alpine

# Remove default Nginx index.html
RUN rm -rf /usr/share/nginx/html/*

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy Angular build output
COPY --from=build /app/dist/browser /usr/share/nginx/html

# Fix ownership and permissions
RUN mkdir -p /usr/share/nginx/html && \
    chown -R nginx:nginx /usr/share/nginx/html && \
    find /usr/share/nginx/html -type d -exec chmod 755 {} \; && \
    find /usr/share/nginx/html -type f -exec chmod 644 {} \;

# Expose port
EXPOSE 80

# Run Nginx
CMD ["nginx", "-g", "daemon off;"]
