FROM node:18

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 8080

# ENTRYPOINT [ "executable" ]

CMD node dbinit.js && node index.js
