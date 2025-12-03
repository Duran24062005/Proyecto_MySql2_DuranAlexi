-- ================================= 35
-- Funciones y Procedimeintos
-- =================================

-- uso de la base de datos
use pizzeria_piccolo_db;

-- Función para calcular el total de un pedido (Sumando precio de pizzas + costo envio + iva)
DELIMITER //
CREATE FUNCTION calcular_total_pedido()
BEGIN
END ; //

DELIMITER ;



-- Función para calcular la ganancia neta diaria (ventas - costo de ingredientes)
DELIMITER //
CREATE FUNCTION calcular_ganacia_neta_diaria()
BEGIN
END ; //

DELIMITER ;




DELIMITER //
CREATE FUNCTION calcular_costo_envio()
BEGIN
END ; //

DELIMITER ;



-- Procedimeinto para cambiar automáticamente el estado del pedido a "entregado" 
-- cuando se registre la hora de entrega
DELIMITER //
CREATE PROCEDURE cambiar_estado_pedido()
BEGIN
END ; //

DELIMITER ;