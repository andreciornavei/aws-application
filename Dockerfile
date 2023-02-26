FROM node:18.14.2-alpine

RUN mkdir -p /usr/app
WORKDIR /usr/app

COPY ./app /usr/app

EXPOSE 1337

ARG NODE_ENV

ENV NODE_ENV=$NODE_ENV

RUN rm -rf node_modules 
RUN npm install --no-audit
RUN npm run build
