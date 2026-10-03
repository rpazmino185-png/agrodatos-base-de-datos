-- =====================================================
-- Proyecto ABP AgroDatos - Base de Datos (Ingeniería de Software)
-- Script 1: creación del esquema relacional normalizado (3FN)
-- =====================================================

CREATE TABLE socio (
    id_socio      INTEGER PRIMARY KEY,
    cedula        VARCHAR(10)  NOT NULL UNIQUE,
    nombres       VARCHAR(80)  NOT NULL,
    canton        VARCHAR(40)  NOT NULL,
    fecha_ingreso DATE         NOT NULL
);

CREATE TABLE cultivo (
    id_cultivo    INTEGER PRIMARY KEY,
    nombre        VARCHAR(40)  NOT NULL UNIQUE,
    precio_kg     DECIMAL(6,2) NOT NULL CHECK (precio_kg > 0)
);

CREATE TABLE parcela (
    id_parcela    INTEGER PRIMARY KEY,
    id_socio      INTEGER      NOT NULL REFERENCES socio(id_socio),
    hectareas     DECIMAL(6,2) NOT NULL CHECK (hectareas > 0),
    ubicacion     VARCHAR(80)
);

CREATE TABLE entrega (
    id_entrega    INTEGER PRIMARY KEY,
    id_parcela    INTEGER      NOT NULL REFERENCES parcela(id_parcela),
    id_cultivo    INTEGER      NOT NULL REFERENCES cultivo(id_cultivo),
    fecha         DATE         NOT NULL,
    kilos         DECIMAL(8,2) NOT NULL CHECK (kilos > 0)
);

CREATE TABLE pago (
    id_pago       INTEGER PRIMARY KEY,
    id_socio      INTEGER      NOT NULL REFERENCES socio(id_socio),
    fecha         DATE         NOT NULL,
    monto         DECIMAL(10,2) NOT NULL CHECK (monto > 0)
);
