-- ================================= 35
-- Funciones y Procedimeintos
-- =================================

-- uso de la base de datos
use pizzeria_piccolo_db;



-- ================================= 35
-- Funciones
-- =================================

-- Función para calcular el total de un pedido (Sumando precio de pizzas + costo envio + iva)
DELIMITER //
DROP FUNCTION IF EXISTS calcular_total_pedido //

CREATE FUNCTION calcular_total_pedido(
    p_pedido_id INT
) RETURNS DOUBLE
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_subtotal DOUBLE DEFAULT 0;
    DECLARE v_costo_envio DOUBLE DEFAULT 0;
    DECLARE v_iva_pct DECIMAL(5,2);
    DECLARE v_total DOUBLE;
    
    -- Obtener el subtotal de las pizzas
    SELECT COALESCE(SUM(subtotal), 0)
    INTO v_subtotal
    FROM detalle_pedido_item
    WHERE pedido_id = p_pedido_id;
    
    -- Obtener el costo de envío si existe
    SELECT COALESCE(costo_envio, 0)
    INTO v_costo_envio
    FROM Domicilios
    WHERE pedido_id = p_pedido_id
    LIMIT 1;
    
    -- Obtener el porcentaje de IVA
    SELECT iva_pct
    INTO v_iva_pct
    FROM Pedidos
    WHERE id = p_pedido_id;
    
    -- Calcular total: (subtotal + envío) + IVA
    SET v_total = (v_subtotal + v_costo_envio) * (1 + (v_iva_pct / 100));
    
    RETURN v_total;
END ; //

DELIMITER ;



-- Función para calcular la ganancia neta diaria (ventas - costo de ingredientes)
DELIMITER //
DROP FUNCTION IF EXISTS calcular_ganacia_neta_diaria//

CREATE FUNCTION calcular_ganacia_neta_diaria(
    p_fecha DATE
) RETURNS DOUBLE
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_ventas_totales DOUBLE DEFAULT 0;
    DECLARE v_costos_totales DOUBLE DEFAULT 0;
    DECLARE v_ganancia_neta DOUBLE;
    
    -- Calcular ventas totales del día
    SELECT COALESCE(SUM(total_pedido), 0)
    INTO v_ventas_totales
    FROM Pedidos
    WHERE DATE(fecha_pedido) = p_fecha
    AND estado != 'cancelado';
    
    -- Calcular costos totales del día
    SELECT COALESCE(SUM(cp.total_costos), 0)
    INTO v_costos_totales
    FROM costo_pedido cp
    INNER JOIN Pedidos p ON cp.pedido_id = p.id
    WHERE DATE(p.fecha_pedido) = p_fecha
    AND p.estado != 'cancelado';
    
    -- Calcular ganancia neta
    SET v_ganancia_neta = v_ventas_totales - v_costos_totales;
    
    RETURN v_ganancia_neta;
END ; //

DELIMITER ;



-- Calcular costo de envió por distancia
DELIMITER //
DROP FUNCTION IF EXISTS calcular_costo_envio//

CREATE FUNCTION calcular_costo_envio(
    p_zona_id INT,
    p_distancia_km DOUBLE
) RETURNS DOUBLE
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_costo_base DOUBLE;
    DECLARE v_costo_por_km DOUBLE;
    DECLARE v_costo_total DOUBLE;
    
    -- Obtener costos de la zona
    SELECT costo_base_envio, costo_por_km
    INTO v_costo_base, v_costo_por_km
    FROM Zonas
    WHERE id_zona = p_zona_id;
    
    -- Calcular costo total
    SET v_costo_total = v_costo_base + (p_distancia_km * v_costo_por_km);
    
    RETURN v_costo_total;
END ; //

DELIMITER ;


-- Verificar disponibilidad de ingredientes
DELIMITER //
DROP FUNCTION IF EXISTS verificar_stock_ingrediente //

CREATE FUNCTION verificar_stock_ingrediente(
    p_ingrediente_id INT,
    p_cantidad_requerida DOUBLE
) RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_stock_actual DOUBLE;
    
    SELECT stock
    INTO v_stock_actual
    FROM Ingredientes
    WHERE id_ingrediente = p_ingrediente_id;
    
    RETURN v_stock_actual >= p_cantidad_requerida;
END ; //
DELIMITER ;


-- Contar pedidos de cliente en periodo
DELIMITER //
DROP FUNCTION IF EXISTS contar_pedidos_cliente //

CREATE FUNCTION contar_pedidos_cliente(
    p_cliente_id INT,
    p_fecha_inicio DATE,
    p_fecha_fin DATE
) RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_cantidad INT;
    
    SELECT COUNT(*)
    INTO v_cantidad
    FROM Pedidos
    WHERE cliente_id = p_cliente_id
    AND DATE(fecha_pedido) BETWEEN p_fecha_inicio AND p_fecha_fin
    AND estado != 'cancelado';
    
    RETURN v_cantidad;
END ; //

DELIMITER ;

SHOW FUNCTION STATUS;
SHOW FUNCTION STATUS WHERE Db = 'pizzeria_piccolo_db';


-- ================================= 35
-- Procedimeintos Almacenados
-- =================================





DELIMITER //

-- Procedimeinto para cambiar automáticamente el estado del pedido a "entregado" 
-- cuando se registre la hora de entrega
DROP PROCEDURE IF EXISTS marcar_pedido_entregado//

CREATE PROCEDURE marcar_pedido_entregado(
    IN p_pedido_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error al marcar pedido como entregado' AS mensaje;
    END;
    
    START TRANSACTION;
    
    -- Actualizar estado del pedido
    UPDATE Pedidos
    SET estado = 'entregado'
    WHERE id = p_pedido_id;
    
    -- Si es domicilio y no tiene hora de entrega, asignarla
    UPDATE Domicilios
    SET hora_entrega = CURTIME()
    WHERE pedido_id = p_pedido_id
    AND hora_entrega IS NULL;
    
    COMMIT;
    
    SELECT 'Pedido marcado como entregado exitosamente' AS mensaje;
END ; //


-- Registrar nuevo pedido completo
DROP PROCEDURE IF EXISTS registrar_pedido//

CREATE PROCEDURE registrar_pedido(
    IN p_cliente_id INT,
    IN p_metodo_pago VARCHAR(20),
    IN p_user_id INT,
    IN p_tipo_pedido VARCHAR(20),
    IN p_zona_id INT,
    IN p_distancia_km DOUBLE
)
BEGIN
    DECLARE v_pedido_id INT;
    DECLARE v_costo_envio DOUBLE DEFAULT 0;
    DECLARE v_total DOUBLE DEFAULT 0;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error al registrar pedido' AS mensaje;
    END;
    
    START TRANSACTION;
    
    -- Calcular costo de envío si es domicilio
    IF p_tipo_pedido = 'domicilio' THEN
        SET v_costo_envio = calcular_costo_envio(p_zona_id, p_distancia_km);
    END IF;
    
    -- Insertar pedido
    INSERT INTO Pedidos (cliente_id, metodo_pago, total_pedido, user_id, estado, tipo_pedido)
    VALUES (p_cliente_id, p_metodo_pago, 0, p_user_id, 'pendiente', p_tipo_pedido);
    
    SET v_pedido_id = LAST_INSERT_ID();
    
    -- Si es domicilio, crear registro de domicilio
    IF p_tipo_pedido = 'domicilio' THEN
        INSERT INTO Domicilios (zona_id, domiciliario_id, pedido_id, distancia_km, costo_envio)
        SELECT p_zona_id, id, v_pedido_id, p_distancia_km, v_costo_envio
        FROM Domiciliarios
        WHERE zona_asignada = p_zona_id AND estado = 'disponible'
        LIMIT 1;
    END IF;
    
    COMMIT;
    
    SELECT v_pedido_id AS pedido_id, 'Pedido registrado exitosamente' AS mensaje;
END ; //


-- Agregar pizza a pedido
DROP PROCEDURE IF EXISTS agregar_pizza_pedido//

CREATE PROCEDURE agregar_pizza_pedido(
    IN p_pedido_id INT,
    IN p_pizza_id INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_precio_unitario DOUBLE;
    DECLARE v_subtotal DOUBLE;
    DECLARE v_total_pedido DOUBLE;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error al agregar pizza al pedido' AS mensaje;
    END;
    
    START TRANSACTION;
    
    -- Obtener precio de la pizza
    SELECT precio_base INTO v_precio_unitario
    FROM Pizzas
    WHERE id = p_pizza_id AND activo = TRUE;
    
    -- Calcular subtotal
    SET v_subtotal = v_precio_unitario * p_cantidad;
    
    -- Insertar detalle del pedido
    INSERT INTO detalle_pedido_item (pedido_id, pizza_id, cantidad, precio_unitario, subtotal)
    VALUES (p_pedido_id, p_pizza_id, p_cantidad, v_precio_unitario, v_subtotal);
    
    -- Actualizar total del pedido
    SET v_total_pedido = calcular_total_pedido(p_pedido_id);
    
    UPDATE Pedidos
    SET total_pedido = v_total_pedido
    WHERE id = p_pedido_id;
    
    COMMIT;
    
    SELECT 'Pizza agregada al pedido exitosamente' AS mensaje;
END ; //


-- Actualizar stock ingredientes
DROP PROCEDURE IF EXISTS actualizar_stock_ingrediente//

CREATE PROCEDURE actualizar_stock_ingrediente(
    IN p_ingrediente_id INT,
    IN p_cantidad DOUBLE,
    IN p_operacion VARCHAR(10) -- 'sumar' o 'restar'
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error al actualizar stock' AS mensaje;
    END;
    
    START TRANSACTION;
    
    IF p_operacion = 'sumar' THEN
        UPDATE Ingredientes
        SET stock = stock + p_cantidad
        WHERE id_ingrediente = p_ingrediente_id;
    ELSEIF p_operacion = 'restar' THEN
        UPDATE Ingredientes
        SET stock = stock - p_cantidad
        WHERE id_ingrediente = p_ingrediente_id;
    END IF;
    
    COMMIT;
    
    SELECT 'Stock actualizado exitosamente' AS mensaje;
END ; //


-- Generar reporte ventas periodo
DROP PROCEDURE IF EXISTS reporte_ventas_periodo//

CREATE PROCEDURE reporte_ventas_periodo(
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE
)
BEGIN
    SELECT 
        DATE(p.fecha_pedido) AS fecha,
        COUNT(p.id) AS total_pedidos,
        SUM(p.total_pedido) AS ventas_totales,
        AVG(p.total_pedido) AS ticket_promedio,
        SUM(CASE WHEN p.tipo_pedido = 'domicilio' THEN 1 ELSE 0 END) AS pedidos_domicilio,
        SUM(CASE WHEN p.tipo_pedido = 'local' THEN 1 ELSE 0 END) AS pedidos_local
    FROM Pedidos p
    WHERE DATE(p.fecha_pedido) BETWEEN p_fecha_inicio AND p_fecha_fin
    AND p.estado != 'cancelado'
    GROUP BY DATE(p.fecha_pedido)
    ORDER BY fecha DESC;
END ; //

DELIMITER ;


SHOW PROCEDURE STATUS;