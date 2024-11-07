<<<<<<< HEAD

CREATE DATABASE modaClick;
USE modaClick;

-- Tabla Impuesto
CREATE TABLE Impuesto (
    idImpuesto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(40),
    porcentaje INT,
    descripcion TEXT
);

-- Tabla Categoria
CREATE TABLE Categoria (
    idCategoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(30),
    descripcion TEXT
);

-- Tabla Inventario
CREATE TABLE Inventario (
    idArticulo INT AUTO_INCREMENT PRIMARY KEY,
    nombreArticulo VARCHAR(30),
    descripcion TEXT,
    costoUnitCompra INT,
    valorUnitVenta INT,
    stock INT,
    stockMinimo INT,
    stockMaximo INT,
    tipoTela VARCHAR(30),
    colorArticulo VARCHAR(30),
    talla VARCHAR(10),
    foto VARCHAR(100),
    idCategoria INT,
    FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria)
);

-- Tabla ImpuestoInventario
CREATE TABLE ImpuestoInventario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idArticulo INT,
    idImpuesto INT,
    FOREIGN KEY (idArticulo) REFERENCES Inventario(idArticulo),
    FOREIGN KEY (idImpuesto) REFERENCES Impuesto(idImpuesto)
);

-- Tabla Persona
CREATE TABLE Persona (
    identificacion VARCHAR(15) PRIMARY KEY,
    nombre VARCHAR(50),
    telefono VARCHAR(15),
    genero CHAR(1),
    correoElectronico VARCHAR(80),
    tipo CHAR(1),
    clave VARCHAR(32)
);

-- Tabla Venta
CREATE TABLE Venta (
    idVenta INT AUTO_INCREMENT PRIMARY KEY,
    fechaVenta DATETIME,
    idCliente VARCHAR(15),
    FOREIGN KEY (idCliente) REFERENCES Persona(identificacion)
);

-- Tabla VentaDetalle
CREATE TABLE VentaDetalle (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idVentaDetalle INT,
    idArticuloInventario INT,
    cantidad INT,
    valorUnitVenta INT,
    impuesto INT,
    FOREIGN KEY (idVentaDetalle) REFERENCES Venta(idVenta),
    FOREIGN KEY (idArticuloInventario) REFERENCES Inventario(idArticulo)
);

-- Tabla DevolucionVenta
CREATE TABLE DevolucionVenta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME,
    idVentaDetalle INT,
    FOREIGN KEY (idVentaDetalle) REFERENCES Venta(idVenta)
);

-- Tabla DevolucionVentaDetalles
CREATE TABLE DevolucionVentaDetalles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    estadoDevolucion CHAR(1),
    comentariosAdicionales TEXT,
    idVentaDetalle INT,
    idDevolucion INT,
    cantidad INT,
    FOREIGN KEY (idVentaDetalle) REFERENCES VentaDetalle(id),
    FOREIGN KEY (idDevolucion) REFERENCES DevolucionVenta(id)
);

-- Tabla Pedido
CREATE TABLE Pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idCliente VARCHAR(15),
    idVentaDetalle INT,
    fecha DATETIME,
    idTipoEnvio INT,
    estado VARCHAR(20),
    FOREIGN KEY (idCliente) REFERENCES Persona(identificacion),
    FOREIGN KEY (idVentaDetalle) REFERENCES Venta(idVenta)
);

-- Tabla PedidoDetalle
CREATE TABLE PedidoDetalle (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idPedido INT,
    idArticulo INT,
    cantidad INT,
    valorUnitVenta INT,
    FOREIGN KEY (idPedido) REFERENCES Pedido(id),
    FOREIGN KEY (idArticulo) REFERENCES Inventario(idArticulo)
);

-- Tabla TipoEnvio
CREATE TABLE TipoEnvio (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(40),
    descripcion TEXT
);

-- Tabla Compra
CREATE TABLE Compra (
    idCompra INT AUTO_INCREMENT PRIMARY KEY,
    fechaCompra DATETIME,
    idProveedor VARCHAR(15),
    FOREIGN KEY (idProveedor) REFERENCES Persona(identificacion)
);

-- Tabla CompraDetalle
CREATE TABLE CompraDetalle (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idCompraDetalle INT,
    idArticuloInventario INT,
    cantidad INT,
    costoUnitCompra INT,
    impuesto INT,
    FOREIGN KEY (idCompraDetalle) REFERENCES Compra(idCompra),
    FOREIGN KEY (idArticuloInventario) REFERENCES Inventario(idArticulo)
);

-- Tabla DevolucionCompra
CREATE TABLE DevolucionCompra (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME,
    idCompraDetalle INT,
    FOREIGN KEY (idCompraDetalle) REFERENCES Compra(idCompra)
);

-- Tabla DevolucionDetallesCompra
CREATE TABLE DevolucionDetallesCompra (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idCompraDetalle INT,
    idDevolucionCompra INT,
    cantidad INT,
    estadoCompra CHAR(1),
    comentariosAdicionales TEXT,
    FOREIGN KEY (idCompraDetalle) REFERENCES CompraDetalle(idCompraDetalle),
    FOREIGN KEY (idDevolucionCompra) REFERENCES DevolucionCompra(id)
);

-- Tabla MedioPago
CREATE TABLE MedioPago (
    idMedioPago INT AUTO_INCREMENT PRIMARY KEY,
    tipoPago VARCHAR(40),
    descripcionMetodoPago TEXT
);

-- Tabla MedioPagoPorVenta
CREATE TABLE MedioPagoPorVenta (
    idMedioPagoFactura INT AUTO_INCREMENT PRIMARY KEY,
    idVentaDetalle INT,
    idPagos INT,
    fecha DATETIME,
    valor INT,
    FOREIGN KEY (idVentaDetalle) REFERENCES Venta(idVenta),
    FOREIGN KEY (idPagos) REFERENCES MedioPago(idMedioPago)
);

-- Tabla MedioPagoPorCompra
CREATE TABLE MedioPagoPorCompra (
    idMedioPagoCompra INT AUTO_INCREMENT PRIMARY KEY,
    idCompraDetalle INT,
    idPagos INT,
    fecha DATETIME,
    valor INT,
    FOREIGN KEY (idCompraDetalle) REFERENCES Compra(idCompra),
    FOREIGN KEY (idPagos) REFERENCES MedioPago(idMedioPago)
);
=======
/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  SENA
 * Created: 4/04/2024
 */
create database tienda;

create table Categoria(
     id int auto_increment primary key,
     nombre varchar (50),
     descripcion text
);
insert into Categoria (nombre, descripcion)value('frutas','para comer');
insert into Categoria (nombre, descripcion)value('pastel','de varios sabores y preparacion');
insert into Categoria (nombre, descripcion)value('jugos','para refrescar');
insert into Categoria (nombre, descripcion)value('dulces','deliciosos para endulsar la vida');

Create table Producto (
id int auto_increment primary key,
codigoDeBarras varchar(14),
nombre varchar(50),
stock int,    
stockMinimo int,
stockMaximo int,
valorUnitario int,
descripcion text,
foto varchar(100),    
idCategoria int,
FOREIGN KEY (idCategoria) REFERENCES Categoria(id)
);
insert into Producto (nombre, stock, stockMinimo, stockMaximo, valorUnitario, idCategoria,foto) values ('Peritas', 5, 10, 100, 1000, 1, '3.jpeg');
insert into Producto (nombre, stock, stockMinimo, stockMaximo, valorUnitario, idCategoria,foto) values ('Manzanas', 100, 10, 50, 2000, 1, '1.jpeg');
insert into Producto (nombre, stock, stockMinimo, stockMaximo, valorUnitario, idCategoria,foto) values ('Mandarinitas', 10, 5, 50, 1500, 1, '2.jpg');


Create table Persona(
identificacion VARCHAR(12) PRIMARY KEY,
nombres VARCHAR(50),
apellidos VARCHAR(50),
genero CHAR,
telefono VARCHAR(12),
email VARCHAR(80),
tipo CHAR,
clave VARCHAR(32)
);

insert into persona (identificacion, nombres, apellidos, genero, tipo, clave) values ('1234','Administrador', 'del sistema', 'o', 'A' , md5('1234') );
select * from persona;

CREATE TABLE Factura(
numero VARCHAR(10),
identificacionCliente VARCHAR(12),
fecha DATETIME,
PRIMARY KEY (numero),
FOREIGN KEY (identificacionCliente) REFERENCES Persona(identificacion)
);
INSERT INTO Factura (numero, identificacionCliente, fecha) VALUES ('1111', '123', NOW());
INSERT INTO facturaDetalle (numeroFactura, idProducto, cantidad, valorUnitario) VALUES ('1111', 1, 5, 1000);
INSERT INTO facturaDetalle (numeroFactura, idProducto, cantidad, valorUnitario) VALUES ('1111', 2, 3, 2000);


Create table FacturaDetalle(
id INT AUTO_INCREMENT PRIMARY KEY,
numeroFactura VARCHAR(10),
idProducto INT,
cantidad INT,  
valorUnitario INT,
FOREIGN KEY (numeroFactura)
REFERENCES Factura(numero)
);

Create table MedioDePago(
id int auto_increment primary key,
nombre varchar(50),
descripcion text
);

insert into medioDePago (nombre, descripcion) values ('daviPlata','pagos');

Create table MedioDePagoFactura (
id int auto_increment primary key,
idMedioDePago int,    
numeroFactura varchar(10),
valor int,
FOREIGN KEY (numeroFactura)
REFERENCES FacturaDetalle(numeroFactura),
FOREIGN KEY (idMedioDePago)
REFERENCES MedioDePago(id)
);
>>>>>>> 7107026975515d79007e051943af17425710c6d8
