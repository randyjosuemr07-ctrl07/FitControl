DROP DATABASE IF EXISTS FitControl;
CREATE DATABASE FitControl;
USE FitControl;


-- 1. USUARIO
CREATE TABLE Usuario (
    cedula CHAR(10) PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    edad INT CHECK (edad >= 0),
    telefono VARCHAR(20),
    direccion VARCHAR(150),
    estado CHAR(1) NOT NULL DEFAULT 'A' CHECK (estado IN ('A','I'))
);

-- 2. MEMBRESIA
CREATE TABLE Membresia (
    id_membresia INT AUTO_INCREMENT PRIMARY KEY,
    tipo_plan VARCHAR(20) NOT NULL UNIQUE CHECK (tipo_plan IN ('Mensual','Trimestral','Anual')),
    precio DECIMAL(10,2) NOT NULL CHECK (precio > 0),
    duracion_dias INT NOT NULL CHECK (duracion_dias > 0)
);

-- 3. METODO DE PAGO
CREATE TABLE Metodo_Pago (
    id_metodo INT AUTO_INCREMENT PRIMARY KEY,
    metodo VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO Metodo_Pago (metodo) VALUES
('Efectivo'),('Transferencia'),('Tarjeta');

-- 4. PAGO
CREATE TABLE Pago (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    cedula CHAR(10) NOT NULL,
    id_membresia INT NOT NULL,
    id_metodo INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL CHECK (monto > 0),
    fecha_pago DATE NOT NULL,

    CONSTRAINT fk_pago_usuario FOREIGN KEY (cedula) REFERENCES Usuario(cedula),
    CONSTRAINT fk_pago_membresia FOREIGN KEY (id_membresia) REFERENCES Membresia(id_membresia),
    CONSTRAINT fk_pago_metodo FOREIGN KEY (id_metodo) REFERENCES Metodo_Pago(id_metodo)
);

-- 5. ASISTENCIA
CREATE TABLE Asistencia (
    id_asistencia INT AUTO_INCREMENT PRIMARY KEY,
    cedula CHAR(10) NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    CONSTRAINT fk_asistencia_usuario FOREIGN KEY (cedula) REFERENCES Usuario(cedula),
    UNIQUE (cedula, fecha)
);

-- 6. HISTORIAL DE MEMBRESIA
CREATE TABLE Usuario_Membresia (
    id_usuario_membresia INT AUTO_INCREMENT PRIMARY KEY,
    cedula CHAR(10) NOT NULL,
    id_membresia INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,

    CONSTRAINT fk_hist_usuario
        FOREIGN KEY (cedula) REFERENCES Usuario(cedula),

    CONSTRAINT fk_hist_membresia
        FOREIGN KEY (id_membresia) REFERENCES Membresia(id_membresia)
);
-- 7. ESTADO FACTURA
CREATE TABLE Estado_Factura (
    id_estado INT AUTO_INCREMENT PRIMARY KEY,
    estado VARCHAR(20) UNIQUE NOT NULL
);

INSERT INTO Estado_Factura (estado) VALUES ('Activa'),('Anulada');

-- 8. FACTURA
CREATE TABLE Factura (
    id_factura INT AUTO_INCREMENT PRIMARY KEY,
    id_pago INT NOT NULL,
    cedula CHAR(10) NOT NULL,
    fecha_emision DATE NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    iva DECIMAL(10,2) NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    id_metodo INT NOT NULL,
    id_estado INT NOT NULL,

    FOREIGN KEY (id_pago) REFERENCES Pago(id_pago),
    FOREIGN KEY (cedula) REFERENCES Usuario(cedula),
    FOREIGN KEY (id_metodo) REFERENCES Metodo_Pago(id_metodo),
    FOREIGN KEY (id_estado) REFERENCES Estado_Factura(id_estado)
);

--===========================
--INSERTS
--==========================USUARIO========================
INSERT INTO Usuario (cedula, nombres, apellidos, edad, telefono, direccion, estado) VALUES
('1700000001', 'Carlos', 'Mendoza', 25, '0981111111', 'Av. Central 123', 'A'),
('1700000002', 'Ana', 'Lopez', 22, '0982222222', 'Calle Norte 45', 'A'),
('1700000003', 'Luis', 'Perez', 30, '0983333333', 'Barrio Sur', 'A'),
('1700000004', 'Maria', 'Gomez', 28, '0984444444', 'Av. Los Rios', 'A'),
('1700000005', 'Jose', 'Torres', 35, '0985555555', 'Cdla. Kennedy', 'I'),
('1700000006', 'Diana', 'Castro', 24, '0986666666', 'Av. Quito', 'A'),
('1700000007', 'Miguel', 'Vera', 29, '0987777777', 'Centro', 'A'),
('1700000008', 'Sofia', 'Ramos', 21, '0988888888', 'Av. Amazonas', 'A'),
('1700000009', 'Andres', 'Morales', 33, '0989999999', 'La Floresta', 'A'),
('1700000010', 'Valeria', 'Jimenez', 26, '0970000001', 'Los Laureles', 'A'),
('1700000011', 'Ricardo', 'Salazar', 32, '0970000002', 'La Kennedy', 'A'),
('1700000012', 'Fernanda', 'Quinteros', 27, '0970000003', 'El Inca', 'A'),
('1700000013', 'Jorge', 'Narvaez', 40, '0970000004', 'La Tola', 'A'),
('1700000014', 'Camila', 'Ortiz', 23, '0970000005', 'Nueva Aurora', 'A'),
('1700000015', 'Pablo', 'Chavez', 31, '0970000006', 'Monjas', 'A');
--==========================USUARIO_MEMBRESIA========================
INSERT INTO Usuario_Membresia (cedula, id_membresia, fecha_inicio, fecha_fin) VALUES
('1700000001', 1, '2025-01-01', '2025-01-31'),
('1700000002', 2, '2025-01-01', '2025-03-31'),
('1700000003', 3, '2025-01-01', '2025-12-31'),
('1700000004', 1, '2025-02-01', '2025-02-28'),
('1700000005', 2, '2025-01-15', '2025-04-15'),
('1700000006', 1, '2025-03-01', '2025-03-31'),
('1700000007', 3, '2025-01-01', '2025-12-31'),
('1700000008', 1, '2025-02-10', '2025-03-10'),
('1700000009', 2, '2025-03-01', '2025-06-01'),
('1700000010', 1, '2025-02-05', '2025-03-05'),
('1700000011', 3, '2025-02-10', '2026-02-10'),
('1700000012', 2, '2025-03-01', '2025-06-01'),
('1700000013', 1, '2025-03-10', '2025-04-10'),
('1700000014', 1, '2025-04-01', '2025-05-01'),
('1700000015', 3, '2025-04-15', '2026-04-15');
--==========================PAGO========================
INSERT INTO Pago (cedula, id_membresia, id_metodo, monto, fecha_pago) VALUES
('1700000001', 1, 1, 25.00, '2025-01-01'),
('1700000002', 2, 3, 65.00, '2025-01-05'),
('1700000003', 3, 2, 220.00, '2025-01-08'),
('1700000004', 1, 1, 25.00, '2025-02-01'),
('1700000005', 2, 3, 65.00, '2025-01-15'),
('1700000006', 1, 1, 25.00, '2025-03-01'),
('1700000007', 3, 2, 220.00, '2025-01-01'),
('1700000008', 1, 1, 25.00, '2025-02-10'),
('1700000009', 2, 3, 65.00, '2025-03-01'),
('1700000010', 1, 2, 25.00, '2025-02-05'),
('1700000011', 3, 2, 220.00, '2025-02-10'),
('1700000012', 2, 3, 65.00, '2025-03-01'),
('1700000013', 1, 1, 25.00, '2025-03-10'),
('1700000014', 1, 1, 25.00, '2025-04-01'),
('1700000015', 3, 2, 220.00, '2025-04-15');
--==========================FACTURA========================
INSERT INTO Factura (id_pago, cedula, fecha_emision, subtotal, iva, total, id_metodo, id_estado) VALUES
(1, '1700000001', '2025-01-01', 25.00, 3.75, 28.75, 1, 1),
(2, '1700000002', '2025-01-05', 65.00, 9.75, 74.75, 3, 1),
(3, '1700000003', '2025-01-08', 220.00, 33.00, 253.00, 2, 1),
(4, '1700000004', '2025-02-01', 25.00, 3.75, 28.75, 1, 1),
(5, '1700000005', '2025-01-15', 65.00, 9.75, 74.75, 3, 1),
(6, '1700000006', '2025-03-01', 25.00, 3.75, 28.75, 1, 1),
(7, '1700000007', '2025-01-01', 220.00, 33.00, 253.00, 2, 1),
(8, '1700000008', '2025-02-10', 25.00, 3.75, 28.75, 1, 1),
(9, '1700000009', '2025-03-01', 65.00, 9.75, 74.75, 3, 1),
(10, '1700000010', '2025-02-05', 25.00, 3.75, 28.75, 2, 1),
(11, '1700000011', '2025-02-10', 220.00, 33.00, 253.00, 2, 1),
(12, '1700000012', '2025-03-01', 65.00, 9.75, 74.75, 3, 1),
(13, '1700000013', '2025-03-10', 25.00, 3.75, 28.75, 1, 1),
(14, '1700000014', '2025-04-01', 25.00, 3.75, 28.75, 1, 1),
(15, '1700000015', '2025-04-15', 220.00, 33.00, 253.00, 2, 1);
--==========================ASISTENCIA========================
INSERT INTO Asistencia (cedula, fecha, hora) VALUES
('1700000001', '2025-01-01', '07:30:00'),
('1700000002', '2025-01-05', '08:00:00'),
('1700000003', '2025-01-08', '09:15:00'),
('1700000004', '2025-02-01', '07:45:00'),
('1700000005', '2025-01-15', '10:00:00'),
('1700000006', '2025-03-01', '06:30:00'),
('1700000007', '2025-01-01', '18:00:00'),
('1700000008', '2025-02-10', '17:30:00'),
('1700000009', '2025-03-01', '19:00:00'),
('1700000010', '2025-02-05', '08:15:00'),
('1700000011', '2025-02-10', '08:45:00'),
('1700000012', '2025-03-01', '07:50:00'),
('1700000013', '2025-03-10', '09:00:00'),
('1700000014', '2025-04-01', '06:45:00'),
('1700000015', '2025-04-15', '10:20:00');