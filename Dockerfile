FROM elixir:1.12.0

WORKDIR /app
ADD . /app

RUN mix local.hex --force && mix local.rebar --force
CMD ["mix", "phx.server"]