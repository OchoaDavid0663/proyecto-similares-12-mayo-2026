-- =====================================================
-- BASE DE DATOS: FARMACIAS SIMILARES
-- =====================================================

CREATE DATABASE IF NOT EXISTS farmacias_similares;
USE farmacias_similares;

-- =====================================================
-- TABLA: PUESTO
-- =====================================================

CREATE TABLE puesto (
    id_puesto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150),
    salario_base DECIMAL(10,2) NOT NULL
);

-- =====================================================
-- TABLA: SUCURSAL
-- =====================================================

CREATE TABLE sucursal (
    id_sucursal INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    estado VARCHAR(100) NOT NULL,
    codigo_postal CHAR(5),
    telefono VARCHAR(15),
    horario VARCHAR(100),
    estatus ENUM('ACTIVA','INACTIVA') DEFAULT 'ACTIVA'
);

-- =====================================================
-- TABLA: EMPLEADO
-- =====================================================

CREATE TABLE empleado (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(100) NOT NULL,
    apellido_materno VARCHAR(100),
    curp CHAR(18) UNIQUE,
    telefono VARCHAR(15),
    correo VARCHAR(100),
    fecha_contratacion DATE NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    id_puesto INT NOT NULL,
    id_sucursal INT NOT NULL,

    CONSTRAINT fk_empleado_puesto
        FOREIGN KEY (id_puesto)
        REFERENCES puesto(id_puesto),

    CONSTRAINT fk_empleado_sucursal
        FOREIGN KEY (id_sucursal)
        REFERENCES sucursal(id_sucursal)
);

-- =====================================================
-- TABLA: CATEGORIA
-- =====================================================

CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(200)
);

-- =====================================================
-- TABLA: PROVEEDOR
-- =====================================================

CREATE TABLE proveedor (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre_empresa VARCHAR(150) NOT NULL,
    contacto VARCHAR(100),
    telefono VARCHAR(15),
    correo VARCHAR(100),
    direccion VARCHAR(200)
);

-- =====================================================
-- TABLA: PRODUCTO
-- =====================================================

CREATE TABLE producto (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion VARCHAR(255),
    precio DECIMAL(10,2) NOT NULL,
    presentacion VARCHAR(100),
    requiere_receta BOOLEAN DEFAULT FALSE,
    id_categoria INT NOT NULL,

    CONSTRAINT fk_producto_categoria
        FOREIGN KEY (id_categoria)
        REFERENCES categoria(id_categoria)
);

-- =====================================================
-- TABLA: INVENTARIO
-- =====================================================

CREATE TABLE inventario (
    id_inventario INT AUTO_INCREMENT PRIMARY KEY,
    id_sucursal INT NOT NULL,
    id_producto INT NOT NULL,
    stock_actual INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 5,

    CONSTRAINT fk_inventario_sucursal
        FOREIGN KEY (id_sucursal)
        REFERENCES sucursal(id_sucursal),

    CONSTRAINT fk_inventario_producto
        FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto),

    UNIQUE(id_sucursal, id_producto)
);

-- =====================================================
-- TABLA: CLIENTE
-- =====================================================

CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(100) NOT NULL,
    apellido_materno VARCHAR(100),
    telefono VARCHAR(15),
    correo VARCHAR(100),
    fecha_registro DATE NOT NULL
);

-- =====================================================
-- TABLA: VENTA
-- =====================================================

CREATE TABLE venta (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    fecha_venta DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    metodo_pago ENUM('EFECTIVO','TARJETA','TRANSFERENCIA') NOT NULL,
    folio VARCHAR(50) UNIQUE NOT NULL,
    id_cliente INT NULL,
    id_empleado INT NOT NULL,

    CONSTRAINT fk_venta_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente),

    CONSTRAINT fk_venta_empleado
        FOREIGN KEY (id_empleado)
        REFERENCES empleado(id_empleado)
);

-- =====================================================
-- TABLA: DETALLE_VENTA
-- =====================================================

CREATE TABLE detalle_venta (
    id_detalle_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    descuento DECIMAL(10,2) DEFAULT 0,

    CONSTRAINT fk_detalle_venta_venta
        FOREIGN KEY (id_venta)
        REFERENCES venta(id_venta),

    CONSTRAINT fk_detalle_venta_producto
        FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto)
);

-- =====================================================
-- TABLA: RECETA
-- =====================================================

CREATE TABLE receta (
    id_receta INT AUTO_INCREMENT PRIMARY KEY,
    folio_receta VARCHAR(50),
    nombre_medico VARCHAR(100),
    cedula_profesional VARCHAR(30),
    fecha_emision DATE,
    id_venta INT NOT NULL,

    CONSTRAINT fk_receta_venta
        FOREIGN KEY (id_venta)
        REFERENCES venta(id_venta)
);

-- =====================================================
-- TABLA: COMPRA
-- =====================================================

CREATE TABLE compra (
    id_compra INT AUTO_INCREMENT PRIMARY KEY,
    fecha_compra DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    id_proveedor INT NOT NULL,
    id_sucursal INT NOT NULL,

    CONSTRAINT fk_compra_proveedor
        FOREIGN KEY (id_proveedor)
        REFERENCES proveedor(id_proveedor),

    CONSTRAINT fk_compra_sucursal
        FOREIGN KEY (id_sucursal)
        REFERENCES sucursal(id_sucursal)
);

-- =====================================================
-- TABLA: DETALLE_COMPRA
-- =====================================================

CREATE TABLE detalle_compra (
    id_detalle_compra INT AUTO_INCREMENT PRIMARY KEY,
    id_compra INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    costo_unitario DECIMAL(10,2) NOT NULL,
    lote VARCHAR(50),
    fecha_caducidad DATE,

    CONSTRAINT fk_detalle_compra_compra
        FOREIGN KEY (id_compra)
        REFERENCES compra(id_compra),

    CONSTRAINT fk_detalle_compra_producto
        FOREIGN KEY (id_producto)
        REFERENCES producto(id_producto)
);

-- =====================================================
-- FIN DEL SCRIPT
-- =====================================================
