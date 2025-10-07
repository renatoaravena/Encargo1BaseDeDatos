-- CASO 1: IMPLEMENTACIÓN DEL -- =============================================

-- Tablas fuertes (entidades independientes)
CREATE TABLE region (
    id_region NUMBER(4) PRIMARY KEY,
    nom_region VARCHAR2(255) NOT NULL
);

CREATE TABLE comuna (
    id_comuna NUMBER(4) PRIMARY KEY,
    nom_comuna VARCHAR2(100) NOT NULL,
    cod_region NUMBER(4) NOT NULL
);

CREATE TABLE afp (
    id_afp NUMBER(5) PRIMARY KEY,
    nom_afp VARCHAR2(255) NOT NULL
);

CREATE TABLE salud (
    id_salud NUMBER(4) PRIMARY KEY,
    nom_salud VARCHAR2(40) NOT NULL
);

CREATE TABLE marca (
    id_marca NUMBER(3) PRIMARY KEY,
    nombre_marca VARCHAR2(255) NOT NULL
);

CREATE TABLE categoria (
    id_categoria NUMBER(3) PRIMARY KEY,
    nombre_categoria VARCHAR2(255) NOT NULL
);

CREATE TABLE medio_pago (
    id_medio NUMBER(3) PRIMARY KEY,
    nombre_medio VARCHAR2(50) NOT NULL
);

-- Tabla PROVEEDOR
CREATE TABLE proveedor (
    id_proveedor NUMBER(5) PRIMARY KEY,
    nombre_proveedor VARCHAR2(150) NOT NULL,
    nd_proveedor VARCHAR2(10),
    telefono VARCHAR2(10),
    email VARCHAR2(200),
    direccion VARCHAR2(200),
    cod_comuna NUMBER(4) NOT NULL
);

-- Tabla EMPLEADO
CREATE TABLE empleado (
    id_empleado NUMBER(4) PRIMARY KEY,
    nd_empleado VARCHAR2(10) NOT NULL,
    nombre_empleado VARCHAR2(25) NOT NULL,
    apellido_paterno VARCHAR2(25) NOT NULL,
    apellido_materno VARCHAR2(25) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    sueldo_base NUMBER(10) NOT NULL,
    bono_jefatura NUMBER(10),
    activo CHAR(1) NOT NULL,
    tipo_empleado VARCHAR2(25) NOT NULL,
    cod_jefe NUMBER(4),
    cod_salud NUMBER(4) NOT NULL,
    cod_afp NUMBER(5) NOT NULL
);

-- Tabla PRODUCTO
CREATE TABLE producto (
    id_producto NUMBER(4) PRIMARY KEY,
    nombre_producto VARCHAR2(100) NOT NULL,
    precio_unitario NUMBER(10) NOT NULL,
    origen_nacional CHAR(1) NOT NULL,
    stock_minimo NUMBER(3) NOT NULL,
    accion CHAR(1),
    cod_marca NUMBER(3) NOT NULL,
    cod_categoria NUMBER(3) NOT NULL,
    cod_proveedor NUMBER(5) NOT NULL
);

-- Tabla VENTA
CREATE TABLE venta (
    id_venta NUMBER(4) PRIMARY KEY,
    fecha_venta DATE NOT NULL,
    total_venta NUMBER(10) NOT NULL,
    cod_medio NUMBER(3) NOT NULL,
    cod_empleado NUMBER(4) NOT NULL
);

-- Tablas subtipos de EMPLEADO
CREATE TABLE administrativo (
    id_empleado NUMBER(4) PRIMARY KEY
);

CREATE TABLE vendedor (
    id_empleado NUMBER(4) PRIMARY KEY,
    comision_venta NUMBER(2,2) NOT NULL
);

-- Tabla de detalle
CREATE TABLE detalle_venta (
    cod_venta NUMBER(4),
    cod_producto NUMBER(4),
    cantidad NUMBER(6) NOT NULL,
    PRIMARY KEY (cod_venta, cod_producto)
);-- =============================================
-- CASO 2: MODIFICACIÓN DEL MODELO - REGLAS DE NEGOCIO


-- 1. Sueldo base mínimo
ALTER TABLE empleado ADD CONSTRAINT empleado_ck_sueldo_min 
CHECK (sueldo_base >= 400000);

-- 2. Comisión de vendedor entre 0 y 0.25
ALTER TABLE vendedor ADD CONSTRAINT vendedor_ck_comision 
CHECK (comision_venta BETWEEN 0 AND 0.25);

-- 3. Stock mínimo de al menos 3 unidades
ALTER TABLE producto ADD CONSTRAINT producto_ck_stock_min 
CHECK (stock_minimo >= 3);

-- 4. Email único en proveedores
ALTER TABLE proveedor ADD CONSTRAINT proveedor_uk_email 
UNIQUE (email);

-- 5. Nombre único en marcas
ALTER TABLE marca ADD CONSTRAINT marca_uk_nombre 
UNIQUE (nombre_marca);

-- 6. Cantidad mínima en detalle de venta
ALTER TABLE detalle_venta ADD CONSTRAINT detalle_venta_ck_cantidad 
CHECK (cantidad >= 1);

 
-- RESTRICCIONES DE CLAVE FORÁNEA


-- COMUNA
ALTER TABLE comuna ADD CONSTRAINT comuna_fk_region 
FOREIGN KEY (cod_region) REFERENCES region(id_region);

-- PROVEEDOR
ALTER TABLE proveedor ADD CONSTRAINT proveedor_fk_comuna 
FOREIGN KEY (cod_comuna) REFERENCES comuna(id_comuna);

-- EMPLEADO
ALTER TABLE empleado ADD CONSTRAINT empleado_fk_salud 
FOREIGN KEY (cod_salud) REFERENCES salud(id_salud);

ALTER TABLE empleado ADD CONSTRAINT empleado_fk_afp 
FOREIGN KEY (cod_afp) REFERENCES afp(id_afp);

ALTER TABLE empleado ADD CONSTRAINT empleado_fk_jefe 
FOREIGN KEY (cod_jefe) REFERENCES empleado(id_empleado);

-- PRODUCTO
ALTER TABLE producto ADD CONSTRAINT producto_fk_marca 
FOREIGN KEY (cod_marca) REFERENCES marca(id_marca);

ALTER TABLE producto ADD CONSTRAINT producto_fk_categoria 
FOREIGN KEY (cod_categoria) REFERENCES categoria(id_categoria);

ALTER TABLE producto ADD CONSTRAINT producto_fk_proveedor 
FOREIGN KEY (cod_proveedor) REFERENCES proveedor(id_proveedor);

-- VENTA
ALTER TABLE venta ADD CONSTRAINT venta_fk_medio_pago 
FOREIGN KEY (cod_medio) REFERENCES medio_pago(id_medio);

ALTER TABLE venta ADD CONSTRAINT venta_fk_empleado 
FOREIGN KEY (cod_empleado) REFERENCES empleado(id_empleado);

-- TABLAS SUBTIPOS
ALTER TABLE administrativo ADD CONSTRAINT administrativo_fk_empleado 
FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado);

ALTER TABLE vendedor ADD CONSTRAINT vendedor_fk_empleado 
FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado);

-- DETALLE_VENTA
ALTER TABLE detalle_venta ADD CONSTRAINT detalle_venta_fk_venta 
FOREIGN KEY (cod_venta) REFERENCES venta(id_venta);

ALTER TABLE detalle_venta ADD CONSTRAINT detalle_venta_fk_producto 
FOREIGN KEY (cod_producto) REFERENCES producto(id_producto);


-- SECUENCIAS 


CREATE SEQUENCE seq_salud 
START WITH 2050 
INCREMENT BY 10;

CREATE SEQUENCE seq_empleado 
START WITH 750 
INCREMENT BY 3;

CREATE SEQUENCE seq_afp 
START WITH 210 
INCREMENT BY 6;

CREATE SEQUENCE seq_venta 
START WITH 5050 
INCREMENT BY 3;


-- CASO 3: POBLAMIENTO DEL MODELO


-- Tabla REGION
INSERT INTO region (id_region, nom_region) VALUES (1, 'Región de Tarapacá');
INSERT INTO region (id_region, nom_region) VALUES (2, 'Región de Antofagasta');
INSERT INTO region (id_region, nom_region) VALUES (3, 'Región de Atacama');
INSERT INTO region (id_region, nom_region) VALUES (4, 'Región de Coquimbo');
INSERT INTO region (id_region, nom_region) VALUES (5, 'Región de Valparaíso');

-- Tabla COMUNA (ejemplo con algunas comunas)
INSERT INTO comuna (id_comuna, nom_comuna, cod_region) VALUES (1, 'Arica', 1);
INSERT INTO comuna (id_comuna, nom_comuna, cod_region) VALUES (2, 'Iquique', 1);
INSERT INTO comuna (id_comuna, nom_comuna, cod_region) VALUES (3, 'Antofagasta', 2);
INSERT INTO comuna (id_comuna, nom_comuna, cod_region) VALUES (4, 'Calama', 2);
INSERT INTO comuna (id_comuna, nom_comuna, cod_region) VALUES (5, 'Viña del Mar', 5);

-- Tabla SALUD (usando secuencia)
INSERT INTO salud (id_salud, nom_salud) VALUES (seq_salud.NEXTVAL, 'Fonasa');
INSERT INTO salud (id_salud, nom_salud) VALUES (seq_salud.NEXTVAL, 'Banmédica');
INSERT INTO salud (id_salud, nom_salud) VALUES (seq_salud.NEXTVAL, 'Colmena');
INSERT INTO salud (id_salud, nom_salud) VALUES (seq_salud.NEXTVAL, 'Consalud');
INSERT INTO salud (id_salud, nom_salud) VALUES (seq_salud.NEXTVAL, 'Cruz Blanca');

-- Tabla AFP (usando secuencia)
INSERT INTO afp (id_afp, nom_afp) VALUES (seq_afp.NEXTVAL, 'Capital');
INSERT INTO afp (id_afp, nom_afp) VALUES (seq_afp.NEXTVAL, 'Cuprum');
INSERT INTO afp (id_afp, nom_afp) VALUES (seq_afp.NEXTVAL, 'Habitat');
INSERT INTO afp (id_afp, nom_afp) VALUES (seq_afp.NEXTVAL, 'Planvital');
INSERT INTO afp (id_afp, nom_afp) VALUES (seq_afp.NEXTVAL, 'Provida');
INSERT INTO afp (id_afp, nom_afp) VALUES (seq_afp.NEXTVAL, 'Modelo');

-- Tabla MEDIO_PAGO
INSERT INTO medio_pago (id_medio, nombre_medio) VALUES (1, 'Efectivo');
INSERT INTO medio_pago (id_medio, nombre_medio) VALUES (2, 'Tarjeta Débito');
INSERT INTO medio_pago (id_medio, nombre_medio) VALUES (3, 'Tarjeta Crédito');
INSERT INTO medio_pago (id_medio, nombre_medio) VALUES (4, 'Transferencia');

-- Tabla EMPLEADO (usando secuencia)
-- Jefe (sin cod_jefe)
INSERT INTO empleado (id_empleado, nd_empleado, nombre_empleado, apellido_paterno, 
                     apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, 
                     activo, tipo_empleado, cod_jefe, cod_salud, cod_afp) 
VALUES (seq_empleado.NEXTVAL, '12345678-9', 'Ana', 'González', 'Pérez', 
        TO_DATE('2020-03-15', 'YYYY-MM-DD'), 850000, 150000, 'S', 'Administrativo', 
        NULL, 2050, 210);

-- Empleados
INSERT INTO empleado (id_empleado, nd_empleado, nombre_empleado, apellido_paterno, 
                     apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, 
                     activo, tipo_empleado, cod_jefe, cod_salud, cod_afp) 
VALUES (seq_empleado.NEXTVAL, '23456789-0', 'Carlos', 'Muñoz', 'López', 
        TO_DATE('2021-06-10', 'YYYY-MM-DD'), 650000, NULL, 'S', 'Vendedor', 
        750, 2060, 216);

INSERT INTO empleado (id_empleado, nd_empleado, nombre_empleado, apellido_paterno, 
                     apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, 
                     activo, tipo_empleado, cod_jefe, cod_salud, cod_afp) 
VALUES (seq_empleado.NEXTVAL, '34567890-1', 'María', 'Silva', 'Rojas', 
        TO_DATE('2022-01-20', 'YYYY-MM-DD'), 580000, NULL, 'S', 'Vendedor', 
        750, 2070, 222);

INSERT INTO empleado (id_empleado, nd_empleado, nombre_empleado, apellido_paterno, 
                     apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, 
                     activo, tipo_empleado, cod_jefe, cod_salud, cod_afp) 
VALUES (seq_empleado.NEXTVAL, '45678901-2', 'Pedro', 'Martínez', 'Díaz', 
        TO_DATE('2021-11-05', 'YYYY-MM-DD'), 720000, 80000, 'S', 'Administrativo', 
        750, 2080, 228);

INSERT INTO empleado (id_empleado, nd_empleado, nombre_empleado, apellido_paterno, 
                     apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, 
                     activo, tipo_empleado, cod_jefe, cod_salud, cod_afp) 
VALUES (seq_empleado.NEXTVAL, '56789012-3', 'Laura', 'Fernández', 'Gómez', 
        TO_DATE('2023-02-14', 'YYYY-MM-DD'), 520000, NULL, 'S', 'Vendedor', 
        750, 2090, 234);

-- Tabla VENDEDOR
INSERT INTO vendedor (id_empleado, comision_venta) VALUES (753, 0.15);
INSERT INTO vendedor (id_empleado, comision_venta) VALUES (756, 0.12);
INSERT INTO vendedor (id_empleado, comision_venta) VALUES (762, 0.10);

-- Tabla ADMINISTRATIVO
INSERT INTO administrativo (id_empleado) VALUES (750);
INSERT INTO administrativo (id_empleado) VALUES (759);

-- Tabla VENTA (usando secuencia)
INSERT INTO venta (id_venta, fecha_venta, total_venta, cod_medio, cod_empleado) 
VALUES (seq_venta.NEXTVAL, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 125000, 1, 753);

INSERT INTO venta (id_venta, fecha_venta, total_venta, cod_medio, cod_empleado) 
VALUES (seq_venta.NEXTVAL, TO_DATE('2024-01-16', 'YYYY-MM-DD'), 89000, 3, 756);

INSERT INTO venta (id_venta, fecha_venta, total_venta, cod_medio, cod_empleado) 
VALUES (seq_venta.NEXTVAL, TO_DATE('2024-01-17', 'YYYY-MM-DD'), 156000, 2, 753);

INSERT INTO venta (id_venta, fecha_venta, total_venta, cod_medio, cod_empleado) 
VALUES (seq_venta.NEXTVAL, TO_DATE('2024-01-18', 'YYYY-MM-DD'), 72000, 1, 762);

COMMIT;


-- CASO 4: RECUPERACIÓN DE DATOS - INFORMES


-- INFORME 1: Sueldo total estimado de empleados activos con bono de jefatura
SELECT 
    id_empleado AS "IDENTIFICADOR",
    nombre_empleado || ' ' || apellido_paterno || ' ' || apellido_materno AS "NOMBRE COMPLETO",
    sueldo_base AS "SALARIO",
    bono_jefatura AS "BONIFICACION",
    (sueldo_base + NVL(bono_jefatura, 0)) AS "SALARIO SIMULADO"
FROM empleado
WHERE activo = 'S' 
    AND bono_jefatura IS NOT NULL
ORDER BY "SALARIO SIMULADO" DESC, apellido_paterno DESC;

-- INFORME 2: Empleados con sueldo base entre $550.000 y $800.000 con posible aumento
SELECT 
    nombre_empleado || ' ' || apellido_paterno || ' ' || apellido_materno AS "EMPLEADO",
    sueldo_base AS "SUELDO",
    '8%' AS "POSIBLE AUMENTO",
    (sueldo_base * 1.08) AS "SALARIO SIMULADO"
FROM empleado
WHERE sueldo_base BETWEEN 550000 AND 800000
ORDER BY sueldo_base ASC;