FROM klakegg/hugo:ext-ci AS build
WORKDIR /src

COPY . ./
RUN hugo --environment production --cleanDestinationDir --minify --panicOnWarning -d /out

FROM caddy:2.8.4 AS run

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=build /out /srv
