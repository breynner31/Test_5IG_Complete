# Test 5IG - Prueba Técnica Completa

## Descripción del Proyecto

Este repositorio contiene la solución completa para la prueba técnica de 5IG Solutions, desarrollada para la Universidad de los Andes. El proyecto está organizado en tres tareas independientes que demuestran competencias en diferentes áreas del desarrollo de software.


## Tareas Implementadas

### Tarea 1: Diseño de Base de Datos
- **Objetivo**: Diseño de modelo ER para sistema de gestión de biblioteca
- **Tecnologías**: MySQL, SQL, Diagrama ER
- **Estado**:  Completada
- **Archivos**: Ver carpeta `Tarea1_Database/`

### Tarea 2: APIs REST
- **Objetivo**: Script Python para interactuar con APIs REST
- **Tecnologías**: Python, Requests, JSONPlaceholder API
- **Estado**:  Completada
- **Archivos**: Ver carpeta `Tarea2_API_REST/`

### Tarea 3: Frontend
- **Objetivo**: Desarrollo de interfaz de usuario con React
- **Tecnologías**: React, Axios, CSS3, JSONPlaceholder API
- **Estado**:  Completada
- **Archivos**: Ver carpeta `Tarea3_Frontend/`

### Tarea 4: DevOps y CI/CD
- **Objetivo**: Pipeline de CI/CD para automatización de despliegue
- **Tecnologías**: GitHub Actions, Node.js, Bash Scripts
- **Estado**:  Completada
- **Archivos**: Ver carpeta `Tarea4_DevOps/`

## Instalación y Ejecución

### Prerrequisitos
- MySQL Server
- Python 3.7+
- Navegador web moderno

### Configuración por Tarea

#### Tarea 1 - Base de Datos
```bash
cd Tarea1_Database
mysql -u root -p  
source library_management_system.sql
```

#### Tarea 2 - API REST
```bash
cd Tarea2_API_REST
pip install -r requirements.txt
python Tarea2_API_REST.py
```

#### Tarea 3 - Frontend
```bash
cd Tarea3_Frontend
npm install
npm start
```

#### Tarea 4 - DevOps y CI/CD
```bash
# El pipeline se ejecuta automáticamente al hacer push
# Configuración: .github/workflows/deploy.yml (GitHub Actions)
# Documentación completa: Tarea4_DevOps/Tarea4_README.md
```



## Características Técnicas

### Base de Datos
- Modelo ER normalizado
- Triggers para automatización
- Índices para optimización
- Escalabilidad para futuras funcionalidades

### API REST
- Arquitectura orientada a objetos
- Manejo robusto de errores
- Sesiones HTTP optimizadas
- Documentación completa

### Frontend
- Componentes React funcionales
- Manejo de estado con hooks
- Diseño responsive y moderno
- Integración con APIs REST

### DevOps y CI/CD
- Pipeline automatizado con GitHub Actions
- Testing, building y deployment automático
- Scripts de automatización en Bash
- Despliegue continuo a GitHub Pages


---

*Proyecto desarrollado para 5IG Solutions - Universidad de los Andes* 