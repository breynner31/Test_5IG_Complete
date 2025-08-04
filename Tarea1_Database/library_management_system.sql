-- =====================================================
-- SISTEMA DE GESTIÓN DE BIBLIOTECA - UNIVERSIDAD DE LOS ANDES
-- 5IG Solutions
-- Script de creación de base de datos
-- =====================================================

-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS library_management_system 
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE library_management_system;

-- Configurar codificación para la sesión
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- =====================================================
-- TABLA: ESTUDIANTE (student)
-- =====================================================
CREATE TABLE student (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_code VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    registration_date DATE NOT NULL,
    active_status BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_student_code (student_code),
    INDEX idx_email (email),
    INDEX idx_active_status (active_status)
);

-- =====================================================
-- TABLA: ESTANTE (shelf)
-- =====================================================
CREATE TABLE shelf (
    shelf_id INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(20) NOT NULL, -- Sección A, B, C, etc.
    main_topic VARCHAR(100) NOT NULL, -- Economía, Ciencia, Política, etc.
    material VARCHAR(50) NOT NULL, -- Madera, Metal, etc.
    total_capacity INT NOT NULL,
    current_books INT NOT NULL DEFAULT 0,
    created_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    

    
    INDEX idx_location (location),
    INDEX idx_main_topic (main_topic)
);

-- =====================================================
-- TABLA: LIBRO (book)
-- =====================================================
CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100) NOT NULL,
    publisher VARCHAR(100),
    publication_year INT,
    edition VARCHAR(20),
    pages INT,
    language VARCHAR(30) DEFAULT 'Espanol',
    book_type ENUM('fisico', 'digital') DEFAULT 'fisico',
    status ENUM('disponible', 'prestado', 'perdido', 'mantenimiento') DEFAULT 'disponible',
    shelf_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (shelf_id) REFERENCES shelf(shelf_id) ON DELETE SET NULL,
    

    
    INDEX idx_isbn (isbn),
    INDEX idx_title (title),
    INDEX idx_author (author),
    INDEX idx_status (status),
    INDEX idx_book_type (book_type)
);

-- =====================================================
-- TABLA: PRÉSTAMO (loan)
-- =====================================================
CREATE TABLE loan (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    book_id INT NOT NULL,
    loan_date DATE NOT NULL,
    estimated_return_date DATE NOT NULL,
    actual_return_date DATE NULL,
    status ENUM('activo', 'devuelto', 'vencido') DEFAULT 'activo',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE RESTRICT,
    FOREIGN KEY (book_id) REFERENCES book(book_id) ON DELETE RESTRICT,
    

    
    INDEX idx_student_id (student_id),
    INDEX idx_book_id (book_id),
    INDEX idx_loan_date (loan_date),
    INDEX idx_status (status),
    INDEX idx_estimated_return_date (estimated_return_date)
);

-- =====================================================
-- TABLA: CATEGORÍA (category) - Para escalabilidad
-- =====================================================
CREATE TABLE category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_category_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (parent_category_id) REFERENCES category(category_id) ON DELETE CASCADE,
    
    INDEX idx_name (name),
    INDEX idx_parent_category_id (parent_category_id)
);

-- =====================================================
-- TABLA: LIBRO_CATEGORÍA (book_category) - Relación N:M
-- =====================================================
CREATE TABLE book_category (
    book_id INT NOT NULL,
    category_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (book_id, category_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES category(category_id) ON DELETE CASCADE
);

-- =====================================================
-- TRIGGERS PARA MANTENER INTEGRIDAD
-- =====================================================

-- Trigger para actualizar current_books en shelf cuando se agrega un libro
DELIMITER //
CREATE TRIGGER after_book_insert
AFTER INSERT ON book
FOR EACH ROW
BEGIN
    IF NEW.shelf_id IS NOT NULL THEN
        UPDATE shelf 
        SET current_books = current_books + 1 
        WHERE shelf_id = NEW.shelf_id;
    END IF;
END//

-- Trigger para actualizar current_books en shelf cuando se elimina un libro
CREATE TRIGGER after_book_delete
AFTER DELETE ON book
FOR EACH ROW
BEGIN
    IF OLD.shelf_id IS NOT NULL THEN
        UPDATE shelf 
        SET current_books = current_books - 1 
        WHERE shelf_id = OLD.shelf_id;
    END IF;
END//

-- Trigger para actualizar current_books cuando se cambia el shelf_id de un libro
CREATE TRIGGER after_book_update
AFTER UPDATE ON book
FOR EACH ROW
BEGIN
    -- Si cambió el estante
    IF OLD.shelf_id != NEW.shelf_id THEN
        -- Decrementar en el estante anterior
        IF OLD.shelf_id IS NOT NULL THEN
            UPDATE shelf 
            SET current_books = current_books - 1 
            WHERE shelf_id = OLD.shelf_id;
        END IF;
        
        -- Incrementar en el nuevo estante
        IF NEW.shelf_id IS NOT NULL THEN
            UPDATE shelf 
            SET current_books = current_books + 1 
            WHERE shelf_id = NEW.shelf_id;
        END IF;
    END IF;
END//

-- Trigger para actualizar el status del libro cuando se crea un préstamo
CREATE TRIGGER after_loan_insert
AFTER INSERT ON loan
FOR EACH ROW
BEGIN
    UPDATE book 
    SET status = 'prestado' 
    WHERE book_id = NEW.book_id;
END//

-- Trigger para actualizar el status del libro cuando se devuelve
CREATE TRIGGER after_loan_update
AFTER UPDATE ON loan
FOR EACH ROW
BEGIN
    IF NEW.status = 'devuelto' AND OLD.status != 'devuelto' THEN
        UPDATE book 
        SET status = 'disponible' 
        WHERE book_id = NEW.book_id;
    END IF;
END//

DELIMITER ;

-- =====================================================
-- DATOS DE EJEMPLO
-- =====================================================

-- Insertar estantes de ejemplo
INSERT INTO shelf (location, main_topic, material, total_capacity, created_date) VALUES
('Seccion A', 'Economia', 'Madera', 50, '2024-01-01'),
('Seccion B', 'Ciencia', 'Metal', 75, '2024-01-01'),
('Seccion C', 'Politica', 'Madera', 40, '2024-01-01'),
('Seccion D', 'Literatura', 'Madera', 60, '2024-01-01'),
('Seccion E', 'Tecnologia', 'Metal', 80, '2024-01-01');

-- Insertar categorías de ejemplo
INSERT INTO category (name, description) VALUES
('Economia', 'Libros sobre economia y finanzas'),
('Ciencia', 'Libros de ciencias naturales'),
('Politica', 'Libros sobre politica y gobierno'),
('Literatura', 'Obras literarias y ficcion'),
('Tecnologia', 'Libros sobre tecnologia e informatica');

-- Insertar estudiantes de ejemplo
INSERT INTO student (student_code, first_name, last_name, email, phone, registration_date) VALUES
('2023001', 'Maria', 'Gonzalez', 'maria.gonzalez@estudiantes.uniandes.edu.co', '3001234567', '2024-01-01'),
('2023002', 'Carlos', 'Rodriguez', 'carlos.rodriguez@estudiantes.uniandes.edu.co', '3002345678', '2024-01-01'),
('2023003', 'Ana', 'Martinez', 'ana.martinez@estudiantes.uniandes.edu.co', '3003456789', '2024-01-01');

-- Insertar libros de ejemplo
INSERT INTO book (isbn, title, author, publisher, publication_year, pages, shelf_id) VALUES
('978-84-8181-227-5', 'Principios de Economia', 'Gregory Mankiw', 'McGraw-Hill', 2020, 800, 1),
('978-84-8181-228-2', 'Fisica para Ingenieros', 'Raymond Serway', 'Cengage Learning', 2019, 1200, 2),
('978-84-8181-229-9', 'Historia de la Politica', 'John Dunn', 'Cambridge University Press', 2021, 450, 3),
('978-84-8181-230-5', 'Cien Anos de Soledad', 'Gabriel Garcia Marquez', 'Editorial Sudamericana', 1967, 432, 4),
('978-84-8181-231-2', 'Clean Code', 'Robert C. Martin', 'Prentice Hall', 2008, 464, 5);

-- Asignar categorías a libros
INSERT INTO book_category (book_id, category_id) VALUES
(1, 1), -- Principios de Economia -> Economia
(2, 2), -- Fisica para Ingenieros -> Ciencia
(3, 3), -- Historia de la Politica -> Politica
(4, 4), -- Cien Anos de Soledad -> Literatura
(5, 5); -- Clean Code -> Tecnologia

-- Insertar préstamos de ejemplo
INSERT INTO loan (student_id, book_id, loan_date, estimated_return_date) VALUES
(1, 1, '2024-01-15', '2024-02-15'),
(2, 3, '2024-01-10', '2024-02-10'),
(3, 5, '2024-01-20', '2024-02-20');

-- Marcar un préstamo como devuelto
UPDATE loan SET actual_return_date = '2024-01-25', status = 'devuelto' WHERE loan_id = 2; 