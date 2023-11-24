FROM node:14

WORKDIR /usr/src/app

COPY package.json ./

COPY package-lock.json ./

COPY . .

EXPOSE 3000

RUN npm install

CMD ["node", "index.js"]