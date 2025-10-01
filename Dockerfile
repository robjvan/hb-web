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

FROM node:20-alpine AS build

WORKDIR /app

COPY package.json package-lock.json ./ 
RUN npm ci

COPY . .
RUN npm run build -- --output-path=./dist/hb-web/browser --configuration=production --base-href=/

# Final stage: just copy the built artifacts
FROM alpine:latest

WORKDIR /usr/share/nginx/html

COPY --from=build /app/dist/hb-web/browser .

# Expose port 80, as Coolify's Traefik/Caddy will forward to this port
EXPOSE 80