FROM node:20.10.0 AS build
ARG app

WORKDIR /app

COPY package*.json ./
COPY . .

RUN npm i
RUN npx nx build ${app} --prod

FROM nginx:1.24.0-perl
ARG host

WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=build /app/dist/apps/${app} .
ENTRYPOINT ["nginx", "-g", "daemon off;"]
