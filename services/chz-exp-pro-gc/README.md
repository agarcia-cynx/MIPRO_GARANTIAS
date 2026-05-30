# chz-exp-mipro-api

Experience Layer API diseñada para el ecosistema MiPro, optimizada para ejecutarse en **Google Cloud Run**.


## 📂 Estructura de Directorios

- **`src/routes/index.js`**: Definición centralizada de todos los endpoints de la API.
- **`src/controllers/`**: Manejo de la lógica de petición/respuesta y validación de entrada.
- **`src/services/`**: Lógica de orquestación o llamadas a otras APIs (Process/System layers).
- **`src/models/`**: Definición de esquemas de datos o interfaces.
- **`src/middlewares/`**: Funciones intermedias (Seguridad, Manejo de Errores Global, Auth).
- **`src/config/`**: Configuraciones centralizadas (Logger, Variables de Entorno).
- **`src/utils/`**: Funciones de utilidad transversales y reutilizables.
- **`src/app.js`**: Configuración de Express y middlewares base.
- **`src/server.js`**: Punto de entrada principal con gestión de cierre gracioso (Graceful Shutdown).

## 🚀 Comandos de Desarrollo

### Local
1. Instalar dependencias:
   ```bash
   npm install
   ```
2. Ejecutar en modo desarrollo (usa `env.dev.yaml`):
   ```bash
   npm run dev
   ```

## ☁️ Comandos de Despliegue (Google Cloud Run)

### Requisitos Previos
Asegúrate de tener configurado el archivo `env.prod.yaml` con las variables de producción.

### Despliegue a Desarrollo (Staging)
```bash
gcloud run deploy chz-exp-mipro-api-dev \
  --source . \
  --region us-east1 \
  --project chz-cynx-space-ia \
  --env-vars-file env.dev.yaml \
  --allow-unauthenticated
```

### Despliegue a Producción
```bash
gcloud run deploy chz-exp-mipro-api \
  --source . \
  --region us-east1 \
  --project chz-cynx-space-ia \
  --env-vars-file env.prod.yaml \
  --allow-unauthenticated
```

## ⚙️ Variables de Entorno (YAML)

El proyecto utiliza archivos YAML para gestionar configuraciones por entorno:
- `env.dev.yaml`: Configuración para desarrollo local y staging.
- `env.prod.yaml`: Configuración para producción.

*Nota: Estos archivos están excluidos del control de versiones por seguridad.*

## 🛠️ Estándares Técnicos
- **Logs**: Formato JSON estructurado para Google Cloud Logging.
- **Seguridad**: Implementación de Helmet y CORS.
- **Manejo de Errores**: Middleware global centralizado.
- **Shutdown**: Gestión de señales `SIGTERM` para evitar pérdida de peticiones en Cloud Run.
