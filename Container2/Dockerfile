# Use the official Node.js image
FROM  node:18-alpine

# Set the working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json /app/package.json
RUN npm install
RUN mkdir -p /app/files

# Copy the rest of the application
COPY . /app



# Start the app
CMD ["npm", "start"]
