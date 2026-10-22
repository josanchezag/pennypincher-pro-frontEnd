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

1. El usuario inicia sesión con **Google OAuth2** (authorization code + PKCE, vía `flutter_web_auth_2`).
2. El frontend envía el `code` y el `codeVerifier` al backend (`POST /api/v1/auth/google/callback`).
3. El backend valida la identidad con Google y emite **sus propios tokens**:
   - *Access token* JWT RS256 de 15 minutos, que el frontend guarda **solo en memoria** y envía
     como `Authorization: Bearer <token>`.
   - *Refresh token* opaco y rotativo, enviado como cookie `httpOnly; Secure; SameSite=Strict`
     (el frontend nunca lo lee).
4. Cuando la API responde `401`, el cliente llama a `POST /api/v1/auth/refresh` y reintenta una vez.

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
> del backend. Para el login con Google, en el cliente OAuth de Google Cloud Console hay que
> registrar ese origen en *Authorized JavaScript origins* y la página de retorno del flujo PKCE
> (por ejemplo `http://localhost:3000/auth.html`) en *Authorized redirect URIs*, igual para el
> dominio de producción. Esa página de retorno se agrega junto con el login (EPIC-002).

## Build de producción

```bash
flutter build web --release \
  --dart-define=API_BASE_URL=https://<backend>.onrender.com/api/v1 \
  --dart-define=GOOGLE_CLIENT_ID=xxxx.apps.googleusercontent.com
```

El resultado queda en `build/web` y se puede servir desde cualquier hosting estático con
*fallback* a `index.html` (rutas SPA).

## Estructura

Arquitectura limpia por *feature*:

```
lib/
├── core/
│   ├── config/      # AppConfig (lee los --dart-define)
│   ├── constants/   # AppConstants, EnvKeys, EnvDefaults
│   ├── di/          # get_it + injectable (injection.dart y su .config.dart generado)
│   ├── error/       # Failure (sealed) y AppException
│   ├── layout/      # AppShell responsive (barra inferior / rail / rail expandido)
│   ├── network/     # Cliente dio
│   ├── router/      # AppRoute, AppDestination y AppRouter (go_router)
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

## Estado

En construcción: base del proyecto (EPIC-001).
