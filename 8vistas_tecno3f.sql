productosCREATE DATABASE IF NOT EXISTS ventas_ecommerce_3f;

USE ventas_ecommerce_3f;

CREATE TABLE IF NOT EXISTS productos (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL,
    existencia BOOLEAN NOT NULL DEFAULT FALSE,
    precio FLOAT NOT NULL DEFAULT 0.0,
    precio_compra FLOAT NOT NULL DEFAULT 0.0
);
-- agregamos los datos
INSERT INTO productos (nombre,existencia, precio, precio_compra) 
VALUES  
 ('TRACKPAD BLUETOOTH MELODY', '0', '19060', '17600'),
 ('TRACKPAD INALÁMBRICO USB LOGI', '0', '32000', '12600'),
 ('MONITOR SAMSUNG 24" ', '1', '35000', '19500'),
 ('MONITOR SAMSUNG 27"', '1', '40000', '32500'),
 ('MONITOR SAMSUNG 24" CURVO', '0', '60000', '40000'),
 ('MOUSE INALÁMBRICO SOUL ', '1', '6500', '4500'),
 ('MOUSE CABLEADO LOGI', '0', '4100', '2900'),
 ('MOUSE INALÁMBRICO USB LOGI V2', '1', '5500', '3300');
 
 /* CREACION DE LA VISTA PRODUCTOS */

CREATE VIEW view_productos AS 
SELECT * FROM productos;

-- Creacion de Vista_costo_producto
CREATE VIEW view_costo_producto AS 
SELECT id,nombre,precio_compra FROM productos;

SELECT * FROM view_costo_producto;

-- Creacion de vistas con productos en existencia   Vista_productos_en_existencia
CREATE VIEW view_productos_en_existencia AS 
SELECT id,nombre,precio_compra 
FROM productos
WHERE existencia > 0;

SELECT * FROM view_productos_en_existencia;


-- A LA VISTA GENERADA, NECESITAMOS VER EL PRECIO_COMPRA CON UN 45% DE AUMENTO
SELECT id, nombre,precio_compra AS 'precio normal', CONCAT ('$ ',(precio_compra * 1.45 ) )as 'Precio con 45%'
FROM view_productos_en_existencia;

-- UTILIZAMOS LA VISTA : Vista_productos_en_existencia para filtrar informacion
SELECT id, nombre,precio_compra 
FROM view_productos_en_existencia
WHERE precio_compra > 6000;

CREATE TABLE IF NOT EXISTS stock (
   id INT AUTO_INCREMENT PRIMARY KEY, 
   producto_id INT NOT NULL,
   unidades INT NOT NULL,
   FOREIGN KEY (producto_id) REFERENCES productos(id)
);

INSERT INTO stock (producto_id, unidades) VALUES 
('1', '0'),
('2', '0'),
('3', '7'),
('4', '21'),
('5', '0'),
('6', '14'),
('7', '0'),
('8', '10');

CREATE OR REPLACE VIEW view_productos_unidades AS
SELECT p.nombre, p.precio_compra, s.unidades
FROM productos as P
INNER JOIN stock as S
ON S.producto_id = P.id;


SELECT * FROM view_productos_unidades;


/*vista de productos y con unidades mayor a 0 */

CREATE OR REPLACE VIEW view_productos_sin_stock AS
SELECT p.nombre, p.precio_compra, s.unidades
FROM productos as P
INNER JOIN stock as S
ON S.producto_id = P.id
WHERE S.unidades = 0;

SELECT * FROM view_productos_sin_stock;

CREATE OR REPLACE VIEW view_productos_con_stock AS
SELECT p.nombre, p.precio_compra, s.unidades
FROM productos as P
INNER JOIN stock as S
ON S.producto_id = P.id
WHERE S.unidades > 0;

SELECT * FROM view_productos_con_stock;


/*CREANDO UNA VISTA CON UNA SUBCONSULTA*/
-- TRAER EL ID, NOMBRE DE LOS  PRODUCTO CON BAJO STOCK (UNIDADES MENORES A 7)

select * from stock;

CREATE OR REPLACE VIEW view_ProductosConBajoStock AS
SELECT p.nombre, p.precio_compra, s.unidades
FROM productos as P
INNER JOIN stock as S
ON S.producto_id = P.id
WHERE p.id IN (
 SELECT producto_id
    FROM STOCK
    WHERE unidades <= 7
);

SELECT * FROM view_ProductosConBajoStock;

-- eliminacion de vistas DROP VIEW 

DROP VIEW view_ProductosConBajoStock;