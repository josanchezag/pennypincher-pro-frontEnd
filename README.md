# PennyPincher Pro · Frontend

Aplicación web **responsive** en **Flutter** para gestionar las finanzas personales del hogar, reemplazando la hoja de cálculo de presupuesto mensual.

> Backend: [pennypincher-pro-backend](https://github.com/josanchezag/pennypincher-pro-backend)

## Módulos

| Módulo | Descripción |
|---|---|
| **Fortuna neta** | Activos − Pasivos, histórico mensual y avance hacia la meta. |
| **Presupuesto mensual** | Ingresos y gastos por categoría, % real vs. % ideal, flujo de caja. |
| **Detalles** | Tarjetas de crédito, préstamos, gastos fijos, variables y ahorros. |
| **Metas financieras** | Seguridad, Independencia, Libertad y Libertad Absoluta, con rentabilidad esperada. |

## Stack

- Flutter (target principal: **Web**, diseño responsive móvil / tablet / escritorio)
- Autenticación: **Google OAuth2** (el token se envía al backend como `Bearer`)
- Consumo de API REST del backend Kotlin

## Requisitos

- Flutter SDK (canal stable)
- Un *OAuth Client ID* de Google de tipo **Web application**

## Configuración

Las variables se pasan en tiempo de compilación con `--dart-define` (no se versionan secretos):

| Variable | Ejemplo |
|---|---|
| `API_BASE_URL` | `http://localhost:8080` |
| `GOOGLE_CLIENT_ID` | `xxxx.apps.googleusercontent.com` |

```bash
flutter pub get
flutter run -d chrome \
  --dart-define=API_BASE_URL=http://localhost:8080 \
  --dart-define=GOOGLE_CLIENT_ID=xxxx.apps.googleusercontent.com
```

> En Google Cloud Console agrega como *Authorized JavaScript origins* tanto `http://localhost:<puerto>` como el dominio de producción.

## Build de producción

```bash
flutter build web --release \
  --dart-define=API_BASE_URL=https://<backend>.onrender.com \
  --dart-define=GOOGLE_CLIENT_ID=xxxx.apps.googleusercontent.com
```

## Despliegue (gratuito)

- **Cloudflare Pages** o **GitHub Pages** sirviendo `build/web`.
- El dominio final debe estar en la lista de orígenes permitidos (**CORS**) del backend y en los orígenes autorizados del cliente OAuth de Google.

## Estado

🚧 En construcción.
