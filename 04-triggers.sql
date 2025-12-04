-- ================================= 35
-- Triggers
-- =================================

-- uso de la base de datos
use pizzeria_piccolo_db;

DELIMITER //
-- 1. Trigger de actualización automática del stock de ingredientes cuando se realiza un pedido
DROP TRIGGER IF EXISTS trg_actualizar_stock_pedido//

CREATE TRIGGER trg_actualizar_stock_pedido
AFTER INSERT ON detalle_pedido_item
FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_ingrediente_id INT;
    DECLARE v_cantidad_necesaria DOUBLE;
    
    DECLARE cur CURSOR FOR
        SELECT pi.ingrediente_id, (pi.cantidad * NEW.cantidad) AS cantidad_total
        FROM pizza_ingrediente pi
        WHERE pi.pizzas_id = NEW.pizza_id;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO v_ingrediente_id, v_cantidad_necesaria;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Descontar del stock
        UPDATE Ingredientes
        SET stock = stock - v_cantidad_necesaria
        WHERE id_ingrediente = v_ingrediente_id;
    END LOOP;
    
    CLOSE cur;
END//




-- 2. Trigger de auditoría que registra el historial de precios en la tabla historial_precios
-- cada vez que se modifique el precio de una pizza.
DROP TRIGGER IF EXISTS trg_historial_precios//

CREATE TRIGGER trg_historial_precios
BEFORE UPDATE ON Pizzas
FOR EACH ROW
BEGIN
    IF OLD.precio_base != NEW.precio_base THEN
        INSERT INTO historial_precios (id_pizza, precio_antiguo, precio_nuevo)
        VALUES (OLD.id, OLD.precio_base, NEW.precio_base);
    END IF;
END//





-- 3. Trigger para marcar repartidor como "disponible" nuevamente cuando termine el domicilio.
DROP TRIGGER IF EXISTS trg_liberar_domiciliario //

CREATE TRIGGER trg_liberar_domiciliario
AFTER UPDATE ON Domicilios
FOR EACH ROW
BEGIN
    IF NEW.hora_entrega IS NOT NULL AND OLD.hora_entrega IS NULL THEN
        UPDATE Domiciliarios
        SET estado = 'disponible'
        WHERE id = NEW.domiciliario_id;
    END IF;
END //


-- Validar stock antes de insertar pedido
DROP TRIGGER IF EXISTS trg_validar_stock_antes_pedido //

CREATE TRIGGER trg_validar_stock_antes_pedido
BEFORE INSERT ON detalle_pedido_item
FOR EACH ROW
BEGIN
    DECLARE v_ingrediente_id INT;
    DECLARE v_stock_actual DOUBLE;
    DECLARE v_cantidad_necesaria DOUBLE;
    DECLARE v_ingrediente_nombre VARCHAR(50);
    DECLARE v_mensaje_error VARCHAR(255);
    DECLARE done INT DEFAULT FALSE;
    
    DECLARE cur CURSOR FOR
        SELECT pi.ingrediente_id, i.stock, (pi.cantidad * NEW.cantidad) AS cantidad_necesaria, i.nombre
        FROM pizza_ingrediente pi
        INNER JOIN Ingredientes i ON pi.ingrediente_id = i.id_ingrediente
        WHERE pi.pizzas_id = NEW.pizza_id;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    
    check_loop: LOOP
        FETCH cur INTO v_ingrediente_id, v_stock_actual, v_cantidad_necesaria, v_ingrediente_nombre;
        IF done THEN
            LEAVE check_loop;
        END IF;
        
        IF v_stock_actual < v_cantidad_necesaria THEN
            SET v_mensaje_error = CONCAT('Stock insuficiente de: ', v_ingrediente_nombre);
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = v_mensaje_error;
        END IF;
    END LOOP;
    
    CLOSE cur;
END //


-- Ocupar domiciliario al asignar pedido
DROP TRIGGER IF EXISTS trg_ocupar_domiciliario //

CREATE TRIGGER trg_ocupar_domiciliario
AFTER INSERT ON Domicilios
FOR EACH ROW
BEGIN
    UPDATE Domiciliarios
    SET estado = 'ocupado'
    WHERE id = NEW.domiciliario_id;
END //


-- Calcular costos del pedido
DROP TRIGGER IF EXISTS trg_calcular_costos_pedido //

CREATE TRIGGER trg_calcular_costos_pedido
AFTER INSERT ON detalle_pedido_item
FOR EACH ROW
BEGIN
    DECLARE v_costo_ingredientes DOUBLE DEFAULT 0;
    DECLARE v_costo_envio DOUBLE DEFAULT 0;
    DECLARE v_existe_costo INT;
    
    -- Calcular costo de ingredientes
    SELECT SUM(i.costo_unitario * pi.cantidad * NEW.cantidad)
    INTO v_costo_ingredientes
    FROM pizza_ingrediente pi
    INNER JOIN Ingredientes i ON pi.ingrediente_id = i.id_ingrediente
    WHERE pi.pizzas_id = NEW.pizza_id;
    
    -- Obtener costo de envío si existe
    SELECT COALESCE(costo_envio, 0)
    INTO v_costo_envio
    FROM Domicilios
    WHERE pedido_id = NEW.pedido_id;
    
    -- Verificar si ya existe registro de costo
    SELECT COUNT(*)
    INTO v_existe_costo
    FROM costo_pedido
    WHERE pedido_id = NEW.pedido_id;
    
    IF v_existe_costo = 0 THEN
        INSERT INTO costo_pedido (pedido_id, costo_total_ingredientes, costo_real_envio, total_costos)
        VALUES (NEW.pedido_id, v_costo_ingredientes, v_costo_envio, v_costo_ingredientes + v_costo_envio);
    ELSE
        UPDATE costo_pedido
        SET costo_total_ingredientes = costo_total_ingredientes + v_costo_ingredientes,
            total_costos = costo_total_ingredientes + v_costo_ingredientes + costo_real_envio
        WHERE pedido_id = NEW.pedido_id;
    END IF;
END //

DELIMITER ;