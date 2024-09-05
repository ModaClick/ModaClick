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
    costoUnitarioCompra INT,
    valorUnitarioVenta INT,
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
    idVenta INT,
    idArticuloInventario INT,
    cantidad INT,
    valorUnitarioVenta INT,
    FOREIGN KEY (idVenta) REFERENCES Venta(idVenta),
    FOREIGN KEY (idArticuloInventario) REFERENCES Inventario(idArticulo)
);

-- Tabla DevolucionVenta
CREATE TABLE DevolucionVenta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME,
    idVenta INT,
    FOREIGN KEY (idVenta) REFERENCES Venta(idVenta)
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
    idVenta INT,
    fecha DATETIME,
    idTipoEnvio INT,
    FOREIGN KEY (idCliente) REFERENCES Persona(identificacion),
    FOREIGN KEY (idVenta) REFERENCES Venta(idVenta)
);

-- Tabla PedidoDetalle
CREATE TABLE PedidoDetalle (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idPedido INT,
    idArticulo INT,
    cantidad INT,
    valorUnitario INT,
    FOREIGN KEY (idPedido) REFERENCES Pedido(id),
    FOREIGN KEY (idArticulo) REFERENCES Inventario(idArticulo)
);

-- Tabla TipoEnvio
CREATE TABLE TipoEnvio (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(40),
    descripcion TEXT
);

-- Tabla OrdenDeSalida
CREATE TABLE OrdenDeSalida (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idVenta INT,
    fecha DATETIME,
    FOREIGN KEY (idVenta) REFERENCES Venta(idVenta)
);

-- Tabla OrdenDeSalidaDetalle
CREATE TABLE OrdenDeSalidaDetalle (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idOrdenDeSalida INT,
    idVentaDetalle INT,
    cantidad INT,
    FOREIGN KEY (idOrdenDeSalida) REFERENCES OrdenDeSalida(id),
    FOREIGN KEY (idVentaDetalle) REFERENCES VentaDetalle(id)
);

-- Tabla Compra
CREATE TABLE Compra (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fechaCompra DATETIME,
    idProveedor VARCHAR(15),
    FOREIGN KEY (idProveedor) REFERENCES Persona(identificacion)
);

-- Tabla CompraDetalle
CREATE TABLE CompraDetalle (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idArticuloInventario INT,
    idCompra INT,
    cantidad INT,
    impuesto INT,
    costoUnitarioCompra INT,
    FOREIGN KEY (idArticuloInventario) REFERENCES Inventario(idArticulo),
    FOREIGN KEY (idCompra) REFERENCES Compra(id)
);

-- Tabla DevolucionCompra
CREATE TABLE DevolucionCompra (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME,
    idCompra INT,
    FOREIGN KEY (idCompra) REFERENCES Compra(id)
);

-- Tabla DevolucionDetallesCompra
CREATE TABLE DevolucionDetallesCompra (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idCompraDetalle INT,
    idDevolucionCompra INT,
    cantidad INT,
    estadoCompra CHAR(1),
    comentariosAdicionales TEXT,
    FOREIGN KEY (idCompraDetalle) REFERENCES CompraDetalle(id),
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
    idVenta INT,
    idMedioPago INT,
    fecha DATETIME,
    valor INT,
    FOREIGN KEY (idVenta) REFERENCES Venta(idVenta),
    FOREIGN KEY (idMedioPago) REFERENCES MedioPago(idMedioPago)
);

-- Tabla MedioPagoPorCompra
CREATE TABLE MedioPagoPorCompra (
    idMedioPagoCompra INT AUTO_INCREMENT PRIMARY KEY,
    idCompra INT,
    idMedioPago INT,
    fecha DATETIME,
    valor INT,
    FOREIGN KEY (idCompra) REFERENCES Compra(id),
    FOREIGN KEY (idMedioPago) REFERENCES MedioPago(idMedioPago)
);
