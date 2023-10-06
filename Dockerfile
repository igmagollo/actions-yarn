FROM node:12.22.0-alpine

RUN apk add --no-cache git python2 build-base openssh
RUN npm i -g --force yarn
RUN mkdir ~/.ssh
RUN ssh-keyscan -H github.com >> ~/.ssh/known_hosts
COPY "entrypoint.sh" "/entrypoint.sh"
ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]
