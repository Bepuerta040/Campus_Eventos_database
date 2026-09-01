# 🎪 CampusEventos — Diseño, Normalización y Sistema Relacional en PostgreSQL

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16+-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Data Architecture](https://img.shields.io/badge/Architecture-3FN_Normalized-00599C?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

Sistema completo de gestión y arquitectura de base de datos relacional para **CampusEventos**. El proyecto abarca desde el análisis de requerimientos y auditoría de datos iniciales desestructurados, hasta la normalización en 3FN, diseño DDL con restricciones de integridad complejas y batería de consultas analíticas (DML) y transaccionales.

---

## 📐 Technical Summary

* **Engine:** PostgreSQL 16+
* **Scope:** Gestión integral de eventos, sesiones, salas, ponentes, asistentes, inscripciones, transacciones de pago, certificados y recursos logísticos.
* **Integrity Features:** Restricciones declarativas nativas (`CHECK`, `UNIQUE`, `FOREIGN KEY`), claves compuestas y relaciones 1:1 opcionales estrictas.

---

## 📊 Normalization & Data Architecture Strategy

El modelo original consistía en una estructura desnormalizada y plana con graves anomalías de redundancia e inserción. Se aplicaron los siguientes niveles de normalización:

* **1FN (Atomicidad):** Descomposición de listas compuestas (`ponente/s`, `recursos_sesion`) en relaciones N:M mediante tablas puente (`sesion_ponente`, `sesion_recurso`).
* **2FN (Dependencia Funcional Total):** Eliminación de dependencias parciales separando las entidades principales (`eventos`, `sesiones`, `asistentes`) de los registros transaccionales de inscripción.
* **3FN (Eliminación de Transitividad):** Desacoplamiento de entidades independientes (`empresas`, `salas`) respecto a ponentes, asistentes y sesiones. Aislamiento de `pagos` y `certificados` en relaciones 1:1 opcionales.

```text
                     +-------------------+
                     |     EMPRESAS      |
                     +-------------------+
                       ^               ^
                       | (1:N)         | (1:N)
             +---------+---+       +---+-----------+
             |  PONENTES   |       |  ASISTENTES   |
             +-------------+       +---------------+
                   ^                       ^
                   | (N:M)                 | (1:N)
  +-------+   +----+-----+           +-----+---------+   +-------+   +--------------+
  | SALAS |<--| SESIONES |           | INSCRIPCIONES |<--| PAGOS |   | CERTIFICADOS |
  +-------+   +----------+           +---------------+   +-------+   +--------------+
                   |                         ^                (1:1)         (1:1)
                   v (N:M)                   | (N:1)
              +----------+           +-------+-------+
              | RECURSOS |           |    EVENTOS    |
              +----------+           +---------------+
```

---

## 📁 Repository Structure

```text
campus-eventos-database-sql/
├── sql/
│   ├── 01_schemas.sql      # Definición de tablas, PKs, FKs, CHECKs y UNIQUEs (DDL)
│   ├── 02_data.sql         # Inserción de datos maestros y transaccionales de prueba (DML)
│   ├── 03_queries.sql      # 20 Consultas complejas de selección y analítica (SELECT)
│   ├── 04_actions.sql      # 10 Consultas de acción, actualización y transacciones (DML)
│   └── 05_tests.sql        # Pruebas negativas para validación de restricciones
├── docs/
│   └── ER_Diagram.png      # Diagrama Entidad-Relación y Relacional
├── LICENSE                 # Licencia MIT
└── README.md               # Documentación principal del repositorio

```

---

## ⚡ Execution Steps

### 1. Despliegue del Esquema y Datos

Para inicializar la base de datos e importar la estructura y datos de prueba desde PostgreSQL CLI (`psql`):

```bash
# Crear la base de datos
psql -U postgres -c "CREATE DATABASE campuseventos;"

# Ejecutar tablas e integridad
psql -U postgres -d campuseventos -f sql/01_schemas.sql

# Cargar datos iniciales
psql -U postgres -d campuseventos -f sql/02_data.sql

```

### 2. Ejecución de Consultas y Tests

```bash
# Consultas de selección y analítica
psql -U postgres -d campuseventos -f sql/03_queries.sql

# Transacciones y acciones
psql -U postgres -d campuseventos -f sql/04_actions.sql

# Validación de restricciones (Pruebas de error controlado)
psql -U postgres -d campuseventos -f sql/05_tests.sql

```

---

## 🔒 Business Rules & Constraints

* **Eventos & Sesiones:** Validación de intervalo cronológico (`fecha_fin >= fecha_inicio`) y estados restringidos (`borrador`, `abierto`, `cerrado`, `cancelado`, `finalizado`).
* **Salas & Aforo:** Capacidad estricta mayor a cero (`capacidad > 0`).
* **Inscripciones:** Unicidad por tupla `(evento_id, asistente_id)` para evitar duplicidad de registros por asistente en un mismo evento.
* **Finanzas:** Garantía de importes no negativos (`importe_final >= 0`) y garantía $1:1$ opcional en pagos mediante restricciones `UNIQUE` sobre la clave foránea `inscripcion_id`.

```

```
