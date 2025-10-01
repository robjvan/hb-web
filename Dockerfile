FROM node:20-alpine AS build

WORKDIR /app

COPY package.json package-lock.json ./ 
RUN npm install

COPY . .
RUN npm run build -- --output-path=./dist/hb-web/browser --configuration=production

FROM nginx:alpine AS serve

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist/hb-web/browser /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]