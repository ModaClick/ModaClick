create database if not exists tienda;
use tienda;

create table Categoria(
id int auto_increment not null primary key,
nombre varchar(50),
descripcion text
);

create table Producto(
id int auto_increment not null primary key,
codigoDeBarras varchar(14),
nombre unique varchar not null(50),
stock int,
stockMinimo int,
stockMaximo int,
valorUnitario int,
descripcion text,
foto varchar(100),
idCategoria int,
foreign key(idCategoria) references Categoria(id) on update cascade on delete restrict
);

create table Persona(
identificacion varchar(12) not null primary key, 
nombres varchar(50),
apellidos varchar(50),
genero char,
telefono varchar(12),
email varchar(80),
tipo char,
clave varchar(32)
);

create table Factura(
numero varchar(10) not null primary key,
identificacionCliente varchar(12),
foreign key(identificacionCliente) references Persona(identificacion) on update cascade on delete restrict,
fecha datetime
);

create table FacturaDetalle(
id int auto_increment not null primary key,
idProducto int,
numeroFactura varchar(10), # incompatibilidad en la restriccion de las llaves foraneas.
foreign key (idProducto) references Producto(id) on update cascade on delete restrict, 
foreign key (numeroFactura) references Factura(numero) on update cascade on delete restrict,
cantidad int,
valorUnitario int
);

create table MedioDePago(
id int auto_increment not null primary key,
nombre varchar(50),
descripcion text
);

create table MedioDePagoFactura(
id int auto_increment not null primary key,
idMedioDePago int,
numeroFactura varchar(10),
foreign key (idMedioDePago) references MedioDePago(id) on update cascade on delete restrict,
foreign key (numeroFactura) references Factura(numero) on update cascade on delete restrict
);