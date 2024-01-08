FROM node:latest

ENV NG_CLI_ANALYTICS="false"
RUN npm install -g @angular/cli