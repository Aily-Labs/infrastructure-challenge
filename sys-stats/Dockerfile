FROM node:16.20.1 as node-build

LABEL maintainer="infrastructure"

WORKDIR /app

COPY . .

RUN npm install \
    && npm run build

FROM nginx:1.25.3 as nginx-frontend

COPY --from=node-build /app/build/ /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
