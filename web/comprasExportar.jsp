<%@page import="clases.MedioPagoPorCompra"%>
<%@page import="java.util.List"%>
<%@page import="clases.Compra"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Determinar el formato de salida
    String tipoDeContenido = "";
    String extensionDeArchivo = "";
    switch (request.getParameter("formato")) {
        case "excel":
            tipoDeContenido = "application/vnd.ms-excel";
            extensionDeArchivo = ".xls";
            break;
        case "word":
            tipoDeContenido = "application/vnd.msword";
            extensionDeArchivo = ".doc";
            break;
        default:
            tipoDeContenido = "text/html"; // Tipo de contenido por defecto
    }
    response.setContentType(tipoDeContenido);
    response.setHeader("Content-Disposition", "inline; filename=\"compras" + extensionDeArchivo + "\"");

    // Variables para totales
    int totalLista = 0;
    int totalAbonado = 0;
    int totalSaldo = 0;

    // Verificar si el filtro es nulo y asignar un valor por defecto si es necesario
    String filtro = request.getParameter("filtro");
    if (filtro == null || filtro.isEmpty()) {
        filtro = "";  // Filtro por defecto si no se recibe ninguno
    }

    // Intentar obtener la lista de compras y validar la respuesta
    List<Compra> datos = Compra.getListaEnObjetos(filtro, "idCompra desc");
    if (datos == null || datos.isEmpty()) {
        out.println("<p>No se encontraron resultados para la consulta.</p>");
    } else {
        String lista = "";

        for (Compra compra : datos) {
            List<MedioPagoPorCompra> datosMediosDePago = compra.getMediosDePago();
            boolean presentarRegistro = true;
            String listaMediosDePago = "<table>";

            for (MedioPagoPorCompra medioDePagoCompra : datosMediosDePago) {
                listaMediosDePago += "<tr>";
                listaMediosDePago += "<td>" + medioDePagoCompra.getNombreMedioDePago() + "</td>";
                listaMediosDePago += "<td align='right'>" + medioDePagoCompra.getValor() + "</td>";
                listaMediosDePago += "</tr>";
            }

            listaMediosDePago += "</table>";

            if (presentarRegistro) {
                totalLista += compra.getTotal();
                totalAbonado += compra.getAbonado();
                totalSaldo += compra.getSaldo();

                lista += "<tr>";
                lista += "<td>" + compra.getFechaCompra() + "</td>";
                lista += "<td>" + compra.getIdCompra() + "</td>";
                lista += "<td>" + compra.getIdProveedor() + " - " + compra.getNombresCompletosProveedor() + "</td>";
                lista += "<td>" + listaMediosDePago + "</td>";
                lista += "<td align='right'>" + compra.getTotal() + "</td>";
                lista += "<td align='right'>" + compra.getAbonado() + "</td>";
                lista += "<td align='right'>" + compra.getSaldo() + "</td>";
                lista += "</tr>";
            }
        }
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Exportar Compras</title>
    </head>
    <body>
        <h3>LISTA DE COMPRAS</h3>
        <table border="1">
            <tr>
                <th>Fecha</th>
                <th>Nº Compra</th>
                <th>Proveedor</th>
                <th>Medio de pago</th>
                <th>Total</th>
                <th>Abonado</th>
                <th>Saldo</th>
            </tr>
            <%= lista %>
            <tr>
                <th colspan="4">TOTAL</th>
                <th align="right"><%= totalLista %></th>
                <th align="right"><%= totalAbonado %></th>
                <th align="right"><%= totalSaldo %></th>
            </tr>
        </table>
    </body>
</html>

<%
    }
%>
