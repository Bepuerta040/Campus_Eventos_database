-- 03_QUERIES.SQL

-- 1. Listar eventos con número de sesiones y estado
SELECT e.titulo, e.estado, COUNT(s.id_sesion) AS num_sesiones
FROM eventos e LEFT JOIN sesiones s ON e.id_evento = s.evento_id
GROUP BY e.id_evento, e.titulo, e.estado;

-- 2. Mostrar sesiones de un evento concreto con sala, fecha, duración y estado
SELECT s.titulo, sa.nombre AS sala, s.fecha_hora, s.duracion_minutos, s.estado
FROM sesiones s JOIN salas sa ON s.sala_id = sa.id_sala
WHERE s.evento_id = 1;

-- 3. Mostrar ponentes de cada sesión
SELECT s.titulo AS sesion, p.nombre AS ponente, p.email
FROM sesiones s
JOIN sesion_ponente sp ON s.id_sesion = sp.sesion_id
JOIN ponentes p ON sp.ponente_id = p.id_ponente;

-- 4. Mostrar asistentes inscritos en cada evento
SELECT e.titulo AS evento, a.nombre AS asistente, a.email, i.tipo_entrada
FROM eventos e
JOIN inscripciones i ON e.id_evento = i.evento_id
JOIN asistentes a ON i.asistente_id = a.id_asistente;

-- 5. Mostrar inscripciones pendientes de pago
SELECT i.id_inscripcion, a.nombre, e.titulo AS evento, i.importe_final
FROM inscripciones i
JOIN asistentes a ON i.asistente_id = a.id_asistente
JOIN eventos e ON i.evento_id = e.id_evento
LEFT JOIN pagos p ON i.id_inscripcion = p.inscripcion_id
WHERE p.estado = 'pendiente' OR p.id_pago IS NULL;

-- 6. Calcular ingresos pagados por evento
SELECT e.titulo, COALESCE(SUM(p.monto), 0) AS total_ingresos
FROM eventos e
JOIN inscripciones i ON e.id_evento = i.evento_id
JOIN pagos p ON i.id_inscripcion = p.inscripcion_id
WHERE p.estado = 'pagado'
GROUP BY e.id_evento, e.titulo;

-- 7. Mostrar sesiones canceladas
SELECT s.titulo, e.titulo AS evento, s.fecha_hora
FROM sesiones s JOIN eventos e ON s.evento_id = e.id_evento
WHERE s.estado = 'cancelada';

-- 8. Mostrar salas usadas en un intervalo de fechas
SELECT DISTINCT sa.nombre, sa.capacidad
FROM salas sa JOIN sesiones s ON sa.id_sala = s.sala_id
WHERE s.fecha_hora BETWEEN '2026-10-01' AND '2026-10-31';

-- 9. Mostrar eventos sin inscripciones
SELECT e.titulo, e.codigo
FROM eventos e LEFT JOIN inscripciones i ON e.id_evento = i.evento_id
WHERE i.id_inscripcion IS NULL;

-- 10. Mostrar asistentes inscritos en más de un evento
SELECT a.nombre, a.email, COUNT(i.evento_id) AS total_eventos
FROM asistentes a JOIN inscripciones i ON a.id_asistente = i.asistente_id
GROUP BY a.id_asistente, a.nombre, a.email
HAVING COUNT(i.evento_id) > 1;

-- 11. Mostrar recursos necesarios por sesión
SELECT s.titulo AS sesion, r.nombre AS recurso, sr.cantidad
FROM sesiones s
JOIN sesion_recurso sr ON s.id_sesion = sr.sesion_id
JOIN recursos r ON sr.recurso_id = r.id_recurso;

-- 12. Mostrar sesiones que usan un recurso concreto (ej. 'proyector')
SELECT s.titulo, s.fecha_hora
FROM sesiones s
JOIN sesion_recurso sr ON s.id_sesion = sr.sesion_id
JOIN recursos r ON sr.recurso_id = r.id_recurso
WHERE r.nombre = 'proyector';

-- 13. Mostrar ponentes que participan en más de una sesión
SELECT p.nombre, p.email, COUNT(sp.sesion_id) AS total_sesiones
FROM ponentes p JOIN sesion_ponente sp ON p.id_ponente = sp.ponente_id
GROUP BY p.id_ponente, p.nombre, p.email
HAVING COUNT(sp.sesion_id) > 1;

-- 14. Mostrar certificados emitidos con datos del asistente y evento
SELECT c.codigo_verificacion, a.nombre AS asistente, e.titulo AS evento, c.fecha_emision
FROM certificados c
JOIN inscripciones i ON c.inscripcion_id = i.id_inscripcion
JOIN asistentes a ON i.asistente_id = a.id_asistente
JOIN eventos e ON i.evento_id = e.id_evento;

-- 15. Mostrar inscripciones confirmadas sin certificado
SELECT i.id_inscripcion, a.nombre, e.titulo AS evento
FROM inscripciones i
JOIN asistentes a ON i.asistente_id = a.id_asistente
JOIN eventos e ON i.evento_id = e.id_evento
LEFT JOIN certificados c ON i.id_inscripcion = c.inscripcion_id
WHERE i.estado IN ('confirmada', 'asistida') AND c.id_certificado IS NULL;

-- 16. Mostrar pagos devueltos
SELECT p.id_pago, a.nombre, p.monto, p.fecha_pago
FROM pagos p
JOIN inscripciones i ON p.inscripcion_id = i.id_inscripcion
JOIN asistentes a ON i.asistente_id = a.id_asistente
WHERE p.estado = 'devuelto';

-- 17. Calcular ocupación de cada evento (confirmadas vs capacidad estimada)
SELECT e.titulo, COUNT(i.id_inscripcion) AS inscritos_confirmados
FROM eventos e
LEFT JOIN inscripciones i ON e.id_evento = i.evento_id AND i.estado IN ('confirmada', 'asistida')
GROUP BY e.id_evento, e.titulo;

-- 18. Mostrar empresas con mayor número de asistentes inscritos
SELECT emp.nombre AS empresa, COUNT(i.id_inscripcion) AS total_inscripciones
FROM empresas emp
JOIN asistentes a ON emp.id_empresa = a.empresa_id
JOIN inscripciones i ON a.id_asistente = i.asistente_id
GROUP BY emp.id_empresa, emp.nombre
ORDER BY total_inscripciones DESC;

-- 19. Mostrar sesiones programadas para una fecha concreta
SELECT titulo, fecha_hora, estado 
FROM sesiones 
WHERE DATE(fecha_hora) = '2026-10-05';

-- 20. Mostrar eventos finalizados con importe total ingresado y certificados emitidos
SELECT e.titulo, 
       COALESCE(SUM(p.monto), 0) AS total_ingresado,
       COUNT(DISTINCT c.id_certificado) AS certificados_emitidos
FROM eventos e
LEFT JOIN inscripciones i ON e.id_evento = i.evento_id
LEFT JOIN pagos p ON i.id_inscripcion = p.inscripcion_id AND p.estado = 'pagado'
LEFT JOIN certificados c ON i.id_inscripcion = c.inscripcion_id
WHERE e.estado = 'finalizado'
GROUP BY e.id_evento, e.titulo;
