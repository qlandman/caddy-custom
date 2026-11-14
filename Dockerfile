# Caddy with the Cloudflare DNS module and caddy-docker-proxy (labels), built from official sources.
# Versions are pinned by the workflow from versions.json; the defaults here are only for local builds.
ARG CADDY_VERSION=2.11.9
FROM caddy:${CADDY_VERSION}-builder AS builder
ARG CLOUDFLARE_VERSION=v0.2.4
ARG DOCKER_PROXY_VERSION=v2.13.1
RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare@${CLOUDFLARE_VERSION} \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2@${DOCKER_PROXY_VERSION}

FROM caddy:${CADDY_VERSION}-alpine
ARG CADDY_VERSION
ARG CLOUDFLARE_VERSION=v0.2.4
ARG DOCKER_PROXY_VERSION=v2.13.1
LABEL org.opencontainers.image.title="caddy-cloudflare-proxy" \
      org.opencontainers.image.description="Caddy ${CADDY_VERSION} + caddy-dns/cloudflare ${CLOUDFLARE_VERSION} + caddy-docker-proxy ${DOCKER_PROXY_VERSION}" \
      org.opencontainers.image.source="https://github.com/qlandman/caddy-custom" \
      nl.landhost.caddy.version="${CADDY_VERSION}" \
      nl.landhost.cloudflare.version="${CLOUDFLARE_VERSION}" \
      nl.landhost.docker-proxy.version="${DOCKER_PROXY_VERSION}"
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
CMD ["caddy", "docker-proxy"]
