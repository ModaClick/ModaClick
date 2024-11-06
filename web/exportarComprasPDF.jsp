<%@page import="clases.Inventario"%>
<%@page import="clases.MedioDePago"%>
<%@page import="com.itextpdf.text.*"%>
<%@page import="com.itextpdf.text.pdf.*"%>
<%@page import="clases.Compra"%>
<%@page import="clases.Persona"%>
<%@page import="clases.CompraDetalle"%>
<%@page import="clases.MedioPagoPorCompra"%>
<%@page contentType="application/pdf" pageEncoding="UTF-8"%>

<%
    // Establecer la respuesta como PDF
    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition", "attachment; filename=\"detalles_compra.pdf\"");

    // Obtener el ID de la compra desde el parámetro
    String idCompraStr = request.getParameter("id");
    int idCompra = Integer.parseInt(idCompraStr);

    // Obtener la compra por ID
    Compra compra = Compra.getCompraPorId(idCompra);

    if (compra == null) {
        out.println("La compra con ID " + idCompra + " no se encontró.");
    } else {
        // Preparar los datos de la compra
        Persona proveedor = new Persona(String.valueOf(compra.getIdProveedor()));
        List<CompraDetalle> detallesCompra = CompraDetalle.getDetallesPorCompra(idCompra);
        List<MedioPagoPorCompra> mediosPago = MedioPagoPorCompra.getMediosPagoPorCompra(idCompra);

        int totalCompra = 0;
        for (CompraDetalle detalle : detallesCompra) {
            totalCompra += (detalle.getCostoUnitarioCompra() * detalle.getCantidad()) + detalle.getImpuesto();
        }

        int totalAbonado = 0;
        for (MedioPagoPorCompra medio : mediosPago) {
            totalAbonado += medio.getValor();
        }

        int saldo = totalCompra - totalAbonado;

        // Crear el documento PDF
        Document document = new Document();
        PdfWriter.getInstance(document, response.getOutputStream());
        document.open();

        // Añadir título
        document.add(new Paragraph("Detalles de la Compra N°: " + idCompra, FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16)));
        document.add(new Paragraph(" ")); // Espacio en blanco

        // Información del proveedor
        document.add(new Paragraph("Proveedor: " + proveedor.getNombre()));
        document.add(new Paragraph("Identificación del Proveedor: " + proveedor.getIdentificacion()));
        document.add(new Paragraph("Fecha de Compra: " + compra.getFechaCompra().toString()));
        document.add(new Paragraph(" ")); // Espacio en blanco

        // Validar si existen detalles de compra
        if (detallesCompra != null && !detallesCompra.isEmpty()) {
            // Crear la tabla para los artículos
            PdfPTable table = new PdfPTable(8);
            table.setWidthPercentage(100);
            table.setSpacingBefore(10f);
            table.setSpacingAfter(10f);

            // Añadir encabezados de la tabla
            table.addCell("Artículo");
            table.addCell("Costo Unitario");
            table.addCell("Tipo Tela");
            table.addCell("Color");
            table.addCell("Talla");
            table.addCell("Cantidad");
            table.addCell("Impuesto");
            table.addCell("Subtotal");

            // Añadir datos de los artículos
            for (CompraDetalle detalle : detallesCompra) {
                int subtotal = (detalle.getCostoUnitarioCompra() * detalle.getCantidad()) + detalle.getImpuesto();
                table.addCell(detalle.getNombreArticulo());
                table.addCell("$" + detalle.getCostoUnitarioCompra());
                table.addCell(detalle.getTipoTela() != null ? detalle.getTipoTela() : "N/A");
                table.addCell(detalle.getColorArticulo() != null ? detalle.getColorArticulo() : "N/A");
                table.addCell(detalle.getTalla() != null ? detalle.getTalla() : "N/A");
                table.addCell(String.valueOf(detalle.getCantidad()));
                table.addCell("$" + detalle.getImpuesto());
                table.addCell("$" + subtotal);
            }

            // Añadir total de la compra al final de la tabla
            PdfPCell cell = new PdfPCell(new Phrase("Total"));
            cell.setColspan(7);
            cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            table.addCell(cell);
            table.addCell("$" + totalCompra);

            document.add(table);
        } else {
            // Si no hay detalles de compra, mostrar un mensaje
            document.add(new Paragraph("No se encontraron detalles para la compra.", FontFactory.getFont(FontFactory.HELVETICA, 12, Font.ITALIC)));
        }

        // Medios de pago
        document.add(new Paragraph("Medios de Pago", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14)));

        // Validar si existen medios de pago
        if (mediosPago != null && !mediosPago.isEmpty()) {
            PdfPTable paymentTable = new PdfPTable(2);
            paymentTable.setWidthPercentage(100);
            paymentTable.setSpacingBefore(10f);
            paymentTable.setSpacingAfter(10f);

            // Encabezados de la tabla de medios de pago
            paymentTable.addCell("Medio de Pago");
            paymentTable.addCell("Monto");

            // Añadir datos de los medios de pago
            for (MedioPagoPorCompra medio : mediosPago) {
                paymentTable.addCell(medio.getTipoPago() != null ? medio.getTipoPago() : "No especificado");
                paymentTable.addCell("$" + medio.getValor());
            }

            // Añadir total abonado y saldo al final de la tabla de medios de pago
            PdfPCell totalAbonadoCell = new PdfPCell(new Phrase("Total Abonado"));
            totalAbonadoCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            paymentTable.addCell(totalAbonadoCell);
            paymentTable.addCell("$" + totalAbonado);

            PdfPCell saldoCell = new PdfPCell(new Phrase("Saldo"));
            saldoCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            paymentTable.addCell(saldoCell);
            paymentTable.addCell("$" + saldo);

            document.add(paymentTable);
        } else {
            // Si no hay medios de pago, mostrar un mensaje
            document.add(new Paragraph("No se encontraron medios de pago para esta compra.", FontFactory.getFont(FontFactory.HELVETICA, 12, Font.ITALIC)));
        }

        // Cerrar el documento
        document.close();
    }
%>
