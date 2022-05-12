FROM node:12.13.0-alpine

RUN apk add --no-cache git python2 build-base openssh
RUN npm i -g --force yarn
COPY "entrypoint.sh" "/entrypoint.sh"
ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]
