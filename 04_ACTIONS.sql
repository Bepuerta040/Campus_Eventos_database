-- 04_ACTIONS.SQL

-- 1. Insertar un nuevo evento en estado borrador
INSERT INTO eventos (codigo, titulo, tipo_evento, fecha_inicio, fecha_fin, estado)
VALUES ('EVT-AI-2026', 'Jornada IA Aplicada', 'jornada', '2026-11-15', '2026-11-15', 'borrador');

-- 2. Insertar dos sesiones para un evento existente
INSERT INTO sesiones (evento_id, sala_id, titulo, fecha_hora, duracion_minutos, estado) VALUES 
(4, 1, 'Introducción a LLMs', '2026-11-15 09:30:00', 90, 'programada'),
(4, 1, 'Prompt Engineering Avanzado', '2026-11-15 11:30:00', 120, 'programada');

-- 3. Asignar dos ponentes a una sesión
INSERT INTO sesion_ponente (sesion_id, ponente_id) VALUES (6, 1), (6, 4);

-- 4. Asignar varios recursos a una sesión
INSERT INTO sesion_recurso (sesion_id, recurso_id, cantidad) VALUES (6, 1, 1), (6, 3, 2);

-- 5. Insertar un nuevo asistente
INSERT INTO asistentes (nombre, email, empresa_id) 
VALUES ('Elena Gómez', 'elena@empresa.test', 4);

-- 6. Crear una inscripción confirmada para un evento
INSERT INTO inscripciones (evento_id, asistente_id, tipo_entrada, importe_final, estado)
VALUES (4, 6, 'general', 50.00, 'confirmada');

-- 7. Registrar un pago pagado para una inscripción pendiente
INSERT INTO pagos (inscripcion_id, monto, estado)
VALUES (2, 40.00, 'pagado');

-- 8. Actualizar un evento de borrador a abierto
UPDATE eventos SET estado = 'abierto' WHERE codigo = 'EVT-AI-2026';

-- 9. Cancelar una inscripción y dejar constancia en el estado
UPDATE inscripciones SET estado = 'cancelada' WHERE id_inscripcion = 6;

-- 10. Emitir un certificado para una inscripción asistida
INSERT INTO certificados (inscripcion_id, codigo_verificacion)
VALUES (1, 'CERT-SQL-2026-002');