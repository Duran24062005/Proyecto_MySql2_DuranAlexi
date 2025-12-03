-- Uso de la base de datos
use PiccoloPizzeriaDB;


-- ================================= 35
-- Inserciones de prueba
-- =================================

-- Insertar Personas
INSERT INTO Personas (nombre, telefono, correo, direccion) VALUES
('Juan Pérez', '3001234567', 'juan.perez@email.com', 'Calle 10 #20-30'),
('María García', '3107654321', 'maria.garcia@email.com', 'Carrera 15 #45-67'),
('Carlos Rodríguez', '3209876543', 'carlos.rodriguez@email.com', 'Avenida 5 #12-34'),
('Ana Martínez', '3156789012', 'ana.martinez@email.com', 'Calle 8 #90-12'),
('Luis Hernández', '3187654321', 'luis.hernandez@email.com', 'Carrera 20 #34-56'),
('Sofia López', '3001112233', 'sofia.lopez@email.com', 'Calle 25 #40-50'),
('Pedro Gómez', '3112223344', 'pedro.gomez@email.com', 'Carrera 30 #60-70');

-- Insertar Clientes
INSERT INTO Clientes (persona_id) VALUES
(1), (2), (3), (4), (5);

-- Insertar usuarios del sistema
INSERT INTO users (persona_id, email, password_hash) VALUES
(6, 'sofia.lopez@email.com', '$2y$10$abcdefghijklmnopqrstuvwxyz1234567890'),
(7, 'pedro.gomez@email.com', '$2y$10$1234567890abcdefghijklmnopqrstuvwxyz');

-- Insertar Zonas
INSERT INTO Zonas (nombre_zona, costo_base_envio, costo_por_km, tiempo_estim_min, estado) VALUES
('Norte', 5000, 1000, 20, TRUE),
('Sur', 6000, 1200, 25, TRUE),
('Centro', 4000, 800, 15, TRUE),
('Oriente', 5500, 1100, 22, TRUE),
('Occidente', 5500, 1100, 23, FALSE);

-- Insertar Domiciliarios
INSERT INTO Domiciliarios (persona_id, zona_asignada, estado) VALUES
(6, 1, 'disponible'),
(7, 2, 'disponible');

-- Insertar Ingredientes
INSERT INTO Ingredientes (nombre, unidad, costo_unitario, stock, stock_minimo) VALUES
('Harina', 'kg', 2500, 100, 20),
('Queso mozzarella', 'kg', 15000, 50, 10),
('Tomate', 'kg', 3000, 30, 5),
('Pepperoni', 'kg', 25000, 20, 5),
('Champiñones', 'kg', 8000, 15, 3),
('Pimiento', 'kg', 4000, 10, 2),
('Cebolla', 'kg', 2000, 20, 5),
('Aceitunas', 'kg', 12000, 10, 2),
('Jamón', 'kg', 18000, 15, 3),
('Piña', 'kg', 5000, 12, 3);

-- Insertar Pizzas
INSERT INTO Pizzas (nombre_pizza, tamaño, precio_base, tipo_pizza, descripcion, activo) VALUES
('Margarita', 'mediana', 25000, 'tradicional', 'Pizza clásica con tomate y queso', TRUE),
('Pepperoni', 'grande', 35000, 'tradicional', 'Pizza con pepperoni y queso', TRUE),
('Vegetariana', 'mediana', 28000, 'vegetariana', 'Pizza con champiñones, pimiento y cebolla', TRUE),
('Hawaiana', 'grande', 32000, 'especial', 'Pizza con jamón y piña', TRUE),
('Cuatro Quesos', 'familiar', 45000, 'premium', 'Pizza con cuatro tipos de queso', TRUE),
('Suprema', 'grande', 40000, 'premium', 'Pizza con todos los ingredientes', TRUE);

-- Insertar relación pizza_ingrediente
INSERT INTO pizza_ingrediente (pizzas_id, ingrediente_id, cantidad) VALUES
-- Margarita
(1, 1, 200), (1, 2, 150), (1, 3, 100),
-- Pepperoni
(2, 1, 250), (2, 2, 200), (2, 3, 120), (2, 4, 100),
-- Vegetariana
(3, 1, 200), (3, 2, 150), (3, 5, 80), (3, 6, 60), (3, 7, 50),
-- Hawaiana
(4, 1, 250), (4, 2, 200), (4, 9, 100), (4, 10, 80),
-- Cuatro Quesos
(5, 1, 300), (5, 2, 300),
-- Suprema
(6, 1, 250), (6, 2, 200), (6, 4, 80), (6, 5, 60), (6, 6, 50), (6, 7, 40), (6, 8, 30);

-- Insertar Pedidos
INSERT INTO Pedidos (cliente_id, metodo_pago, total, user_id, tipo_pedido) VALUES
(1, 'efectivo', 60000, 1, 'domicilio'),
(2, 'tarjeta', 45000, 1, 'domicilio'),
(3, 'transferencia', 80000, 2, 'local'),
(4, 'wallet', 35000, 1, 'llevar'),
(5, 'efectivo', 90000, 2, 'domicilio');

-- Insertar detalle_pedido_item
INSERT INTO detalle_pedido_item (pedido_id, pizza_id, cantidad, precio_unitario, subtotal) VALUES
(1, 2, 1, 35000, 35000),
(1, 1, 1, 25000, 25000),
(2, 5, 1, 45000, 45000),
(3, 6, 2, 40000, 80000),
(4, 3, 1, 28000, 28000),
(5, 4, 2, 32000, 64000),
(5, 1, 1, 25000, 25000);

-- Insertar Domicilios
INSERT INTO Domicilios (zona_id, domiciliario_id, pedido_id, hora_salida, hora_entrega, distancia_km, costo_envio) VALUES
(1, 1, 1, '18:30:00', '19:00:00', 3.5, 8500),
(2, 2, 2, '19:00:00', '19:35:00', 4.2, 11040),
(1, 1, 5, '20:00:00', '20:25:00', 2.8, 7800);

-- Insertar pagos
INSERT INTO pagos (id_pedido, metodo, referencia) VALUES
(1, 'efectivo', NULL),
(2, 'tarjeta', 'TRX-2024-001'),
(3, 'transferencia', 'TRANS-2024-045'),
(4, 'wallet', 'NEQUI-789456'),
(5, 'efectivo', NULL);

-- Insertar costo_pedido
INSERT INTO costo_pedido (pedido_id, costo_total_ingredientes, costo_real_envio, total_costos) VALUES
(1, 15000, 8500, 23500),
(2, 18000, 11040, 29040),
(3, 25000, 0, 25000),
(4, 10000, 0, 10000),
(5, 22000, 7800, 29800);

-- Insertar historial_precios
INSERT INTO historial_precios (id_pizza, precio_antiguo, precio_nuevo) VALUES
(1, 23000, 25000),
(2, 32000, 35000),
(5, 42000, 45000);


-- ================================= 35
-- Consultas de verificación
-- =================================

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
    p.total
FROM Pedidos p
JOIN Clientes c ON p.cliente_id = c.id
JOIN Personas per ON c.persona_id = per.id
JOIN detalle_pedido_item d ON p.id = d.pedido_id
JOIN Pizzas pz ON d.pizza_id = pz.id
ORDER BY p.id;