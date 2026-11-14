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

`.github/workflows/build.yml` runs daily. It looks up the newest Caddy release and the newest
tags of both plugins, compares them with `versions.json`, and only builds when something changed
(or on a push to the Dockerfile/workflow, or a manual run with *force*). Every Monday it rebuilds
regardless, to pick up security fixes in the `caddy:<version>-alpine` base image; each build commits
`last-build.json`, which also keeps the scheduled workflow from being disabled after 60 days of
repository inactivity. After a successful build
and a smoke test (`caddy list-modules` must contain both modules) it commits the new
`versions.json`. On the Docker host, WUD picks up the new `<caddy>-<date>` tag.

The image contains no secrets; the Cloudflare token is passed at runtime.
Actions are pinned to commit SHAs; Dependabot keeps them current.
