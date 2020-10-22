FROM bitwalker/alpine-elixir:latest as releaser

# TODO: remove once 1.11 will be available
# Install NPM
RUN \
    mkdir -p /opt/app && \
    chmod -R 777 /opt/app && \
    apk update && \
    apk --no-cache --update add \
      make \
      g++ \
      wget \
      curl \
      inotify-tools \
      nodejs \
      nodejs-npm && \
    npm install npm -g --no-progress && \
    update-ca-certificates --fresh && \
    rm -rf /var/cache/apk/*

# Add local node module binaries to PATH
ENV PATH=./node_modules/.bin:$PATH
# TODO END: remove once 1.11 will be available

WORKDIR /app

RUN mix do local.hex --force, local.rebar --force

COPY config/ /app/config/
COPY mix.exs mix.lock /app/
COPY apps/zeit/mix.exs /app/apps/zeit/
COPY apps/zeit_web/mix.exs /app/apps/zeit_web/

ENV MIX_ENV=prod
RUN mix do deps.get --only $MIX_ENV, deps.compile

COPY . /app/

# Build web
WORKDIR /app/apps/zeit_web/assets
RUN npm install
RUN npm rebuild node-sass
RUN npm run deploy

WORKDIR /app/apps/zeit_web
RUN MIX_ENV=prod mix compile
RUN mix phx.digest

WORKDIR /app

RUN mix deps.clean --all &&\
    MIX_ENV=prod mix release --overwrite

FROM scratch as artifact
COPY --from=releaser /app/_build/prod /artifact

# Final image
FROM bitwalker/alpine-elixir-phoenix:latest

EXPOSE 4000
ENV PORT=4000 \
    MIX_ENV=prod \
    SHELL=/bin/bash

WORKDIR /app
COPY --from=releaser /app/_build/prod/rel/zeit_machine .
COPY scripts/start.sh bin/
CMD ["./bin/zeit_machine", "start"]
