-- 02_DATA.SQL
INSERT INTO empresas (nombre) VALUES 
('Datos Norte'), ('Aula Sur'), ('Independiente'), ('TechCorp');

INSERT INTO salas (nombre, capacidad, ubicacion) VALUES 
('Aula Magna', 120, 'Edificio Central'),
('Laboratorio 2', 25, 'Planta 2'),
('Auditorio', 300, 'Edificio Anexo');

INSERT INTO ponentes (nombre, email, empresa_id) VALUES 
('Ana Soler', 'ana.soler@empresa.test', 1),
('Luis Vidal', 'luis.vidal@empresa.test', 1),
('Marta Gil', 'marta.gil@empresa.test', 2),
('Eva Luna', 'eva.luna@empresa.test', 4);

INSERT INTO asistentes (nombre, email, empresa_id) VALUES 
('Laura Ruiz', 'laura@empresa.test', 1),
('Pablo Vidal', 'pablo@empresa.test', 1),
('Marta Gil', 'marta@empresa.test', 2),
('Sergio Mora', 'sergio@empresa.test', 3),
('Carlos Vega', 'carlos@empresa.test', 4);

INSERT INTO recursos (nombre, descripcion) VALUES 
('proyector', 'Proyector 4K'),
('portátil', 'Laptop de alta gama'),
('micrófono', 'Micrófono inalámbrico'),
('ordenadores', 'Equipos de laboratorio'),
('pizarra', 'Pizarra blanca'),
('sonido', 'Sistema de sonido envolvente'),
('streaming', 'Equipo de emisión en directo');

INSERT INTO eventos (codigo, titulo, tipo_evento, fecha_inicio, fecha_fin, estado) VALUES 
('EVT-SQL-2026', 'Jornada SQL Profesional', 'jornada', '2026-10-05', '2026-10-05', 'finalizado'),
('EVT-PG-2026', 'Taller PostgreSQL', 'taller', '2026-10-06', '2026-10-06', 'abierto'),
('EVT-DATA-2026', 'Congreso DataEdu', 'congreso', '2026-10-10', '2026-10-12', 'abierto'),
('EVT-WEB-2026', 'Webinar Cloud', 'webinar', '2026-11-01', '2026-11-01', 'borrador');

INSERT INTO sesiones (evento_id, sala_id, titulo, fecha_hora, duracion_minutos, aforo_max, estado) VALUES 
(1, 1, 'Normalización práctica', '2026-10-05 09:00:00', 120, 120, 'realizada'),
(1, 1, 'Consultas avanzadas', '2026-10-05 12:00:00', 120, 120, 'realizada'),
(2, 2, 'Triggers desde cero', '2026-10-06 16:00:00', 180, 25, 'programada'),
(3, 3, 'Mesa redonda IA y datos', '2026-10-10 11:00:00', 90, 300, 'programada'),
(3, 3, 'Taller Deep Learning', '2026-10-11 10:00:00', 120, 50, 'cancelada');

INSERT INTO sesion_ponente (sesion_id, ponente_id) VALUES 
(1, 1), (1, 2), (2, 2), (3, 3), (4, 4), (4, 1);

INSERT INTO sesion_recurso (sesion_id, recurso_id, cantidad) VALUES 
(1, 1, 1), (1, 2, 1), (1, 3, 2),
(2, 1, 1), (2, 2, 1),
(3, 4, 25), (3, 5, 1),
(4, 6, 1), (4, 7, 1), (4, 3, 4);

INSERT INTO inscripciones (evento_id, asistente_id, tipo_entrada, importe_final, estado) VALUES 
(1, 1, 'general', 40.00, 'asistida'),
(1, 2, 'general', 40.00, 'confirmada'),
(2, 3, 'taller', 65.00, 'confirmada'),
(2, 4, 'taller', 65.00, 'cancelada'),
(3, 1, 'vip', 120.00, 'confirmada'),
(3, 5, 'general', 80.00, 'preinscrita');

INSERT INTO pagos (inscripcion_id, monto, estado) VALUES 
(1, 40.00, 'pagado'),
(2, 40.00, 'pendiente'),
(3, 65.00, 'pagado'),
(4, 65.00, 'devuelto');

INSERT INTO certificados (inscripcion_id, codigo_verificacion) VALUES 
(1, 'CERT-SQL-2026-001');