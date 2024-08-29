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