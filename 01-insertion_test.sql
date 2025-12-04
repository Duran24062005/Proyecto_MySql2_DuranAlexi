-- ================================= 35
-- Inserciones de prueba AMPLIADAS
-- =================================

-- uso de la base de datos
USE pizzeria_piccolo_db;

-- ========================================
-- 1. Insertar Personas (ampliado a 20 personas)
-- ========================================
INSERT INTO Personas (nombre, telefono, correo, direccion) VALUES
('Juan Pérez', '3001234567', 'juan.perez@email.com', 'Calle 10 #20-30'),
('María García', '3107654321', 'maria.garcia@email.com', 'Carrera 15 #45-67'),
('Carlos Rodríguez', '3209876543', 'carlos.rodriguez@email.com', 'Avenida 5 #12-34'),
('Ana Martínez', '3156789012', 'ana.martinez@email.com', 'Calle 8 #90-12'),
('Luis Hernández', '3187654321', 'luis.hernandez@email.com', 'Carrera 20 #34-56'),
('Sofia López', '3001112233', 'sofia.lopez@email.com', 'Calle 25 #40-50'),
('Pedro Gómez', '3112223344', 'pedro.gomez@email.com', 'Carrera 30 #60-70'),
('Laura Sánchez', '3145678901', 'laura.sanchez@email.com', 'Calle 12 #35-40'),
('Diego Torres', '3198765432', 'diego.torres@email.com', 'Carrera 8 #22-15'),
('Valentina Ruiz', '3123456789', 'valentina.ruiz@email.com', 'Avenida 3 #50-60'),
('Andrés Castro', '3167890123', 'andres.castro@email.com', 'Calle 18 #70-80'),
('Carolina Vargas', '3134567890', 'carolina.vargas@email.com', 'Carrera 25 #15-20'),
('Roberto Mendoza', '3176543210', 'roberto.mendoza@email.com', 'Calle 5 #40-45'),
('Patricia Moreno', '3189012345', 'patricia.moreno@email.com', 'Avenida 10 #25-30'),
('Fernando Silva', '3145671234', 'fernando.silva@email.com', 'Carrera 12 #55-65'),
('Gabriela Rojas', '3198764321', 'gabriela.rojas@email.com', 'Calle 22 #80-90'),
('Miguel Ángel Díaz', '3123459876', 'miguel.diaz@email.com', 'Avenida 7 #10-15'),
('Camila Herrera', '3167895432', 'camila.herrera@email.com', 'Calle 14 #45-50'),
('Santiago Ortiz', '3134568901', 'santiago.ortiz@email.com', 'Carrera 18 #30-35'),
('Juliana Ramírez', '3176549012', 'juliana.ramirez@email.com', 'Avenida 12 #65-70');

-- ========================================
-- 2. Insertar Clientes (15 clientes)
-- ========================================
INSERT INTO Clientes (persona_id) VALUES
(1), (2), (3), (4), (5), (8), (9), (10), (11), (12), (13), (14), (16), (17), (19);

-- ========================================
-- 3. Insertar usuarios del sistema (5 empleados)
-- ========================================
INSERT INTO users (persona_id, usuario, password_hash) VALUES
(6, 'sofia.lopez', '$2y$10$abcdefghijklmnopqrstuvwxyz1234567890'),
(7, 'pedro.gomez', '$2y$10$1234567890abcdefghijklmnopqrstuvwxyz'),
(15, 'fernando.silva', '$2y$10$9876543210zyxwvutsrqponmlkjihgfedcba'),
(18, 'camila.herrera', '$2y$10$abcd1234efgh5678ijkl9012mnop3456qrst'),
(20, 'juliana.ramirez', '$2y$10$xyz9876abc5432def1098ghi6543jkl2109');

-- ========================================
-- 4. Insertar Zonas (mantener las 5 zonas)
-- ========================================
INSERT INTO Zonas (nombre_zona, costo_base_envio, costo_por_km, tiempo_estim_min, estado) VALUES
('Norte', 5000, 1000, 20, TRUE),
('Sur', 6000, 1200, 25, TRUE),
('Centro', 4000, 800, 15, TRUE),
('Oriente', 5500, 1100, 22, TRUE),
('Occidente', 5500, 1100, 23, TRUE);

-- ========================================
-- 5. Insertar Domiciliarios (4 domiciliarios)
-- ========================================
INSERT INTO Domiciliarios (persona_id, zona_asignada, estado) VALUES
(6, 1, 'disponible'),
(7, 2, 'disponible'),
(15, 3, 'disponible'),
(18, 4, 'disponible');

-- ========================================
-- 6. Insertar Ingredientes (stock variado para probar alertas)
-- ========================================
INSERT INTO Ingredientes (nombre, unidad, costo_unitario, stock, stock_minimo) VALUES
('Harina', 'kg', 2500, 100, 20),
('Queso mozzarella', 'kg', 15000, 50, 10),
('Tomate', 'kg', 3000, 8, 10),  -- Stock bajo mínimo
('Pepperoni', 'kg', 25000, 20, 5),
('Champiñones', 'kg', 8000, 2, 5),  -- Stock bajo mínimo
('Pimiento', 'kg', 4000, 10, 8),
('Cebolla', 'kg', 2000, 3, 5),  -- Stock bajo mínimo
('Aceitunas', 'kg', 12000, 10, 8),
('Jamón', 'kg', 18000, 15, 10),
('Piña', 'kg', 5000, 12, 10),
('Salsa BBQ', 'kg', 8000, 25, 5),
('Pollo', 'kg', 12000, 30, 8),
('Carne molida', 'kg', 14000, 18, 6),
('Maíz', 'kg', 3500, 15, 4),
('Queso parmesano', 'kg', 18000, 12, 5);

-- ========================================
-- 7. Insertar Pizzas (más variedad)
-- ========================================
INSERT INTO Pizzas (nombre_pizza, tamaño, precio_base, tipo_pizza, descripcion, activo) VALUES
('Margarita', 'mediana', 25000, 'tradicional', 'Pizza clásica con tomate y queso', TRUE),
('Pepperoni', 'grande', 35000, 'tradicional', 'Pizza con pepperoni y queso', TRUE),
('Vegetariana', 'mediana', 28000, 'vegetariana', 'Pizza con champiñones, pimiento y cebolla', TRUE),
('Hawaiana', 'grande', 32000, 'especial', 'Pizza con jamón y piña', TRUE),
('Cuatro Quesos', 'familiar', 45000, 'premium', 'Pizza con cuatro tipos de queso', TRUE),
('Suprema', 'grande', 40000, 'premium', 'Pizza con todos los ingredientes', TRUE),
('BBQ Chicken', 'grande', 38000, 'especial', 'Pizza con pollo y salsa BBQ', TRUE),
('Mexicana', 'mediana', 30000, 'especial', 'Pizza con carne molida, maíz y jalapeños', TRUE),
('Napolitana', 'pequeña', 20000, 'tradicional', 'Pizza con tomate fresco y albahaca', TRUE),
('Carnívora', 'familiar', 48000, 'premium', 'Pizza con pepperoni, jamón y carne', TRUE);

-- ========================================
-- 8. Insertar relación pizza_ingrediente
-- ========================================
INSERT INTO pizza_ingrediente (pizzas_id, ingrediente_id, cantidad) VALUES
-- Margarita (id:1)
(1, 1, 200), (1, 2, 150), (1, 3, 100),
-- Pepperoni (id:2)
(2, 1, 250), (2, 2, 200), (2, 3, 120), (2, 4, 100),
-- Vegetariana (id:3)
(3, 1, 200), (3, 2, 150), (3, 5, 80), (3, 6, 60), (3, 7, 50),
-- Hawaiana (id:4)
(4, 1, 250), (4, 2, 200), (4, 9, 100), (4, 10, 80),
-- Cuatro Quesos (id:5)
(5, 1, 300), (5, 2, 250), (5, 15, 100),
-- Suprema (id:6)
(6, 1, 250), (6, 2, 200), (6, 4, 80), (6, 5, 60), (6, 6, 50), (6, 7, 40), (6, 8, 30),
-- BBQ Chicken (id:7)
(7, 1, 250), (7, 2, 180), (7, 11, 100), (7, 12, 120), (7, 7, 40),
-- Mexicana (id:8)
(8, 1, 200), (8, 2, 150), (8, 13, 100), (8, 14, 60), (8, 6, 40),
-- Napolitana (id:9)
(9, 1, 180), (9, 2, 120), (9, 3, 80),
-- Carnívora (id:10)
(10, 1, 300), (10, 2, 250), (10, 4, 100), (10, 9, 100), (10, 13, 80);

-- ========================================
-- 9. Insertar Pedidos (25 pedidos - varios en el mes actual)
-- ========================================
INSERT INTO Pedidos (cliente_id, fecha_pedido, metodo_pago, total_pedido, user_id, estado, tipo_pedido) VALUES
-- Pedidos del mes pasado
(1, '2024-11-05 12:30:00', 'efectivo', 68500, 1, 'entregado', 'domicilio'),
(2, '2024-11-10 18:45:00', 'tarjeta', 53550, 1, 'entregado', 'domicilio'),
(3, '2024-11-15 14:20:00', 'transferencia', 95200, 2, 'entregado', 'local'),
(4, '2024-11-20 19:30:00', 'wallet', 33320, 1, 'entregado', 'llevar'),
-- Pedidos del mes actual (diciembre) - Cliente frecuente: Juan Pérez (id:1)
(1, '2024-12-01 13:00:00', 'efectivo', 71400, 1, 'entregado', 'domicilio'),
(1, '2024-12-03 19:15:00', 'tarjeta', 44625, 2, 'entregado', 'domicilio'),
(1, '2024-12-05 20:30:00', 'efectivo', 39270, 1, 'entregado', 'llevar'),
(1, '2024-12-08 12:45:00', 'wallet', 35700, 3, 'entregado', 'domicilio'),
(1, '2024-12-10 18:00:00', 'tarjeta', 53550, 1, 'entregado', 'local'),
(1, '2024-12-12 21:00:00', 'efectivo', 68500, 2, 'entregado', 'domicilio'),
-- Cliente frecuente: María García (id:2)
(2, '2024-12-02 14:30:00', 'tarjeta', 71400, 1, 'entregado', 'domicilio'),
(2, '2024-12-04 19:45:00', 'efectivo', 33320, 2, 'entregado', 'llevar'),
(2, '2024-12-06 13:15:00', 'wallet', 44625, 1, 'entregado', 'domicilio'),
(2, '2024-12-09 20:00:00', 'tarjeta', 57120, 3, 'entregado', 'local'),
(2, '2024-12-11 17:30:00', 'efectivo', 39270, 1, 'entregado', 'domicilio'),
(2, '2024-12-13 19:00:00', 'tarjeta', 68500, 2, 'entregado', 'domicilio'),
-- Otros clientes del mes actual
(3, '2024-12-01 15:00:00', 'transferencia', 95200, 2, 'entregado', 'local'),
(4, '2024-12-02 20:30:00', 'wallet', 35700, 1, 'entregado', 'domicilio'),
(5, '2024-12-03 12:00:00', 'efectivo', 106904, 2, 'entregado', 'domicilio'),
(6, '2024-12-05 18:30:00', 'tarjeta', 29750, 1, 'entregado', 'llevar'),
(7, '2024-12-07 19:45:00', 'efectivo', 82110, 3, 'entregado', 'domicilio'),
(8, '2024-12-09 14:15:00', 'wallet', 23800, 1, 'entregado', 'local'),
(9, '2024-12-11 20:00:00', 'tarjeta', 57120, 2, 'entregado', 'domicilio'),
-- Pedidos pendientes (para probar triggers)
(10, NOW(), 'efectivo', 71400, 1, 'pendiente', 'domicilio'),
(11, NOW(), 'tarjeta', 44625, 2, 'en preparación', 'domicilio');

-- ========================================
-- 10. Insertar detalle_pedido_item
-- ========================================
INSERT INTO detalle_pedido_item (pedido_id, pizza_id, cantidad, precio_unitario, subtotal) VALUES
-- Pedido 1
(1, 2, 1, 35000, 35000), (1, 1, 1, 25000, 25000),
-- Pedido 2
(2, 5, 1, 45000, 45000),
-- Pedido 3
(3, 6, 2, 40000, 80000),
-- Pedido 4
(4, 3, 1, 28000, 28000),
-- Pedido 5
(5, 4, 2, 32000, 64000),
-- Pedido 6
(6, 5, 1, 45000, 45000),
-- Pedido 7
(7, 3, 1, 28000, 28000), (7, 1, 1, 25000, 25000),
-- Pedido 8
(8, 1, 1, 25000, 25000), (8, 9, 1, 20000, 20000),
-- Pedido 9
(9, 5, 1, 45000, 45000),
-- Pedido 10
(10, 4, 2, 32000, 64000),
-- Pedido 11
(11, 2, 2, 35000, 70000),
-- Pedido 12
(12, 3, 1, 28000, 28000),
-- Pedido 13
(13, 5, 1, 45000, 45000),
-- Pedido 14
(14, 6, 1, 40000, 40000), (14, 1, 1, 25000, 25000),
-- Pedido 15
(15, 7, 1, 38000, 38000),
-- Pedido 16
(16, 1, 1, 25000, 25000), (16, 9, 1, 20000, 20000),
-- Pedido 17
(17, 6, 2, 40000, 80000),
-- Pedido 18
(18, 1, 1, 25000, 25000), (18, 3, 1, 28000, 28000),
-- Pedido 19
(19, 10, 2, 48000, 96000),
-- Pedido 20
(20, 1, 1, 25000, 25000),
-- Pedido 21
(21, 8, 2, 30000, 60000), (21, 7, 1, 38000, 38000),
-- Pedido 22
(22, 9, 1, 20000, 20000),
-- Pedido 23
(23, 6, 1, 40000, 40000), (23, 4, 1, 32000, 32000),
-- Pedido 24 (pendiente)
(24, 4, 2, 32000, 64000),
-- Pedido 25 (en preparación)
(25, 5, 1, 45000, 45000);

-- ========================================
-- 11. Insertar Domicilios (solo pedidos tipo domicilio)
-- ========================================
INSERT INTO Domicilios (zona_id, domiciliario_id, pedido_id, hora_salida, hora_entrega, distancia_km, costo_envio) VALUES
(1, 1, 1, '12:45:00', '13:15:00', 3.5, 8500),
(2, 2, 2, '19:00:00', '19:35:00', 4.2, 11040),
(1, 1, 5, '13:15:00', '13:45:00', 2.8, 7800),
(3, 3, 6, '19:30:00', '19:55:00', 3.0, 6400),
(4, 4, 8, '13:00:00', '13:30:00', 4.5, 10450),
(1, 1, 10, '21:15:00', '21:45:00', 3.2, 8200),
(2, 2, 11, '14:45:00', '15:20:00', 5.0, 12000),
(3, 3, 13, '13:30:00', '14:00:00', 2.5, 6000),
(1, 1, 15, '20:15:00', '20:40:00', 3.8, 8800),
(4, 4, 18, '20:30:00', '21:10:00', 6.0, 12100),
(2, 2, 21, '20:00:00', '20:35:00', 4.8, 11760),
(3, 3, 23, '20:15:00', '20:50:00', 5.5, 11000),
-- Domicilios pendientes (sin hora_entrega para probar triggers)
(1, 1, 24, '20:30:00', NULL, 3.0, 8000),
(2, 2, 25, '19:45:00', NULL, 3.5, 10200);

-- ========================================
-- 12. Insertar pagos
-- ========================================
INSERT INTO pagos (id_pedido, metodo, referencia, fecha_pago) VALUES
(1, 'efectivo', NULL, '2024-11-05 13:15:00'),
(2, 'tarjeta', 'TRX-2024-001', '2024-11-10 19:35:00'),
(3, 'transferencia', 'TRANS-2024-045', '2024-11-15 14:20:00'),
(4, 'wallet', 'NEQUI-789456', '2024-11-20 19:30:00'),
(5, 'efectivo', NULL, '2024-12-01 13:45:00'),
(6, 'tarjeta', 'TRX-2024-002', '2024-12-03 19:55:00'),
(7, 'efectivo', NULL, '2024-12-05 20:30:00'),
(8, 'wallet', 'NEQUI-123789', '2024-12-08 13:30:00'),
(9, 'tarjeta', 'TRX-2024-003', '2024-12-10 18:00:00'),
(10, 'efectivo', NULL, '2024-12-12 21:45:00'),
(11, 'tarjeta', 'TRX-2024-004', '2024-12-02 15:20:00'),
(12, 'efectivo', NULL, '2024-12-04 19:45:00'),
(13, 'wallet', 'NEQUI-456123', '2024-12-06 14:00:00'),
(14, 'tarjeta', 'TRX-2024-005', '2024-12-09 20:00:00'),
(15, 'efectivo', NULL, '2024-12-11 20:40:00'),
(16, 'tarjeta', 'TRX-2024-006', '2024-12-13 21:10:00'),
(17, 'transferencia', 'TRANS-2024-046', '2024-12-01 15:00:00'),
(18, 'wallet', 'NEQUI-789123', '2024-12-02 21:10:00'),
(19, 'efectivo', NULL, '2024-12-03 12:00:00'),
(20, 'tarjeta', 'TRX-2024-007', '2024-12-05 18:30:00'),
(21, 'efectivo', NULL, '2024-12-07 20:35:00'),
(22, 'wallet', 'NEQUI-321456', '2024-12-09 14:15:00'),
(23, 'tarjeta', 'TRX-2024-008', '2024-12-11 20:50:00');

-- ========================================
-- 13. Insertar costo_pedido
-- ========================================
INSERT INTO costo_pedido (pedido_id, costo_total_ingredientes, costo_real_envio, total_costos) VALUES
(1, 15000, 8500, 23500),
(2, 18000, 11040, 29040),
(3, 25000, 0, 25000),
(4, 10000, 0, 10000),
(5, 22000, 7800, 29800),
(6, 18000, 6400, 24400),
(7, 13000, 0, 13000),
(8, 11000, 10450, 21450),
(9, 18000, 0, 18000),
(10, 22000, 8200, 30200),
(11, 23000, 12000, 35000),
(12, 10000, 0, 10000),
(13, 18000, 6000, 24000),
(14, 20000, 0, 20000),
(15, 14000, 8800, 22800),
(16, 11000, 0, 11000),
(17, 25000, 0, 25000),
(18, 13000, 12100, 25100),
(19, 30000, 0, 30000),
(20, 8000, 0, 8000),
(21, 24000, 11760, 35760),
(22, 6000, 0, 6000),
(23, 23000, 11000, 34000),
(24, 22000, 8000, 30000),
(25, 18000, 10200, 28200);

-- ========================================
-- 14. Insertar historial_precios (cambios de precio)
-- ========================================
INSERT INTO historial_precios (id_pizza, precio_antiguo, precio_nuevo, fecha_actualizacion) VALUES
(1, 23000, 25000, '2024-11-01 10:00:00'),
(2, 32000, 35000, '2024-11-01 10:00:00'),
(5, 42000, 45000, '2024-11-15 09:00:00'),
(7, 35000, 38000, '2024-11-20 08:30:00'),
(10, 45000, 48000, '2024-12-01 09:00:00');





-- ================================= 35
-- Consultas de verificación
-- =================================

-- uso
use pizzeria_piccolo_db;


-- Verificar datos insertados
SELECT 'Personas' as Tabla, COUNT(*) as Total FROM Personas
UNION ALL
SELECT 'Clientes', COUNT(*) FROM Clientes
UNION ALL
SELECT 'Pedidos', COUNT(*) FROM Pedidos
UNION ALL
SELECT 'Pizzas', COUNT(*) FROM Pizzas
UNION ALL
SELECT 'Ingredientes', COUNT(*) FROM Ingredientes;

-- Consulta de ejemplo: Pedidos con detalles
SELECT 
    p.id as pedido_id,
    per.nombre as cliente,
    pz.nombre_pizza,
    d.cantidad,
    d.subtotal,
    p.total_pedido
FROM Pedidos p
JOIN Clientes c ON p.cliente_id = c.id
JOIN Personas per ON c.persona_id = per.id
JOIN detalle_pedido_item d ON p.id = d.pedido_id
JOIN Pizzas pz ON d.pizza_id = pz.id
ORDER BY p.id;

-- Revisión de inserción de la tabla Personas
SELECT * FROM Personas;

-- Revisión de inserción de la tabla Clientes
SELECT * FROM Clientes;

-- Revisión de inserción de la tabla users
SELECT * FROM users;

-- Revisión de inserción de la tabla Zonas
SELECT * FROM Zonas;

-- Revisión de inserción de la tabla Domiciliarios
SELECT * FROM Domiciliarios;

-- Revisión de inserción de la tabla Pedidos
SELECT * FROM Pedidos;

-- Revisión de inserción de la tabla Domicilios
SELECT * FROM Domicilios;

-- Revisión de inserción de la tabla Pizzas
SELECT * FROM Pizzas;

-- Revisión de inserción de la tabla Ingredientes
SELECT * FROM Ingredientes;

-- Revisión de inserción de la tabla pizza_ingrediente
SELECT * FROM pizza_ingrediente;

-- Revisión de inserción de la tabla detalle_pedido_item
SELECT * FROM detalle_pedido_item;

-- Revisión de inserción de la tabla pagos
SELECT * FROM pagos;

-- Revisión de inserción de la tabla costo_pedido
SELECT * FROM costo_pedido;

-- Revisión de inserción de la tabla historial_precios
SELECT * FROM historial_precios;
