-- ================================= 35
-- Triggers
-- =================================

-- uso de la base de datos
use pizzeria_piccolo_db;

-- 1. Trigger de actualización automática del stock de ingredientes cuando se realiza un pedido
DELIMITER //
CREATE TRIGGER calcular_total_pedido
BEFORE INSERT
BEGIN
END ; //

DELIMITER ;



-- 2. Trigger de auditoría que registra el historial de precios en la tabla historial_precios
-- cada vez que se modifique el precio de una pizza.




-- 3. Trigger para marcar repartidor como "disponible" nuevamente cuando termine el domicilio.