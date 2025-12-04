-- ================================= 35
-- Consultas Sql requeridas
-- =================================



-- uso de la base de datos
use pizzeria_piccolo_db;


-- 1. Clientes con pedidos enmtre dos fechas (BETWEEN)
SELECT 
    p.id AS pedido_id,
    per.nombre AS cliente,
    per.telefono,
    per.correo,
    p.fecha_pedido,
    p.total_pedido,
    p.estado,
    p.tipo_pedido,
    p.metodo_pago
FROM Pedidos p
INNER JOIN Clientes c ON p.cliente_id = c.id
INNER JOIN Personas per ON c.persona_id = per.id
WHERE p.fecha_pedido BETWEEN '2024-12-01' AND '2024-12-31'
ORDER BY p.fecha_pedido DESC;

-- Versión con resumen por cliente
SELECT 
    per.nombre AS cliente,
    per.telefono,
    COUNT(p.id) AS total_pedidos,
    SUM(p.total_pedido) AS total_gastado,
    MIN(p.fecha_pedido) AS primera_compra,
    MAX(p.fecha_pedido) AS ultima_compra
FROM Pedidos p
INNER JOIN Clientes c ON p.cliente_id = c.id
INNER JOIN Personas per ON c.persona_id = per.id
WHERE p.fecha_pedido BETWEEN '2024-12-01' AND '2024-12-31'
GROUP BY per.nombre, per.telefono
ORDER BY total_gastado DESC;





-- 2. Pizzas más vendidas (GROUP BY y COUNT)
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

-- Top 5 pizzas más vendidas
SELECT 
    pz.nombre_pizza,
    pz.tamaño,
    SUM(dpi.cantidad) AS unidades_vendidas,
    SUM(dpi.subtotal) AS ingresos_generados
FROM Pizzas pz
INNER JOIN detalle_pedido_item dpi ON pz.id = dpi.pizza_id
INNER JOIN Pedidos p ON dpi.pedido_id = p.id
WHERE p.estado != 'cancelado'
GROUP BY pz.nombre_pizza, pz.tamaño
ORDER BY unidades_vendidas DESC
LIMIT 5;





-- 3. Pedidos por repartidor (JOIN)
SELECT 
    d.id AS domiciliario_id,
    per.nombre AS repartidor,
    z.nombre_zona AS zona_asignada,
    COUNT(dom.id) AS total_entregas,
    SUM(dom.costo_envio) AS ingresos_envios,
    ROUND(AVG(dom.distancia_km), 2) AS distancia_promedio,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, dom.hora_salida, dom.hora_entrega)), 2) AS tiempo_promedio_min,
    d.estado AS estado_actual
FROM Domiciliarios d
INNER JOIN Personas per ON d.persona_id = per.id
INNER JOIN Zonas z ON d.zona_asignada = z.id_zona
LEFT JOIN Domicilios dom ON d.id = dom.domiciliario_id
GROUP BY d.id, per.nombre, z.nombre_zona, d.estado
ORDER BY total_entregas DESC;

-- Detalle de pedidos por repartidor específico
SELECT 
    per.nombre AS repartidor,
    p.id AS pedido_id,
    c_per.nombre AS cliente,
    p.fecha_pedido,
    dom.hora_salida,
    dom.hora_entrega,
    dom.distancia_km,
    dom.costo_envio,
    p.total_pedido,
    TIMESTAMPDIFF(MINUTE, dom.hora_salida, dom.hora_entrega) AS tiempo_entrega_min
FROM Domiciliarios d
INNER JOIN Personas per ON d.persona_id = per.id
INNER JOIN Domicilios dom ON d.id = dom.domiciliario_id
INNER JOIN Pedidos p ON dom.pedido_id = p.id
INNER JOIN Clientes c ON p.cliente_id = c.id
INNER JOIN Personas c_per ON c.persona_id = c_per.id
WHERE d.id = 1  -- Cambiar por el ID del repartidor que desees consultar
ORDER BY p.fecha_pedido DESC;





-- 4. Promedio de entregas por zonas (AVG y JOIN)
SELECT 
    z.id_zona,
    z.nombre_zona,
    COUNT(dom.id) AS total_entregas,
    ROUND(AVG(dom.distancia_km), 2) AS distancia_promedio_km,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, dom.hora_salida, dom.hora_entrega)), 2) AS tiempo_entrega_promedio_min,
    ROUND(AVG(dom.costo_envio), 2) AS costo_envio_promedio,
    z.costo_base_envio,
    z.costo_por_km,
    z.tiempo_estim_min AS tiempo_estimado_min
FROM Zonas z
LEFT JOIN Domicilios dom ON z.id_zona = dom.zona_id
WHERE dom.hora_entrega IS NOT NULL  -- Solo domicilios completados
GROUP BY z.id_zona, z.nombre_zona, z.costo_base_envio, z.costo_por_km, z.tiempo_estim_min
ORDER BY total_entregas DESC;

-- Comparación entre tiempo estimado y real por zona
SELECT 
    z.nombre_zona,
    z.tiempo_estim_min AS tiempo_estimado,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, dom.hora_salida, dom.hora_entrega)), 2) AS tiempo_real_promedio,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, dom.hora_salida, dom.hora_entrega)) - z.tiempo_estim_min, 2) AS diferencia_min,
    CASE 
        WHEN AVG(TIMESTAMPDIFF(MINUTE, dom.hora_salida, dom.hora_entrega)) <= z.tiempo_estim_min 
        THEN 'Cumple expectativa'
        ELSE 'No cumple expectativa'
    END AS evaluacion
FROM Zonas z
INNER JOIN Domicilios dom ON z.id_zona = dom.zona_id
WHERE dom.hora_entrega IS NOT NULL
GROUP BY z.nombre_zona, z.tiempo_estim_min
ORDER BY diferencia_min ASC;





-- 5. Clientes que gastarón más de un monto (HAVING)
SELECT 
    c.id AS cliente_id,
    per.nombre AS cliente,
    per.telefono,
    per.correo,
    COUNT(p.id) AS total_pedidos,
    SUM(p.total_pedido) AS total_gastado,
    ROUND(AVG(p.total_pedido), 2) AS ticket_promedio,
    MAX(p.fecha_pedido) AS ultima_compra
FROM Clientes c
INNER JOIN Personas per ON c.persona_id = per.id
INNER JOIN Pedidos p ON c.id = p.cliente_id
WHERE p.estado != 'cancelado'
GROUP BY c.id, per.nombre, per.telefono, per.correo
HAVING SUM(p.total_pedido) > 100000  -- Clientes que gastaron más de $100,000
ORDER BY total_gastado DESC;

-- Clientes VIP (más de $200,000 gastados)
SELECT 
    per.nombre AS cliente_vip,
    per.telefono,
    COUNT(p.id) AS pedidos_realizados,
    SUM(p.total_pedido) AS total_gastado,
    ROUND(AVG(p.total_pedido), 2) AS gasto_promedio_por_pedido,
    CASE 
        WHEN SUM(p.total_pedido) >= 300000 THEN 'Platinum'
        WHEN SUM(p.total_pedido) >= 200000 THEN 'Gold'
        ELSE 'Silver'
    END AS categoria_cliente
FROM Clientes c
INNER JOIN Personas per ON c.persona_id = per.id
INNER JOIN Pedidos p ON c.id = p.cliente_id
WHERE p.estado != 'cancelado'
GROUP BY c.id, per.nombre, per.telefono
HAVING SUM(p.total_pedido) > 200000
ORDER BY total_gastado DESC;





-- 6. Busqueda por coincidencia parcial de nombre de pizza (LIKE)
-- Buscar pizzas que contengan "queso" en su nombre o descripción
SELECT 
    id,
    nombre_pizza,
    tamaño,
    precio_base,
    tipo_pizza,
    descripcion,
    activo
FROM Pizzas
WHERE nombre_pizza LIKE '%queso%' 
   OR descripcion LIKE '%queso%'
ORDER BY precio_base DESC;

-- Buscar pizzas que empiecen con una letra específica (ejemplo: 'M')
SELECT 
    nombre_pizza,
    tamaño,
    precio_base,
    tipo_pizza
FROM Pizzas
WHERE nombre_pizza LIKE 'M%'
ORDER BY nombre_pizza;

-- Buscar pizzas por tipo (vegetariana o premium)
SELECT 
    nombre_pizza,
    tamaño,
    precio_base,
    tipo_pizza,
    descripcion
FROM Pizzas
WHERE tipo_pizza LIKE '%vegetariana%' 
   OR tipo_pizza LIKE '%premium%'
ORDER BY tipo_pizza, precio_base DESC;

-- Búsqueda flexible por múltiples criterios
SELECT 
    pz.nombre_pizza,
    pz.tamaño,
    pz.precio_base,
    pz.tipo_pizza,
    GROUP_CONCAT(i.nombre SEPARATOR ', ') AS ingredientes
FROM Pizzas pz
INNER JOIN pizza_ingrediente pi ON pz.id = pi.pizzas_id
INNER JOIN Ingredientes i ON pi.ingrediente_id = i.id_ingrediente
WHERE pz.nombre_pizza LIKE '%a%'  -- Pizzas con 'a' en el nombre
GROUP BY pz.id, pz.nombre_pizza, pz.tamaño, pz.precio_base, pz.tipo_pizza
ORDER BY pz.nombre_pizza;



-- 7. Subconsultas para obtener los clientes más frecuentes (más de 5 pedidos mensuales)
SELECT 
    c.id AS cliente_id,
    per.nombre AS cliente,
    per.telefono,
    per.correo,
    (
        SELECT COUNT(*) 
        FROM Pedidos p 
        WHERE p.cliente_id = c.id 
        AND MONTH(p.fecha_pedido) = MONTH(CURDATE())
        AND YEAR(p.fecha_pedido) = YEAR(CURDATE())
        AND p.estado != 'cancelado'
    ) AS pedidos_mes_actual,
    (
        SELECT SUM(p.total_pedido) 
        FROM Pedidos p 
        WHERE p.cliente_id = c.id 
        AND MONTH(p.fecha_pedido) = MONTH(CURDATE())
        AND YEAR(p.fecha_pedido) = YEAR(CURDATE())
        AND p.estado != 'cancelado'
    ) AS total_gastado_mes
FROM Clientes c
INNER JOIN Personas per ON c.persona_id = per.id
WHERE (
    SELECT COUNT(*) 
    FROM Pedidos p 
    WHERE p.cliente_id = c.id 
    AND MONTH(p.fecha_pedido) = MONTH(CURDATE())
    AND YEAR(p.fecha_pedido) = YEAR(CURDATE())
    AND p.estado != 'cancelado'
) > 5
ORDER BY pedidos_mes_actual DESC;

-- Versión alternativa con IN
SELECT 
    per.nombre AS cliente_frecuente,
    per.telefono,
    COUNT(p.id) AS pedidos_este_mes,
    SUM(p.total_pedido) AS gasto_total_mes,
    ROUND(AVG(p.total_pedido), 2) AS ticket_promedio
FROM Clientes c
INNER JOIN Personas per ON c.persona_id = per.id
INNER JOIN Pedidos p ON c.id = p.cliente_id
WHERE c.id IN (
    SELECT cliente_id
    FROM Pedidos
    WHERE MONTH(fecha_pedido) = MONTH(CURDATE())
    AND YEAR(fecha_pedido) = YEAR(CURDATE())
    AND estado != 'cancelado'
    GROUP BY cliente_id
    HAVING COUNT(*) > 5
)
AND MONTH(p.fecha_pedido) = MONTH(CURDATE())
AND YEAR(p.fecha_pedido) = YEAR(CURDATE())
AND p.estado != 'cancelado'
GROUP BY c.id, per.nombre, per.telefono
ORDER BY pedidos_este_mes DESC;

-- Clientes frecuentes con detalles de sus pizzas favoritas
SELECT 
    per.nombre AS cliente,
    COUNT(DISTINCT p.id) AS total_pedidos_mes,
    SUM(p.total_pedido) AS total_gastado,
    (
        SELECT pz.nombre_pizza
        FROM detalle_pedido_item dpi
        INNER JOIN Pizzas pz ON dpi.pizza_id = pz.id
        INNER JOIN Pedidos p2 ON dpi.pedido_id = p2.id
        WHERE p2.cliente_id = c.id
        AND MONTH(p2.fecha_pedido) = MONTH(CURDATE())
        AND YEAR(p2.fecha_pedido) = YEAR(CURDATE())
        GROUP BY pz.nombre_pizza
        ORDER BY SUM(dpi.cantidad) DESC
        LIMIT 1
    ) AS pizza_favorita
FROM Clientes c
INNER JOIN Personas per ON c.persona_id = per.id
INNER JOIN Pedidos p ON c.id = p.cliente_id
WHERE MONTH(p.fecha_pedido) = MONTH(CURDATE())
AND YEAR(p.fecha_pedido) = YEAR(CURDATE())
AND p.estado != 'cancelado'
GROUP BY c.id, per.nombre
HAVING COUNT(DISTINCT p.id) > 5
ORDER BY total_pedidos_mes DESC;


-- CONSULTAS ADICIONALES ÚTILES

-- Análisis de ventas por método de pago
SELECT 
    p.metodo_pago,
    COUNT(p.id) AS total_pedidos,
    SUM(p.total_pedido) AS ingresos_totales,
    ROUND(AVG(p.total_pedido), 2) AS ticket_promedio,
    ROUND((COUNT(p.id) * 100.0 / (SELECT COUNT(*) FROM Pedidos WHERE estado != 'cancelado')), 2) AS porcentaje_uso
FROM Pedidos p
WHERE p.estado != 'cancelado'
GROUP BY p.metodo_pago
ORDER BY ingresos_totales DESC;

-- Ventas por día de la semana
SELECT 
    DAYNAME(fecha_pedido) AS dia_semana,
    COUNT(id) AS total_pedidos,
    SUM(total_pedido) AS ventas_totales,
    ROUND(AVG(total_pedido), 2) AS ticket_promedio
FROM Pedidos
WHERE estado != 'cancelado'
GROUP BY DAYNAME(fecha_pedido), DAYOFWEEK(fecha_pedido)
ORDER BY DAYOFWEEK(fecha_pedido);

-- Ingredientes más utilizados
SELECT 
    i.nombre AS ingrediente,
    i.unidad,
    COUNT(DISTINCT pi.pizzas_id) AS pizzas_que_lo_usan,
    SUM(pi.cantidad) AS cantidad_total_recetas,
    i.stock AS stock_actual,
    i.stock_minimo,
    ROUND((i.stock / i.stock_minimo) * 100, 2) AS porcentaje_stock
FROM Ingredientes i
INNER JOIN pizza_ingrediente pi ON i.id_ingrediente = pi.ingrediente_id
GROUP BY i.id_ingrediente, i.nombre, i.unidad, i.stock, i.stock_minimo
ORDER BY pizzas_que_lo_usan DESC;