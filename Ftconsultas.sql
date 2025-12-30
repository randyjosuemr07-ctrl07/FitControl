USE FitControl;

-- ============================
-- CONSULTA DE IMPRESIÓN DE FACTURA (JOIN múltiple)
-- ============================
SELECT 
    f.id_factura,
    u.nombres,
    u.apellidos,
    m.tipo_plan,
    f.subtotal,
    f.iva,
    f.total,
    mp.metodo AS metodo_pago,
    f.fecha_emision
FROM Factura f
JOIN Usuario u ON f.cedula = u.cedula
JOIN Pago p ON f.id_pago = p.id_pago
JOIN Membresia m ON p.id_membresia = m.id_membresia
JOIN Metodo_Pago mp ON f.id_metodo = mp.id_metodo;

-- ============================
-- Ordenar clientes por edad DESC
-- ============================
SELECT cedula, nombres, apellidos, edad
FROM Usuario
ORDER BY edad DESC;

-- ============================
-- Ordenar clientes por edad ASC
-- ============================
SELECT cedula, nombres, apellidos, edad
FROM Usuario
ORDER BY edad ASC;

-- ============================
-- Usuarios activos con su membresía (JOIN + WHERE)
-- ============================
SELECT 
    u.cedula,
    u.nombres,
    m.tipo_plan,
    um.fecha_inicio,
    um.fecha_fin
FROM Usuario u
JOIN Usuario_Membresia um ON u.cedula = um.cedula
JOIN Membresia m ON um.id_membresia = m.id_membresia
WHERE u.estado = 'A';

-- ============================
-- Pagos mayores o iguales a 65 (DECIMAL)
-- ============================
SELECT
    p.id_pago,
    p.cedula,
    m.tipo_plan,
    p.monto,
    p.fecha_pago
FROM Pago p
JOIN Membresia m ON p.id_membresia = m.id_membresia
WHERE p.monto >= 65;

-- ============================
-- Pagos que NO fueron en efectivo (<>)
-- ============================
SELECT
    p.id_pago,
    p.cedula,
    p.monto,
    mp.metodo
FROM Pago p
JOIN Metodo_Pago mp ON p.id_metodo = mp.id_metodo
WHERE mp.metodo <> 'Efectivo';

-- ============================
-- Cantidad de asistencias por usuario (GROUP BY)
-- ============================
SELECT cedula, COUNT(*) AS total_asistencias
FROM Asistencia
GROUP BY cedula;

-- ============================
-- Usuarios con membresía más cara que la mensual (SUBCONSULTA)
-- ============================
SELECT
    u.cedula,
    u.nombres,
    m.tipo_plan,
    m.precio
FROM Usuario u
JOIN Usuario_Membresia um ON u.cedula = um.cedula
JOIN Membresia m ON um.id_membresia = m.id_membresia
WHERE m.precio > (
    SELECT precio
    FROM Membresia
    WHERE tipo_plan = 'Mensual'
);

-- ============================
-- Condiciones con OR
-- ============================
SELECT cedula, nombres, edad, estado
FROM Usuario
WHERE estado = 'A'
    OR edad > 30;

-- ============================
-- Condición con NOT
-- ============================
SELECT cedula, nombres, estado
FROM Usuario
WHERE NOT estado = 'A';

-- ============================
-- LEFT JOIN: usuarios aunque no tengan pagos
-- ============================
SELECT 
    u.cedula,
    u.nombres,
    p.id_pago,
    p.monto
FROM Usuario u
LEFT JOIN Pago p ON u.cedula = p.cedula;

-- ============================
-- RIGHT JOIN: pagos aunque no tengan usuario
-- ============================
SELECT 
    u.cedula,
    u.nombres,
    p.id_pago,
    p.monto
FROM Usuario u
RIGHT JOIN Pago p ON u.cedula = p.cedula;

-- ============================
-- Orden descendente por monto
-- ============================
SELECT id_pago, monto, fecha_pago
FROM Pago
ORDER BY monto DESC;

-- ============================
-- Ordenamiento mixto ASC y DESC
-- ============================
SELECT p.id_pago, mp.metodo, p.monto
FROM Pago p
JOIN Metodo_Pago mp ON p.id_metodo = mp.id_metodo
ORDER BY mp.metodo ASC, p.monto DESC;

-- ============================
-- VIEW: usuarios activos con edad >= 25 (AND)
-- ============================
CREATE VIEW vista_usuarios_activos AS
SELECT cedula, nombres, edad
FROM Usuario
WHERE estado = 'A'
    AND edad >= 25;

SELECT * FROM vista_usuarios_activos;

-- ============================
-- VIEW: usuario + tipo de membresía
-- ============================
CREATE VIEW vista_usuario_membresia AS
SELECT 
    u.cedula,
    u.nombres,
    m.tipo_plan
FROM Usuario u
JOIN Usuario_Membresia um ON u.cedula = um.cedula
JOIN Membresia m ON um.id_membresia = m.id_membresia;

SELECT * FROM vista_usuario_membresia;

-- ============================
-- CONCAT: nombre completo
-- ============================
SELECT 
    cedula,
    CONCAT(nombres, ' ', apellidos) AS nombre_completo,
    estado
FROM Usuario;

-- ============================
-- VIEW con CONCAT
-- ============================
CREATE VIEW vista_nombre_completo AS
SELECT 
    cedula,
    CONCAT(nombres, ' ', apellidos) AS nombre_completo,
    estado
FROM Usuario;

SELECT * FROM vista_nombre_completo;

-- ============================
-- Subconsulta con AVG
-- ============================
SELECT cedula, monto
FROM Pago
WHERE monto > (
    SELECT AVG(monto)
    FROM Pago
);

-- ============================
-- RIGHT JOIN: membresías aunque no tengan usuario
-- ============================
SELECT
    u.cedula,
    u.nombres,
    m.tipo_plan
FROM Usuario u
RIGHT JOIN Usuario_Membresia um ON u.cedula = um.cedula
RIGHT JOIN Membresia m ON um.id_membresia = m.id_membresia;

-- ============================
-- CURDATE(): días restantes de membresía
-- ============================
SELECT 
    u.cedula,
    u.nombres,
    um.fecha_fin,
    DATEDIFF(um.fecha_fin, CURDATE()) AS dias_restantes
FROM Usuario u
JOIN Usuario_Membresia um ON u.cedula = um.cedula;

-- ============================
-- BETWEEN en fechas
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
-- IS NULL: usuarios sin pagos
-- ============================
SELECT u.cedula, u.nombres
FROM Usuario u
LEFT JOIN Pago p ON u.cedula = p.cedula
WHERE p.id_pago IS NULL;

-- ============================
-- IS NOT NULL: usuarios con pagos
-- ============================
SELECT DISTINCT u.cedula, u.nombres
FROM Usuario u
JOIN Pago p ON u.cedula = p.cedula
WHERE p.id_pago IS NOT NULL;

-- ============================
-- DISTINCT
-- ============================
SELECT DISTINCT tipo_plan
FROM Membresia;

-- ============================
-- CASE WHEN THEN ELSE
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
-- UNION
-- ============================
SELECT cedula, nombres, 'Activo' AS estado_label
FROM Usuario
WHERE estado = 'A'
UNION
SELECT cedula, nombres, 'Inactivo'
FROM Usuario
WHERE estado = 'I';

-- ============================
-- EXISTS users con al menos un pago en el sistema 
-- ============================
SELECT u.cedula, u.nombres
FROM Usuario u
WHERE EXISTS (
    SELECT 1
    FROM Pago p
    WHERE p.cedula = u.cedula
);

-- ============================
-- CONSULTAS GENERALES
-- ============================
SELECT * FROM Usuario;
SELECT * FROM Membresia;
SELECT * FROM Pago;
SELECT * FROM Asistencia;
SELECT * FROM Usuario_Membresia;
SELECT * FROM Factura;
SELECT * FROM Estado_Factura;
SELECT * FROM Metodo_Pago;
