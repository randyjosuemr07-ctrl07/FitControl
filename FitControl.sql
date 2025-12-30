CREATE DATABASE FitControl;
USE FitControl;

-- ============================
-- 1. TABLA USUARIO
-- ============================
CREATE TABLE Usuario (
    cedula CHAR(10) PRIMARY KEY,
    nombres VARCHAR(100),
    apellidos VARCHAR(100),
    edad INT,
    telefono VARCHAR(20),
    direccion VARCHAR(150),
    estado CHAR(1)   -- A = activo, I = inactivo
);
-- ============================
-- 1. TABLA USUARIO MODIFICACIONES
ALTER TABLE Usuario
MODIFY nombres VARCHAR(100) NOT NULL,
MODIFY apellidos VARCHAR(100) NOT NULL,
MODIFY edad INT,
MODIFY estado CHAR(1) NOT NULL DEFAULT 'A';

ALTER TABLE Usuario
ADD CONSTRAINT chk_estado_usuario
CHECK (estado IN ('A','I'));

ALTER TABLE Usuario
ADD CONSTRAINT chk_edad_usuario
CHECK (edad >= 0);

-- 2. TABLA MEMBRESIA (Tipo de plan)
-- ============================
CREATE TABLE Membresia (
    id_membresia INT AUTO_INCREMENT PRIMARY KEY,
    tipo_plan VARCHAR(20),    -- Mensual, Trimestral, Anual
    precio DECIMAL(10,2),
    duracion_dias INT
);
-- ============================
-- 2. TABLA MEMBRESIA MODIFICACIONES
ALTER TABLE Membresia
MODIFY tipo_plan VARCHAR(20) NOT NULL,
MODIFY precio DECIMAL(10,2) NOT NULL,
MODIFY duracion_dias INT NOT NULL;

ALTER TABLE Membresia
ADD CONSTRAINT chk_tipo_plan
CHECK (tipo_plan IN ('Mensual','Trimestral','Anual'));

ALTER TABLE Membresia
ADD CONSTRAINT chk_precio_membresia
CHECK (precio > 0);

ALTER TABLE Membresia
ADD CONSTRAINT chk_duracion_membresia
CHECK (duracion_dias > 0);

ALTER TABLE Membresia
ADD CONSTRAINT uq_tipo_plan UNIQUE (tipo_plan);

-- 3. TABLA PAGO
-- ============================
CREATE TABLE Pago (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    cedula CHAR(10),
    id_membresia INT,
    monto DECIMAL(10,2),
    fecha_pago DATE,
    metodo_pago VARCHAR(50),

    CONSTRAINT fk_pago_usuario 
        FOREIGN KEY (cedula) REFERENCES Usuario(cedula),

    CONSTRAINT fk_pago_membresia 
        FOREIGN KEY (id_membresia) REFERENCES Membresia(id_membresia)
);
-- ============================
-- 3. TABLA PAGO MODIFICACIONES
ALTER TABLE Pago
MODIFY cedula CHAR(10) NOT NULL,
MODIFY id_membresia INT NOT NULL,
MODIFY monto DECIMAL(10,2) NOT NULL,
MODIFY fecha_pago DATE NOT NULL,
MODIFY metodo_pago VARCHAR(50) NOT NULL;

ALTER TABLE Pago
ADD CONSTRAINT chk_monto_pago
CHECK (monto > 0);

ALTER TABLE Pago
ADD CONSTRAINT chk_metodo_pago
CHECK (metodo_pago IN ('Efectivo','Transferencia','Tarjeta'));

-- ============================
-- 4. TABLA ASISTENCIA
-- ============================
CREATE TABLE Asistencia (
    id_asistencia INT AUTO_INCREMENT PRIMARY KEY,
    cedula CHAR(10),
    fecha DATE,
    hora TIME,

    CONSTRAINT fk_asistencia_usuario
        FOREIGN KEY (cedula) REFERENCES Usuario(cedula)
);
-- ============================
-- 4. TABLA ASISTENCIA MODIFICACIONES
ALTER TABLE Asistencia
MODIFY cedula CHAR(10) NOT NULL,
MODIFY fecha DATE NOT NULL,
MODIFY hora TIME NOT NULL;

ALTER TABLE Asistencia
ADD CONSTRAINT unica_asistencia_por_dia
UNIQUE (cedula, fecha);

-- 5. TABLA USUARIO_MEMBRESIA 
-- (Historial de planes)
-- ============================
CREATE TABLE Usuario_Membresia (
    id_usuario_membresia INT AUTO_INCREMENT PRIMARY KEY,
    cedula CHAR(10),
    id_membresia INT,
    fecha_inicio DATE,
    fecha_fin DATE,

    CONSTRAINT fk_hist_usuario 
        FOREIGN KEY (cedula) REFERENCES Usuario(cedula),

    CONSTRAINT fk_hist_membresia 
        FOREIGN KEY (id_membresia) REFERENCES Membresia(id_membresia)
);

-- ============================
-- 5. TABLA USUARIO_MEMBRESIA MODIFICACIONES
ALTER TABLE Usuario_Membresia
MODIFY cedula CHAR(10) NOT NULL,
MODIFY id_membresia INT NOT NULL,
MODIFY fecha_inicio DATE NOT NULL,
MODIFY fecha_fin DATE NOT NULL;

ALTER TABLE Usuario_Membresia
ADD CONSTRAINT chk_fechas_membresia
CHECK (fecha_fin > fecha_inicio);

--       INSERTS
-- ============================

-- INSERTS DE USUARIO
INSERT INTO Usuario (cedula, nombres, apellidos, edad, telefono, direccion, estado)
VALUES ('1754896321', 'Carlos', 'Mendoza', 25, '0987654321', 'Av. Central 123', 'A');
INSERT INTO Usuario (cedula, nombres, apellidos, edad, telefono, direccion, estado) VALUES
('1700000001', 'Carlos', 'Mendoza', 25, '0981111111', 'Av. Central 123', 'A'),
('1700000002', 'Ana', 'Lopez', 22, '0982222222', 'Calle Norte 45', 'A'),
('1700000003', 'Luis', 'Perez', 30, '0983333333', 'Barrio Sur', 'A'),
('1700000004', 'Maria', 'Gomez', 28, '0984444444', 'Av. Los Rios', 'A'),
('1700000005', 'Jose', 'Torres', 35, '0985555555', 'Cdla. Kennedy', 'I'),
('1700000006', 'Diana', 'Castro', 24, '0986666666', 'Av. Quito', 'A'),
('1700000007', 'Miguel', 'Vera', 29, '0987777777', 'Centro', 'A'),
('1700000008', 'Sofia', 'Ramos', 21, '0988888888', 'Av. Amazonas', 'A'),
('1700000009', 'Andres', 'Morales', 33, '0989999999', 'La Floresta', 'A');

-- INSERTS DE MEMBRESIA
INSERT INTO Membresia (tipo_plan, precio, duracion_dias) VALUES
('Mensual', 25.00, 30),
('Trimestral', 65.00, 90),
('Anual', 220.00, 365);

-- INSERTS DE PAGO
INSERT INTO Pago (cedula, id_membresia, monto, fecha_pago, metodo_pago)
VALUES ('1754896321', 1, 25.00, '2025-12-10', 'Efectivo');
INSERT INTO Pago (cedula, id_membresia, monto, fecha_pago, metodo_pago) VALUES
('1700000001', 1, 25.00, '2025-01-01', 'Efectivo'),
('1700000002', 2, 65.00, '2025-01-01', 'Tarjeta'),
('1700000003', 3, 220.00, '2025-01-01', 'Transferencia'),
('1700000004', 1, 25.00, '2025-02-01', 'Efectivo'),
('1700000005', 2, 65.00, '2025-01-15', 'Tarjeta'),
('1700000006', 1, 25.00, '2025-03-01', 'Efectivo'),
('1700000007', 3, 220.00, '2025-01-01', 'Transferencia'),
('1700000008', 1, 25.00, '2025-02-10', 'Efectivo'),
('1700000009', 2, 65.00, '2025-03-01', 'Tarjeta');

-- INSERTS DE ASISTENCIA
INSERT INTO Asistencia (cedula, fecha, hora)
VALUES ('1754896321', '2025-12-10', '14:30:00');
INSERT INTO Asistencia (cedula, fecha, hora) VALUES
('1700000001', '2025-03-01', '07:30:00'),
('1700000002', '2025-03-01', '08:00:00'),
('1700000003', '2025-03-01', '09:15:00'),
('1700000004', '2025-03-02', '07:45:00'),
('1700000005', '2025-03-02', '10:00:00'),
('1700000006', '2025-03-03', '06:30:00'),
('1700000007', '2025-03-03', '18:00:00'),
('1700000008', '2025-03-04', '17:30:00'),
('1700000009', '2025-03-04', '19:00:00');

-- INSERTS DE USUARIO_MEMBRESIA
INSERT INTO Usuario_Membresia (cedula, id_membresia, fecha_inicio, fecha_fin)
VALUES ('1754896321', 1, '2025-12-10', '2026-01-10');
INSERT INTO Usuario_Membresia (cedula, id_membresia, fecha_inicio, fecha_fin) VALUES
('1700000001', 1, '2025-01-01', '2025-01-31'),
('1700000002', 2, '2025-01-01', '2025-03-31'),
('1700000003', 3, '2025-01-01', '2025-12-31'),
('1700000004', 1, '2025-02-01', '2025-02-28'),
('1700000005', 2, '2025-01-15', '2025-04-15'),
('1700000006', 1, '2025-03-01', '2025-03-31'),
('1700000007', 3, '2025-01-01', '2025-12-31'),
('1700000008', 1, '2025-02-10', '2025-03-10'),
('1700000009', 2, '2025-03-01', '2025-06-01');
-- ============================
-- FACTURAS
-- ============================
CREATE TABLE Factura (
    id_factura INT AUTO_INCREMENT PRIMARY KEY,
    id_pago INT,
    cedula CHAR(10),
    fecha_emision DATE,
    subtotal DECIMAL(10,2),
    iva DECIMAL(10,2),
    total DECIMAL(10,2),
    metodo_pago VARCHAR(50),
    estado VARCHAR(15),

    CONSTRAINT fk_factura_pago
        FOREIGN KEY (id_pago) REFERENCES Pago(id_pago),

    CONSTRAINT fk_factura_usuario
        FOREIGN KEY (cedula) REFERENCES Usuario(cedula)
);
--MODIFICACIONES

ALTER TABLE Factura
MODIFY id_pago INT NOT NULL,
MODIFY cedula CHAR(10) NOT NULL,
MODIFY fecha_emision DATE NOT NULL,
MODIFY subtotal DECIMAL(10,2) NOT NULL,
MODIFY iva DECIMAL(10,2) NOT NULL,
MODIFY total DECIMAL(10,2) NOT NULL,
MODIFY metodo_pago VARCHAR(50) NOT NULL,
MODIFY estado VARCHAR(15) NOT NULL;

ALTER TABLE Factura
ADD CONSTRAINT chk_factura_subtotal
CHECK (subtotal >= 0);

ALTER TABLE Factura
ADD CONSTRAINT chk_factura_iva
CHECK (iva >= 0);

ALTER TABLE Factura
ADD CONSTRAINT chk_factura_total
CHECK (total >= subtotal);

ALTER TABLE Factura
ADD CONSTRAINT chk_factura_estado
CHECK (estado IN ('Activa','Anulada'));

ALTER TABLE Factura
ADD CONSTRAINT chk_factura_metodo
CHECK (metodo_pago IN ('Efectivo','Transferencia','Tarjeta'));
-- ============================
--INSERTS
-- ============================
INSERT INTO Factura
(id_pago, cedula, fecha_emision, subtotal, iva, total, metodo_pago, estado)
VALUES
(1, '1754896321', '2025-12-10', 25.00, 3.75, 28.75, 'Efectivo', 'Activa'),

(2, '1700000001', '2025-01-01', 25.00, 3.75, 28.75, 'Efectivo', 'Activa'),

(3, '1700000002', '2025-01-01', 65.00, 9.75, 74.75, 'Tarjeta', 'Activa'),

(4, '1700000003', '2025-01-01', 220.00, 33.00, 253.00, 'Transferencia', 'Activa'),

(5, '1700000004', '2025-02-01', 25.00, 3.75, 28.75, 'Efectivo', 'Activa'),

(6, '1700000005', '2025-01-15', 65.00, 9.75, 74.75, 'Tarjeta', 'Activa');

SELECT subtotal, iva, total
FROM Factura;

-- ============================
--CONSULTA DE IMPRESION
-- ============================
SELECT 
    f.id_factura,
    u.nombres,
    u.apellidos,
    m.tipo_plan,
    f.subtotal,
    f.iva,
    f.total,
    f.metodo_pago,
    f.fecha_emision
FROM Factura f
JOIN Usuario u ON f.cedula = u.cedula
JOIN Pago p ON f.id_pago = p.id_pago
JOIN Membresia m ON p.id_membresia = m.id_membresia;
-- ============================
--Orden de clientes por edad DESC
-- ============================
SELECT
    cedula,
    nombres,
    apellidos,
    edad
FROM Usuario
ORDER BY edad DESC;
-- ============================
--Orden de clientes por edad ASC
-- ============================
SELECT
    cedula,
    nombres,
    apellidos,
    edad
FROM Usuario
ORDER BY edad ASC;
-- ============================
-- Usuarios con membresía activa y su tipo de plan
-- ============================
SELECT 
    u.cedula,
    u.nombres,
    m.tipo_plan,
    um.fecha_inicio,
    um.fecha_fin
FROM Usuario u
JOIN Usuario_Membresia um ON u.cedula = um.cedula
JOIN Membresia m ON m.id_membresia = um.id_membresia
WHERE u.estado = 'A';

-- ============================
--Pagos mayores o iguales a un valor (decimal)
--============================
SELECT
    p.id_pago,
    p.cedula,
    m.tipo_plan,
    p.monto,
    p.fecha_pago
FROM Pago p
JOIN Membresia m ON m.id_membresia = p.id_membresia
WHERE p.monto >= 65;

-- ============================
--Pagos que NO fueron en efectivo
--============================
SELECT
    id_pago,
    cedula,
    monto,
    metodo_pago
FROM Pago
WHERE metodo_pago <> 'Efectivo';

-- ============================
--Cantidad de asistencias por usuario
--============================
SELECT
    cedula,
    COUNT(*) AS total_asistencias
FROM Asistencia
GROUP BY cedula;

-- ============================
--Usuarios que tienen una membresía más cara que la membresía mensual
--============================
SELECT
    u.cedula,
    u.nombres,
    m.tipo_plan,
    m.precio
FROM Usuario u
JOIN Usuario_Membresia um ON u.cedula = um.cedula
JOIN Membresia m ON m.id_membresia = um.id_membresia
WHERE m.precio > (
    SELECT precio
    FROM Membresia
    WHERE tipo_plan = 'Mensual'
);

-- ============================
--Dos condiciones unidas con OR
--============================
SELECT cedula, nombres, edad, estado
FROM Usuario
WHERE estado = 'A'
    OR edad > 30;

-- ============================
--Usuarios inactivos (NOT)
--============================
SELECT cedula, nombres, estado
FROM Usuario
WHERE NOT estado = 'A';
-- ============================
--Litado de users
--============================
SELECT 
    u.cedula,
    u.nombres,
    p.id_pago,
    p.monto
FROM Usuario u
LEFT JOIN Pago p ON u.cedula = p.cedula;
-- ============================
--Litado de pagos, aunque no tengan user
--============================
SELECT 
    u.cedula,
    u.nombres,
    p.id_pago,
    p.monto
FROM Usuario u
RIGHT JOIN Pago p ON u.cedula = p.cedula;

-- ============================
--Orden descendente (pagos mas altos primero)
--============================
SELECT id_pago, monto, fecha_pago
FROM Pago
ORDER BY monto DESC;

-- ============================
--Ordenamiento mixto Primero(A-Z) y luego por monto de mayor a menor
--============================
SELECT id_pago, metodo_pago, monto
FROM Pago
ORDER BY metodo_pago ASC, monto DESC;

-- ============================
--Uso de and, usuarioa activos con edad mayor o igual a 25
--Create view para guardar consultas
--============================
CREATE VIEW vista_usuarios_activos AS
SELECT cedula, nombres, edad
FROM Usuario
WHERE estado = 'A'
    AND edad >= 25;
--Vista
SELECT * FROM vista_usuarios_activos;

-- ============================
--Usuario + Tipo de Membresia
--============================
CREATE VIEW vista_usuario_membresia AS
SELECT 
    u.cedula,
    u.nombres,
    m.tipo_plan
FROM Usuario u
JOIN Usuario_Membresia um ON u.cedula = um.cedula
JOIN Membresia m ON m.id_membresia = um.id_membresia;
--Vista
SELECT * FROM vista_usuario_membresia;

-- ============================
--Nombre + Estado
--============================
SELECT 
    cedula,
    CONCAT(nombres, ' ', apellidos) AS nombre_completo,
    estado
FROM Usuario;

-- ============================
--Vista de concatenacion
--============================
CREATE VIEW vista_nombre_completo AS
SELECT 
    cedula,
    CONCAT(nombres, ' ', apellidos) AS nombre_completo,
    estado
FROM Usuario;
--Vista
SELECT * FROM vista_nombre_completo;

-- ============================
--Subconsulta basada en clave foránea
--============================
SELECT cedula, monto
FROM Pago
WHERE monto > (
    SELECT AVG(monto)
    FROM Pago
);
-- ============================
-- CONSULTA mostrar membresias aun szi no tiene usuario (right join)
-- ============================
SELECT
    u.cedula,
    u.nombres,
    m.tipo_plan
FROM Usuario u
RIGHT JOIN Usuario_Membresia um 
    ON u.cedula = um.cedula
RIGHT JOIN Membresia m
    ON m.id_membresia = um.id_membresia;

-- ============================
-- CONSULTAS USANDO CURDATE: calcular cuántos días faltan para que termine la membresía de cada usuario:
-- ============================
SELECT 
    u.cedula,
    u.nombres,
    um.fecha_fin,
    DATEDIFF(um.fecha_fin, CURDATE()) AS dias_restantes
FROM Usuario u
JOIN Usuario_Membresia um ON u.cedula = um.cedula;
-- ============================
-- CONSULTAS USO BETWEEN: miembros cuyo inicio de membresía esté entre enero y marzo de 2025:
-- ============================
SELECT 
    u.cedula,
    u.nombres,
    um.fecha_inicio,
    um.fecha_fin
FROM Usuario u
JOIN Usuario_Membresia um ON u.cedula = um.cedula
WHERE um.fecha_inicio BETWEEN '2025-01-01' AND '2025-03-31';

-- ============================
-- CONSULTAS USO DE IS NULL / IS NOT NULL usuarios que todavía no han hecho ningún pago:
-- ============================
SELECT u.cedula, u.nombres
FROM Usuario u
LEFT JOIN Pago p ON u.cedula = p.cedula
WHERE p.id_pago IS NULL;

-- ============================
-- CONSULTAS IS NULL / IS NOT NULL Usuarios que sí han hecho pagos:
-- ============================
SELECT u.cedula, u.nombres
FROM Usuario u
JOIN Pago p ON u.cedula = p.cedula
WHERE p.id_pago IS NOT NULL;

-- ============================
-- CONSULTAS USO DE DISTINCT tipos de membresía únicos:
-- ============================
SELECT DISTINCT tipo_plan
FROM Membresia;
-- ============================
-- CONSULTAS WHEN THEN ELSE: CLASIFICACION POR EDAD
-- ============================
SELECT 
    cedula,
    nombres,
    edad,
    CASE 
        WHEN edad < 25 THEN 'Joven'
        WHEN edad BETWEEN 25 AND 35 THEN 'Adulto'
        ELSE 'Senior'
    END AS categoria_edad
FROM Usuario;
-- ============================
-- CONSULTAS UNION: COMBINACIION DE USEERS ACTIVOS E INACTIVOS
-- ============================
SELECT cedula, nombres, 'Activo' AS estado_label
FROM Usuario
WHERE estado = 'A'
UNION
SELECT cedula, nombres, 'Inactivo' AS estado_label
FROM Usuario
WHERE estado = 'I';
-- ============================
-- CONSULTAS EXISTS: USERS CON AL MENOS UN PAGO REGISTRADO
-- ============================
SELECT u.cedula, u.nombres
FROM Usuario u
WHERE EXISTS (
    SELECT 1 
    FROM Pago p 
    WHERE p.cedula = u.cedula
);
-- ============================
-- CONSUKTAS GENERICAS
-- ============================
SELECT * FROM Usuario;
SELECT * FROM Membresia;
SELECT * FROM Pago;
SELECT * FROM Asistencia;
SELECT * FROM Usuario_Membresia;
SELECT * FROM Factura;

-- ============================
-- BORRAR TABLAS
-- ============================
DROP TABLE IF EXISTS Usuario_Membresia;
DROP TABLE IF EXISTS Asistencia;
DROP TABLE IF EXISTS Pago;
DROP TABLE IF EXISTS Membresia;
DROP TABLE IF EXISTS Usuario;
DROP TABLE IF EXISTS Factura;
