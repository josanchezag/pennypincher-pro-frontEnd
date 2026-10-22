# PennyPincher Pro · Frontend

Aplicación web **responsive** en **Flutter** para gestionar las finanzas personales del hogar,
reemplazando la hoja de cálculo de presupuesto mensual. Este repositorio contiene solo el cliente
web; la API REST, la base de datos y la documentación del proyecto (spec, épicas y ADR) viven en
el backend.

> Backend: [pennypincher-pro-backend](https://github.com/josanchezag/pennypincher-pro-backend)

## Módulos

| Módulo | Ruta | Descripción |
|---|---|---|
| **Dashboard** | `/dashboard` | Resumen financiero en una sola vista. |
| **Fortuna neta** | `/net-worth` | Activos − Pasivos, histórico mensual y avance hacia la meta. |
| **Presupuesto mensual** | `/budget` | Ingresos y gastos por categoría, % real vs. % ideal, flujo de caja. |
| **Detalles de gastos** | `/expenses` | Tarjetas de crédito, préstamos, gastos fijos, variables y ahorros. |
| **Metas financieras** | `/goals` | Seguridad, Independencia, Libertad y Libertad Absoluta, con proyección. |
| **Configuración** | `/settings` | Perfil del usuario. |

## Stack

- Flutter **3.24.x** (stable), target principal **Web**, diseño responsive móvil / tablet / escritorio.
- Estado con **BLoC** (`flutter_bloc`), navegación con **go_router**, HTTP con **dio**.
- Inyección de dependencias con **get_it + injectable**, gráficas con **fl_chart**.
- Material 3 con un tema oscuro propio (tipografía Inter).

## Autenticación

1. El usuario inicia sesión con **Google OAuth2** (authorization code + PKCE, vía `flutter_web_auth_2`):
   el frontend genera un `code_verifier` aleatorio de 64 caracteres, su `code_challenge` S256 y un
   `state` aleatorio, y abre `https://accounts.google.com/o/oauth2/v2/auth` en una pestaña nueva.
2. Google redirige a `web/auth.html` (`GOOGLE_REDIRECT_URI`), cuyo script externo
   `auth_callback.js` devuelve la URL de retorno a la app. La app verifica el `state` y envía
   `code`, `redirectUri` y `codeVerifier` al backend (`POST /api/v1/auth/google/callback`).
3. El backend valida la identidad con Google y emite **sus propios tokens**:
   - *Access token* JWT RS256 de 15 minutos, que el frontend guarda **solo en memoria** y envía
     como `Authorization: Bearer <token>`.
   - *Refresh token* opaco y rotativo, enviado como cookie `httpOnly; Secure; SameSite=Strict`
     (el frontend nunca lo lee).
4. `AuthInterceptor` (dio, `QueuedInterceptorsWrapper`) agrega el *bearer* a cada llamada que no
   sea `/auth/*`. Ante un `401` llama una sola vez a `POST /api/v1/auth/refresh` (las peticiones
   concurrentes comparten ese único *refresh*) y reintenta la petición original una vez, con un
   cliente sin el interceptor, así que nunca entra en bucle. Si el *refresh* responde `401`, se
   borra el token y la sesión pasa a *unauthenticated*; un error de red en el *refresh* no cierra
   la sesión. Si otra pestaña rotó la cookie primero, el backend responde `401` con
   `REFRESH_SUPERSEDED`: el cliente espera 300 ms y repite el *refresh* una vez (el navegador ya
   tiene la cookie nueva); nunca lo trata como cierre de sesión.
5. `AuthGuard` (redirect de go_router, reevaluado con cada cambio del `AuthBloc`) manda a `/login`
   a quien no tiene sesión (guardando la ruta pedida en `?from=`) y saca de `/login` a quien ya la
   tiene (hacia `from` o `/dashboard`; tras un *sign out* explícito va a `/login` sin `from`; `from` solo se sigue si es una ruta relativa conocida de la
   app, sin esquema, host ni barras invertidas). *Sign out* (`DELETE /auth/logout`) siempre limpia la sesión
   local, aunque falle la llamada.
6. Al arrancar, la app envía `AuthCheckRequested`: como el *access token* no se persiste, la
   sesión se restaura con un `POST /auth/refresh` silencioso usando la cookie. El *splash* se
   muestra al menos 1 s; abre la ruta pedida (o `/dashboard`) si hay sesión, o `/login` si no.
   Si el chequeo sigue en curso a los 2 s (por ejemplo, un arranque en frío del backend), pasa a
   `/login`, y el guard redirige en cuanto la sesión se restaura.

El token de Google **nunca** se usa directamente contra la API.

## Requisitos

- Flutter SDK **3.24.x** (canal stable) con soporte web (`flutter precache --web`).
- Backend corriendo en local (ver el README del backend) o una URL remota.
- Para el login real: un *OAuth Client ID* de Google de tipo **Web application**. Para desarrollo
  local basta el *dev login* (ver abajo).

## Configuración

Las variables se pasan en tiempo de compilación con `--dart-define`; no se versionan secretos.

| Variable | Obligatoria | Ejemplo | Descripción |
|---|---|---|---|
| `API_BASE_URL` | No | `http://localhost:8080/api/v1` | URL base de la API (incluye `/api/v1`). Por defecto, la de desarrollo local. |
| `GOOGLE_CLIENT_ID` | Para login con Google | `xxxx.apps.googleusercontent.com` | Client ID público de OAuth2. |
| `GOOGLE_REDIRECT_URI` | Para login con Google | `http://localhost:3000/auth.html` | Página de retorno del flujo OAuth: siempre `<origen del frontend>/auth.html`. Debe estar registrada en Google Cloud Console y en `GOOGLE_ALLOWED_REDIRECT_URIS` del backend. Por defecto `http://localhost:3000/auth.html`. |
| `DEV_LOGIN` | No | `true` | Muestra el botón *Dev login*, que usa `POST /auth/dev-login` (solo existe con el perfil `local` del backend). Por defecto `false`. |

## Ejecución local

```bash
flutter pub get
flutter run -d chrome --web-port=3000 \
  --dart-define=API_BASE_URL=http://localhost:8080/api/v1 \
  --dart-define=DEV_LOGIN=true
```

Sin Chrome instalado se puede usar el servidor web de Flutter:

```bash
flutter run -d web-server --web-port=3000 \
  --dart-define=API_BASE_URL=http://localhost:8080/api/v1 \
  --dart-define=DEV_LOGIN=true
```

Se usa el puerto `3000` porque es el origen que el backend permite por defecto en CORS.

> El origen del frontend (por ejemplo `http://localhost:3000`) debe estar en `CORS_ALLOWED_ORIGINS`
> del backend: el cliente envía las cookies (`withCredentials`) para que la cookie `httpOnly` del
> *refresh token* llegue a `/auth/refresh` y `/auth/logout`.

### Configurar Google Cloud Console

1. En [Google Cloud Console](https://console.cloud.google.com) → *APIs & Services* → *Credentials*,
   crear un *OAuth client ID* de tipo **Web application**.
2. *Authorized JavaScript origins*: `http://localhost:3000` y el dominio de producción.
3. *Authorized redirect URIs*: `http://localhost:3000/auth.html` y
   `https://<dominio de producción>/auth.html` (el valor exacto de `GOOGLE_REDIRECT_URI`).
4. Pasar el *Client ID* al frontend con `--dart-define=GOOGLE_CLIENT_ID=...`. El *Client secret*
   solo lo usa el backend (`GOOGLE_CLIENT_SECRET`), que hace el intercambio del código.
5. Agregar las mismas URIs de retorno a `GOOGLE_ALLOWED_REDIRECT_URIS` del backend.

Sin `GOOGLE_CLIENT_ID` el botón *Sign in with Google* queda deshabilitado; para desarrollo local
basta `--dart-define=DEV_LOGIN=true` con el backend en el perfil `local`.

## Build de producción

```bash
flutter build web --release \
  --dart-define=API_BASE_URL=https://<backend>.onrender.com/api/v1 \
  --dart-define=GOOGLE_CLIENT_ID=xxxx.apps.googleusercontent.com \
  --dart-define=GOOGLE_REDIRECT_URI=https://<frontend>/auth.html
```

El resultado queda en `build/web` y se puede servir desde cualquier hosting estático con
*fallback* a `index.html` (rutas SPA).

## Docker

Imagen *multi-stage*: compila con Flutter 3.24.5 (`ghcr.io/cirruslabs/flutter:3.24.5`) y sirve
`build/web` con `nginx:1.27-alpine`. Las variables de compilación se pasan como `--build-arg`:

```bash
docker build -t pennypincher-frontend \
  --build-arg API_BASE_URL=http://localhost:8080/api/v1 \
  --build-arg API_ORIGIN=http://localhost:8080 \
  --build-arg GOOGLE_CLIENT_ID=xxxx.apps.googleusercontent.com \
  --build-arg GOOGLE_REDIRECT_URI=http://localhost:3000/auth.html \
  --build-arg DEV_LOGIN=true .

docker run --rm -p 3000:80 pennypincher-frontend
# http://localhost:3000
```

| Parámetro | Tipo | Descripción |
|---|---|---|
| `API_BASE_URL`, `GOOGLE_CLIENT_ID`, `GOOGLE_REDIRECT_URI`, `DEV_LOGIN` | build arg | Se convierten en `--dart-define` (ver *Configuración*). |
| `FLUTTER_IMAGE` | build arg | Imagen de compilación (por defecto `ghcr.io/cirruslabs/flutter:3.24.5`; cualquier imagen con Flutter 3.24.5 sirve, p. ej. `instrumentisto/flutter:3.24.5`). |
| `API_ORIGIN` | build arg y env | Origen del backend permitido en `connect-src` de la *Content-Security-Policy* (por defecto `http://localhost:8080`). Debe ser el `scheme://host[:puerto]` de `API_BASE_URL`: si cambias uno, cambia el otro. Se fija al construir y se puede sobrescribir al arrancar con `-e API_ORIGIN=...`. |

`nginx.conf` es una plantilla que la imagen oficial de nginx procesa al arrancar. Incluye:

- *Fallback* SPA: cualquier ruta sin archivo devuelve `index.html` (deep links de go_router).
- Caché: `index.html`, el código de la app y `assets/` (manifiestos de assets y fuentes,
  `NOTICES`, fuentes) se revalidan siempre (`no-cache` + ETag), porque Flutter no pone hash en
  los nombres; `canvaskit/` e `icons/` se cachean 1 día.
- Cabeceras de seguridad: CSP, `X-Frame-Options: DENY`, `X-Content-Type-Options`,
  `Referrer-Policy`, `Permissions-Policy` y `Cross-Origin-Opener-Policy`
  (`same-origin-allow-popups`, compatible con la ventana emergente del login de Google).
  HSTS se configura en el proxy o CDN que termina TLS. `connect-src` también permite
  `fonts.gstatic.com` (fuentes de respaldo de CanvasKit) y `*.googleusercontent.com` (fotos de
  perfil de Google cargadas con `Image.network`). La página de retorno del login con Google
  (`auth.html`) no necesita cambios en la CSP: su lógica está en el script externo
  `auth_callback.js` (permitido por `script-src 'self'`) y su estilo en `auth.css`. La pestaña de
  Google se abre con `noopener`, así que `auth.html` entrega la URL de retorno por `localStorage`
  (clave `flutter-web-auth-2`), que la app lee y borra en menos de un segundo (y que además borra al arrancar y antes de cada
  inicio de sesión, por si quedó de un intento abandonado); nunca se guardan
  tokens: el código no sirve sin el `code_verifier`, que solo vive en memoria.
- `GET /healthz` para *health checks* (usado por el `HEALTHCHECK` de la imagen).

El bundle se compila con `--no-web-resources-cdn`, así CanvasKit se sirve desde la propia imagen.

## Estructura

Arquitectura limpia por *feature*:

```
lib/
├── core/
│   ├── auth/        # TokenService (access token solo en memoria) y SessionRefresher
│   ├── config/      # AppConfig (lee los --dart-define)
│   ├── constants/   # AppConstants, EnvKeys, EnvDefaults
│   ├── di/          # get_it + injectable (injection.dart y su .config.dart generado)
│   ├── error/       # Failure (sealed) y AppException
│   ├── layout/      # AppShell responsive (barra inferior / rail / rail expandido)
│   ├── network/     # Clientes dio (con y sin AuthInterceptor), sobre de la API
│   ├── router/      # AppRoute, AppDestination, AppRouter (go_router) y AuthGuard
│   ├── theme/       # AppColors, AppTypography, AppSpacing, AppBreakpoints, AppTheme
│   └── widgets/     # Widgets reutilizables (placeholder, mensajes de estado)
├── features/
│   └── <feature>/{data,domain,presentation}
├── app.dart
└── main.dart
```

Breakpoints: móvil `< 600 px` (barra de navegación inferior), tablet `600–1023 px` (rail
colapsado) y escritorio `>= 1024 px` (rail expandido con etiquetas); el contenido se limita a
`1280 px` de ancho.

Las fuentes **Inter** y **Roboto Mono** (licencia OFL) van empaquetadas en `assets/fonts`, así
la app no descarga fuentes en tiempo de ejecución.

## Código generado

Los archivos generados por `build_runner` (`*.config.dart`, `*.g.dart`, `*.freezed.dart`)
**se versionan**: CI y Docker compilan sin ejecutar el generador. Después de cambiar una clase
anotada (`@injectable`, `@freezed`, `@JsonSerializable`) hay que regenerarlos y commitearlos:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Calidad

```bash
dart format --set-exit-if-changed .
flutter analyze --fatal-infos
flutter test
flutter build web --release
```

## Integración continua

`.github/workflows/ci.yml` corre en cada *push* a `master` y en cada *pull request*, con
Flutter 3.24.5 fijado:

1. `flutter pub get --enforce-lockfile`
2. `dart format --set-exit-if-changed .`
3. `build_runner` + `git status --porcelain` vacío en `lib` y `test` (el código generado
   versionado debe estar al día, sin archivos modificados ni nuevos)
4. `flutter analyze --fatal-infos`
5. `flutter test --coverage` (sube `coverage/lcov.info` como artefacto)
6. `flutter build web --release`
7. Job `docker`: construye la imagen y hace un *smoke test* contra `/healthz`, `/` y un deep link.

## Estado

En construcción: base del proyecto (EPIC-001) y autenticación con Google, protección de rutas y
restauración de sesión (EPIC-002).
