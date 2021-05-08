FROM node:16-alpine3.11 AS developement

WORKDIR /app

COPY . .

RUN yarn install
RUN yarn build
CMD yarn start:prod
