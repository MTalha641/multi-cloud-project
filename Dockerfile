# Base image
FROM node:16

# Set working directory
WORKDIR /app


COPY package*.json ./

# Install dependencies
RUN npm install


COPY . .


EXPOSE 8080

CMD ["npm", "start"]
