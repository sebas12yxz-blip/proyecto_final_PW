-- =============================================================
-- Script de carga - Concesionaria de motos (Moto Sport Suzuki)
-- Ejecutar DESPUÉS de 01_crear_tablas.sql
-- =============================================================

-- Vacía las tablas y reinicia los contadores SERIAL en 1,
-- para que los id coincidan con los usados en este script.
TRUNCATE ventas, repuestos, motos, clientes, vendedores RESTART IDENTITY;

-- -------------------------------------------------------------
-- MOTOS (11) - catálogo Suzuki de MotoSport
-- El id se asigna en orden: Burgman = 1, Gixxer 150 DI = 2, ...
-- -------------------------------------------------------------
INSERT INTO motos (modelo, tipo, cilindraje_cc, anio_modelo, precio_lista) VALUES
('Burgman Street 125', 'automatica',      124,  2026,   9800000),  -- 1
('Gixxer 150 DI',      'sport',           155,  2026,  10500000),  -- 2
('Gixxer FI 150',      'sport',           155,  2026,  11200000),  -- 3
('GSX-R150',           'sport',           147,  2026,  13900000),  -- 4 (sin repuestos ni ventas)
('Gixxer 250',         'sport',           249,  2026,  16500000),  -- 5
('Gixxer 250 FI',      'sport',           249,  2026,  17900000),  -- 6
('V-Strom 250 SX',     'aventura',        249,  2026,  22500000),  -- 7
('V-Strom 650 XT',     'aventura',        645,  2026,  58000000),  -- 8
('GSX-8S',             'alto cilindraje', 776, 2026, 52000000),  -- 9
('GSX-R1000R',         'alto cilindraje', 999,  2025, 110000000),  -- 10
('Hayabusa-Gris',      'alto cilindraje', 1340, 2026, 125000000);  -- 11

-- -------------------------------------------------------------
-- REPUESTOS (12) - cada uno pertenece a un modelo de moto
-- -------------------------------------------------------------
INSERT INTO repuestos (id_moto, referencia, nombre, precio, stock) VALUES
(1,  'REP-0001', 'Pastillas de freno delanteras',     85000,  15),
(2,  'REP-0002', 'Filtro de aceite',                  28000,  40),
(2,  'REP-0003', 'Kit de arrastre (cadena y piñones)', 195000,  8),
(3,  'REP-0004', 'Bujía de encendido',                22000,  50),
(5,  'REP-0005', 'Filtro de aire',                    65000,  12),
(6,  'REP-0006', 'Batería 12V',                      210000,   4),
(7,  'REP-0007', 'Espejo retrovisor derecho',         75000,   6),
(7,  'REP-0008', 'Llanta trasera 140/70-17',         380000,   3),
(8,  'REP-0009', 'Pastillas de freno traseras',      160000,  10),
(9,  'REP-0010', 'Cable de clutch',                   95000,   0),
(10, 'REP-0011', 'Farola delantera LED',            1850000,   2),
(11, 'REP-0012', 'Kit de embrague',                 1250000,   1);

-- -------------------------------------------------------------
-- CLIENTES (12) - datos ficticios, ciudades del Huila
-- -------------------------------------------------------------
INSERT INTO clientes (cedula, nombres, apellidos, telefono, correo, ciudad) VALUES
('1075263418', 'Carlos Andrés',  'Muñoz Rojas',      '3156284719', 'carlosmunoz.rojas@gmail.com',     'Neiva'),        -- 1
('1083904562', 'Laura Marcela',  'Perdomo Díaz',     '3204718536', 'lauraperdomo.diaz@gmail.com',     'Pitalito'),     -- 2
('12236587',   'Jorge Iván',     'Cuéllar Silva',    '3112950847', 'jorgeivan.cuellar@gmail.com',     'Garzón'),       -- 3
('36182754',   'Diana Patricia', 'Vargas Losada',    '3008462193', 'dianavargas.losada@gmail.com',    'La Plata'),     -- 4
('1077865203', 'Andrés Felipe',  'Polanía Cortés',   '3217093648', 'andrespolania.c@gmail.com',       'Campoalegre'),  -- 5
('1003816745', 'María José',     'Trujillo Charry',  '3502846170', 'mariajose.trujillo@gmail.com',    'Neiva'),        -- 6
('7729845',    'Luis Eduardo',   'Ramírez Medina',   '3134058926', 'luiseduardo.ramirez@gmail.com',   'Gigante'),      -- 7
('1081736290', 'Valentina',      'Ortiz Quintero',   '3016593874', 'valentina.ortizq@gmail.com',      'Rivera'),       -- 8
('1075321987', 'Santiago',       'Calderón Puentes', '3183627405', 'santiagocalderon.p@gmail.com',    'Neiva'),        -- 9
('55174826',   'Paola Andrea',   'Rojas Bermeo',     '3045719382', 'paolarojas.bermeo@gmail.com',     'Aipe'),         -- 10
('1079542318', 'Juan David',     'Castro Narváez',   '3168240957', 'juandavid.castron@gmail.com',     'Palermo'),      -- 11
('1006427583', 'Camila',         'Sánchez Tovar',    '3229164038', 'camilasanchez.tovar@gmail.com',   'Yaguará');      -- 12 (sin ventas)

-- -------------------------------------------------------------
-- VENDEDORES (10) - datos ficticios
-- -------------------------------------------------------------
INSERT INTO vendedores (cedula, nombres, apellidos, telefono, correo, fecha_ingreso, comision_pct) VALUES
('1075218364', 'Andrés',    'Cuéllar Vargas',    '3125947361', 'andres.cuellarv@gmail.com',         '2019-03-15', 2.50),  -- 1
('1075284937', 'Natalia',   'Gómez Perdomo',     '3013648295', 'nataliagomez.perdomo@gmail.com',    '2020-07-01', 2.00),  -- 2
('12195843',   'Óscar',     'Medina Salazar',    '3147285016', 'oscarmedina.salazar@gmail.com',     '2021-01-18', 2.25),  -- 3
('1083872145', 'Juliana',   'Rivas Andrade',     '3209536871', 'julianarivas.andrade@gmail.com',    '2021-09-06', 1.75),  -- 4
('1080296473', 'Felipe',    'Arias Montealegre', '3152704689', 'felipe.ariasm@gmail.com',           '2022-04-20', 2.00),  -- 5
('36289517',   'Mónica',    'Lozano Cabrera',    '3006174852', 'monicalozano.cabrera@gmail.com',    '2022-11-02', 3.00),  -- 6
('1075309825', 'Daniel',    'Paredes Molina',    '3174826390', 'danielparedes.molina@gmail.com',    '2023-05-15', 1.50),  -- 7
('1004738216', 'Sofía',     'Herrera Bonilla',   '3507391246', 'sofiaherrera.bonilla@gmail.com',    '2024-02-12', 2.00),  -- 8
('1077924581', 'Cristian',  'Ospina Guzmán',     '3118560274', 'cristianospina.g@gmail.com',        '2025-06-01', 1.50),  -- 9
('1005862347', 'Alejandra', 'Navarro Fierro',    '3192485637', 'alejandranavarro.f@gmail.com',      '2026-08-01', 1.50);  -- 10 (sin ventas)

-- -------------------------------------------------------------
-- VENTAS (12) - cliente, vendedor y moto existentes
-- -------------------------------------------------------------
INSERT INTO ventas (id_cliente, id_vendedor, id_moto, fecha_venta, numero_chasis, forma_pago, precio_final) VALUES
(1,  1, 1,  '2026-01-15', 'MSZ-BUR-260001', 'contado',    9600000),
(2,  2, 2,  '2026-02-03', 'MSZ-GDI-260002', 'credito',   10500000),
(3,  1, 5,  '2026-02-20', 'MSZ-G25-260003', 'credito',   16300000),
(4,  3, 7,  '2026-03-11', 'MSZ-VS2-260004', 'contado',   22000000),
(5,  4, 3,  '2026-04-02', 'MSZ-GFI-260005', 'credito',   11200000),
(6,  5, 6,  '2026-05-14', 'MSZ-GSF-260006', 'contado',   17500000),
(1,  6, 8,  '2026-06-21', 'MSZ-VS6-260007', 'credito',   57000000),
(7,  7, 9,  '2026-07-08', 'MSZ-S75-260008', 'contado',   51000000),
(8,  2, 10, '2026-08-19', 'MSZ-R1K-260009', 'credito',  108000000),
(9,  8, 11, '2026-09-05', 'MSZ-HAY-260010', 'contado',  123500000),
(10, 9, 1,  '2026-10-12', 'MSZ-BUR-260011', 'credito',    9800000),
(11, 3, 2,  '2026-11-02', 'MSZ-GDI-260012', 'contado',   10300000);