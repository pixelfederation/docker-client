FROM nginx:stable-alpine as target1
COPY index.html /usr/share/nginx/html/index.html

FROM target1 as target2
RUN apk add curl
