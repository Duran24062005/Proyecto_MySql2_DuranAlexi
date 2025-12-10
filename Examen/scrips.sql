-- ================================= 35
-- Scripts del Examen 10-12-2025 - MySql2
-- =================================
use pizzeria_piccolo_db;

-- Consulta de entregas realizadas por cada repartidor
-- Mostrar el nombre del repartidor, cantidad de entregas realizadas (estado='entregado'), y total acumulado de pedidos entregados.
SELECT
    d.id AS domiciliario_id,
    per.nombre AS repartidor,
    COUNT(dom.id) AS total_entregas
FROM
    Domiciliarios d
    JOIN Personas per ON d.persona_id = per.id
    JOIN Domicilios dom ON d.id = dom.domiciliario_id
    JOIN Pedidos p ON d.id = p.id
WHERE
    p.estado = 'entregado'
GROUP BY
    d.id,
    per.nombre
ORDER BY total_entregas DESC;

-- Consulta de pedidos demorados
-- Mostrar los pedidos cuya entrega tomó más de 40 minutos entre hora_salida y hora_entrega
--  (Usa TIMESTAMPDIFF(MINUTE, hora_salida, hora_entrega) > 40).

SELECT *, (
        TIMESTAMPDIFF (
            MINUTE, d.hora_salida, d.hora_entrega
        ) > 40
    )
FROM Pedidos p
    JOIN Domicilios d;

-- Consulta de repartidores activos sin entregas
-- Mostrar los repartidores con estado 'activo' que no tienen domicilios asignados (usa LEFT JOIN y WHERE domicilio.id_domicilio IS NULL).
SELECT *
FROM Domiciliarios d
    JOIN Domicilios do ON d.id = do.domiciliario_id
WHERE
    d.estado = 'disponible';

-- Vista resumen de desempeño
-- Crear una vista vista_desempeno_repartidor que muestre:
-- nombre_repartidor
-- entregas_totales
-- promedio_minutos_entrega