# NPM Dependencies
FROM node:13.7 AS npm-build

WORKDIR /var/www/html

COPY package.json package-lock.json webpack.mix.js /var/www/html/
COPY resources /var/www/html/resources/
COPY public /var/www/html/public/

RUN npm ci
RUN npm run production

#Nginx  Production
FROM nginx:stable-alpine

COPY /docker/nginx/nginx_dev.conf /etc/nginx/conf.d/default.conf

COPY --from=npm-build /var/www/html/public/ /var/www/html/public/
COPY . /var/www/html
