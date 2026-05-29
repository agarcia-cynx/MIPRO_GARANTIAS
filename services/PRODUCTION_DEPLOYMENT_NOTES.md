# Notas para Despliegue en Producción

Este archivo contiene configuraciones y cambios necesarios antes de realizar el despliegue a entornos de producción para mejorar la seguridad, el rendimiento y seguir las mejores prácticas.

## Pendientes para Producción

### 1. `services/chz-exp-pro-gc/src/config/env.js`
- **Cambio requerido:** Modificar la lógica de `loadEnv` para que en entornos de producción (`NODE_ENV === 'production'`) no realice operaciones de sistema de archivos (`fs.existsSync`, `fs.readFileSync`).
- **Razón:** En producción, las variables de entorno deben ser inyectadas directamente por la plataforma (Cloud Run, Kubernetes, etc.) en `process.env`. Intentar buscar archivos YAML es innecesario, genera logs de advertencia (`warn`) y es una operación de I/O superflua.
- **Acción:** Implementar una guarda al inicio de la función `loadEnv`.

```javascript
const loadEnv = () => {
  if (process.env.NODE_ENV === 'production') {
    return;
  }
  // ... resto de la lógica ...
};
```

### 4. Cambio de Nomenclatura (`numero_seria` -> `numero_serie`)
- **Cambio crítico:** Se ha corregido el nombre del campo `numero_seria` a `numero_serie` en el backend `chz-prc-pro-gc` (tanto en la lógica `Mock` como en la llamada al Stored Procedure `SKMI.Garantia`).
- **Acción:** Es necesario actualizar el frontend (Aplicación Móvil) y cualquier otra capa que invoque al endpoint `POST /garantias` para que envíen el parámetro como `numero_serie` en lugar de `numero_seria`.
- **Razón:** Corrección de error de tipografía para mantener la coherencia con el modelo de datos real en Oracle.
