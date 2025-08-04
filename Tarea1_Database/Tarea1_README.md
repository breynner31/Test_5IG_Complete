# Tarea 1: Sistema de Gestión de Biblioteca
## Universidad de los Andes - 5IG Solutions

###  Descripción del Proyecto

Este proyecto implementa el diseño de base de datos para un sistema de gestión de biblioteca desarrollado por 5IG Solutions para la Universidad de los Andes. El sistema permite gestionar libros, estudiantes, préstamos y organización por estantes.

###  Funcionalidades Implementadas

✅ **Lista completa de libros** (disponibles y prestados)  
✅ **Seguimiento de préstamos** por estudiante  
✅ **Gestión de información de préstamos** (fechas de préstamo, devolución estimada y real)  
✅ **Organización por estantes** con características específicas  
✅ **Escalabilidad** para nuevas categorías y libros digitales  

###  Estructura de la Base de Datos

#### Entidades Principales:
- **student**: Información de estudiantes
- **book**: Catálogo de libros
- **shelf**: Estantes con características específicas
- **loan**: Registro de préstamos
- **category**: Categorías para escalabilidad
- **book_category**: Relación muchos a muchos entre libros y categorías


```

###  Instalación y Configuración

#### Prerrequisitos:
- MySQL 8.0+ 
- Cliente MySQL (mysql-client)

#### Pasos de Instalación:

1. **Clonar o descargar los archivos del proyecto**

2. **Crear la base de datos:**
   ```powershell
   mysql -u root -p 
   source library_management_system.sql
   ```

###  Consultas Principales

#### 1. Lista Completa de Libros
```sql
SELECT 
    b.title, b.author, b.status,
    s.location AS shelf_location,
    GROUP_CONCAT(c.name SEPARATOR ', ') AS categories
FROM Book b
LEFT JOIN Shelf s ON b.shelf_id = s.shelf_id
LEFT JOIN BookCategory bc ON b.book_id = bc.book_id
LEFT JOIN Category c ON bc.category_id = c.category_id
GROUP BY b.book_id
ORDER BY b.title;
```

#### 2. Préstamos Activos por Estudiante
```sql
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    b.title AS book_title,
    l.loan_date,
    l.estimated_return_date
FROM Loan l
JOIN Book b ON l.book_id = b.book_id
JOIN Student s ON l.student_id = s.student_id
WHERE l.status = 'activo'
ORDER BY l.estimated_return_date;
```

#### 3. Información de Estantes
```sql
SELECT 
    s.location,
    s.main_topic,
    s.current_books,
    s.total_capacity,
    ROUND((s.current_books / s.total_capacity) * 100, 2) AS occupancy_percentage
FROM Shelf s
ORDER BY s.location;
```

###  Características Técnicas

#### Triggers Automáticos:
- **Actualización de contadores** en estantes al agregar/eliminar libros
- **Cambio automático de estado** de libros al crear/devolver préstamos
- **Validación de integridad** de datos

#### Índices Optimizados:
- Búsqueda por ISBN, título, autor
- Filtrado por estado de libros y préstamos
- Consultas por ubicación de estantes

#### Restricciones de Integridad:
- Claves foráneas con CASCADE/RESTRICT apropiados
- Check constraints para validaciones de fechas
- Unique constraints en campos críticos

###  Escalabilidad

#### Para Nuevas Categorías:
- Sistema jerárquico de categorías
- Relación muchos a muchos entre libros y categorías
- Fácil agregado de nuevas categorías sin modificar estructura

#### Para Libros Digitales:
- Campo `book_type` que distingue entre físico y digital
- Estructura preparada para campos adicionales específicos

#### Para Expansión Futura:
- Campos de auditoría (created_at, updated_at)
- Soft deletes para mantener integridad
- Estructura modular para nuevas entidades

###  Datos de Prueba

El sistema incluye datos de ejemplo para demostrar todas las funcionalidades:

- **5 estantes** con diferentes temas y capacidades
- **5 categorías** principales
- **3 estudiantes** registrados
- **5 libros** de diferentes tipos
- **3 préstamos** activos y devueltos



###  Notas de Desarrollo

#### Decisiones de Diseño:
1. **Analizaar** los requerimientos. como cuales? que muestre una lista de libros incluyendo disponibilidad y los que estan ocupados o prestados si. y etc.... 
2. **Diseñar** un diagram ER (entidad relacional): Para poder llevar un buen orden y de como se tenia que relacionar las tablas.
3. **Implementacion** un script en sql. para asi poder mirar el funcionamiento de cada tabla.
4. **optimizacion** la funcion Triggers para asi poder reflejar los cambios que se este haciendo la consulta.

---

**Desarrollado por:** Breynner Jose Sierra Arias 
**Fecha:** 2025/08/03
**Versión:** 1.0