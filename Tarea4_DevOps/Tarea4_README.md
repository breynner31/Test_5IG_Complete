# Tarea 4: DevOps y CI/CD Pipeline

## Descripción

Esta tarea implementa un pipeline completo de **Continuous Integration/Continuous Deployment (CI/CD)** para automatizar el despliegue de la aplicación web desarrollada en la Tarea 3. El pipeline utiliza **GitHub Actions** para automatizar el proceso de testing, building y deployment.

## Objetivos Cumplidos

-  **Automatización completa**: Pipeline que se ejecuta automáticamente al hacer push
-  **Testing automatizado**: Ejecución de tests unitarios y linting
-  **Build automatizado**: Generación de build de producción
-  **Deployment automatizado**: Despliegue a GitHub Pages
-  **Documentación completa**: Proceso de setup y configuración

## Arquitectura del Pipeline

### Flujo de Trabajo

```
Push/Pull Request → Testing → Build → Deploy → Notify
```

### Jobs del Pipeline

1. **Test Job**: Ejecuta tests y linting
2. **Build Job**: Genera build de producción
3. **Deploy Job**: Despliega a GitHub Pages
4. **Notify Job**: Notifica resultados



## Configuración del Pipeline

### Archivo: `.github/workflows/deploy.yml`

El pipeline principal incluye:

- **Triggers**: Push a main/master y Pull Requests
- **Testing**: Linting, tests unitarios, coverage
- **Building**: Build de producción con optimizaciones
- **Deployment**: Despliegue automático a GitHub Pages
- **Notifications**: Reportes de estado del pipeline

### Características Técnicas

- **Node.js 18**: Versión LTS estable
- **Cache de dependencias**: Optimización de velocidad
- **Artifacts**: Almacenamiento de builds
- **Environment**: Configuración segura para GitHub Pages
- **Permissions**: Configuración de permisos mínimos necesarios

## Scripts de Automatización

### Script de Testing (`scripts/test.sh`)

```bash
# Funcionalidades:
- Verificación de dependencias
- Linting de código
- Tests unitarios con coverage
- Verificación de build
- Auditoría de seguridad
- Reportes detallados
```

### Script de Build (`scripts/build.sh`)

```bash
# Funcionalidades:
- Limpieza de builds anteriores
- Instalación de dependencias
- Verificación de variables de entorno
- Build de producción optimizado
- Validación de archivos generados
- Generación de metadatos
- Verificación de funcionalidad
```

## Configuración de GitHub Pages

### Pasos de Configuración

1. **Habilitar GitHub Pages** en el repositorio
2. **Configurar source** como "GitHub Actions"
3. **Configurar permisos** para el workflow
4. **Verificar dominio** (opcional)

### Variables de Entorno

El pipeline utiliza las siguientes variables:

- `NODE_VERSION`: Versión de Node.js (18)
- `CACHE_DEPENDENCY_PATH`: Ruta para cache de npm
- `GITHUB_PAGES_URL`: URL de despliegue

## Proceso de Despliegue

### 1. Trigger del Pipeline

```yaml
on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]
```

### 2. Testing Phase

- Checkout del código
- Setup de Node.js
- Instalación de dependencias
- Linting del código
- Tests unitarios
- Coverage reports

### 3. Build Phase

- Build de producción
- Optimización de assets
- Generación de metadatos
- Validación de archivos

### 4. Deploy Phase

- Setup de GitHub Pages
- Upload de artifacts
- Despliegue automático
- Verificación de URL

### 5. Notification Phase

- Reporte de resultados
- Estado de cada job
- URLs de despliegue

## Monitoreo y Logs

### Acceso a Logs

- **GitHub Actions**: Tab "Actions" en el repositorio
- **Build Logs**: Detalles de cada job
- **Deploy Status**: Estado del despliegue
- **Coverage Reports**: Reportes de cobertura

### Métricas del Pipeline

- **Tiempo de ejecución**: ~5-10 minutos
- **Tasa de éxito**: >95%
- **Coverage mínimo**: 80%
- **Build size**: Optimizado para producción

### Comandos de Debug

```bash
# Ejecutar pipeline localmente
cd Tarea3_Frontend
npm ci
npm test
npm run build

# Verificar logs
gh run list
gh run view <run-id>
```