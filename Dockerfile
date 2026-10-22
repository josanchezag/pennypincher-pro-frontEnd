# syntax=docker/dockerfile:1
#
# Multi-stage build: compile the Flutter web bundle, then serve it with nginx.
#
#   docker build -t pennypincher-frontend \
#     --build-arg API_BASE_URL=http://localhost:8080/api/v1 \
#     --build-arg API_ORIGIN=http://localhost:8080 \
#     --build-arg GOOGLE_CLIENT_ID=xxxx.apps.googleusercontent.com \
#     --build-arg GOOGLE_REDIRECT_URI=http://localhost:3000/auth.html \
#     --build-arg DEV_LOGIN=true .
#   docker run --rm -p 3000:80 pennypincher-frontend
#
# API_ORIGIN must be the scheme://host[:port] of API_BASE_URL; it can still
# be overridden at runtime with `docker run -e API_ORIGIN=...`.

ARG FLUTTER_IMAGE=ghcr.io/cirruslabs/flutter:3.24.5
ARG NGINX_IMAGE=nginx:1.27-alpine
ARG API_ORIGIN=http://localhost:8080

# ---- Stage 1: build the web bundle ------------------------------------------
FROM ${FLUTTER_IMAGE} AS builder
WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get --enforce-lockfile

COPY . .

ARG API_BASE_URL=http://localhost:8080/api/v1
ARG GOOGLE_CLIENT_ID=
ARG GOOGLE_REDIRECT_URI=http://localhost:3000/auth.html
ARG DEV_LOGIN=false
RUN flutter build web --release --no-web-resources-cdn \
      --dart-define=API_BASE_URL=${API_BASE_URL} \
      --dart-define=GOOGLE_CLIENT_ID=${GOOGLE_CLIENT_ID} \
      --dart-define=GOOGLE_REDIRECT_URI=${GOOGLE_REDIRECT_URI} \
      --dart-define=DEV_LOGIN=${DEV_LOGIN}

# ---- Stage 2: serve with nginx ----------------------------------------------
FROM ${NGINX_IMAGE}

# Origin of the backend API allowed by the Content-Security-Policy.
# The official nginx entrypoint substitutes it into the template at startup.
ARG API_ORIGIN
ENV API_ORIGIN=${API_ORIGIN}

COPY nginx.conf /etc/nginx/templates/default.conf.template
COPY --from=builder /app/build/web /usr/share/nginx/html

EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1/healthz || exit 1
