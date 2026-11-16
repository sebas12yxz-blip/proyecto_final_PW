CREATE TABLE motos (
    id_moto       SERIAL PRIMARY KEY,
    modelo        VARCHAR(60) NOT NULL UNIQUE,
    tipo          VARCHAR(20) NOT NULL CHECK (tipo IN ('automatica', 'semiautomatica', 'sport', 'enduro', 'cruiser', 'aventura', 'alto cilindraje')),
    cilindraje_cc INT NOT NULL CHECK (cilindraje_cc > 0),
    anio_modelo   INT NOT NULL CHECK (anio_modelo BETWEEN 2015 AND 2030),
    precio_lista  NUMERIC(12,2) NOT NULL CHECK (precio_lista > 0)
);

CREATE TABLE repuestos (
    id_repuesto SERIAL PRIMARY KEY,
    id_moto     INT NOT NULL REFERENCES motos(id_moto) ON DELETE RESTRICT,
    referencia  VARCHAR(30) NOT NULL UNIQUE,
    nombre      VARCHAR(80) NOT NULL,
    precio      NUMERIC(12,2) NOT NULL CHECK (precio > 0),
    stock       INT NOT NULL CHECK (stock >= 0)
);

CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    cedula     VARCHAR(15) NOT NULL UNIQUE,
    nombres    VARCHAR(60) NOT NULL,
    apellidos  VARCHAR(60) NOT NULL,
    telefono   VARCHAR(20) NOT NULL,
    correo     VARCHAR(120) NOT NULL UNIQUE,
    ciudad     VARCHAR(60) NOT NULL
);

CREATE TABLE vendedores (
    id_vendedor   SERIAL PRIMARY KEY,
    cedula        VARCHAR(15) NOT NULL UNIQUE,
    nombres       VARCHAR(60) NOT NULL,
    apellidos     VARCHAR(60) NOT NULL,
    telefono      VARCHAR(20) NOT NULL,
    correo        VARCHAR(120) NOT NULL UNIQUE,
    fecha_ingreso DATE NOT NULL,
    comision_pct  NUMERIC(5,2) NOT NULL CHECK (comision_pct BETWEEN 0 AND 100)
);

CREATE TABLE ventas (
    id_venta      SERIAL PRIMARY KEY,
    id_cliente    INT NOT NULL REFERENCES clientes(id_cliente) ON DELETE RESTRICT,
    id_vendedor   INT NOT NULL REFERENCES vendedores(id_vendedor) ON DELETE RESTRICT,
    id_moto       INT NOT NULL REFERENCES motos(id_moto) ON DELETE RESTRICT,
    fecha_venta   DATE NOT NULL,
    numero_chasis VARCHAR(25) NOT NULL UNIQUE,
    forma_pago    VARCHAR(15) NOT NULL CHECK (forma_pago IN ('contado', 'credito')),
    precio_final  NUMERIC(12,2) NOT NULL CHECK (precio_final > 0)
);