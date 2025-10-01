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

# Install http-server globally in the build stage
RUN npm install -g http-server

# Final stage: just copy the built artifacts and serve them with http-server
FROM alpine:latest

WORKDIR /usr/share/nginx/html

COPY --from=build /app/dist/hb-web/browser .

# Copy http-server from the build stage
COPY --from=build /usr/local/bin/http-server /usr/local/bin/http-server
COPY --from=build /usr/local/lib/node_modules/http-server /usr/local/lib/node_modules/http-server

# Expose port 8080 (default for http-server)
EXPOSE 8080

# Command to run http-server to serve the static files
CMD ["http-server", ".", "-p", "8080", "--spa"]