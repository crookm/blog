FROM klakegg/hugo:ext-ci AS build
WORKDIR /src

COPY . ./
RUN hugo -e production -d /out

FROM caddy:2.7.6 AS run

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=build /out /srv
