FROM node:12.13.0

RUN apk add --no-cache git build-base ssh python2
RUN npm i -g --force yarn
COPY "entrypoint.sh" "/entrypoint.sh"
ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]
