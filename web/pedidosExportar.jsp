<%@page import="clases.Pedido"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
String tipoDeContenido = "";
String extensionArchivo = "";
switch (request.getParameter("formato")) {
    case "excel":
        tipoDeContenido = "application/vnd.ms-excel";
        extensionArchivo = ".xls";
        break;
    case "word":
        tipoDeContenido = "application/vnd.msword";
        extensionArchivo = ".doc";
        break;
}
response.setContentType(tipoDeContenido);
response.setHeader("Content-Disposition", "inline; filename=\"pedidos" + extensionArchivo + "\"");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Exportar Pedidos</title>
    </head>
    <body>
        <%
        // Obtener los pedidos de la base de datos
        List<Pedido> pedidos = Pedido.getListaEnObjetos(null, "id ASC");  // Corregido para usar 'id' en lugar de 'idPedido'
        String listaPedidos = "";

        for (Pedido pedido : pedidos) {
            listaPedidos += "<tr>";
            listaPedidos += "<td>" + pedido.getId() + "</td>";  // Código de Pedido
            listaPedidos += "<td>" + pedido.getIdVentaDetalle() + "</td>";   // Código de Venta
            listaPedidos += "<td>" + pedido.getFecha() + "</td>";     // Fecha
            listaPedidos += "<td>" + pedido.getNombreCliente() + "</td>";  // Nombre Cliente
            listaPedidos += "<td>" + pedido.getTipoEnvio() + "</td>";      // Tipo Envío
            listaPedidos += "<td>" + pedido.getEstado() + "</td>";         // Estado
            listaPedidos += "<td align='right'>" + pedido.calcularValorTotal() + "</td>";  // Valor Total
            listaPedidos += "</tr>";
        }
        %>

        <h3>Lista de Pedidos</h3>
        <table border="1">
            <tr>
                <th>Código Pedido</th>
                <th>Código Venta</th>
                <th>Fecha</th>
                <th>Nombre Cliente</th>
                <th>Tipo Envío</th>
                <th>Estado</th>
                <th>Valor Total</th>
            </tr>
            <%= listaPedidos %>
        </table>
    </body>
</html>
