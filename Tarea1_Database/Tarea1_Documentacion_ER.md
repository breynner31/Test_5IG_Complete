# Tarea 1: Diseño de Base de Datos - Sistema de Gestión de Biblioteca
## Universidad de los Andes - 5IG Solutions

### 1. Análisis de Requerimientos

#### Funcionalidades Principales:
1. **Gestión de Libros**: Lista completa de libros (disponibles y prestados)
2. **Seguimiento de Préstamos**: Control de qué estudiante tiene qué libro
3. **Gestión de Préstamos**: Fechas de préstamo, devolución estimada y real
4. **Organización por Estantes**: Características de ubicación y capacidad

#### Requisitos de Escalabilidad:
- Soporte para nuevas categorías
- Gestión de libros digitales
- Flexibilidad para expansión futura

### 2. Modelo Entidad-Relación (ER)

#### Entidades Principales:

**1. ESTUDIANTE (student)**
- **Atributos**:
  - `student_id` (PK) - Identificador único del estudiante
  - `student_code` - Código de estudiante de la universidad
  - `first_name` - Nombre
  - `last_name` - Apellido
  - `email` - Correo electrónico
  - `phone` - Teléfono
  - `registration_date` - Fecha de registro
  - `active_status` - Estado activo/inactivo

**2. LIBRO (book)**
- **Atributos**:
  - `book_id` (PK) - Identificador único del libro
  - `isbn` - Número ISBN
  - `title` - Título del libro
  - `author` - Autor
  - `publisher` - Editorial
  - `publication_year` - Año de publicación
  - `edition` - Edición
  - `pages` - Número de páginas
  - `language` - Idioma
  - `book_type` - Tipo (físico/digital)
  - `status` - Estado (disponible/prestado/perdido)
  - `shelf_id` (FK) - Referencia al estante

**3. ESTANTE (shelf)**
- **Atributos**:
  - `shelf_id` (PK) - Identificador único del estante
  - `location` - Ubicación (Sección A, B, C, etc.)
  - `main_topic` - Tema principal (Economía, Ciencia, Política, etc.)
  - `material` - Material del estante
  - `total_capacity` - Capacidad total de libros
  - `current_books` - Número actual de libros
  - `created_date` - Fecha de creación

**4. PRÉSTAMO (loan)**
- **Atributos**:
  - `loan_id` (PK) - Identificador único del préstamo
  - `student_id` (FK) - Referencia al estudiante
  - `book_id` (FK) - Referencia al libro
  - `loan_date` - Fecha de préstamo
  - `estimated_return_date` - Fecha estimada de devolución
  - `actual_return_date` - Fecha real de devolución
  - `status` - Estado del préstamo (activo/devuelto/vencido)
  - `notes` - Notas adicionales

**5. CATEGORÍA (category)** - Para escalabilidad futura
- **Atributos**:
  - `category_id` (PK) - Identificador único de categoría
  - `name` - Nombre de la categoría
  - `description` - Descripción
  - `parent_category_id` (FK) - Categoría padre (para jerarquías)

**6. LIBRO_CATEGORÍA (book_category)** - Tabla de relación muchos a muchos
- **Atributos**:
  - `book_id` (FK) - Referencia al libro
  - `category_id` (FK) - Referencia a la categoría

### 3. Relaciones

1. **ESTUDIANTE → PRÉSTAMO**: 1:N (Un estudiante puede tener múltiples préstamos)
2. **LIBRO → PRÉSTAMO**: 1:N (Un libro puede ser prestado múltiples veces)
3. **ESTANTE → LIBRO**: 1:N (Un estante puede contener múltiples libros)
4. **LIBRO ↔ CATEGORÍA**: N:M (Un libro puede tener múltiples categorías y viceversa)

### 4. Consideraciones de Escalabilidad

#### Para Nuevas Categorías:
- Tabla CATEGORÍA con estructura jerárquica
- Tabla de relación LIBRO_CATEGORÍA para múltiples categorías por libro

#### Para Libros Digitales:
- Campo `book_type` en tabla LIBRO
- Posibilidad de agregar campos específicos para digitales (URL, formato, etc.)

#### Para Expansión Futura:
- Estructura modular que permite agregar nuevas entidades
- Campos de auditoría (created_at, updated_at)
- Soft deletes para mantener integridad referencial

### 5. Índices Recomendados

- `student_code` en ESTUDIANTE
- `isbn` en LIBRO
- `title` en LIBRO
- `loan_date` en PRÉSTAMO
- `status` en LIBRO y PRÉSTAMO
- `location` en ESTANTE

### 6. Restricciones de Integridad

- Claves primarias únicas
- Claves foráneas con CASCADE/RESTRICT según el caso
- Check constraints para validaciones de fechas
- Unique constraints donde sea necesario 