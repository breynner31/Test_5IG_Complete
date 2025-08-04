# Tarea 3: Frontend Development - React App

## Descripción

Aplicación web frontend desarrollada en React que consume la API JSONPlaceholder para mostrar, filtrar y crear posts. La aplicación cumple con todos los requisitos especificados en la prueba técnica.

## Requisitos Cumplidos

### 1. Fetch y Display de Datos
-  Obtiene posts desde JSONPlaceholder API
-  Muestra datos en formato de tarjetas atractivas
-  Manejo de estados de carga y error

### 2. Búsqueda y Filtrado
-  Búsqueda por título y contenido
-  Filtrado por usuario
-  Filtros en tiempo real
-  Estadísticas dinámicas

### 3. Interfaz Visual Atractiva
-  Diseño moderno y responsive
-  Gradientes y efectos hover
-  Tipografía profesional (Inter)
-  Paleta de colores coherente

### 4. Funcionalidades Adicionales
-  Crear nuevos posts
-  **Persistencia local con localStorage**
-  Estadísticas en tiempo real
-  Animaciones de carga
-  Manejo de errores

## Tecnologías Utilizadas

- **React 18.2.0** - Framework principal
- **Axios** - Cliente HTTP para APIs
- **CSS3** - Estilos modernos y responsive
- **localStorage** - Persistencia de datos local
- **JSONPlaceholder API** - API de datos

## Instalación y Ejecución

### Prerrequisitos
```bash
# Node.js 16+ y npm
node --version
npm --version
```

### Instalación
```bash
cd Tarea3_Frontend
npm install
```

### Ejecución en Desarrollo
```bash
npm start
```
La aplicación se abrirá en `http://localhost:3000`

### Build para Producción
```bash
npm run build
```

### Deploy a GitHub Pages
```bash
npm run deploy
```

## Características Técnicas

### Arquitectura React
- **Functional Components** - Componentes modernos con hooks
- **State Management** - useState para estado local
- **Effect Hooks** - useEffect para efectos secundarios
- **Custom Components** - Componentes reutilizables



### API Integration
- **GET /posts** - Obtener lista de posts
- **POST /posts** - Crear nuevo post
- **Error Handling** - Manejo robusto de errores
- **Loading States** - Estados de carga



## Funcionalidades Implementadas

### 1. Dashboard Principal
- Header con título y descripción
- Formulario para crear posts
- Panel de estadísticas
- Filtros de búsqueda

### 2. Gestión de Posts
- **Visualización**: Tarjetas con diseño moderno
- **Creación**: Formulario con validación
- **Persistencia**: localStorage para mantener datos
- **Filtrado**: Por texto y usuario
- **Estadísticas**: Contadores en tiempo real

### 3. Experiencia de Usuario
- **Responsive Design**: Adaptable a móviles
- **Loading States**: Indicadores de carga
- **Error Handling**: Mensajes informativos
- **Animaciones**: Transiciones suaves
- **Persistencia**: Los posts creados se mantienen al recargar

### 4. Componentes Principales

#### CreatePostForm
- Formulario para crear nuevos posts
- Validación de campos
- Estado de creación
- Guardado automático en localStorage

#### Statistics
- Contador de posts totales
- Contador de posts filtrados
- Contador de usuarios únicos
- Contador de posts guardados localmente
- Botón para limpiar localStorage

#### PostCard
- Tarjeta individual para cada post
- Información del usuario
- Contador de caracteres
- Efectos hover

## Diseño y UX

### Paleta de Colores
- **Primary**: #3b82f6 (Azul)
- **Secondary**: #6b7280 (Gris)
- **Success**: #16a34a (Verde)
- **Error**: #dc2626 (Rojo)
- **Background**: #f8fafc (Gris claro)

### Tipografía
- **Font Family**: Inter (Google Fonts)
- **Weights**: 300, 400, 500, 600, 700
- **Responsive**: Escalado automático

### Layout
- **Grid System**: CSS Grid para posts
- **Flexbox**: Para alineaciones
- **Responsive**: Breakpoints en 768px y 480px

## Casos de Uso

### Para Usuarios
- **Explorar Posts**: Ver todos los posts disponibles
- **Buscar Contenido**: Filtrar por palabras clave
- **Filtrar por Usuario**: Ver posts de usuarios específicos
- **Crear Posts**: Agregar nuevo contenido (se mantiene al recargar)
- **Gestionar Datos**: Limpiar posts guardados localmente

### Para Desarrolladores
- **Código Limpio**: Arquitectura React moderna
- **Componentes Reutilizables**: Fácil mantenimiento
- **Estado Predictible**: Manejo claro del estado
- **Performance**: Optimizaciones incluidas
- **Persistencia**: localStorage para datos locales


### Demostración
```bash
# Ejecutar aplicación
npm start

# Mostrar funcionalidades:
# - Carga de posts desde API
# - Búsqueda en tiempo real
# - Filtrado por usuario
# - Creación de nuevos posts
# - Persistencia con localStorage
# - Diseño responsive
```

## Deployment

### GitHub Pages
La aplicación está configurada para deploy automático en GitHub Pages:

```bash
npm run deploy
```

### URL del Demo
`https://breynnersierra.github.io/library-management-app`

