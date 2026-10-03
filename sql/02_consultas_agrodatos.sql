-- =====================================================
-- Proyecto ABP AgroDatos - Script 2: preguntas de información
-- =====================================================

-- P1. Kilos entregados e ingreso generado por cada socio, de mayor a menor
SELECT s.nombres,
       SUM(e.kilos)                AS kilos_entregados,
       SUM(e.kilos * c.precio_kg)  AS ingreso_usd
FROM socio s
JOIN parcela p ON p.id_socio  = s.id_socio
JOIN entrega e ON e.id_parcela = p.id_parcela
JOIN cultivo c ON c.id_cultivo = e.id_cultivo
GROUP BY s.id_socio, s.nombres
ORDER BY ingreso_usd DESC;

-- P2. Producción total por cultivo y cantón
SELECT c.nombre AS cultivo, s.canton, SUM(e.kilos) AS kilos
FROM entrega e
JOIN cultivo c ON c.id_cultivo = e.id_cultivo
JOIN parcela p ON p.id_parcela = e.id_parcela
JOIN socio   s ON s.id_socio   = p.id_socio
GROUP BY c.nombre, s.canton;

-- P3. Socios con saldo pendiente (ingreso generado mayor que lo pagado)
SELECT s.nombres,
       (SELECT COALESCE(SUM(e.kilos * c.precio_kg), 0)
          FROM parcela p
          JOIN entrega e ON e.id_parcela = p.id_parcela
          JOIN cultivo c ON c.id_cultivo = e.id_cultivo
         WHERE p.id_socio = s.id_socio)
     - (SELECT COALESCE(SUM(pg.monto), 0)
          FROM pago pg
         WHERE pg.id_socio = s.id_socio) AS saldo_pendiente_usd
FROM socio s
WHERE (SELECT COALESCE(SUM(e.kilos * c.precio_kg), 0)
         FROM parcela p
         JOIN entrega e ON e.id_parcela = p.id_parcela
         JOIN cultivo c ON c.id_cultivo = e.id_cultivo
        WHERE p.id_socio = s.id_socio)
    > (SELECT COALESCE(SUM(pg.monto), 0) FROM pago pg WHERE pg.id_socio = s.id_socio);
