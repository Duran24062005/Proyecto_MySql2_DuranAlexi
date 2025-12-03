-- ================================= 35
-- Vistas
-- =================================



-- uso de la base de datos
use pizzeria_piccolo_db;


-- 1. Vista de resumen de pedidos por cliente (nombre del cliente, cantidad de pedidos, total gastado).
DROP VIEW IF EXISTS vista_resumen_clientes;

CREATE VIEW vista_resumen_clientes AS
SELECT 
    c.id AS cliente_id,
    p.nombre AS nombre_cliente,
    p.telefono,
    p.correo,
    COUNT(ped.id) AS cantidad_pedidos,
    COALESCE(SUM(ped.total_pedido), 0) AS total_gastado,
    COALESCE(AVG(ped.total_pedido), 0) AS ticket_promedio,
    MAX(ped.fecha_pedido) AS ultima_compra
FROM Clientes c
INNER JOIN Personas p ON c.persona_id = p.id
LEFT JOIN Pedidos ped ON c.id = ped.cliente_id AND ped.estado != 'cancelado'
GROUP BY c.id, p.nombre, p.telefono, p.correo;





-- 2. Vista de desempeño de repartidores (número de entregas, tiempo promedio, zona)
DROP VIEW IF EXISTS vista_desempeno_domiciliarios;

CREATE VIEW vista_desempeno_domiciliarios AS
SELECT 
    d.id AS domiciliario_id,
    p.nombre AS nombre_domiciliario,
    z.nombre_zona AS zona_asignada,
    COUNT(dom.id) AS total_entregas,
    COALESCE(AVG(TIMESTAMPDIFF(MINUTE, dom.hora_salida, dom.hora_entrega)), 0) AS tiempo_promedio_entrega,
    COALESCE(SUM(dom.distancia_km), 0) AS kilometros_recorridos,
    COALESCE(SUM(dom.costo_envio), 0) AS ingresos_envios,
    d.estado AS estado_actual
FROM Domiciliarios d
INNER JOIN Personas p ON d.persona_id = p.id
INNER JOIN Zonas z ON d.zona_asignada = z.id_zona
LEFT JOIN Domicilios dom ON d.id = dom.domiciliario_id
GROUP BY d.id, p.nombre, z.nombre_zona, d.estado;



-- 3. Vista de stock de ingredientes por debajo del minimo permitido
DROP VIEW IF EXISTS vista_stock_critico;

CREATE VIEW vista_stock_critico AS
SELECT 
    id_ingrediente,
    nombre AS ingrediente,
    unidad,
    stock AS stock_actual,
    stock_minimo,
    (stock_minimo - stock) AS deficit,
    ROUND((stock / stock_minimo) * 100, 2) AS porcentaje_stock,
    costo_unitario,
    ROUND((stock_minimo - stock) * costo_unitario, 2) AS costo_reposicion
FROM Ingredientes
WHERE stock <= stock_minimo
ORDER BY porcentaje_stock ASC;




-- Pizzas más vendidas
DROP VIEW IF EXISTS vista_pizzas_mas_vendidas;

CREATE VIEW vista_pizzas_mas_vendidas AS
SELECT 
    pz.id AS pizza_id,
    pz.nombre_pizza,
    pz.tamaño,
    pz.tipo_pizza,
    pz.precio_base,
    COUNT(dpi.id) AS veces_ordenada,
    SUM(dpi.cantidad) AS unidades_vendidas,
    SUM(dpi.subtotal) AS ingresos_totales,
    ROUND(AVG(dpi.cantidad), 2) AS promedio_por_pedido
FROM Pizzas pz
INNER JOIN detalle_pedido_item dpi ON pz.id = dpi.pizza_id
INNER JOIN Pedidos p ON dpi.pedido_id = p.id
WHERE p.estado != 'cancelado'
GROUP BY pz.id, pz.nombre_pizza, pz.tamaño, pz.tipo_pizza, pz.precio_base
ORDER BY unidades_vendidas DESC;


-- Análisis de ventas por zona
DROP VIEW IF EXISTS vista_ventas_por_zona;

CREATE VIEW vista_ventas_por_zona AS
SELECT 
    z.id_zona,
    z.nombre_zona,
    COUNT(DISTINCT dom.pedido_id) AS total_pedidos,
    COALESCE(SUM(p.total_pedido), 0) AS ventas_totales,
    COALESCE(AVG(p.total_pedido), 0) AS ticket_promedio,
    COALESCE(SUM(dom.distancia_km), 0) AS kilometros_totales,
    COALESCE(AVG(dom.distancia_km), 0) AS distancia_promedio,
    COALESCE(AVG(TIMESTAMPDIFF(MINUTE, dom.hora_salida, dom.hora_entrega)), 0) AS tiempo_entrega_promedio,
    z.costo_base_envio,
    z.costo_por_km,
    z.estado AS zona_activa
FROM Zonas z
LEFT JOIN Domicilios dom ON z.id_zona = dom.zona_id
LEFT JOIN Pedidos p ON dom.pedido_id = p.id AND p.estado != 'cancelado'
GROUP BY z.id_zona, z.nombre_zona, z.costo_base_envio, z.costo_por_km, z.estado;


-- Clientes frecuentes
DROP VIEW IF EXISTS vista_clientes_frecuentes;

CREATE VIEW vista_clientes_frecuentes AS
SELECT 
    c.id AS cliente_id,
    p.nombre,
    p.telefono,
    p.correo,
    COUNT(ped.id) AS pedidos_mes_actual,
    SUM(ped.total_pedido) AS total_gastado_mes,
    'Frecuente' AS clasificacion
FROM Clientes c
INNER JOIN Personas p ON c.persona_id = p.id
INNER JOIN Pedidos ped ON c.id = ped.cliente_id
WHERE ped.estado != 'cancelado'
AND MONTH(ped.fecha_pedido) = MONTH(CURDATE())
AND YEAR(ped.fecha_pedido) = YEAR(CURDATE())
GROUP BY c.id, p.nombre, p.telefono, p.correo
HAVING COUNT(ped.id) > 5
ORDER BY pedidos_mes_actual DESC;


-- Rentabilidad por pedido
DROP VIEW IF EXISTS vista_rentabilidad_pedidos;

CREATE VIEW vista_rentabilidad_pedidos AS
SELECT 
    p.id AS pedido_id,
    p.fecha_pedido,
    per.nombre AS cliente,
    p.total_pedido AS ingreso_total,
    cp.total_costos AS costo_total,
    (p.total_pedido - cp.total_costos) AS ganancia_neta,
    ROUND(((p.total_pedido - cp.total_costos) / p.total_pedido) * 100, 2) AS margen_porcentaje,
    p.tipo_pedido,
    p.estado
FROM Pedidos p
INNER JOIN Clientes c ON p.cliente_id = c.id
INNER JOIN Personas per ON c.persona_id = per.id
LEFT JOIN costo_pedido cp ON p.id = cp.pedido_id
WHERE p.estado != 'cancelado'
ORDER BY p.fecha_pedido DESC;