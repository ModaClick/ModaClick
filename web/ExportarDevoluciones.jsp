<%@ page import="java.sql.ResultSet, java.sql.SQLException, java.util.List, com.itextpdf.text.*, com.itextpdf.text.pdf.PdfWriter, java.io.OutputStream, com.itextpdf.text.pdf.PdfPTable" %>
<%@ page import="clases.DevolucionCompra, clases.DevolucionDetallesCompra, clases.CompraDetalle" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%
    String tipoDeContenido = request.getParameter("formato");
    String extensionArchivo = "doc";

    // Configuración para la respuesta según el formato
    if ("word".equalsIgnoreCase(tipoDeContenido)) {
        response.setContentType("application/msword");
        extensionArchivo = "doc";
    } else if ("pdf".equalsIgnoreCase(tipoDeContenido)) {
        response.setContentType("application/pdf");
        extensionArchivo = "pdf";
    }

    response.setHeader("Content-Disposition", "attachment; filename=\"devoluciones." + extensionArchivo + "\"");

    List<DevolucionCompra> devoluciones = DevolucionCompra.getListaEnObjetos();
    StringBuilder lista = new StringBuilder();
    double totalValorDevoluciones = 0; 

    if ("pdf".equalsIgnoreCase(tipoDeContenido)) {
        // Configurar iText para crear un documento PDF
        Document document = new Document();
        try {
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // Agregar título al PDF
            document.add(new Paragraph("Lista de Devoluciones Exportada", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16)));
            document.add(new Paragraph(" ")); // Espacio en blanco

            // Crear una tabla para los datos
            PdfPTable table = new PdfPTable(5);
            table.setWidthPercentage(100);
            table.addCell("Fecha");
            table.addCell("Número de Compra");
            table.addCell("Proveedor");
            table.addCell("Código");
            table.addCell("Valor Total Devolución");

            // Iterar sobre las devoluciones y generar filas
            for (DevolucionCompra devolucion : devoluciones) {
                double valorTotalDevolucion = 0;
                List<DevolucionDetallesCompra> detallesDevolucion = DevolucionDetallesCompra.getDetallesPorDevolucion(devolucion.getId());

                for (DevolucionDetallesCompra detalle : detallesDevolucion) {
                    String query = "SELECT costoUnitCompra, idArticuloInventario FROM CompraDetalle WHERE id = " + detalle.getIdCompraDetalle();
                    ResultSet rs = clasesGenericas.ConectorBD.consultar(query);

                    double valorUnitario = 0;
                    String idArticuloInventario = null;

                    try {
                        if (rs.next()) {
                            valorUnitario = rs.getDouble("costoUnitCompra");
                            idArticuloInventario = rs.getString("idArticuloInventario");
                        }
                        if (rs != null) rs.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }

                    // Consultar los impuestos asociados al artículo
                    String consultaImpuestos = "SELECT porcentaje FROM Impuesto "
                                             + "INNER JOIN ImpuestoInventario ON Impuesto.idImpuesto = ImpuestoInventario.idImpuesto "
                                             + "WHERE ImpuestoInventario.idArticulo = '" + idArticuloInventario + "'";
                    ResultSet rsImpuestos = clasesGenericas.ConectorBD.consultar(consultaImpuestos);

                    double totalImpuestos = 0.0;
                    try {
                        while (rsImpuestos != null && rsImpuestos.next()) {
                            int porcentaje = rsImpuestos.getInt("porcentaje");
                            totalImpuestos += porcentaje / 100.0;  // Sumar todos los porcentajes
                        }
                        if (rsImpuestos != null) rsImpuestos.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }

                    int cantidadDevuelta = detalle.getCantidad();

                    double valorDevuelto = cantidadDevuelta * valorUnitario;
                    double totalConImpuesto = valorDevuelto + (valorDevuelto * totalImpuestos);

                    valorTotalDevolucion += totalConImpuesto;
                }

                // Agregar los datos a la tabla PDF
                table.addCell(devolucion.getFecha().toString());
                table.addCell(devolucion.getCompra().getIdCompra());
                table.addCell(devolucion.getCompra().getNombresProveedor());
                table.addCell(String.valueOf(devolucion.getId()));
                table.addCell(String.format("$%.2f", valorTotalDevolucion));

                totalValorDevoluciones += valorTotalDevolucion;
            }

            // Agregar la tabla y el total al documento
            document.add(table);
            document.add(new Paragraph(" "));
            document.add(new Paragraph("Total Valor Devoluciones: $" + String.format("%.2f", totalValorDevoluciones), FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12)));

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            document.close();
        }
    } else {
        // Generar salida HTML para Word
%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Exportar Devoluciones</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h3>Lista de Devoluciones Exportada</h3>
    <table>
        <tr>
            <th>Fecha</th>
            <th>Número de Compra</th>
            <th>Proveedor</th>
            <th>Código</th>
            <th>Valor Total Devolución</th>
        </tr>
        <%
            for (DevolucionCompra devolucion : devoluciones) {
                double valorTotalDevolucion = 0;
                List<DevolucionDetallesCompra> detallesDevolucion = DevolucionDetallesCompra.getDetallesPorDevolucion(devolucion.getId());

                for (DevolucionDetallesCompra detalle : detallesDevolucion) {
                    String query = "SELECT costoUnitCompra, idArticuloInventario FROM CompraDetalle WHERE id = " + detalle.getIdCompraDetalle();
                    ResultSet rs = clasesGenericas.ConectorBD.consultar(query);

                    double valorUnitario = 0;
                    String idArticuloInventario = null;

                    try {
                        if (rs.next()) {
                            valorUnitario = rs.getDouble("costoUnitCompra");
                            idArticuloInventario = rs.getString("idArticuloInventario");
                        }
                        if (rs != null) rs.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }

                    // Consultar los impuestos asociados al artículo
                    String consultaImpuestos = "SELECT porcentaje FROM Impuesto "
                                             + "INNER JOIN ImpuestoInventario ON Impuesto.idImpuesto = ImpuestoInventario.idImpuesto "
                                             + "WHERE ImpuestoInventario.idArticulo = '" + idArticuloInventario + "'";
                    ResultSet rsImpuestos = clasesGenericas.ConectorBD.consultar(consultaImpuestos);

                    double totalImpuestos = 0.0;
                    try {
                        while (rsImpuestos != null && rsImpuestos.next()) {
                            int porcentaje = rsImpuestos.getInt("porcentaje");
                            totalImpuestos += porcentaje / 100.0;  // Sumar todos los porcentajes
                        }
                        if (rsImpuestos != null) rsImpuestos.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }

                    int cantidadDevuelta = detalle.getCantidad();

                    double valorDevuelto = cantidadDevuelta * valorUnitario;
                    double totalConImpuesto = valorDevuelto + (valorDevuelto * totalImpuestos);

                    valorTotalDevolucion += totalConImpuesto;
                }

                lista.append("<tr>");
                lista.append("<td>").append(devolucion.getFecha()).append("</td>");
                lista.append("<td>").append(devolucion.getCompra().getIdCompra()).append("</td>");
                lista.append("<td>").append(devolucion.getCompra().getNombresProveedor()).append("</td>");
                lista.append("<td>").append(devolucion.getId()).append("</td>");
                lista.append("<td>$").append(String.format("%.2f", valorTotalDevolucion)).append("</td>");
                lista.append("</tr>");

                totalValorDevoluciones += valorTotalDevolucion;
            }
        %>
        <%= lista.toString() %>
        <tr>
            <th colspan="4">TOTAL VALOR DEVOLUCIONES</th>
            <th>$<%= String.format("%.2f", totalValorDevoluciones) %></th>
        </tr>
    </table>
</body>
</html>
<%
    }
%>
