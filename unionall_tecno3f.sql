-- PROYECTO CINE

CREATE DATABASE cine_DG;
USE cine_DG;

-- CREACION DE LAS TABLAS

CREATE TABLE IF NOT EXISTS cliente(
    idCliente INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR (100) NOT NULL
);

CREATE TABLE IF NOT EXISTS pelicula(
    idPelicula INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR (100) NOT NULL
);

CREATE TABLE IF NOT EXISTS producto(
    idProducto INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR (100) NOT NULL,
    precio_unitario INT
);

CREATE TABLE IF NOT EXISTS factura(
    idFactura INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    fecha_hora datetime not null,
    idCliente INT,
	FOREIGN KEY (idCliente) REFERENCES cliente(idCliente)
);


CREATE TABLE IF NOT EXISTS detalle_factura_entrada(
    idDetalleFacturaEntrada INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    idFactura INT,
    idPelicula INT,
    idProducto INT,
    cantidad int ,
	precio_unitario INT,
	FOREIGN KEY (idFactura) REFERENCES factura(idFactura),
    FOREIGN KEY (idPelicula) REFERENCES pelicula(idPelicula),
    FOREIGN KEY (idProducto) REFERENCES producto(idProducto)
);

CREATE TABLE IF NOT EXISTS detalle_factura_producto(
    idDetalleFacturaProducto INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    idFactura INT,
    idProducto INT,
    cantidad int ,
	precio_unitario INT,
	FOREIGN KEY (idFactura) REFERENCES factura(idFactura),
    FOREIGN KEY (idProducto) REFERENCES producto(idProducto)
);


INSERT INTO cliente (`idCliente`,`nombre`) VALUES (1,'Diego');
INSERT INTO cliente (`idCliente`,`nombre`) VALUES (2,'Valentina');
INSERT INTO cliente (`idCliente`,`nombre`) VALUES (3,'Rosario');
INSERT INTO cliente (`idCliente`,`nombre`) VALUES (4,'Pancha');


INSERT INTO pelicula (`idPelicula`,`nombre`) VALUES (1,'Hombre araña 2');
INSERT INTO pelicula (`idPelicula`,`nombre`) VALUES (2,'Batman');
INSERT INTO pelicula (`idPelicula`,`nombre`) VALUES (3,'Mario Bross');
INSERT INTO pelicula (`idPelicula`,`nombre`) VALUES (4,'Lluvia de Hamburguesa');


INSERT INTO producto (`idProducto`,`nombre`,`precio_unitario`) VALUES (1,'entrada menor',1000);
INSERT INTO producto (`idProducto`,`nombre`,`precio_unitario`) VALUES (2,'entrada mayor',2000);
INSERT INTO producto (`idProducto`,`nombre`,`precio_unitario`) VALUES (3,'entrada jubilado ',1500);
INSERT INTO producto (`idProducto`,`nombre`,`precio_unitario`) VALUES (4,'gaseosa',200);
INSERT INTO producto (`idProducto`,`nombre`,`precio_unitario`) VALUES (5,'papas fritas',400);

INSERT INTO factura (`idFactura`,`fecha_hora`,`idCliente`) VALUES (1,'2023-06-01 18:24:21',1);
INSERT INTO factura (`idFactura`,`fecha_hora`,`idCliente`) VALUES (2,'2023-06-01 18:24:38',2);
INSERT INTO factura (`idFactura`,`fecha_hora`,`idCliente`) VALUES (3,'2023-06-01 18:24:46',3);


INSERT INTO detalle_factura_entrada (`idDetalleFacturaEntrada`,`idFactura`,`idPelicula`,`idProducto`,`cantidad`,`precio_unitario`) VALUES (1,1,1,1,3,1000);
INSERT INTO detalle_factura_entrada (`idDetalleFacturaEntrada`,`idFactura`,`idPelicula`,`idProducto`,`cantidad`,`precio_unitario`) VALUES (2,1,2,1,4,1000);
INSERT INTO detalle_factura_entrada (`idDetalleFacturaEntrada`,`idFactura`,`idPelicula`,`idProducto`,`cantidad`,`precio_unitario`) VALUES (3,1,2,2,1,2000);
INSERT INTO detalle_factura_entrada (`idDetalleFacturaEntrada`,`idFactura`,`idPelicula`,`idProducto`,`cantidad`,`precio_unitario`) VALUES (4,2,3,1,1,1000);
INSERT INTO detalle_factura_entrada (`idDetalleFacturaEntrada`,`idFactura`,`idPelicula`,`idProducto`,`cantidad`,`precio_unitario`) VALUES (5,2,3,2,1,2000);
INSERT INTO detalle_factura_entrada (`idDetalleFacturaEntrada`,`idFactura`,`idPelicula`,`idProducto`,`cantidad`,`precio_unitario`) VALUES (6,3,3,2,1,2000);


INSERT INTO detalle_factura_producto (`idDetalleFacturaProducto`,`idFactura`,`idProducto`,`cantidad`,`precio_unitario`) VALUES (1,1,4,3,200);
INSERT INTO detalle_factura_producto (`idDetalleFacturaProducto`,`idFactura`,`idProducto`,`cantidad`,`precio_unitario`) VALUES (2,1,5,4,400);

/*CONOCER EL DETALLE DE LAS FACTURAS DE TODOS LOS CLIENTES  */
/* DETALLE FACTURA ENTRADA */

SELECT C.nombre , F.idFactura, F.fecha_hora, p.nombre as 'Descripcion' , DFE.cantidad , DFE.precio_unitario, Pe.nombre as 'Nombre Pelicula' 
FROM cliente AS C
INNER JOIN factura as F
    ON c.idCliente = f.idCliente
INNER JOIN detalle_factura_entrada as DFE
    ON F.idFactura = DFE.idFactura
INNER JOIN producto as P
    ON P.idProducto = DFE.idProducto
INNER JOIN pelicula as Pe
    ON Pe.idPelicula = DFE.idPelicula;
    
    SELECT C.nombre , F.idFactura, F.fecha_hora, p.nombre as 'Descripcion' , DFP.cantidad , DFP.precio_unitario, 'producto'
FROM cliente AS C
INNER JOIN factura as F
    ON c.idCliente = f.idCliente
INNER JOIN detalle_factura_producto as DFP
    ON F.idFactura = DFP.idFactura
INNER JOIN producto as P
    ON P.idProducto = DFP.idProducto;

WITH cte AS ( 
 SELECT C.idCliente, F.idFactura, sum(DFE.precio_unitario) AS 'Total'
 FROM cine_dg.cliente AS C
 INNER JOIN cine_dg.factura AS F
  ON c.idCliente = f.idCliente
 INNER JOIN cine_dg.detalle_factura_entrada AS DFE
  ON F.idFactura = DFE.idFactura
 GROUP BY  F.idFactura

  UNION ALL
  
 SELECT C.idCliente, F.idFactura, sum(DFP.precio_unitario)  AS 'Total'
 FROM cine_dg.cliente AS C
 INNER JOIN cine_dg.factura AS F
  ON c.idCliente = f.idCliente
 INNER JOIN cine_dg.detalle_factura_producto AS DFP
  ON F.idFactura = DFP.idFactura
 GROUP BY  F.idFactura

)

SELECT idCliente, idFactura, SUM(total)   
FROM cte 
GROUP BY idFactura;
