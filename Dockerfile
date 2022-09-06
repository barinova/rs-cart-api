# Base
FROM node:12-alpine as base

# Create app directory
WORKDIR /app

# Dependencies
FROM base as dependencies
COPY package*.json ./
RUN npm install

# Build
FROM dependencies as build
COPY . .
RUN npm run build

# Application
FROM node:12-alpine as application

ENV NODE_ENV=production

# Copy directories from build
COPY --from=build /app/package*.json ./
RUN npm install
COPY --from=build /app/dist ./dist

USER node
ENV PORT=8080
EXPOSE 8080

CMD ["node", "dist/main.js"]