# caddy-custom

Caddy built from the official `caddy:<version>-builder` image with two modules:

- [`caddy-dns/cloudflare`](https://github.com/caddy-dns/cloudflare) — ACME DNS-01 via Cloudflare
- [`lucaslorentz/caddy-docker-proxy`](https://github.com/lucaslorentz/caddy-docker-proxy) — config from container labels

Image: `ghcr.io/qlandman/caddy-cloudflare-proxy`

| Tag | Meaning |
|---|---|
| `2.11.9-20261114` | immutable; pin this in compose |
| `2.11.9` | latest build of that Caddy version |
| `latest` | latest build |

## How updates work

`.github/workflows/build.yml` runs a daily check and **builds only when something changed**,
compared with `versions.json`:

- a new Caddy release, or a new tag of either plugin;
- a new digest of the official base images `caddy:<version>-builder` or `caddy:<version>-alpine`
  (Docker Hub republishes those for Alpine/Go security fixes between Caddy releases).

No change means no new image and no restart on the Docker host. A build is smoke-tested
(`caddy list-modules` must contain both modules), records `versions.json` and `last-build.json`,
and prunes old image versions (the newest 10 are kept). A push to the Dockerfile/workflow or a
manual run with *force* also builds. On the 1st of each month a keepalive commit
(`last-check.json`) stops GitHub from disabling the schedule after 60 days without commits.

The image contains no secrets; the Cloudflare token is passed at runtime.
Actions are pinned to commit SHAs; Dependabot keeps them current.
