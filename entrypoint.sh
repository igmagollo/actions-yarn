#!/bin/sh -x

set -e

if [ -n "$NPM_AUTH_TOKEN" ]; then
  # Respect NPM_CONFIG_USERCONFIG if it is provided, default to $HOME/.npmrc
  NPM_CONFIG_USERCONFIG="${NPM_CONFIG_USERCONFIG:-"$HOME/.npmrc"}"
  NPM_REGISTRY_URL="${NPM_REGISTRY_URL:-registry.npmjs.org}"
  NPM_STRICT_SSL="${NPM_STRICT_SSL:-true}"
  NPM_REGISTRY_SCHEME="https"
  if ! $NPM_STRICT_SSL
  then
    NPM_REGISTRY_SCHEME="http"
  fi

  # Allow registry.npmjs.org to be overridden with an environment variable
  printf "//%s/:_authToken=%s\\nregistry=%s\\nstrict-ssl=%s" "$NPM_REGISTRY_URL" "$NPM_AUTH_TOKEN" "${NPM_REGISTRY_SCHEME}://$NPM_REGISTRY_URL" "${NPM_STRICT_SSL}" > "$NPM_CONFIG_USERCONFIG"

  chmod 0600 "$NPM_CONFIG_USERCONFIG"
fi

if [ -n "$SSH_PRIVATE_KEY" ]; then
  eval $(ssh-agent -s)
  echo -ne "$SSH_PRIVATE_KEY" | base64 -d | tr -d '\r' | ssh-add -
  echo -ne "$SSH_PRIVATE_KEY" | base64 -d > /root/.ssh/id_rsa
  chmod 400 /root/.ssh/id_rsa
  ssh-keygen -y -f /root/.ssh/id_rsa > /root/.ssh/id_rsa.pub
  ssh-keyscan github.com >> /root/.ssh/known_hosts
  chmod 644 /root/.ssh/known_hosts
  echo "Não tem como, forget padrin"
fi

echo "Iniciando yarn $*"
sh -c "yarn $*"
