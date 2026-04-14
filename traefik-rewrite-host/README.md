# Traefik Host Header Rewrite Example

This project demonstrates a live example of **Traefik** acting as reverse proxy that modifies the `Host` header before forwarding the HTTP request to the target server.

## Purpose

The primary goal is to show how Traefik can route traffic based on a specific `Host` header (e.g., `caddy-in-docker.lvh.me`)
and then rewrite that header to a different value (e.g., `caddy.lvh.me`) required by the backend application.

This is particularly useful when:
- The backend application is configured to respond only to a specific domain.
- You want to proxy traffic from an external domain to an internal domain that differs from the original request.

## Getting Started

1. Create the shared network:
```bash
docker network create rewrite
```

2. Start Traefik:
```bash
docker compose up -d
```

3. Start the backend services:
Go to each directory and start the containers:
```bash
cd caddy && docker compose up -d && cd ..
cd podinfo && docker compose up -d && cd ..
```

## Verification

You can verify the setup using `curl`. Traefik is exposed on port `8888`.

### Testing Caddy Rewrite
Send a request to `caddy-in-docker.lvh.me:8888`. Traefik will rewrite the `Host` header to `caddy.lvh.me`.

```bash
curl -v 'caddy-in-docker.lvh.me:8888'
....
< HTTP/1.1 200 OK
< Accept-Ranges: bytes
< Content-Length: 150
< Content-Type: text/html; charset=utf-8
< Date: Tue, 14 Apr 2026 18:57:43 GMT
< Etag: "dhsahjzajaio46"
< Last-Modified: Mon, 13 Apr 2026 19:55:09 GMT
< Server: Caddy
< Vary: Accept-Encoding
<
{ [150 bytes data]
* Connection #0 to host caddy-in-docker.lvh.me left intact
<!DOCTYPE html>
<html lang="">
  <head>
    <meta charset="utf-8">
    <title></title>
  </head>
  <body>
    <h1>caddy.lvh.me</h1>
  </body>
</html>
```

#### Incorrect Host

If we modify the `rewrite-host-caddy` middleware in `caddy/docker-compose.yml`
to set a `Host` header that is not configured in Caddy (e.g., `wrong.lvh.me` instead of `caddy.lvh.me`):

```yaml
# Middleware to change Host header to an unsupported one
- "traefik.http.middlewares.rewrite-host-caddy.headers.customrequestheaders.Host=wrong.lvh.me"
```
We will see an empty response from Caddy:

```bash
curl -v 'caddy-in-docker.lvh.me:8888'
* Host caddy-in-docker.lvh.me:8888 was resolved.
* IPv6: (none)
* IPv4: 127.0.0.1
*   Trying 127.0.0.1:8888...
* Connected to caddy-in-docker.lvh.me (127.0.0.1) port 8888
> GET / HTTP/1.1
> Host: caddy-in-docker.lvh.me:8888
> User-Agent: curl/8.8.0
> Accept: */*
>
* Request completely sent off
< HTTP/1.1 200 OK
< Content-Length: 0
< Date: Tue, 14 Apr 2026 18:56:55 GMT
< Server: Caddy
<
* Connection #0 to host caddy-in-docker.lvh.me left intact
```
