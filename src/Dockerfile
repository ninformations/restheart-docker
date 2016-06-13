FROM node:4-onbuild

WORKDIR /usr/src/app
RUN npm install proxy-middleware
COPY Gruntfile.js .
ADD app ./app

EXPOSE 9000