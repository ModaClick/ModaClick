<%@page import="clases.MedioPagoPorVenta"%>
<%@page import="java.util.List"%>
<%@page import="clases.Venta"%>
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
    response.setHeader("Content-Disposition", "inline; filename=\"ventas" + extensionDeArchivo + "\"");

    // Variables para totales
    int totalLista = 0;
    int totalAbonado = 0;
    int totalSaldo = 0;

    // Verificar si el filtro es nulo y asignar un valor por defecto si es necesario
    String filtro = request.getParameter("filtro");
    if (filtro == null || filtro.isEmpty()) {
        filtro = "";  // Filtro por defecto si no se recibe ninguno
    }

    // Intentar obtener la lista de ventas y validar la respuesta
    List<Venta> datos = Venta.getListaEnObjetos(filtro, "idVenta desc");
    if (datos == null || datos.isEmpty()) {
        out.println("<p>No se encontraron resultados para la consulta.</p>");
    } else {
        String lista = "";

        for (Venta venta : datos) {
            List<MedioPagoPorVenta> datosMediosDePago = venta.getMediosDePago();
            boolean presentarRegistro = true;
            String listaMediosDePago = "<table>";

            for (MedioPagoPorVenta medioDePagoVenta : datosMediosDePago) {
                listaMediosDePago += "<tr>";
                listaMediosDePago += "<td>" + medioDePagoVenta.getNombreMedioDePago() + "</td>";
                listaMediosDePago += "<td align='right'>" + medioDePagoVenta.getValor() + "</td>";
                listaMediosDePago += "</tr>";
            }

            listaMediosDePago += "</table>";

            if (presentarRegistro) {
                totalLista += venta.getTotal();
                totalAbonado += venta.getAbonado();
                totalSaldo += venta.getSaldo();

                lista += "<tr>";
                lista += "<td>" + venta.getFechaVenta() + "</td>";
                lista += "<td>" + venta.getIdVenta() + "</td>";
                lista += "<td>" + venta.getIdCliente() + " - " + venta.getNombresCompletosCliente() + "</td>";
                lista += "<td>" + listaMediosDePago + "</td>";
                lista += "<td align='right'>" + venta.getTotal() + "</td>";
                lista += "<td align='right'>" + venta.getAbonado() + "</td>";
                lista += "<td align='right'>" + venta.getSaldo() + "</td>";
                lista += "</tr>";
            }
        }
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Exportar Ventas</title>
    </head>
    <body>
        <h3>LISTA DE VENTAS</h3>
        <table border="1">
            <tr>
                <th>Fecha</th>
                <th>Nº Venta</th>
                <th>Cliente</th>
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
