<%@page import="com.itextpdf.text.Image"%>
<%@page import="clases.PedidoDetalle"%>
<%@page import="clases.Pedido"%>
<%@page import="clases.Inventario"%>
<%@page import="com.itextpdf.text.Phrase"%>
<%@page import="com.itextpdf.text.pdf.PdfPCell"%>
<%@page import="com.itextpdf.text.pdf.PdfPTable"%>
<%@page import="com.itextpdf.text.Paragraph"%>
<%@page import="com.itextpdf.text.Document"%>
<%@page import="com.itextpdf.text.pdf.PdfWriter"%>
<%@page import="java.util.List"%>
<%@page import="java.io.OutputStream"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
response.setContentType("application/pdf");
response.setHeader("Content-Disposition", "inline; filename=\"pedido.pdf\"");

OutputStream os = response.getOutputStream();
Document documento = new Document();
PdfWriter.getInstance(documento, os);
documento.open();

// Añadir la imagen del logo centrada
String logoPath = application.getRealPath("Icono/logo.jpg");
Image logo = Image.getInstance(logoPath);
logo.setAlignment(Image.ALIGN_CENTER);
logo.scaleToFit(50, 50); // Ajustar el tamaño si es necesario
documento.add(logo);

// Añadir un espacio debajo de la imagen
documento.add(new Paragraph("\n"));

// Obtener el ID del pedido desde el parámetro de la URL
String idPedido = request.getParameter("id");

// Cargar el pedido utilizando la clase Pedido
Pedido pedido = new Pedido(idPedido);

// Obtener los detalles del pedido utilizando la clase PedidoDetalle
List<PedidoDetalle> detalles = PedidoDetalle.getDetallesPorPedido(idPedido);

// Datos del pedido
String nombreCliente = pedido.getNombreCliente();
String idVenta = pedido.getIdVentaDetalle();
String fechaPedido = pedido.getFecha();
String idCliente = pedido.getIdCliente();
String tipoEnvio = pedido.getTipoEnvio();
String estado = pedido.getEstado();

// Título y detalles del pedido
Paragraph title = new Paragraph("ModaClick");
title.setAlignment(Paragraph.ALIGN_CENTER);
documento.add(title);

// Crear y centrar los párrafos
Paragraph pedidoInfo = new Paragraph("Pedido N°: " + idPedido);
pedidoInfo.setAlignment(Paragraph.ALIGN_CENTER);
documento.add(pedidoInfo);

Paragraph ventaInfo = new Paragraph("Venta N°: " + idVenta);  // Incluyendo el ID de la venta
ventaInfo.setAlignment(Paragraph.ALIGN_CENTER);
documento.add(ventaInfo);

Paragraph clienteInfo = new Paragraph("Cliente: " + nombreCliente);
clienteInfo.setAlignment(Paragraph.ALIGN_CENTER);
documento.add(clienteInfo);

Paragraph idClienteInfo = new Paragraph("Identificación: " + idCliente);
idClienteInfo.setAlignment(Paragraph.ALIGN_CENTER);
documento.add(idClienteInfo);

Paragraph fechaInfo = new Paragraph("Fecha: " + fechaPedido);
fechaInfo.setAlignment(Paragraph.ALIGN_CENTER);
documento.add(fechaInfo);

Paragraph tipoEnvioInfo = new Paragraph("Tipo Envío: " + tipoEnvio);
tipoEnvioInfo.setAlignment(Paragraph.ALIGN_CENTER);
documento.add(tipoEnvioInfo);

Paragraph estadoInfo = new Paragraph("Estado del pedido: " + estado);
estadoInfo.setAlignment(Paragraph.ALIGN_CENTER);
documento.add(estadoInfo);

// Añadir un salto de línea para espaciar
documento.add(new Paragraph("\n"));

// Tabla para los productos
PdfPTable productTable = new PdfPTable(4);
productTable.setWidthPercentage(100);

// Encabezado de la tabla
PdfPCell cellArticulo = new PdfPCell(new Phrase("Artículo"));
productTable.addCell(cellArticulo);
PdfPCell cellCantidad = new PdfPCell(new Phrase("Cantidad"));
productTable.addCell(cellCantidad);
PdfPCell cellValorUnitario = new PdfPCell(new Phrase("Valor Unitario"));
productTable.addCell(cellValorUnitario);
PdfPCell cellSubTotal = new PdfPCell(new Phrase("SubTotal"));
productTable.addCell(cellSubTotal);

int totalPedido = 0;

// Llenar la tabla con los detalles del pedido
for (PedidoDetalle detalle : detalles) {
    // Obtener el nombre del artículo utilizando el idArticulo
    Inventario inventario = new Inventario(detalle.getIdArticulo());
    String nombreArticulo = inventario.getNombreArticulo();
    
    productTable.addCell(nombreArticulo);  // Nombre del artículo
    productTable.addCell(String.valueOf(detalle.getCantidad()));
    productTable.addCell(String.valueOf(detalle.getValorUnitVenta()));
    int subtotal = Integer.parseInt(detalle.getCantidad()) * Integer.parseInt(detalle.getValorUnitVenta());
    productTable.addCell(String.valueOf(subtotal));
    totalPedido += subtotal;
}

// Fila del total
PdfPCell cellTotalLabel = new PdfPCell(new Phrase("TOTAL"));
cellTotalLabel.setColspan(3);
productTable.addCell(cellTotalLabel);
productTable.addCell(String.valueOf(totalPedido));

// Añadir la tabla al documento
documento.add(productTable);
documento.add(new Paragraph("\n"));

// Cerrar el documento
documento.close();
%>
