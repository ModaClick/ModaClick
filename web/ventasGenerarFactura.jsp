<%@page import="clases.Inventario"%>
<%@page import="clases.MedioPagoPorVenta"%>
<%@page import="clases.VentaDetalle"%>
<%@page import="java.util.List"%>
<%@page import="com.itextpdf.text.Element"%>
<%@page import="com.itextpdf.text.FontFactory"%>
<%@page import="com.itextpdf.text.Font"%>
<%@page import="com.itextpdf.text.BaseColor"%>
<%@page import="clases.Venta"%>
<%@page import="com.itextpdf.text.Phrase"%>
<%@page import="com.itextpdf.text.pdf.PdfPCell"%>
<%@page import="com.itextpdf.text.pdf.PdfPTable"%>
<%@page import="com.itextpdf.text.Paragraph"%>
<%@page import="com.itextpdf.text.pdf.PdfWriter"%>
<%@page import="com.itextpdf.text.Document"%>
<%@page import="java.io.OutputStream"%>
<%@page import="com.itextpdf.text.Image"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>

<%
    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition", "inline; filename=\"factura.pdf\"");

    OutputStream os = response.getOutputStream();
    Document documento = new Document();
    PdfWriter.getInstance(documento, os);
    documento.open();

    String idVenta = request.getParameter("idVenta");
    Venta venta = new Venta(idVenta);
    List<VentaDetalle> detalles = venta.getDetalles();

    // Formato de número para valores monetarios
    NumberFormat formatoMoneda = NumberFormat.getCurrencyInstance(new Locale("es", "CO"));

    // Add logo image
    String imagePath = getServletContext().getRealPath("/presentacion/logo.jpeg");
    try {
        Image logo = Image.getInstance(imagePath);
        logo.setAlignment(Image.ALIGN_LEFT);
        logo.scaleToFit(100, 50); // Ajustar el tamaño del logo
        documento.add(logo);
    } catch (Exception e) {
        e.printStackTrace();
        documento.add(new Paragraph("Error al cargar el logo"));
    }

    // Add title
    Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, BaseColor.DARK_GRAY);
    Paragraph titulo = new Paragraph("ModaClick", titleFont);
    titulo.setAlignment(Element.ALIGN_CENTER);
    documento.add(titulo);

    Font facturaFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, BaseColor.BLACK);
    Paragraph tituloFactura = new Paragraph("Venta N°: " + idVenta, facturaFont);
    tituloFactura.setAlignment(Element.ALIGN_CENTER);
    documento.add(tituloFactura);

    Font dateFont = FontFactory.getFont(FontFactory.HELVETICA, 12, BaseColor.GRAY);
    String fecha = venta.getFechaVenta();
    Paragraph tituloFecha = new Paragraph("Fecha: " + fecha, dateFont);
    tituloFecha.setAlignment(Element.ALIGN_CENTER);
    documento.add(tituloFecha);

    Font clientFont = FontFactory.getFont(FontFactory.HELVETICA, 12, BaseColor.BLACK);
    Paragraph tituloCliente = new Paragraph("Cliente: " + venta.getNombresCompletosCliente() + " | Identificación: " + venta.getIdCliente(), clientFont);
    tituloCliente.setAlignment(Element.ALIGN_CENTER);
    documento.add(tituloCliente);

    // Tabla de productos con columnas adicionales
    PdfPTable tablaProductos = new PdfPTable(8); 
    tablaProductos.setWidthPercentage(100);
    tablaProductos.setSpacingBefore(10f);
    tablaProductos.setSpacingAfter(10f);

    Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, BaseColor.WHITE);
    BaseColor headerColor = new BaseColor(100, 149, 237); // Azul pastel

    String[] headers = {"Artículo", "Valor Unitario", "Tipo Tela", "Color Artículo", "Talla", "Cantidad", "Impuesto", "Subtotal"};
    for (String header : headers) {
        PdfPCell headerCell = new PdfPCell(new Phrase(header, headerFont));
        headerCell.setBackgroundColor(headerColor);
        headerCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        tablaProductos.addCell(headerCell);
    }

    // Agregar los detalles de los productos a la tabla
    for (VentaDetalle detalle : detalles) {
        Inventario articulo = new Inventario(detalle.getIdArticuloInventario());
        
        tablaProductos.addCell(new PdfPCell(new Phrase(articulo.getNombreArticulo())));
        tablaProductos.addCell(new PdfPCell(new Phrase(formatoMoneda.format(Double.parseDouble(detalle.getValorUnitarioVenta())))));
        tablaProductos.addCell(new PdfPCell(new Phrase(articulo.getTipoTela())));
        tablaProductos.addCell(new PdfPCell(new Phrase(articulo.getColorArticulo())));
        tablaProductos.addCell(new PdfPCell(new Phrase(articulo.getTalla())));
        tablaProductos.addCell(new PdfPCell(new Phrase(detalle.getCantidad())));
        tablaProductos.addCell(new PdfPCell(new Phrase(detalle.getNombreYPorcentajeImpuesto())));
        tablaProductos.addCell(new PdfPCell(new Phrase(formatoMoneda.format(detalle.getSubTotal()))));
    }

    // Añadir la tabla al documento
    documento.add(tablaProductos);
// Totales
PdfPTable tablaTotales = new PdfPTable(2); 
tablaTotales.setWidthPercentage(100);  // Cambiado para que ocupe el 100% del ancho, igual que la tabla de productos
tablaTotales.setSpacingBefore(15f);
tablaTotales.setSpacingAfter(10f);

PdfPCell totalCell = new PdfPCell(new Phrase("TOTAL ARTÍCULOS", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, BaseColor.WHITE)));
totalCell.setBackgroundColor(headerColor);
totalCell.setPadding(10f);
totalCell.setHorizontalAlignment(Element.ALIGN_CENTER);
tablaTotales.addCell(totalCell);
tablaTotales.addCell(new PdfPCell(new Phrase(formatoMoneda.format(venta.getTotal()))));

totalCell = new PdfPCell(new Phrase("ABONADO TOTAL", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, BaseColor.WHITE)));
totalCell.setBackgroundColor(headerColor);
totalCell.setPadding(10f);
totalCell.setHorizontalAlignment(Element.ALIGN_CENTER);
tablaTotales.addCell(totalCell);
tablaTotales.addCell(new PdfPCell(new Phrase(formatoMoneda.format(venta.getAbonado()))));

totalCell = new PdfPCell(new Phrase("SALDO PENDIENTE", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, BaseColor.WHITE)));
totalCell.setBackgroundColor(headerColor);
totalCell.setPadding(10f);
totalCell.setHorizontalAlignment(Element.ALIGN_CENTER);
tablaTotales.addCell(totalCell);
tablaTotales.addCell(new PdfPCell(new Phrase(formatoMoneda.format(venta.getSaldo()))));

// Añadir la tabla de totales al documento
documento.add(tablaTotales);


    documento.close();
%>
