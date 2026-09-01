-- 01_SCHEMAS.SQL
CREATE DATABASE campuseventos;
\c campuseventos;

CREATE TABLE empresas (
    id_empresa SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE salas (
    id_sala SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    capacidad INT NOT NULL CHECK (capacidad > 0),
    ubicacion VARCHAR(100)
);

CREATE TABLE ponentes (
    id_ponente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    empresa_id INT REFERENCES empresas(id_empresa) ON DELETE SET NULL
);

CREATE TABLE asistentes (
    id_asistente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    empresa_id INT REFERENCES empresas(id_empresa) ON DELETE SET NULL
);

CREATE TABLE recursos (
    id_recurso SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT
);

CREATE TABLE eventos (
    id_evento SERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    titulo VARCHAR(150) NOT NULL,
    tipo_evento VARCHAR(20) NOT NULL CHECK (tipo_evento IN ('jornada', 'taller', 'congreso', 'webinar')),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'borrador' 
        CHECK (estado IN ('borrador', 'abierto', 'cerrado', 'cancelado', 'finalizado')),
    CONSTRAINT chk_fechas_evento CHECK (fecha_fin >= fecha_inicio)
);

CREATE TABLE sesiones (
    id_sesion SERIAL PRIMARY KEY,
    evento_id INT NOT NULL REFERENCES eventos(id_evento) ON DELETE CASCADE,
    sala_id INT NOT NULL REFERENCES salas(id_sala) ON DELETE RESTRICT,
    titulo VARCHAR(150) NOT NULL,
    fecha_hora TIMESTAMP NOT NULL,
    duracion_minutos INT NOT NULL CHECK (duracion_minutos > 0),
    aforo_max INT CHECK (aforo_max > 0),
    estado VARCHAR(20) NOT NULL DEFAULT 'programada' 
        CHECK (estado IN ('programada', 'realizada', 'cancelada'))
);

CREATE TABLE inscripciones (
    id_inscripcion SERIAL PRIMARY KEY,
    evento_id INT NOT NULL REFERENCES eventos(id_evento) ON DELETE CASCADE,
    asistente_id INT NOT NULL REFERENCES asistentes(id_asistente) ON DELETE CASCADE,
    tipo_entrada VARCHAR(20) NOT NULL CHECK (tipo_entrada IN ('general', 'reducida', 'vip', 'taller')),
    fecha_inscripcion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    importe_final NUMERIC(10,2) NOT NULL CHECK (importe_final >= 0),
    estado VARCHAR(20) NOT NULL DEFAULT 'preinscrita' 
        CHECK (estado IN ('preinscrita', 'confirmada', 'cancelada', 'asistida')),
    CONSTRAINT uq_evento_asistente UNIQUE (evento_id, asistente_id)
);

CREATE TABLE pagos (
    id_pago SERIAL PRIMARY KEY,
    inscripcion_id INT NOT NULL UNIQUE REFERENCES inscripciones(id_inscripcion) ON DELETE CASCADE,
    fecha_pago TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    monto NUMERIC(10,2) NOT NULL CHECK (monto >= 0),
    metodo_pago VARCHAR(30) DEFAULT 'tarjeta',
    estado VARCHAR(20) NOT NULL DEFAULT 'pendiente' 
        CHECK (estado IN ('pendiente', 'pagado', 'devuelto'))
);

CREATE TABLE certificados (
    id_certificado SERIAL PRIMARY KEY,
    inscripcion_id INT NOT NULL UNIQUE REFERENCES inscripciones(id_inscripcion) ON DELETE CASCADE,
    codigo_verificacion VARCHAR(50) NOT NULL UNIQUE,
    fecha_emision TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sesion_ponente (
    sesion_id INT NOT NULL REFERENCES sesiones(id_sesion) ON DELETE CASCADE,
    ponente_id INT NOT NULL REFERENCES ponentes(id_ponente) ON DELETE CASCADE,
    PRIMARY KEY (sesion_id, ponente_id)
);

CREATE TABLE sesion_recurso (
    sesion_id INT NOT NULL REFERENCES sesiones(id_sesion) ON DELETE CASCADE,
    recurso_id INT NOT NULL REFERENCES recursos(id_recurso) ON DELETE CASCADE,
    cantidad INT NOT NULL DEFAULT 1 CHECK (cantidad > 0),
    PRIMARY KEY (sesion_id, recurso_id)
);